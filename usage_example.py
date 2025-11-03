import math
import time

from utils.defines import *
# from utils.interface import *
from utils.localInterface import *

touch = TouchScreen(r'/dev/hidg0')
kb = KeyBoard(r'/dev/hidg1')
mouse = Mouse(r'/dev/hidg2')


    
def makeCircle(r):
    points = []
    for i in range(r):
        x = r * math.cos(i * 2 * math.pi / r)
        y = r * math.sin(i * 2 * math.pi / r)
        points.append((int(x), int(y)))
    offsets = []
    for i in range(len(points)-1):
        x = points[i+1][0] - points[i][0]
        y = points[i+1][1] - points[i][1]
        offsets.append((x, y))
    return offsets

if __name__ == "__main__":

    for key in [KEY_A,KEY_B,KEY_C,KEY_D]:
        kb.key_press(key)
        time.sleep(0.1)
        kb.key_release(key)
        time.sleep(0.1)

    for i in range(10):
        for (x, y) in makeCircle(200):
            mouse.move(x=x, y=y)

    for i in range(1000):
        val = i * 0x7ffffffe // 1000
        touch.move(0,val,val)
        touch.move(1,0x7ffffffe - val,val)
    for i in range(9):
        touch.release(i)
