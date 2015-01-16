import sys
print("source, input, and output files:")
for x in range(0, 3):
    print (sys.argv[x])

print("resulting file contents:")
file_object = open(sys.argv[1], 'r')
write_file = open(sys.argv[2], 'w')
for line in file_object:

    lineseg1 = line[:2] # get the first 2 characters
    lineseg2 = line[2:4] # get characters 3 and 4
    temp = int(lineseg2, 16) #convert from base 16 to base 10 
    line2 = line[4:] # get the first 4 characters

    #declare variables
    len = 0
    line3 = ''

    #collect the address, address length is based upon S#, S1 = 2 bytes, S2 = 3 bytes, S3 = 4 bytes
    if lineseg1 == "S1":
        len = 2
    if lineseg1 == "S2":
        len = 3
    if lineseg1 == "S3":
        len = 4

    for y in range(0, len*2):
        line3 += line2[y]

    ram_start = int(line3, 16) #convert from base 16 to base 10 

    #more variables
    full_line = ''
    test = ''
    ram_val = ram_start

    #construct lines then print
    for x in range(len, temp-1):
        full_line += "ram["
        full_line += str(ram_val)
        full_line += "] = 8'h"
        full_line += str(line2[x*2:(x+1)*2]) 
        full_line += ";"
        print (full_line)
        write_file.write( full_line )
        write_file.write( "\n" )
        full_line = ''
        ram_val += 1
