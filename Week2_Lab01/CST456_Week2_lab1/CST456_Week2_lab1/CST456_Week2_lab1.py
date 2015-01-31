

#program header
print("PROG_START\tEQU\t\t$2000\n\t\t\torg\t\tPROG_START");

#choose the 3 A cases, or the 3 B cases
pick = 'b'

if(pick == 'a'):
    #generate 256 address and value pairs for LDAA and STAA
    # case #1A
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

    #generate 256 address and value pairs for TAB
    # case #3A
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

        print("\t\t\tTAB");

        temp5 = "$41" + temp3;
        print("\t\t\tstab", temp5);

    #generate 256 address and value pairs for COMA
    #case #2A
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

        temp5 = "$42" + temp3;
        print("\t\t\tstaa", temp5);

#now do the 3 b cases
if( pick == 'b' ):    
    #generate 256 address and value pairs for LDAA and STAA
    # case #1B
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
        print("\t\t\tldab", temp4);

        #print("\t\t\tcoma");

        temp5 = "$40" + temp3;
        print("\t\t\tstab", temp5);

    #generate 256 address and value pairs for TAB
    # case #3B
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
        print("\t\t\tldab", temp4);

        print("\t\t\tTBA");

        temp5 = "$41" + temp3;
        print("\t\t\tstaa", temp5);

    #generate 256 address and value pairs for COMA
    #case #2B
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
        print("\t\t\tldab", temp4);

        print("\t\t\tcomb");

        temp5 = "$42" + temp3;
        print("\t\t\tstab", temp5);



#program footer
print("jump\t\tjmp\tjump\n\t\t\torg\t\t$FFFE\n\t\t\tFDB\t\tPROG_START");