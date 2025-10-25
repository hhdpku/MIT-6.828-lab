/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */

.text

#define TRAPHANDLER(name, num)              \
	.globl name;                            \
	.type name, @function;                  \
	.align 2;                               \
name:                                   	\
	pushl $(num);                           \
	jmp _alltraps;                          \

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */

#define TRAPHANDLER_NOEC(name, num)         \
	.globl name;                            \
	.type name, @function;                  \
	.align 2;                               \
name:                                   	\
	pushl $0;                               \
	pushl $(num);                           \
	jmp _alltraps;                          \

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(divide, T_DIVIDE)
TRAPHANDLER_NOEC(debug, T_DEBUG)
TRAPHANDLER_NOEC(nmi, T_NMI)
TRAPHANDLER_NOEC(brkpt, T_BRKPT)
TRAPHANDLER_NOEC(oflow, T_OFLOW)
TRAPHANDLER_NOEC(bound, T_BOUND)
TRAPHANDLER_NOEC(illop, T_ILLOP)
TRAPHANDLER_NOEC(device, T_DEVICE)
TRAPHANDLER(dblflt, T_DBLFLT)

TRAPHANDLER(tss, T_TSS)
TRAPHANDLER(segnp, T_SEGNP)
TRAPHANDLER(stack, T_STACK)
TRAPHANDLER(gpflt, T_GPFLT)
TRAPHANDLER(pgflt, T_PGFLT)

TRAPHANDLER(fperr, T_FPERR)
TRAPHANDLER(align, T_ALIGN)
TRAPHANDLER(mchk, T_MCHK)
TRAPHANDLER(simderr, T_SIMDERR)
TRAPHANDLER_NOEC(syscall_entry, T_SYSCALL)

.data
.globl trap_table
trap_table:
    .long T_DIVIDE, divide, 0
    .long T_DEBUG, debug, 0
    .long T_NMI, nmi, 0
    .long T_BRKPT, brkpt, 3
    .long T_OFLOW, oflow, 0
    .long T_BOUND, bound, 0
    .long T_ILLOP, illop, 0
    .long T_DEVICE, device, 0
    .long T_DBLFLT, dblflt, 0
    .long T_TSS, tss, 0
    .long T_SEGNP, segnp, 0
    .long T_STACK, stack, 0
    .long T_GPFLT, gpflt, 0
    .long T_PGFLT, pgflt, 0
    .long T_FPERR, fperr, 0
    .long T_ALIGN, align, 0
    .long T_MCHK, mchk, 0
    .long T_SIMDERR, simderr, 0
    .long T_SYSCALL, syscall_entry, 3
    .long -1, 0, 0

/*
 * Lab 3: Your code here for _alltraps
 */
 .text
.globl _alltraps
_alltraps:
	# 保存段寄存器
	pushl %ds
    pushl %es
	# 保存通用寄存器
	pushal
	# 设置内核数据段
	movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es
	pushl %esp
	call trap