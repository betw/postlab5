.section .text      # indicates a code segment
.align 2            # specifies how data should be arranged in memory
.globl pinSetup   # makes pinSetup able to be used outside of this file
.globl pinWrite     # makes pinWrite able to be used outside of this file
.globl pinRead      # makes pinRead able to be used outside of this file
.globl setPixel     # makes setPixel able to be used outside of this file
.globl eraseBuffer  # makes eraseBuffer able to be used outside of this file

# C declaration: int pinRead(int pin_num)
# ARGUMENTS a0: pin_num
# RETURNS bit read from GPIO pin
pinRead:
    lui a2, 0x60004
    addi a2, a2, 0x3C # GPIO_IN_ADDR 
      
    # YOUR CODE HERE...
    lw a3, 0(a2) # load word (input_val) from GPIO_IN_ADDR
    srl a4, a3, a0 # *input_val >> pin_num
    andi a0, a4, 1 # & 1
    jalr x0, 0(ra) 


# C declaration: void pinWrite(int pin_num, int value)
# ARGUMENTS a0: pin_num, a1: value
# RETURNS: Nothing
pinWrite:
    lui a2, 0x60004
    addi a2, a2, 0x4  # GPIO_OUT_ADDR
    lw a3, 0(a2) # load word (input_val) from GPIO_IN_ADDR
    addi a5, x0, 1 # 1
    
    beq a1, x0, skip_set_one # if (value != 0)
    addi a1, x0, 1 # value = 1;
    # value == 1
    sll a4, a5, a0 # 1 << pin_num
    or a4, a3, a4 # input_val | (1 << pin_num)
    sw a4, 0(a2)
    jalr x0, 0(ra)
    
    # value == 0
    skip_set_one:
    sll a4, a5, a0 # 1 << pin_num
    xori a4, a4, -1 # ~(1 << pin_num)
    and a4, a3, a4 # input_val & ~(1 << pin_num)
    sw a4, 0(a2)


    jalr x0, 0(ra)


# C declaration: void pinSetup(int pin_num, int mode)
# ARGUMENTS a0: pin_num, a1: mode
# RETURNS: Nothing
pinSetup:
     lui a2, 0x60009
    addi a2, a2, 0x4  # IO_MUX_GPIOn_ADDR
    
    addi a5, x0, 1 # 1
    lui a3, 0x60004
    addi a3, a3, 0x20 # GPIO_ENABLE_ADDR

    # YOUR CODE HERE...
    
    # mode == GPIO_OUTPUT (1)
    beq a1, x0, mode_input 
    lw a6, 0(a3) # load GPIO_enable
    sll a4, a5, a0 # 1 << pin_num
    or a4, a6, a4 # *gpio_enable | (1 << pin_num)
    sw a4, 0(a3)
    jalr x0, 0(ra)
    
    # mode == GPIO_INPUT (0)
    mode_input:
    # compute proper addres for IO_MUX 
    sll a7, a0, a5 # multiply pin_num by 2
    sll a7, a7, a5 # multiply pin_num by 2
    add a7, a2, a7
    lw a6, 0(a7) # load IO_MUX
    slli a5, a5, 8
    or a6, a6, a5 # *io_mux |= 1 << 8
    addi a5, x0, 1
    slli a5, a5, 9
    or a6, a6, a5
    sw a6, 0(a7) 
    jalr x0, 0(ra)


# C declaration: void setPixel(uint32_t* screen_buffer_addr, uint8_t x, uint8_t y, uint8_t val);
# ARGUMENTS a0: screen_buffer base address, a1: x, a2: y, a3: val
# RETURNS: Nothing
setPixel:
     # a0 buffer_addr, a1 x, a2, y, a3, val
    addi a5, x0, 1 # 1
    slli a2, a2, 2 # 4 * y
    add a2, a2, a0
    lw a6, 0(a2) # load screen_buffer[y_loc]
    beq a3, a5, val # if val == 1
    # val != 1
    sll a7, a5, a1  # 1 left shifted x
    xori a7, a7, -1
    and a7, a6, a7
    sw a7, 0(a2)
    jalr x0, 0(ra)
    # val == 1
    val:
     sll a7, a3, a1  # left shift val by x
     or a7, a6, a7 
     sw a7, 0(a2)
    jalr x0, 0(ra)


# C declaration: void eraseBuffer(uint32_t* screen_buffer_addr)
# ARGUMENTS a0: screen_buffer base address
# RETURNS: Nothing

eraseBuffer:
    addi a1, x0, 8      # upper bound on for loop
    addi a2, x0, 0      # "i" for for loop
looping:
    slli a3, a2, 2      # calculate 4*i
    add a4, a0, a3      # get address of array element by adding base address + 4*i
    sw zero, 0(a4)      # write 0 to memory address
    addi a2, a2, 1      # increment i
    bne a2, a1, looping # continue looping if i < 8
    jalr x0, 0(ra)      # return from eraseBuffer