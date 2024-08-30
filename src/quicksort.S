.section .text     
.align 2 
.globl quicksort

quicksort:
  addi sp, sp, -20
  sw ra, 0(sp)
  sw a1, 4(sp) # start
  sw a2, 8(sp) # end
  sw a0, 12(sp) # int* p
  
  
  bge     a1, a2, done   # start >= end
  call    partition # a0 = q   
  
  
  addi    a2, a0, -1  # end = q - 1
  sw a0, 16(sp) # store q
  lw a0, 12(sp) # int* p
  lw a1, 4(sp) # start
  
  call    quicksort  
  
  lw a0, 12(sp) # int* p
  lw a2, 8(sp) # end
  lw a1, 16(sp) # q
  addi    a1, a1, 1 # start = q + 1    
  call    quicksort 
  
done:
  lw ra, 0(sp)
  addi sp, sp, 20
  ret


# a0 = int* p, a1 = start, a2 = end
partition:
    # your code here
    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)
    sw a0, 12(sp)

    slli a7, a2, 2 # 4*end
    add a7, a7, a0 # 4*end + *p
    lw a3, 0(a7) # x = p[end]
    addi a4, a1, -1 # tmp = start - 1
    addi a5, a1, -1 # i = start - 1
    mv a6, a1 # j = start
    bge a6, a2, out_loop # j >= end
    loop:
    slli a7, a6, 2 # 4*j
    add a7, a7, a0 # 4*j + *p
   
    lw s0,  0(a7) # p[j]
    
    blt a3, s0, end  #  x < p[j]
    # o.w.
    addi a5, a5, 1 # i++
    slli s1, a5, 2 # 4*i
    add s1, s1, a0 # 4*i + *p
    lw s0,  0(s1) # p[i]
    mv a4, s0 # tmp = p[i]
    lw s0, 0(a7) # p[j]
    sw s0 , 0(s1) # p[i] = p[j]
    sw a4, 0(a7) # p[j] = tmp


    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a3, 24(sp)
    sw a4, 28(sp)
    sw a5, 32(sp)
    sw a6, 36(sp)
    sw a7, 40(sp)
    call arrayViz # draw pixels to board
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    lw a5, 32(sp)
    lw a6, 36(sp)
    lw a7, 40(sp)
    lw a0, 12(sp)
    end:
    addi a6, a6, 1 # j++
    blt a6, a2, loop # j < end
    
    out_loop:
    addi a7, a5, 1 # i+1
    slli a7, a7, 2 # (i+1)*4
    add a7, a7, a0 # (i+1)*4 + *p
    lw s0, 0(a7) # p[i+1]
    mv a4, s0 # tmp = p[i+1]
    sw a3, 0(a7) # p[i+1] = p[end]
    
    slli a7, a2, 2 # 4*end
    add a7, a7, a0 # 4*end + *p
    sw  a4, 0(a7) # p[end] = tmp
    addi a5, a5, 1 
    
    lw a0, 12(sp)
    sw a5, 32(sp)
    call arrayViz # draw pixels to board
    lw a5, 32(sp)
    mv a0, a5 # i + 1
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 44
    ret
  