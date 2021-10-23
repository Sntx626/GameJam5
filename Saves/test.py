

class Node(object):
    def __init__(self):
        self.currency_t0 = 0

    def klick(self):
        self.currency_t0 += 1
    
    def print_stats(self):
        text = "#"*10 + "\n"
        text += "Currency: " + str(self.currency_t0) + "\n"
        text += "#"*10
        print(text)

def main():
    n = Node()
    try:
        while True:
            input()
            n.klick()
            n.print_stats()
    except KeyboardInterrupt:
        print("bye")

if __name__ == "__main__":
    main()
