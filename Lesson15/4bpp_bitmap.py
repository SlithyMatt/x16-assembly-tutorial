import sys

# open GIMP indexed raw data file
f = open(sys.argv[1], "rb")
iData = bytearray(f.read()) # read to array
f.close()

# open bitmap output file, initialize with address header
f = open("BITMAP.BIN", "wb")
oData = bytearray([0,0]) # header

# consolidate pixels to 4bpp
for i in range(0,len(iData)/2):
    oData.append((iData[i*2] << 4) | iData[i*2+1])

# write bitmap file
f.write(oData)
f.close()

# open GIMP palette file
f = open(sys.argv[1] + ".pal", "rb")
iData = bytearray(f.read()) # read to array
f.close()

# open palette output file, initialize with address header
f = open("PAL.BIN", "wb")
oData = bytearray([0,0]) # header

# truncate colors to 12-bit
for i in range(0,len(iData)/3):
    b = iData[i*3+1] & 0xF0 # blue
    b = b | (iData[i*3+2] >> 4) # green
    oData.append(b) #BG
    b = iData[i*3] >> 4 # red
    oData.append(b) #0R

# write palette file
f.write(oData)
f.close()
