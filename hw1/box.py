import numpy as np
import matplotlib.pyplot as plt


dataA = [6,47,49,15,42,41,7,39,43,40,36]
dataB = [4,3,1,2]
data = [dataA, dataB]
labels = ["a", "b"]


def getQuartile(arr, x):
    n = len(arr)
    x = n * x
    if x % 100 == 0:
        x //= 100
        return (arr[x - 1] + arr[x]) / 2
    else:
        return arr[x // 100]


def myBoxplot(data):
    # sorted
    data = np.array(data)
    data = np.sort(data)

    # get three quartile
    Q1 = getQuartile(data, 25)
    Q2 = getQuartile(data, 50)
    Q3 = getQuartile(data, 75)
    IQR = Q3 - Q1

    # get limit
    min_limit = Q1 - IQR * 1.5
    max_limit = Q3 + IQR * 1.5
    box_min = data[np.searchsorted(data, min_limit, side="right")]
    box_max = data[np.searchsorted(data, max_limit) - 1]

    return {
        "q1": Q1,
        "med": Q2,
        "q3": Q3,
        "whislo": box_min,
        "whishi": box_max,
        "fliers": data[(data < box_min) | (data > box_max)]}


# ---
# plot by default
# plt.boxplot(data, vert=False, labels=labels)
# ---
# plot by myself
all_data = [myBoxplot(d) for d in data]
print(all_data)

# add label
for i, data in enumerate(all_data):
    data["label"] = labels[i]
    plt.text(data['whislo'], i * 1 + 1.0, f"MIN={data['whislo']}")
    plt.text(data['q1'], i * 1 + 0.88, f"Q1={data['q1']}")
    plt.text(data['med'], i * 1 + 1.1, f"Q2={data['med']}")
    IQR = data["q3"] - data["q1"]
    plt.text(IQR, i * 1 + 1.03, f"IQR={IQR}")
    plt.text(data['q3'], i * 1 + 0.88, f"Q3={data['q3']}")
    plt.text(data['whishi'], i * 1 + 1.0, f"MAX={data['whishi']}")
plt.gca().bxp(all_data, vert=False)

# show
plt.show()
