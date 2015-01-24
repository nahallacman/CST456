

#program header
print("PROG_START\tEQU\t\t$2000\n\t\t\torg\t\tPROG_START");

#generate 256 address and value pairs for LDAA and STAA
for x in range(0,256):
    temp = ''
    #construct a 2 digit hex number that has a leading 0 if the value is less than 0x10 (16 hex)
    temp = hex(x);
    temp2 = temp[2:];
    if int(temp2, 16) < 0x10:
        temp3 = "0" + temp2;
    else:
        temp3 = temp2;
    
    #print the constucted string for testing coma
    temp4 = "#$" + temp3;
    print("\t\t\tldaa", temp4);

    #print("\t\t\tcoma");

    temp5 = "$40" + temp3;
    print("\t\t\tstaa", temp5);

#generate 256 address and value pairs for COMA
for x in range(0,256):
    #temp = ''
    #construct a 2 digit hex number that has a leading 0 if the value is less than 0x10 (16 hex)
    temp = hex(x);
    temp2 = temp[2:];
    if int(temp2, 16) < 0x10:
        temp3 = "0" + temp2;
    else:
        temp3 = temp2;
    
    #print the constucted string for testing coma
    temp4 = "#$" + temp3;
    print("\t\t\tldaa", temp4);

    print("\t\t\tcoma");

    temp5 = "$41" + temp3;
    print("\t\t\tstaa", temp5);



#program footer
print("jump\t\tjmp\tjump\n\t\t\torg\t\t$FFFE\n\t\t\tFDB\t\tPROG_START");