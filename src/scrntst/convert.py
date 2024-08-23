# -*- coding: utf-8 -*-

from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

def main():
    im = Image.open('testscreen.png')
    pixels = im.getdata(0)
    
    data = np.zeros((im.size[1], im.size[0]//8), dtype=np.uint8)
    for y in range(im.size[1]):
        for x in range(im.size[0]):
            if pixels[y * im.size[0] + x] < 100: # invert
                data[y,x//8] |= (1 << (x%8))

    with open('screen.img', 'wb') as f:
        f.write(bytearray(data))

if __name__ == '__main__':
    main()