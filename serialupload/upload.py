# -*- coding: utf-8 -*-
import serial
import struct

def main():
    upload('../hello/hello.com')

def upload(file):
    with open(file,'rb') as f:
        data = bytearray(f.read())

    ser = serial.Serial('COM5', 1200, timeout=10, rtscts=True)
    if not ser.isOpen():
        print("Opening port")
        ser.open()
    nrw = 0
    nrw += ser.write(struct.pack('<H', len(data)))           # upload lower byte
    print('Transferring transaction sequence: %i bytes' % nrw)
    
    print('Transferring 0x%04X bytes' % len(data))
    ser.write(data)

if __name__ == '__main__':
    main()