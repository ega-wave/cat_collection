/* SPDX-License-Identifier: GPL-3.0-or-later */
/*
 * cat.s -- plain-cat(1) read from stdin and write to stdout
 *
 * Copyright (C) 2024- Yoshitaka Egawa (yegawa@ega-wave.co.jp)
 */

	.text
	.section	.text.startup,"ax",@progbits
	.globl _start
	.type  _start, @function
_start:
	pushq	%rbp
	leaq	buf(%rip), %rbp
	pushq	%rdx
	xorq	%rdi, %rdi    # rdi = 0
	xorq	%rax, %rax    # rax = 0
	movq	%rbp, %rsi    # rsi = rbp (void* buf)
# rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp
# 						r	
# 						wb	
# 			r				
# 				ru/w0			
# ru/w0							
# 					wb	rb	
# b = (void*)buf
# u = (uninitialized value)

.loop1:
.read:
	movl	$131072, %edx # edx = 131072
	xorl	%edi, %edi    # edi = 0 (fd)
	xorl	%eax, %eax    # syscall_id = 0 (read)
	syscall               # rax = read(edi, rsi, edx);
	testl	%eax, %eax    # eax == 0
	je	.finish       # if true goto .finish
# rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp
# 			wc1				
# 				r0/w0			
# r0/w0							
# wc2			rc1	r0	rb		
# rc2							
#
# b = (void*)buf
# c1= buf_size = 131072
# c2= read_count

.write:
	movl	%eax, %edx    # edx = eax
	incl	%edi          # edi = 1 (fd)
	movl	%edi, %eax    # syscall_id = 1 (write)
	syscall               # rax = write(edi, rsi, rdx)
	cmpl	%eax, %edx    # eax == edx
	je	.loop1        # if true goto .loop1
	movb	$1, %al       # else al = 1 (and fall through)
# rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp
# rc2			wc2				
# 				r0/w1			
# w1				r1			
# wc3			rc2	r1	rb		
# rc3			rc2				
# w1							
#
# b = (void*)buf
# c1= buf_size = 131072
# c2= read_count
# c3= write_count

.finish:
	popq	%rdx
	popq	%rbp
.exit:
	movb %al, %dil # return code
	movb $60, %al  # syscall_id = 60 (exit)
	syscall        # exit(al) # 0 or 1

	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 131072
buf:
	.zero	131072

