import matplotlib.pyplot as plt
import numpy as np
import json

with open("clicks.dat") as f:
    data = json.load(f)

x = []
y = []

for i in data:
    y.append(i[0])

xpoints = np.array(range(len(data)))
ypoints = np.array(y)

plt.plot(xpoints, ypoints)
plt.show()