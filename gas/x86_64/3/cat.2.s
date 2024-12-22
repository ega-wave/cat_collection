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
	pushq	%rbp
	pushq	%r8
	pushq	%rbx
	pushq	%rcx
	leaq	read_buf(%rip), %rbp
	leaq	write_buf(%rip), %r8
	movl	$1, %ebx      /* ebx = 1 */
/*
rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp	r8
	1	loop	13	fd	buf	rd_buf		wr_buf
						u/		
								u/
	u/							
		u/						
						/rb		
								/wb
	/1							
*/

.loop:
.read:
	xorl	%edi, %edi
	movl	$131072, %edx
	movq	%rbp, %rsi
	xorl	%eax, %eax    /* syscall_id = 0 (read) */
	syscall               /* rax = read(edi, rsi, edx); */
	testq	%rax, %rax
	je	.exit0        /* if true, goto .exit0 (with eax=0) */
                              /*    else, fall through */
/*
rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp	r8
	1	loop	13	fd	buf	rd_buf		wr_buf
				u/0				
	/13							
					/rb	rb/		
u/0								
0/cr	13/			0/	rb/			
cr/								
*/

.memcpy_initialize:
	xorl	%ecx, %ecx
	movq	%r8, %rsi
/*
rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp	r8
	1	loop	13	fd	buf	rd_buf		wr_buf
		u/0						
					/wb			wb/
*/

.memcpy:
	movb	0(%rbp,%rcx), %dl /* dl = rbp[rcx] */
	movb	%dl, (%rsi,%rcx)  /* rsi[rcx] = dl */
	incq	%rcx
	cmpq	%rax, %rcx
	jne	.memcpy
/*
rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp	r8
	1	loop	13	fd	buf	rd_buf		wr_buf
		lc/	/rb[lc]			rb/		
		lc/	rb[lc]/		wb/			
		lc/lc+1						
cr/		lc/						
*/

.write:
	movl	%ebx, %edi    /* edi = 1 (fd) */
	movq	%rcx, %rdx
	movl	%ebx, %eax    /* syscall_id = 1 (write) */
	syscall               /* rax = write(edi, rsi, rdx) */
	cmpq	%rax, %rdx
	je	.read
/*
rax	rbx	rcx	rdx	rdi	rsi	rbp	rsp	r8
	1	loop	13	fd	buf			wr_buf
	1/			/1				
					/wb			wb/
		cr/	/cr					
/1	1/							
/cw			cr/	1/	wb/			
cw/			cr/					
*/

.exit1:
	movl	%ebx, %eax    /* eax = 1 */

.exit0:
.finish:
	popq	%rcx
	popq	%rbx
	popq	%r8
	popq	%rbp

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
