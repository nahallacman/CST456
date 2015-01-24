

#program header
print("PROG_START	EQU		$2000\n   org		PROG_START	");

#generate 256 address and value pairs
for x in range(0,256):
    temp = ''
    #construct a 2 digit hex number that has a leading 0 if the value is less than 0x10 (16 hex)
    temp = hex(x);
    temp2 = temp[2:];
    if int(temp2, 16) < 0x10:
        temp3 = "0" + temp2;
    else:
        temp3 = temp2;
    
    #print the constucted string
    temp4 = "#$" + temp3;
    print("ldaa", temp4);

    print("coma");

    temp5 = "$40" + temp3;
    print("staa", temp5);

#program footer
print("jump		jmp     jump\n  org		$FFFE\n FDB		PROG_START");