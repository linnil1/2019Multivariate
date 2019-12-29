import pandas as pd
import zipcodetw
# make sure python3 -m zipcodetw.builder

postcode = pd.read_csv("data/postcode.csv")
data = pd.read_csv("download/NPA_TMA2.csv")
data.insert(2, "postcode", -1, True)

for i in range(len(data)):
    print(i)
    loc = data.iloc[i]["發生地點"]
    if pd.isna(loc):
        continue
    code = zipcodetw.find(loc)
    code = code[:3]
    if 100 <= int(code) < 200:
        data.at[i, "postcode"] = int(code)
data = data[data["postcode"] != -1]
data.to_csv("data/crash.csv", index=False)
print(data)


new_data = []
data = pd.read_csv("data/crash.csv")
codes = set(data["postcode"])
for code in codes:
    if code >= 200 or code < 100:
        continue
    new_data.append({
        "postcode": code,
        "num": sum(data["postcode"] == code)
    })

new_data = pd.DataFrame(new_data)
new_data.to_csv("data/crash_num.csv", index=False)
print(new_data)

