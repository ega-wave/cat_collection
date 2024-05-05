# cat.s -- plain cat(1) read from stdin and write to stdout
# 
# Copyright (C) 2024 Yoshitaka Egawa.
# 
# This program is free software: you can redistribute it and/or 
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either 
# version 3 of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with this program.
# If not, see <https://www.gnu.org/licenses/>.

# Written by Yoshitaka Egawa.

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
.loop1:
	movl	$131072, %edx # edx = 131072
	xorl	%edi, %edi    # edi = 0 (fd)
	xorl	%eax, %eax    # syscall_id = 0 (read)
	syscall               # rax = read(edi, rsi, edx);
	testl	%eax, %eax    # eax == 0
	je	.finish       # if (eax == 0) goto .finish

	movl	%eax, %edx    # edx = eax
	incl	%edi          # edi = 1 (fd)
	movl	%edi, %eax    # syscall_id = 1 (write)
	syscall               # rax = write(edi, rsi, rdx)
	cmpl	%eax, %edx    # eax == edx
	je	.loop1        # if (eax == edx) goto .loop1
	movb	$1, %al       # al = 1
.finish:
	popq	%rdx
	popq	%rbp
.exit:
	movb %al, %dil # return code
	movb $60, %al  # syscall_id = 60 (exit)
	syscall

	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 131072
buf:
	.zero	131072

