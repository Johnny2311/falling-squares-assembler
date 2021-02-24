start:
  ; verify the command line has enough parameters, if not jump to exitToOs
    pop eax     ;  # Get the number of arguments
	cmp 3,eax   ; "./binary fileinput fileoutput" will have $3 here?? Debug!
	jnz exitToOs

	; open both input and output files at the start of the code
	mov 5, eax       # open 
    pop ebx       # Get the program name

	; open input file first
    pop ebx       # Get the first actual argument - file to read
    mov 0, ecx       # read-only mode
    int 0x80
    cmp $-1, eax  ; valid file handle?
    jz exitToOs
	mov eax, (varInputHandle) ; store input file handle to memory

	; open output file, make it writable, create if not exists
    mov $5, %eax       # open 
    pop %ebx       # Get the second actual argument - file to write
   ; next two lines should use octal numbers, I hope the syntax is correct
    mov $0101, %ecx # create flag + write only access (if google is telling me truth)
	mov $0666, %edx ; permissions for out file as rw-rw-rw-
    int $0x80
    cmp $-1, %eax  ; valid file handle?
    jz 	exitToOs
    mov %eax, ($varOutputHandle) ; store output file handle to memory

processingLoop:

	; read single char to varBuffer
    mov $3, %eax
    mov ($varInputHandle), %ebx
    mov $varBuffer, %ecx
    mov $1, %edx
    int $0x80

	; if no char was read (EOF?), jmp finishProcessing
    cmp $0, %eax
    jz finishProcessing ; looks like total success, finish cleanly

  ;TODO process it
	inc ($varBuffer) ; you wanted this IIRC?

  ; write it
    mov $4, %eax       
    mov ($varOutputHandle), %ebx     # file_descriptor
    mov $varBuffer, %ecx  ; BTW, still set from char read, so just for readability
    mov $1, %edx    ; this one is still set from char read too
    int $0x80

  ; done, go for the next char
    jmp processingLoop

finishProcessing:
    mov $0, ($varExitCode) ; everything went OK, set exit code to 0

exitToOs:
  ; close both input and output files, if any of them is opened
    mov ($varOutputHandle), %ebx     # file_descriptor
    call closeFile
    mov ($varInputHandle), %ebx
    call closeFile

  ; exit back to OS
    mov $1, %eax
    mov ($varExitCode), %ebx
    int $0x80

closeFile:
    cmp $-1, %ebx
    ret z ; file not opened, just ret
    mov $6, %eax  ; sys_close
    int $0x80
    ; returns 0 when OK, or -1 in case of error, but no handling here
    ret

.data
varExitCode: dd 1 ; no idea about AT&T syntax, "dd" is "define dword" in NASM
  ; default value for exit code is "1" (some error)
varInputHandle: dd -1 ; default = invalid handle
varOutputHandle: dd -1 ; default = invalid handle
varBuffer: db ? ; (single byte buffer)