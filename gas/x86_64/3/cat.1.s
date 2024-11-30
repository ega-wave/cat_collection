	.file	"cat.c"
	.text
	.section	.text.startup,"ax",@progbits
/*
int main()
{
*/
	.globl	_start
	.type	_start, @function
_start:
	pushq	%r12
	leaq	write_buf(%rip), %r12
	pushq	%rbp
	leaq	read_buf(%rip), %rbp
	pushq	%rsi
	pushq	%rbx
	pushq	%rcx
	pushq	%rdx
	movl	$1, %ebx      /* ebx = 1 */

.loop:
.read:
	movl	$131072, %edx /* edx = 131072 */
	movq	%rbp, %rsi    /* rsi = rbp (=read_buf) */
	xorl	%edi, %edi    /* edi = 0 (fd) */
	xorl	%eax, %eax    /* syscall_id = 0 (read) */
	syscall               /* rax = read(edi, rsi, edx); */
	movq	%rax, %rdx    /* rdx = rax (used in .write) */
	movq	%rax, %rcx    /* rcx = rax (used in .memcpy) */
	testq	%rax, %rax    /* rax == 0 ? */
	je	.exit0        /* if true, goto .exit0 (with eax=0) */
                              /* if false, fall through */

.memcpy:
	movq	%r12,  %rdi    /* rdi = r12  (=write_buf) */
	movq	%rbp, %rsi    /* rsi = rbp (=read_buf) */
	rep movsb             /* for rcx-times, *rdi++ = *rsi++ */

.write:
	movq	%r12,  %rsi    /* rsi = r12 (=write_buf) */
	movl	%ebx, %edi    /* edi = 1 (fd) */
	movl	%ebx, %eax    /* syscall_id = 1 (write) */
	syscall               /* rax = write(edi, rsi, rdx) */
	cmpq	%rax, %rdx    /* rax == rdx ? */
	je	.read         /* if true, goto .read */
                              /* if false, fall through */

.exit1:
	movl	%ebx, %eax    /* eax = 1 */
                              /* fall through */

.exit0:
.finish:
	popq	%rdx
	popq	%rcx
	popq	%rbx
	popq	%rsi
	popq	%rbp
	popq	%r12

.exit:
	movl %eax,%edi        /* return code */
	movb $60, %al         /* syscall_id = 60 (exit) */
	syscall               /* exit(al) # 0 or 1 */
	.size	_start, .-_start
/*
}
*/
	.globl	write_buf
	.bss
	.align 32
	.type	write_buf, @object
	.size	write_buf, 131072
write_buf:
	.zero	131072


	.globl	read_buf
	.align 32
	.type	read_buf, @object
	.size	read_buf, 131072
read_buf:
	.zero	131072


	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
