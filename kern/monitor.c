// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>
#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display a backtrace of the function stack", mon_backtrace },
	{ "showmappings", "Display page mappings for a virtual address range", mon_showmappings },
    { "setperm", "Set permissions for a virtual address mapping", mon_setperm },
    { "dumpvmem", "Dump virtual memory content", mon_dumpvmem },
    { "dumppmem", "Dump physical memory content", mon_dumppmem }
};

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	uint32_t ebp = read_ebp();
	struct Eipdebuginfo info;
	cprintf("Stack backtrace:\n");
	while(ebp!=0){
		uint32_t *ebp_ptr = (uint32_t *)ebp;
		uint32_t eip = ebp_ptr[1];
        uint32_t arg1 = ebp_ptr[2];
        uint32_t arg2 = ebp_ptr[3];  
        uint32_t arg3 = ebp_ptr[4];
        uint32_t arg4 = ebp_ptr[5];
        uint32_t arg5 = ebp_ptr[6];
		int result = debuginfo_eip(eip, &info);
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n         %s:%d: %.*s+%d\n",
                ebp, eip, arg1, arg2, arg3, arg4, arg5, info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, eip - info.eip_fn_addr);
		ebp = ebp_ptr[0];
	}
	return 0;
}

int mon_showmappings(int argc, char **argv, struct Trapframe *tf){
	if(argc!=3){
		cprintf("Usage:showmappings <start_va> <end_va>\n");
	}
	uintptr_t start_va = strtol(argv[1], NULL, 16);
    uintptr_t end_va = strtol(argv[2], NULL, 16);
	start_va = ROUNDDOWN(start_va, PGSIZE);
    end_va = ROUNDUP(end_va, PGSIZE);
	cprintf("VA         -> PA         | Permissions\n");
    cprintf("------------------------+-----------\n");
	for(uintptr_t va = start_va; va <= end_va; va += PGSIZE){
		pte_t *pte = pgdir_walk(kern_pgdir, (void *)va, 0);
		cprintf("0x%08x -> ", va);
		if(pte && (*pte & PTE_P)){
			physaddr_t pa = PTE_ADDR(*pte);
			cprintf("0x%08x | ", pa);
			cprintf("%c", (*pte & PTE_P) ? 'P' : '-');
            cprintf("%c", (*pte & PTE_W) ? 'W' : '-');
            cprintf("%c", (*pte & PTE_U) ? 'U' : '-'); 
		}
		else{
			cprintf("--- not mapped --- ");
		}
		cprintf("\n");
	}
	return 0;
}
int mon_setperm(int argc, char **argv, struct Trapframe *tf){
    if (argc != 3) {
        cprintf("Usage: setperm <va> <permissions>\n");
        cprintf("Permissions: P=1, W=2, U=4. Combine them for desired value (e.g., P|W|U = 7).\n");
        return 0;
    }
	uintptr_t va = strtol(argv[1], NULL, 16);
    int perms = strtol(argv[2], NULL, 16);
	pte_t *pte = pgdir_walk(kern_pgdir, (void *)va, 0);
	if (!pte || !(*pte & PTE_P)) {
        cprintf("Error: virtual address 0x%x is not mapped.\n", va);
        return 0;
    }
	else{
		*pte = (*pte & ~0xFFF) | (perms & 0xFFF)| PTE_P;
		tlb_invalidate(kern_pgdir, (void *)va);
		cprintf("Permissions for VA 0x%x updated.\n", va);
	}
	return 0;
}
int mon_dumpvmem(int argc, char **argv, struct Trapframe *tf){
	if(argc!=3){
		cprintf("Usage:dumpvmem <va> <length>\n");
		return 0;
	}
	uintptr_t va = strtol(argv[1], NULL, 16);
    int len = strtol(argv[2], NULL, 10);
	for (int i=0;i<len;i++){
		pte_t *pte = pgdir_walk(kern_pgdir, (void *)(va+i), 0);
		if (!pte || !(*pte & PTE_P)) {
            cprintf("Address 0x%x is not mapped. Stopping dump.\n", va + i);
            break;
        }
		if (i % 16 == 0) {
			if(i!=0){
				cprintf("\n");
			}
            cprintf("0x%08x: ", va + i);
        }
		cprintf("%02x ", *((unsigned char *)va + i));
	}
	cprintf("\n");
	return 0;
}
int mon_dumppmem(int argc, char **argv, struct Trapframe *tf){
	if(argc!=3){
		cprintf("Usage:dumppmem <va> <length>\n");
		return 0;
	}
	physaddr_t pa = strtol(argv[1], NULL, 16);
    int len = strtol(argv[2], NULL, 10);
	if (pa >= npages * PGSIZE) {
        cprintf("Error: Physical address out of bounds.\n");
        return 0;
    }
	uintptr_t va = (uintptr_t)KADDR(pa);
	for (int i=0;i<len;i++){
		if (i % 16 == 0) {
			if(i!=0){
				cprintf("\n");
			}
            cprintf("0x%08x: ", pa + i);
        }
        cprintf("%02x ", *((unsigned char *)va + i));
	}
	cprintf("\n");
    return 0;
}

/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
