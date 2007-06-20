From: Adam Snodgrass <list.memberships@sarchasm.us>
Subject: Possible 32/64-bit issue building/using iptables 1.3.7 with UML
 ("ERROR: 0 not a valid target)")
Date: Wed, 20 Jun 2007 01:36:26 -0400
Message-ID: <20070620013626.47f3dfd9@megumi.wolf.fhi>
Reply-To: wolf@sarchasm.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've encountered a strange problem while attempting to build and use a
copy of iptables 1.3.7 userland.  I recently decided it was time to try
using ulogd2 and NFLOG, as my systems are all at least 2.6.21.x.  I
successfully built and used a copy of 1.3.7 on my amd64 host, running
Debian etch and kernel 2.6.21.4 (vanilla, no patches), then proceeded
to try building a 32-bit copy inside a UML (running i386 etch, and
kernel 2.6.21.4).  I am compiling iptables against a copy of
2.6.21.4 (no funny POMng or other patches).  The software builds fine,
but when I get strange errors when I try to use it.  For example:

guest# ./iptables -V
iptables v1.3.7
guest# ./iptables -nL
ERROR: 0 not a valid target)
Aborted
guest# ./iptables -j NFLOG -h
iptables: target `NFLOG' has invalid size 76.
guest#

I found several references to the '0 not a valid target' message from
early 2006, and note that the fix has been applied to mainline for some
time now.  Could this be a UML problem?  (I can compile and run 1.3.7
in an amd64 UML without issue).

(If you're wondering why I don't just use the supplied package in etch,
it sadly lacks the NFLOG target, despite claiming to be version 1.3.6).

Some additional information:

guest$ uname -a
Linux guest 2.6.21.4-um32 #1 Sun Jun 10 01:06:24 EDT 2007 i686 GNU/Linux
host$ uname -a
Linux host 2.6.21.4-amd64-smp #3 SMP Sun Jun 10 00:55:21 EDT 2007 x86_64 GNU/Linux

$ gcc -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v
--enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr
--enable-shared --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --enable-nls
--program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu
--enable-libstdcxx-debug --enable-mpfr --with-tune=i686
--enable-checking=release i486-linux-gnu Thread model: posix gcc
version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

# strace ./iptables -nvL
execve("./iptables", ["./iptables", "-nvL"], [/* 18 vars */]) = 0
uname({sys="Linux", node="guest", ...})   = 0
brk(0)                                  = 0x8054000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40017000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=15617, ...}) = 0
mmap2(NULL, 15617, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40019000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/libdl.so.2", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\f\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=9592, ...}) = 0
mmap2(NULL, 12404, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x4001d000
mmap2(0x4001f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0x4001f000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/libnsl.so.1", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p5\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=76548, ...}) = 0
mmap2(NULL, 87808, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x40021000
mmap2(0x40033000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x11) = 0x40033000
mmap2(0x40035000, 5888, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40035000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240O\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=1241392, ...}) = 0
mmap2(NULL, 1251484, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x40037000
mmap2(0x4015f000, 28672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x127) = 0x4015f000
mmap2(0x40166000, 10396, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40166000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40169000
mprotect(0x4015f000, 20480, PROT_READ)  = 0
set_thread_area({entry_number:-1 -> 12, base_addr:0x401698e0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0x40019000, 15617)               = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\10@\'q\10\0\200\323\n\352\327\5\10@3q\10\300\16"..., [84]) = 0
brk(0)                                  = 0x8054000
brk(0x8075000)                          = 0x8075000
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [656]) = 0
write(2, "ERROR: 0 not a valid target)\n", 29ERROR: 0 not a valid target)
) = 29
rt_sigprocmask(SIG_UNBLOCK, [ABRT], NULL, 8) = 0
gettid()                                = 973
tgkill(973, 973, SIGABRT)               = 0
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++
Process 973 detached

# gdb ./iptables
GNU gdb 6.4.90-debian
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i486-linux-gnu"...Using host libthread_db library "/lib/tls/libthread_db.so.1".

(gdb) set args -nL
(gdb) run
Starting program: /home/user/netfilter/TEST/sbin/iptables -nL
warning: Lowest section in system-supplied DSO at 0xffffe000 is .hash at ffffe0b4
ERROR: 0 not a valid target)

Program received signal SIGABRT, Aborted.
0x4005f947 in raise () from /lib/tls/libc.so.6
(gdb) bt
#0  0x4005f947 in raise () from /lib/tls/libc.so.6
#1  0x400610c9 in abort () from /lib/tls/libc.so.6
#2  0x0804fca5 in standard_target_map ()
#3  0x0804be8c in list_entries ()
#4  0x0804e248 in do_command ()
#5  0x08049d14 in main ()

# gdb ./iptables
GNU gdb 6.4.90-debian
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i486-linux-gnu"...Using host libthread_db library "/lib/tls/libthread_db.so.1".

(gdb) set args -j NFLOG -h
(gdb) run
Starting program: /home/user/netfilter/TEST/sbin/iptables -j NFLOG -h
warning: Lowest section in system-supplied DSO at 0xffffe000 is .hash at ffffe0b4
iptables: target `NFLOG' has invalid size 76.

Program exited with code 01.
(gdb) bt
No stack.



Thanks,

Adam Snodgrass
wolf@sarchasm.us
