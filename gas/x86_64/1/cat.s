	.text
	.section	.text.startup,"ax",@progbits
	.globl _start
	.type  _start, @function
_start:
	pushq	%rbp
	leaq	buf(%rip), %rbp
	pushq	%rbx
	pushq	%rdx
	movq	%rbp, %rsi    # rsi = rbp (void* buf)
.loop1:
	movl	$131072, %edx # edx = 131072
	xorl	%edi, %edi    # edi = 0 (fd)
	xorq	%rax, %rax    # syscall_id = 0 (read)
	syscall               # rax = read(edi, rsi, edx);
	movq	%rax, %rbx    # rbx = rax
	testl	%eax, %eax    # eax == 0
	je	.L1           # if (eax == 0) goto .L1

	movslq	%eax, %rdx    # rdx = SignExtend(eax) (int read_count)
	movl	$1, %edi      # edi = 1 (fd)
	movq	%rdi, %rax    # syscall_id = 1 (write)
	syscall               # rax = write(edi, rsi, rdx)
	cmpl	%eax, %ebx    # eax == ebx
	je	.loop1        # if (eax == ebx) goto .loop1
	movl	$1, %eax      # eax = 1
.L1:
	popq	%rdx
	popq	%rbx
	popq	%rbp
.exit:
	movq $60, %rax # syscall_id
	movq $0,  %rdi # return code
	syscall

	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 131072
buf:
	.zero	131072

# gcc -c exit.s && ld exit.o -o cat #&& ./cat

#rax rdi
#60      rax = 60
#    1   rdi = 1
#        syscall

