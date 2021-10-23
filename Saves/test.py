import matplotlib.pyplot as plt
import numpy as np
import json

with open("clicks.dat") as f:
    data = json.load(f)

x = []
y = []

for i in data:
    x.append(i[0])
    y.append(i[1])

xpoints = np.array(x)
ypoints = np.array(y)

plt.plot(xpoints, ypoints)
plt.show()