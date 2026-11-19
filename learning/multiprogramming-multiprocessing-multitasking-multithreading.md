**Multiprogramming, Multiprocessing, Multitasking, and Multithreading**

I really want to thank the author Gabriel Tolomei for his clear writing for the [source of this article which I basically copied in it's entire structure and organization.](https://gabrieletolomei.wordpress.com/miscellanea/operating-systems/multiprogramming-multiprocessing-multitasking-multithreading/) Thank you author.

Generally speaking, the part of the Operating System that handles allocation of scarce resources to computer programs is called the **Scheduler**

# Multiprogramming

> The ultimate goal of Multiprogramming is to keep the CPU as busy as possible.

A multiprogramming system is a system where there are one or more programs loaded in memory which are ready to execute.

Only one program can use the CPU, so in a multiprogramming system we do `process context switching`: interrupting a running program that does not have to execute a CPU instruction currently to give CPU time to another program.

A popular example of when you may need to do this is when one program is I/O bound (waiting on a network request for example). You'd want the program to not stall everything. A program only gives up "CPU access" either when it voluntarily releases it or it is I/O bound.

One issue with this approach is that processes must not edit each others state; the operating system must provide a safe "sandbox" for each program. On a Linux Operating System this is achieved via [Virtual Memory and Pagination](https://gabrieletolomei.wordpress.com/miscellanea/operating-systems/virtual-memory-paging-and-swapping/)

You may read about my notes on Virtual Memory and Pagination [here](./virtual-memorybpaging-swapping)

Since the amount of CPU time a process takes is basically uncapped here, a process waiting on a task can need to wait for N-1 processes (N being the amount of active processes on the computer system) before waiting to execute.

Multitasking solves this by giving a fair *amount of time* (quantum) to each process.

# Multitasking 

Multitasking is just multiprogramming but in a general sense. so programs, processes, tasks, threads instead of just processes.

programs share a fair 'quantum' (time amount) of the CPU while giving the illusion of paralellism; Both multiprogramming and multitasking share CPU time, but in multitasking systems that sliver is fair.

This is because it is not only bound to a process finishing work or not. A process can be divided into multiple "threads of execution". This could range from a function call (along with all of the functions it depends on) to operating system 'threads' that the program spawns.

# Multiprocessing 

Multiprocessing is a hardware term. It refers to hardware that allow for multiple units / cores. So a CPU with 4 cores would be a multiprocessing CPU.

# Multithreading

So up until now: 

> Multiprogramming allows for multiple processes to be ran on one machine. Each process blocking the CPU until it is done with it's work, or is non-cpu-bound.
> Multiprocessing is when you have multiple CPU units (usually cores); so for N cpu units you can have N independent execution 'threads'. if you have 2 cores, you can basically run 2 multiprogramming systems in parallel (only two parallel executions at a time).
>And multitasking is a more general term for multiprogramming

Threads are basically like child processes that run with the processes resources. You would need this for example for a Video editing app, where encoding a video for export would be computationally expensive, but you wouldn't want to have it block the main thread of execution (the editor GUI itself.). It allows for *apparent* parallel execution within one process.

Multithreading has its own slew of problems: it is more complex for the developer to implement a multithreaded system because they need to worry about asynchronous access. Common ways to get around this are to use OS and programming language primitives such as *mutexes* and *semaphores* 

> [!WARNING]
> (I DO NOT UNDERSTAND SEMAPHORES OR OS LEVEL MUTEXES! (only application lvl)) 

> [!NOTE]
> Note that CPU threads are different from operating system threads, as one is a CPU unit but the other is an independent execution thread.

A quote from the article itself, which I think is too perfect to summarize in my own words:

> The concept of context switching applies to multiprogramming as well as to multitasking yet at a different level of granularity. In the former, the “context” refers to that of a whole process whereas in the latter the “context” may be that of a lighter thread. In fact, process context switching involves switching the virtual memory address space: this includes memory addresses, mappings, page tables, and kernel resources. On the other hand, thread context switching is context switching from one thread to another in the same process (i.e. there is no need of switching the virtual memory address space as the “switcher” and the “switchee” threads share the same virtual address space). This requires switching processor state (such as the program counter and register contents), which is generally very efficient.
>
> Of course, switching from thread to thread across different processes is just like process context switching.

# So, to recap:

Processes (apparently) parallelize via threads, and threads (apparently) paralellize via the scheduler, which shares CPU time between processes/threads which are broken down into their own respective threads of execution (a thread can have a function which needs to be completed fully for example before it can safely stop its execution. The stack may be frozen to keep the variables intact when time is shared to another process).

