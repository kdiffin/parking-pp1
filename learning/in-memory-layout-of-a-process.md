**The in memory layout of a process on a 32-bit (CPU) Linux system**. 
A 32 bit CPU can address a maximum of $2^{32}-1$ addresses on a byte addressed system. each number corresponding to a byte within the contiguous block of memory.

>[!NOTE]
> Using workarounds like PAE (Physical Address Extension) one process can have more than 2^32 (or 64 or whatever depending on the CPU architecture) amount of memory assigned to it, but I don't know how they work and this is beyond the scope of this article)

This is also why the size of a pointer on a 32 bit system is 32 bits (4 bytes) or why it is 64 bits (8 bytes) on a 64 bit CPU architecture. Because each "number" refers to a byte in memory.

diagrams and the mental model are directly taken from [Gabriele Tolomei's article on the matter](https://gabrieletolomei.wordpress.com/miscellanea/operating-systems/in-memory-layout/) 
**Thank you author**

Each process on a [multitasking OS](./multiprogramming-multiprocessing-multitasking-multithreading.md) has it's own virtual address space in memory. This brings a bunch of safety and convenience with itself. And it also allows for every process to think that they have the full 4GiB of ram available to them when they actually don't. Virtual memory is just one of the ways computers trick processes into thinking they own the whole machine! 
See [my notes on the matter](./visual-memory-paging-swapping.md) for a more detailed explanation of virtual memory.

The kernel is also a process on a Linux system, therefore the kernel space also needs its own block of memory allocated to it. As an example we can give the Kernel 1gb of space (which is inaccessible to user space programs (anything other than the kernel) and 3gb for user space. 
![Process memory layout](./imgs/Pasted%20image%2020261119185632.png)


Here is a common memory layout of a process in user space. 
![User space memory layout](./imgs/Pasted%20image%2020261119191108.png)
1GB of numbers allocated for the kernel, the other 3gb for the user space program. While studying about compilers and programming languages you may have encountered terms such the stack and the heap. 

**Text**: the text segment is the code which is executed when running the program. This part in memory of the process can be shared with other processes, to not have to load in popular programs such as *vim* into memory everytime one needs to open a text editor. Each program shares the 'code' but keeps its own private stack, heap, bss and data. You may see an illustration of that below 

![Shared text segment](./imgs/Pasted%20image%2020261119192518.png)
Note that the text is Read-only/Execute. it is not modifiable as that would cause security issues and would cause undefined behaviour.

**Data:** Data is where all variables marked as `global` and `static` are stored. the Data part of memory is generally Read-Write but may also be read only. 

Quoted from the article:
>For instance, the following C statements outside the `main` (i.e., global)  
> `char s[] = "hello world";`  
>`int debug = 1;`  
>would be stored in initialized `Read-Write` area.  
>On the other hand, a C statement like the following  
>`const char* str = "hello world";`  
>defines a character **pointer** variable (identified by `str`), which points to the first char of the constant string literal `"hello world"`. 
>In such a case, the string literal `"hello world"` is stored in initialized `Read-only` area while the character pointer variable `str` in initialized `Read-Write` area (because it may actually be modified at run-time). Similarly, `static int i = 10;` will also be stored in the `Read-Write` area of the data segment.

**BSS segment (also referred to as the "Uninitialized data segment"):** is also for global variables, but its mostly for global variables that are initialized with no default initialization in the source code. Data in this segment will be initialized with a default value of arithmetic `0`. 

`static int i;` for example would be stored in the BSS segment of memory with a value of `0`. As the article states, this comes from an archaic assembler operator that started with `Block Started by Symbol`. The BSS is Read-Write.

# The stack and the heap

**Stack:** the stack is located right below the kernel space, and typically grows downwards (although in some operating system architectures it may grow upwards). The heap on the otherhand grows upwards. Obviously it is a LIFO data structure. and it keeps all of the 

**Heap:** The heap is for any sort of dynamic memory which's size cannot be determined at compile time. Think dynamic arrays and data structures with variable sizes.

>It is managed by `malloc/new`, `free/delete`, which may use the `brk` and `sbrk` **system calls** to adjust its size.

[Source: the rust book](https://web.mit.edu/rust-lang_v1.25/arch/amd64_ubuntu1404/share/doc/rust/html/book/first-edition/the-stack-and-the-heap.html#the-stack) on the differences between the heap and stack.
>The stack is very fast, and is where memory is allocated in Rust by default. But the allocation is local to a function call, and is limited in size. The heap, on the other hand, is slower, and is explicitly allocated by your program. But it’s effectively unlimited in size, and is globally accessible. Note this meaning of heap, which allocates arbitrary-sized blocks of memory in arbitrary order, is quite different from the heap data structure.

To understand how the heap and stack work, please refer to that chapter. It is a great explanation IMO. The rest of the notes assume familiarity with that chapter.

>"There are some important things we have to take note of here. The numbers 0, 1, and 2 are all solely for illustrative purposes, and bear no relationship to the address values the computer will use in reality. In particular, the series of addresses are in reality going to be separated by some number of bytes that separate each address, and that separation may even exceed the size of the value being stored." 

Remember, the lower memory addresses are allocated to text. So we can't have memory address 0 1 and 2 refer to user space variables. This is why the book specifies that it is for illustrative purposes. 

Note that rust does not use malloc for its memory allocator, it uses jemalloc and some stuff related to the borrow checker which I have no idea of how they work.

## Which to use? 

Prefer stack allocation where possible. It is easier to manage - because of its access semantics being LIFO (all you need to do is just increment or decrement a stack pointer) and no heap lifecycle to clean up using a garbage collector / free; and more performant (because data is closer together in the CPU cache, less work for the CPU). The benefit of a heap is a more general access pattern: just store a pointer to the data and access it that way, anywhere in the heap memory. The heap has dynamic sizes and the lifecycle of the data is not tied to a specific function call, a strict limitation of storing data on the stack.
