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
	.p2align 4
_start:
	pushq	%rbx
	pushq	%rsi
	pushq	%rdx
	leaq	buf(%rip), %rsi
	movl	$1, %ebx	/* ebx = 1 */
				/* fall through */
/*
rax	rbx	rdx	rdi	rsi
	u/
				u/
		u/
				/b
	/1
b : (void*)buf
u : (uninitialized value)
*/

	.p2align 4
.loop1:
.read:
	movl	$131072, %edx # edx = 131072
	xorl	%edi, %edi    # edi = 0 (fd)
	xorl	%eax, %eax    # syscall_id = 0 (read)
	syscall               # rax = read(edi, rsi, edx);
	testl	%eax, %eax    # eax == 0
	je	.exit0        # if true goto .exit0 (with eax == 0)
				/* else fall through */
/*
rax	rbx	rdx	rdi	rsi
		/13
			u/0
u/0
0/rc		13/	0/	b/
rc/

b : (void*)buf
13: buf_size(=131072)
rc: read_count
*/

.write:
	movl	%eax, %edx    # edx = eax
	movl	%ebx, %edi    # edi = 1 (fd)
	movl	%ebx, %eax    # syscall_id = 1 (write)
	syscall               # rax = write(edi, rsi, rdx)
	cmpl	%eax, %edx    # eax == edx
	je	.loop1        # if true goto .loop1
				/* else fall-through */
/*
rax	rbx	rdx	rdi	rsi
rc/		/rc
	1/		/1
/1	1/
1/wc		rc/	1/	b/
wc/		rc/

b : (void*)buf
rc: read_count
wc: write_count
*/

.exit1:
	movl	%ebx, %eax	/* eax = 1 */

	.p2align 4
.exit0:
.finish:
	popq	%rdx
	popq	%rsi
	popq	%rbx
.exit:
	movl %eax,%edi # return code
	movb $60, %al  # syscall_id = 60 (exit)
	syscall        # exit(al) # 0 or 1
/*
rax	rbx	rdx	rdi	rsi
0/			/0
/60
60/			0/
*/
	.size   _start, .-_start

	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 131072
buf:
	.zero	131072

