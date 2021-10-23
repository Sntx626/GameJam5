import matplotlib.pyplot as plt
import numpy as np
import json

with open("clicks.dat") as f:
    data = json.load(f)

x = []
y = []

temp = 0
for i in data:
    temp += i[1]*0.000001
    x.append(temp)
    y.append(i[0])

xpoints = np.array(x)
ypoints = np.array(y)

plt.plot(xpoints, ypoints)
plt.show()