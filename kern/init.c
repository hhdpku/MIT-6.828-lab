/* See COPYRIGHT for copyright information. */

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/monitor.h>
#include <kern/console.h>
#include <kern/pmap.h>
#include <kern/kclock.h>


void
i386_init(void)
{
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();

	cprintf("6828 decimal is %o octal!\n", 6828);

	// Lab 2 memory management initialization functions
	mem_init();

	//样例
    cprintf("--- Example 1: Red ---\n");
    cprintf("\x1b[31mThis is an error message.\x1b[0m\n\n");

    cprintf("--- Example 2: Green ---\n");
    cprintf("\x1b[32mOperation successful!\x1b[0m\n\n");

    cprintf("--- Example 3: Blue ---\n");
    cprintf("This is an important link: \x1b[34mhttps://example.com\x1b[0m\n\n");

	cprintf("--- Example 4: Background Color ---\n");
    cprintf("Current Status: \x1b[44;37m PROCESSING \x1b[0m\n\n");

	cprintf("--- Example 5: Mixed Usage ---\n");
    cprintf("Log: [\x1b[32mINFO\x1b[0m] User login successful | [\x1b[1;31mALERT\x1b[0m] Password expiring soon.\n");

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}
