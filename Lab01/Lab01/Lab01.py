
file_object = open('C:\\Users\\cal\\Desktop\\School\\CST456\\CST456-Week1\\example_input.s19', 'r')
for line in file_object:
    #print (line)
    lineseg1 = line[:2] # get the first 2 characters
    lineseg2 = line[2:4] # get characters 3 and 4
    temp = int(lineseg2, 16)
    line2 = line[4:]
    len = 0
    line3 = ''

    if lineseg1 == "S1":
        len = 2
    if lineseg1 == "S2":
        len = 3
    if lineseg1 == "S3":
        len = 4

    #print("address beginning: ")
    for y in range(0, len*2):
        #print(line2[y])
        line3 += line2[y]

    ram_start = int(line3, 16)
    #print (ram_start)

    full_line = ''
    test = ''
    for x in range(len, temp-1):
        full_line += "ram["
        full_line += str(ram_start)
        full_line += "] = 8'h"
        full_line += str(line2[x*2:(x+1)*2]) # this line needs work
        full_line += ";"
        print (full_line)
        full_line = ''
        ram_start += 1

        #print ("ram[") 
        #print (ram_start)
        #print ("] = 8'h")
        #print(line2[x*2:(x+1)*2])
        #print (";")


#    if lineseg1 == 'S1':
 #       testing = 1
  #      lineseg3 = line[4:8] # get characters 5 6 7 8
   #     line2 = line[8:] # get all characters after 8
    #if lineseg1 == 'S2':
#        testing = 2
 #       lineseg3 = line[4:10] # get characters 5 6 7 8 9 10
  #      line2 = line[10:] # get all characters after 8
   # if lineseg1 == 'S3':
    #    testing = 3
     #   lineseg3 = line[4:12] # get characters 5 6 7 8 9 10 11 12
      #  line2 = line[12:] # get all characters after 8
#    print (lineseg1)
 #   print (lineseg2)
  #  print (lineseg3)
    
   # for x in range(0, int(lineseg2)):
    #    print (line2[x*2:(x+1)*2])



#line = file_object.readline()
#print (line)


print('Hello World')