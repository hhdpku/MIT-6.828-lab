	.file	"init.c"
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"entering test_backtrace %d\n"
.LC1:
	.string	"leaving test_backtrace %d\n"
	.text
	.p2align 4
	.globl	test_backtrace
	.type	test_backtrace, @function
test_backtrace:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	%edi, %esi
	xorl	%eax, %eax
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	leaq	.LC0(%rip), %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edi, %ebx
	movq	%rbp, %rdi
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	call	cprintf@PLT
	testl	%ebx, %ebx
	jle	.L2
	leal	-1(%rbx), %r12d
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movl	%r12d, %esi
	call	cprintf@PLT
	testl	%r12d, %r12d
	je	.L3
	leal	-2(%rbx), %r13d
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movl	%r13d, %esi
	call	cprintf@PLT
	testl	%r13d, %r13d
	je	.L4
	leal	-3(%rbx), %r14d
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movl	%r14d, %esi
	call	cprintf@PLT
	testl	%r14d, %r14d
	je	.L5
	leal	-4(%rbx), %r15d
	xorl	%eax, %eax
	movq	%rbp, %rdi
	movl	%r15d, %esi
	call	cprintf@PLT
	testl	%r15d, %r15d
	je	.L6
	leal	-5(%rbx), %edi
	call	test_backtrace
.L7:
	leaq	.LC1(%rip), %rbp
	movl	%r15d, %esi
	xorl	%eax, %eax
	movq	%rbp, %rdi
	call	cprintf@PLT
.L8:
	movl	%r14d, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	call	cprintf@PLT
.L9:
	movl	%r13d, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	call	cprintf@PLT
	jmp	.L10
	.p2align 4,,10
	.p2align 3
.L3:
	xorl	%edx, %edx
	xorl	%esi, %esi
	leaq	.LC1(%rip), %rbp
	xorl	%edi, %edi
	call	mon_backtrace@PLT
.L10:
	movl	%r12d, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	call	cprintf@PLT
.L11:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	movl	%ebx, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	jmp	cprintf@PLT
	.p2align 4,,10
	.p2align 3
.L2:
	.cfi_restore_state
	xorl	%edx, %edx
	xorl	%esi, %esi
	leaq	.LC1(%rip), %rbp
	xorl	%edi, %edi
	call	mon_backtrace@PLT
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L5:
	xorl	%edx, %edx
	xorl	%esi, %esi
	leaq	.LC1(%rip), %rbp
	xorl	%edi, %edi
	call	mon_backtrace@PLT
	jmp	.L8
	.p2align 4,,10
	.p2align 3
.L4:
	xorl	%edx, %edx
	xorl	%esi, %esi
	leaq	.LC1(%rip), %rbp
	xorl	%edi, %edi
	call	mon_backtrace@PLT
	jmp	.L9
	.p2align 4,,10
	.p2align 3
.L6:
	xorl	%edx, %edx
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	mon_backtrace@PLT
	jmp	.L7
	.cfi_endproc
.LFE0:
	.size	test_backtrace, .-test_backtrace
	.section	.rodata.str1.1
.LC2:
	.string	"6828 decimal is %o octal!\n"
.LC3:
	.string	"x %d, y %x, z %d\n"
.LC4:
	.string	"H%x Wo%s"
	.text
	.p2align 4
	.globl	i386_init
	.type	i386_init, @function
i386_init:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	leaq	edata(%rip), %rdi
	leaq	end(%rip), %rdx
	xorl	%esi, %esi
	subl	%edi, %edx
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	call	memset@PLT
	call	cons_init@PLT
	movl	$6828, %esi
	leaq	.LC2(%rip), %rdi
	xorl	%eax, %eax
	call	cprintf@PLT
	movl	$4, %ecx
	xorl	%eax, %eax
	movl	$3, %edx
	movl	$1, %esi
	leaq	.LC3(%rip), %rdi
	call	cprintf@PLT
	leaq	.LC4(%rip), %rdi
	leaq	4(%rsp), %rdx
	xorl	%eax, %eax
	movl	$57616, %esi
	movl	$6581362, 4(%rsp)
	call	cprintf@PLT
	movl	$5, %edi
	call	test_backtrace
	.p2align 4,,10
	.p2align 3
