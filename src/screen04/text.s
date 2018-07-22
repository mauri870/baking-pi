@; 
@; Functions for string utilities
@; 

.global ReverseString
ReverseString:
	start       .req r0								@; pointer to string
	end         .req r1                             @; string length

	add         end, start                          @; length = end + start - 1
	sub         end, #1

	revLoop$:
		cmp     end, start                          @; finished reverse
		movls   pc,lr

		ldrb    r2, [start]                         @; swap start and end chars
		ldrb    r3, [end]
		strb    r3, [start]
		strb    r2, [end]

		add     start, #1
		sub     end, #1
		b       revLoop$

.global UnsignedString
UnsignedString:
	value       .req r0								@; unsigned word
	string      .req r5
	base        .req r6
	length      .req r7
	push        {r4,r5,r6,r7,lr}

	mov         string, r1
	mov         base, r2
	mov         length, #0

	charLoop$:
		mov     r1, base
		bl      DivideU32
		cmp     r1, #9
		addls   r1, #'0'
		addhi   r1, #'a'-10
		teq     string, #0
		strneb  r1, [string, length]
		add     length, #1
		teq     value, #0
		bne     charLoop$
		
	.unreq 		value
	.unreq 		base
	teq 		string, #0
	movne 		r0, string
	movne 		r1, length
	blne 		ReverseString
	mov 		r0, length

	pop 		{r4,r5,r6,r7,pc}
	.unreq 		string
	.unreq 		length

.global SignedString
SignedString:
	value 		.req r0								@; signed word
	string 		.req r1								@; resulting string
	cmp 		value, #0
	bge 		UnsignedString

	rsb 		value, #0
	teq 		string, #0
	movne 		r3, #'-'
	strneb 		r3, [string]
	addne 		string, #1
	push 		{lr}
	bl 			UnsignedString
	add 		r0, #1
	pop 		{pc}
	.unreq 		value
	.unreq 		string

.global FormatString
FormatString:
	format 		.req r4
	formatLen 	.req r5
	dest 		.req r6
	nextArg 	.req r7
	argList 	.req r8
	length 		.req r9

	push 		{r4,r5,r6,r7,r8,r9,lr}
	mov 		format, r0
	mov 		formatLen, r1
	mov 		dest, r2
	mov 		nextArg, r3
	add 		argList, sp, #7*4
	mov 		length, #0

	formatLoop$:
		subs 	formatLen, #1
		movlt 	r0, length
		poplt 	{r4,r5,r6,r7,r8,r9,pc}

		ldrb 	r0, [format]
		add 	format,#1
		teq 	r0, #'%'
		beq 	formatArg$

	formatChar$:
		teq 	dest, #0
		strneb 	r0, [dest]
		addne 	dest, #1
		add 	length, #1
		b 		formatLoop$

	formatArg$:
		subs 	formatLen, #1
		movlt 	r0, length
		poplt 	{r4,r5,r6,r7,r8,r9,pc}
		
		ldrb 	r0, [format]
		add 	format, #1
		teq 	r0, #'%'
		beq 	formatChar$
				
		teq  	r0, #'c'
		moveq 	r0, nextArg
		ldreq 	nextArg, [argList]
		addeq 	argList, #4
		beq 	formatChar$

		teq 	r0, #'s'
		beq 	formatString$
				
		teq 	r0, #'d'
		beq 	formatSigned$
				
		teq 	r0, #'u'
		teqne 	r0, #'x'
		teqne 	r0, #'b'
		teqne 	r0, #'o'
		beq 	formatUnsigned$

		b		formatLoop$

	formatString$:
		ldrb 	r0, [nextArg]
		teq 	r0, #'\0'		
		ldreq 	nextArg, [argList]
		addeq 	argList, #4
		beq 	formatLoop$
		add 	length, #1
		teq 	dest, #0
		strneb 	r0, [dest]
		addne 	dest, #1
		add 	nextArg, #1		
		b 		formatString$

	formatSigned$:
		mov 	r0, nextArg
		ldr 	nextArg, [argList]
		add 	argList, #4
		mov 	r1, dest
		mov 	r2, #10
		bl 		SignedString
		teq 	dest, #0
		addne 	dest, r0
		add 	length, r0
		b 		formatLoop$

	formatUnsigned$:
		teq 	r0, #'u'
		moveq 	r2, #10
		teq 	r0, #'x'
		moveq 	r2, #16
		teq 	r0, #'b'
		moveq 	r2, #2
		teq 	r0, #'o'
		moveq 	r2, #8

		mov 	r0, nextArg
		ldr 	nextArg, [argList]
		add 	argList, #4
		mov 	r1, dest
		bl 		UnsignedString
		teq 	dest, #0
		addne 	dest, r0
		add 	length, r0
		b 		formatLoop$
		