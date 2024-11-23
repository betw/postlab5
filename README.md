Credit: 6.190 Staff (students implement core functionality (writing quicksort in assembly, etc...))

This lab was intended to test students on their Assembly programming skills, specifically calling functions and creating loops while 
adhering to the calling convention of the Assembly language (maintaining registers between calls etc...). The program displays the "Quicksort algorithm"
at work on an 8 x 32 display.

In detail:
This project visualizes the Quicksort algorithm on an 8x32 display using assembly language for sorting an array of integers. The program implements the Quicksort algorithm, showing the process of sorting in real-time by drawing pixel values that represent the array elements. The visualization is updated continuously, showing the current state of the array after each partitioning step, and demonstrating how the array evolves as the algorithm sorts it. The program is designed to be run on embedded hardware with an 8x32 display, where each array element is visualized as a series of bits.

The quicksort function is implemented in assembly and operates on an array of 8 integers. It follows standard recursive logic by partitioning the array and recursively sorting the subarrays. The partitioning step visually updates the display as elements are swapped and the algorithm progresses. After each partition operation, the state of the array is displayed on the screen, providing a clear view of how the sorting process unfolds.
