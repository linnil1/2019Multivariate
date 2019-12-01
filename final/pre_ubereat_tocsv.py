from pprint import pprint
import numpy as np
import pandas as pd
import json
import re
import zipcodetw
# make sure python3 -m zipcodetw.builder
# from core import translate


re_word = re.compile(r"\D+")
re_word_code = re.compile(r"Taiwan (\d+)")
all_stores = []


def getStore(uuid):
    store = json.load(open("raw_data/raw_" + uuid + ".txt"))['data']
    if store.get("code") == 500:
        print("Error: ", uuid)
        return
    if not store.get("location"):
        print("Error Address: ", uuid)
        return
    code = store["location"].get("postalCode")
    if not code or len(str(code)) < 3:
        loc = store.get("location").get("address")
        code = zipcodetw.find(loc)
    if not code or len(str(code)) < 3:
        loc_strip = re_word.findall(loc)[0]
        loc_strip = loc_strip.replace("台灣", "")
        code = zipcodetw.find(loc_strip)
    if not code or len(str(code)) < 3:
        code = re_word_code.findall(loc)
        if len(code):
            code = code[0]
    if code and len(str(code)) < 3:
        print("Error postcode digit: ", code, loc, uuid)
        return
    if not code:
        print("Error postcode: ", loc, uuid)
        return
    code = int(str(code)[:3])
    # debug
    # return
    rate = 0
    rate_num = 0
    if store["ratingBadge"]:
        rate = store["ratingBadge"][0]["children"][0]["text"]
        rate_num = re.findall(r"\d+", store["ratingBadge"][0]["children"][2]["text"])[0]
        # print("Error rate: ", uuid)
    if len(store["categories"]) != 2:
        print("Error categories number: ", uuid)
        return
    prices = [j["price"] for _, i in store["sectionEntitiesMap"].items() for _, j in i.items()]
    try:
        now_dict = {
            "uuid": uuid,
            "city": store["citySlug"],
            "postcode": code,
            "rate": rate,
            "rate_num": rate_num,
            "food_num": len(prices),
            "food_mean": np.mean(prices),
            "food_q1": np.quantile(prices, 0.25),
            "food_q2": np.quantile(prices, 0.50),
            "food_q3": np.quantile(prices, 0.75),
            "food_var": np.std(prices),
            "category": store["categories"][1],
            "money": store["categories"][0],
        }
    except:
        pprint(store)
        raise
    all_stores.append(now_dict)


cities = ["taichung", "hsinchu", "tainan", "kaohsiung", "taipei", "taoyuan"]
for city in cities:
    req = json.load(open(f"raw_data/raw_category_{city}.txt"))
    cats = [r["slug"] for r in req["data"]["categories"]]
    for cat in cats:
        stores = json.load(open(f"raw_data/raw_menu_{city}_{cat}.txt"))["stores"]
        for i in range(len(stores)):
            store_head = stores[i]
            uuid = store_head["uuid"]
            getStore(uuid)

"""
stores = json.load(open("raw_data/raw_menu_taipei_taiwanese.txt"))["stores"]
for i in range(len(stores)):
    store_head = stores[i]
    uuid = store_head["uuid"]
for i in range(10):
"""

data = pd.DataFrame(all_stores)
data = data.reset_index(drop=True)
print(data)
data.to_csv('tmp.csv', index=False)
