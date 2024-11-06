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
	xorl	%edi, %edi    # rdi = 0
	xorl	%eax, %eax    # rax = 0
	movq	%rbp, %rsi    # rsi = rbp (void* buf)
/*
rax	rdx	rdi	rsi	rbp
				u/
				/b
	u/			
		u/0		
u/0				
			/b	b/
b : (void*)buf
u : (uninitialized value)
*/

.loop1:
.read:
	movl	$131072, %edx # edx = 131072
	xorl	%edi, %edi    # edi = 0 (fd)
	xorl	%eax, %eax    # syscall_id = 0 (read)
	syscall               # rax = read(edi, rsi, edx);
	testl	%eax, %eax    # eax == 0
	je	.finish       # if true goto .finish
/*
rax	rdx	rdi	rsi	rbp
	/13			
		u/0		
u/0				
/rc	13/	0/	b/	
rc/				

b : (void*)buf
13: buf_size(=131072)
rc: read_count
*/

.write:
	movl	%eax, %edx    # edx = eax
	incl	%edi          # edi = 1 (fd)
	movl	%edi, %eax    # syscall_id = 1 (write)
	syscall               # rax = write(edi, rsi, rdx)
	cmpl	%eax, %edx    # eax == edx
	je	.loop1        # if true goto .loop1
	movb	$1, %al       # else al = 1 (and fall through)
/*
rax	rdx	rdi	rsi	rbp
rc/	/rc			
		0/1		
/1		1/		
/wc	rc/	1/	b/	
wc/	rc/			
/1				

b : (void*)buf
rc: read_count
wc: write_count
*/

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

