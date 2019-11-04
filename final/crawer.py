import requests
import json
from pprint import pprint
import os


# category = "taiwanese-delivery"
# category = "japanese-delivery"
category = "chinese-delivery"
location = "taipei"


headers = {
    "Host": "www.ubereats.com",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:69.0) Gecko/20100101 Firefox/69.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "zh-TW,en-US;q=0.8,en;q=0.5,zh;q=0.3",
    "Accept-Encoding": "gzip, deflate, br",
    "Connection": "keep-alive",
    "x-csrf-token": "x",
    "Content-Type": "application/json",
}


# get all menus
def getMenu():
    print(location, category)
    req = requests.post("https://www.ubereats.com/api/getFeedV1?localeCode=zh-TW",
                        headers=headers,
                        data=json.dumps({"cacheKey": f"/DELIVERY////0/0//{location}/{category}/0/0",
                                         "categorySlug": category,
                                         "slugName": location})).json()
    json.dump(req, open(f"data/raw_menu_{location}_{category}.txt", "w"))
    stores = [store for _, store in req['data']['storesMap'].items()]
    json.dump({'stores': stores}, open(f"data/raw_menu_{location}_{category}.txt", "w"))
    # pprint(stores)


# get each store
def getStore():
    stores = json.load(open(f"data/raw_menu_{location}_{category}.txt"))['stores']
    for store in stores:
        # curl all data
        try:
            name = "data/raw_" + store['uuid'] + ".txt"
            if os.path.exists(name):
                continue
            req = requests.post("https://www.ubereats.com/api/getStoreV1?localeCode=zh-TW",
                                headers=headers,
                                data=json.dumps({"storeUuid": store["uuid"], "sfNuggetCount": 0})).json()
            print("OK", name)
            json.dump(req, open(name, "w"))
        except BaseException:
            print("Error", store['uuid'])


def getCat():
    req = requests.post("https://www.ubereats.com/api/getCategoriesV1?localeCode=zh-TW",
                        headers=headers,
                        data=json.dumps({"slugName": location})).json()
    # pprint(req)
    json.dump(req, open(f"data/raw_category_{location}.txt", "w"))


def show():
    stores = json.load(open(f"data/raw_menu_{location}_{category}.txt"))['stores']
    for store in stores[:10]:
        # show
        detail = json.load(open("data/raw_" + store['uuid'] + ".txt"))
        # pprint(detail)
        # print(detail["data"])


cities = ["taichung", "hsinchu", "tainan", "kaohsiung", "taipei", "taoyuan"]
for city in cities:
    location = city
    getCat()
    req = json.load(open(f"data/raw_category_{location}.txt"))
    cats = [r["slug"] for r in req["data"]["categories"]]
    for cat in cats:
        category = cat
        getMenu()
        getStore()
