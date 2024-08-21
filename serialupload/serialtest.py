# -*- coding: utf-8 -*-
import serial

def main():
    ser = serial.Serial('COM5', 1200, timeout=10, rtscts=True)
    if not ser.isOpen():
        print("Opening port")
        ser.open()
    ser.write('Hello World!'.encode('ascii'))

if __name__ == '__main__':
    main()