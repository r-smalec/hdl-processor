# instruction's bits:
#  15, 14,     13, ... 8,      7,  ... 0
#  R1  R0      instr code        data

input_file_path = "code.asm"
output_file_path = "code.machine"

def r0_or_r1(reg, act_line_no):
    if      reg == "R0":
        return "01"
    elif    reg == "R1":
        return "10"
    else:
        print(f"Register unknown, line '{act_line_no}'")
        return "00"

def parse_value_to_binary(val, val_binary_length, act_line_no):
    if int(val) >= 0 and int(val) <= ((2 ** val_binary_length) - 1):
        return bin(int(val))[2:].zfill(val_binary_length)
    else:
        print(f"Value invalid, line '{act_line_no}'")
        return "00000000"

def find_label(list, label):
    line_no = 1
    label += ":"
    for line in list:
        args = line.split()
        if args[0] == label:
            return line_no
        else:
            line_no += 1
    
    print(f"No label {label} found")
    return 0

def compiler():
    try:
        with open(input_file_path, 'r') as input_file, open(output_file_path, 'w') as output_file:
            line_no = 0
            for line in input_file:
                args = line.split()
                machine_code_line = ""
                print_code_line = 1

                if      args[0] == "NOT": # !
                
                    machine_code_line += "00"
                    machine_code_line += "000000"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)

                elif    args[0] == "XOR": # ^
                
                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "000001"
                    machine_code_line += parse_value_to_binary(args[2], 8, line_no)
                    
                elif    args[0] == "OR": # |
                                
                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "000010"
                    machine_code_line += parse_value_to_binary(args[2], 8, line_no)
                  
                elif    args[0] == "AND": # &
                                
                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "000011"
                    machine_code_line += parse_value_to_binary(args[2], 8, line_no)
                  
                elif    args[0] == "SUB": # -
                                
                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "000100"
                    machine_code_line += parse_value_to_binary(args[2], 8, line_no)
                  
                elif    args[0] == "ADD": # +
                                
                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "000101"
                    machine_code_line += parse_value_to_binary(args[2], 8, line_no)
                  
                elif    args[0] == "RR": # >>
                
                    machine_code_line += "00"
                    machine_code_line += "000110"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)
                
                elif    args[0] == "RL": # <<
                
                    machine_code_line += "00"
                    machine_code_line += "000111"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)
                
                elif    args[0] == "DEC": # --
                    
                    machine_code_line += "00"
                    machine_code_line += "001000"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)
               
                elif    args[0] == "INC": # ++
                    
                    machine_code_line += "00"
                    machine_code_line += "001001"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)
                
                elif    args[0] == "LD": # Load

                    machine_code_line += "00"
                    machine_code_line += "001010"
                    machine_code_line += parse_value_to_binary(args[1], 8, line_no)

                elif    args[0] == "ST": # Store

                    machine_code_line += r0_or_r1(args[1], line_no)
                    machine_code_line += "00101100000000"
                
                elif    args[0] == "JMPF" or args[0] == "JMPB": # Jump forward or backward
                    machine_code_line += "00"
                    try:
                        with open(input_file_path, 'r') as input_file_to_search:
                            label_line = find_label(input_file_to_search, args[1])
                            input_file_to_search.close()
                    except:
                        print(f"File {input_file_path} read error")
                    
                    relative_address = label_line - line_no
                    if    args[0] == "JMPF" and relative_address >= 0:
                        machine_code_line += "001100"
                        machine_code_line += parse_value_to_binary(relative_address, 8, line_no)
                    elif  args[0] == "JMPB" and relative_address < 0:
                        machine_code_line += "001101"
                        relative_address = -relative_address
                        machine_code_line += parse_value_to_binary(relative_address, 8, line_no)
                    else:
                        if(label_line != 0):
                            print("Syntax error: label's position does not match jump type")
                    print(relative_address)

                elif    args[0] == "NOP": # Nope
                
                    machine_code_line += "0011110000000000"
                
                elif    args[0] == "RST": # Reset
                
                    machine_code_line += "0011111100000000"
                
                elif    args[0][-1] == ":": # Label
                    print_code_line = 0

                else:
                
                    print(f"Command unknown, line '{line_no}'")
                    print_code_line = 0


                if print_code_line:
                    if line_no <= 9:
                        output_file.write(f"\t.CELL0{line_no}(16'b")
                    else:
                        output_file.write(f"\t.CELL{line_no}(16'b")

                    machine_code_line_mod = machine_code_line[:4] + "_" + machine_code_line[4:8] + "_" + machine_code_line[8:12] + "_" + machine_code_line[12:16]
                    output_file.write(f"{machine_code_line_mod}), // {' '.join(args)}\n")
                
                line_no += 1
        
        input_file.close()
        output_file.close()

    except FileNotFoundError:
        print(f"The file '{input_file_path}' does not exist.")

    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == '__main__':
    compiler()