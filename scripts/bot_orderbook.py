import json
import os
import time

from requests import Request, Session
from telegram import InlineKeyboardButton, InlineKeyboardMarkup, Update
from telegram.ext import Application, CallbackQueryHandler, CommandHandler, ContextTypes


dir_path = "/www/orderbook/"

session = Session()
symbol_list = ['BTCUSDT', 'ETHUSDT', 'SOLUSDT', 'WIFUSDT', 'PEPEUSDT', 'ORDIUSDT', 'NOTUSDT', 'BNBUSDT', 'JUPUSDT']

# Telegram Bot Token
TOKEN = "6405624052:AAF6DQP7VDc6qtk98WArEiqaDRUahcRJ4-w"

last_query_time = 0

def get_depth(symbol):
    url = f"https://api.binance.com/api/v3/depth"
    params = {'symbol': symbol, 'limit': 5000}
    response = session.get(url, params=params)
    data = response.json()
    if 'lastUpdateId' not in data:
        return []
    else:
        return data

def format_number(num_str, symbol):
    if symbol == 'PEPEUSDT':
        # 对于 PEPEUSDT，将价格乘以 1000
        num = float(num_str) * 1000
        return f"{num:.4f}"
    else:
        parts = num_str.split('.')
        if len(parts) == 1:
            return num_str + '.0000'
        else:
            return parts[0] + '.' + parts[1][:4].ljust(4, '0')

def process_orderbook(data, symbol):
    # 处理asks
    asks = data['asks']
    asks_sorted = sorted(asks, key=lambda x: float(x[1]), reverse=True)  # 按数量降序排序
    top_asks = [(format_number(price, symbol), format_number(amount, 'default')) for price, amount in asks_sorted[:5]]
    ask_bbo = format_number(asks[0][0], symbol)  # asks的第一个价格是BBO

    # 处理bids
    bids = data['bids']
    bids_sorted = sorted(bids, key=lambda x: float(x[1]), reverse=True)  # 按数量降序排序
    top_bids = [(format_number(price, symbol), format_number(amount, 'default')) for price, amount in bids_sorted[:5]]
    bid_bbo = format_number(bids[0][0], symbol)  # bids的第一个价格是BBO

    return {
        'top_asks': top_asks,
        'ask_bbo': ask_bbo,
        'top_bids': top_bids,
        'bid_bbo': bid_bbo
    }

async def alert_orderbook(symbol):
    global last_query_time
    current_time = time.time()

    # 检查是否在120秒之前有过查询
    if current_time - last_query_time < 120:
        remaining_time = int(120 - (current_time - last_query_time))
        return f"请等待 {remaining_time} 秒后再次查询"

    # 更新查询时间
    last_query_time = current_time

    ob_data = get_depth(symbol)
    try:
        ob_info = process_orderbook(ob_data, symbol)
    except:
        return f"获取 {symbol} 数据时出错"

    # 生成详细消息
    symbol_display = '1000PEPE' if symbol == 'PEPEUSDT' else symbol
    detailed_message = f"""
    <b>symbol:{symbol_display} 大额挂单详情</b>

    Ask 大额挂单 (价格, 数量):
    🔴 {ob_info['top_asks'][0][0]}, {ob_info['top_asks'][0][1]}
    🔴 {ob_info['top_asks'][1][0]}, {ob_info['top_asks'][1][1]}
    🔴 {ob_info['top_asks'][2][0]}, {ob_info['top_asks'][2][1]}
    🔴 {ob_info['top_asks'][3][0]}, {ob_info['top_asks'][3][1]}
    🔴 {ob_info['top_asks'][4][0]}, {ob_info['top_asks'][4][1]}
    Ask BBO: {ob_info['ask_bbo']}

    Bid 大额挂单 (价格, 数量):
    🟢 {ob_info['top_bids'][0][0]}, {ob_info['top_bids'][0][1]}
    🟢 {ob_info['top_bids'][1][0]}, {ob_info['top_bids'][1][1]}
    🟢 {ob_info['top_bids'][2][0]}, {ob_info['top_bids'][2][1]}
    🟢 {ob_info['top_bids'][3][0]}, {ob_info['top_bids'][3][1]}
    🟢 {ob_info['top_bids'][4][0]}, {ob_info['top_bids'][4][1]}
    Bid BBO: {ob_info['bid_bbo']}
    """

    file_path = dir_path + 'orderbook_result.txt'
    if not os.path.exists(file_path):
        with open(file_path, 'w') as f:
            json.dump({}, f)

    with open(file_path, 'r') as f:
        content_dict = json.load(f)

    changes = []
    if symbol not in content_dict:
        content_dict[symbol] = ob_info
    else:
        old_info = content_dict[symbol]

        # 检查最大的Ask挂单是否发生变化
        if old_info['top_asks'][0] != ob_info['top_asks'][0]:
            old_price, old_amount = old_info['top_asks'][0]
            new_price, new_amount = ob_info['top_asks'][0]
            if old_price != new_price:
                emoji = '🟢' if float(new_price) > float(old_price) else '🔴'
                changes.append(f"最大Ask挂单变化: {old_price},{old_amount} -> {emoji}<code>{new_price}</code>,{new_amount}")

        # 检查最大的Bid挂单是否发生变化
        if old_info['top_bids'][0] != ob_info['top_bids'][0]:
            old_price, old_amount = old_info['top_bids'][0]
            new_price, new_amount = ob_info['top_bids'][0]
            if old_price != new_price:
                emoji = '🟢' if float(new_price) > float(old_price) else '🔴'
                changes.append(f"最大Bid挂单变化: {old_price},{old_amount} -> {emoji}<code>{new_price}</code>,{new_amount}")

        # 更新 content_dict
        content_dict[symbol] = ob_info

    with open(file_path, 'w') as f:
        json.dump(content_dict, f)

    # 如果有变化，添加到消息中
    if changes:
        change_message = "\n<b>异动详情:</b>\n" + "\n".join(changes)
        detailed_message += change_message

    return detailed_message


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    keyboard = []
    row = []
    for i, symbol in enumerate(symbol_list):
        # 提取交易对的前缀（例如从 'BTCUSDT' 提取 'BTC'）
        short_name = symbol.replace('USDT', '')
        row.append(InlineKeyboardButton(short_name, callback_data=symbol))

        # 每两个按钮为一行，或者是最后一个按钮
        if (i + 1) % 2 == 0 or i == len(symbol_list) - 1:
            keyboard.append(row)
            row = []

    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.message.reply_text('请选择要查看的交易对:', reply_markup=reply_markup)


async def button(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    await query.answer()

    symbol = query.data
    message = await alert_orderbook(symbol)
    await query.edit_message_text(text=message, parse_mode='HTML')

def main() -> None:
    application = Application.builder().token(TOKEN).build()

    application.add_handler(CommandHandler("start", start))
    application.add_handler(CallbackQueryHandler(button))

    application.run_polling()


if __name__ == '__main__':
    print("start bot server")
    main()