.L15:
	xorl	%edi, %edi
	call	monitor@PLT
	jmp	.L15
	.cfi_endproc
.LFE1:
	.size	i386_init, .-i386_init
	.section	.rodata.str1.1
.LC5:
	.string	"kernel panic at %s:%d: "
.LC6:
	.string	"\n"
	.text
	.p2align 4
	.globl	_panic
	.type	_panic, @function
_panic:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	subq	$208, %rsp
	.cfi_def_cfa_offset 224
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
	testb	%al, %al
	je	.L19
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm1, 96(%rsp)
	movaps	%xmm2, 112(%rsp)
	movaps	%xmm3, 128(%rsp)
	movaps	%xmm4, 144(%rsp)
	movaps	%xmm5, 160(%rsp)
	movaps	%xmm6, 176(%rsp)
	movaps	%xmm7, 192(%rsp)
.L19:
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	cmpq	$0, panicstr(%rip)
	je	.L24
	.p2align 4,,10
	.p2align 3
.L21:
	xorl	%edi, %edi
	call	monitor@PLT
	jmp	.L21
.L24:
	movq	%rbx, panicstr(%rip)
#APP
# 72 "kern/init.c" 1
	cli; cld
# 0 "" 2
#NO_APP
	leaq	224(%rsp), %rax
	movl	%esi, %edx
	movq	%rdi, %rsi
	movl	$24, (%rsp)
	movq	%rax, 8(%rsp)
	leaq	32(%rsp), %rax
	leaq	.LC5(%rip), %rdi
	movq	%rax, 16(%rsp)
	xorl	%eax, %eax
	movl	$48, 4(%rsp)
	call	cprintf@PLT
	movq	%rbx, %rdi
	movq	%rsp, %rsi
	call	vcprintf@PLT
	leaq	.LC6(%rip), %rdi
	xorl	%eax, %eax
	call	cprintf@PLT
	jmp	.L21
	.cfi_endproc
.LFE2:
	.size	_panic, .-_panic
	.section	.rodata.str1.1
.LC7:
	.string	"kernel warning at %s:%d: "
	.text
	.p2align 4
	.globl	_warn
	.type	_warn, @function
_warn:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdx, %rbx
	subq	$208, %rsp
	.cfi_def_cfa_offset 224
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
	testb	%al, %al
	je	.L26
	movaps	%xmm0, 80(%rsp)
	movaps	%xmm1, 96(%rsp)
	movaps	%xmm2, 112(%rsp)
	movaps	%xmm3, 128(%rsp)
	movaps	%xmm4, 144(%rsp)
	movaps	%xmm5, 160(%rsp)
	movaps	%xmm6, 176(%rsp)
	movaps	%xmm7, 192(%rsp)
.L26:
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	leaq	224(%rsp), %rax
	movl	%esi, %edx
	movq	%rdi, %rsi
	movq	%rax, 8(%rsp)
	leaq	32(%rsp), %rax
	leaq	.LC7(%rip), %rdi
	movq	%rax, 16(%rsp)
	xorl	%eax, %eax
	movl	$24, (%rsp)
	movl	$48, 4(%rsp)
	call	cprintf@PLT
	movq	%rbx, %rdi
	movq	%rsp, %rsi
	call	vcprintf@PLT
	xorl	%eax, %eax
	leaq	.LC6(%rip), %rdi
	call	cprintf@PLT
	movq	24(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L29
	addq	$208, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L29:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE3:
	.size	_warn, .-_warn
	.globl	panicstr
	.bss
	.align 8
	.type	panicstr, @object
	.size	panicstr, 8
panicstr:
	.zero	8
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
