import sys

# open GIMP indexed raw data file
f = open(sys.argv[1], "rb")
iData = bytearray(f.read()) # read to array
f.close()

# create new byte array initialized with address header
oData = bytearray([0,0]) # header

# consolidate pixels to 4bpp
for i in range(0,int(len(iData)/2)):
    oData.append((iData[i*2] << 4) | iData[i*2+1])

# write new bytearray to output bitmap file
f = open("BITMAP.BIN", "wb")
f.write(oData)
f.close()

# open GIMP palette file
f = open(sys.argv[1] + ".pal", "rb")
iData = bytearray(f.read()) # read to array
f.close()

# create new byte array initialized with address header
oData = bytearray([0,0]) # header

# truncate colors to 12-bit
for i in range(0,int(len(iData)/3)):
    b = iData[i*3+1] & 0xF0 # green
    b = b | (iData[i*3+2] >> 4) # blue
    oData.append(b) #GB
    b = iData[i*3] >> 4 # red
    oData.append(b) #0R

# write new bytearray to output palette file
f = open("PAL.BIN", "wb")
f.write(oData)
f.close()
