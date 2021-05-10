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

# write new bytearray to output sprites file
f = open("SPRITES.BIN", "wb")
f.write(oData)
f.close()
