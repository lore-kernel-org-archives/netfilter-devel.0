From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: socket() call in iptables?
Date: Wed, 7 Jan 2004 16:51:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <008901c3d536$13a35f50$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I received a report about problems with iptables in a chrooted environment
and grsec with restricted raw socket capabilities within chroot.

# chroot /chroot/ipt/ /bin/strace -f -ff /sbin/iptables -t filter -L -v -n

And here is the result. Please notice:
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = -1 EPERM (Operation not permitted)

[Why is socket() called? Who is calling it, I did not find it anywhere in
iptables,
I do not know why would any other library function call it.Is creating a raw
socket required to do iptables operations?]

execve("/sbin/iptables", ["/sbin/iptables", "-t", "filter", "-L", "-v",
"-n"], [/* 13 vars */]) = 0
uname({sys="Linux", node="tvmax", ...}) = 0
brk(0)                                  = 0x8056d48
open("/etc/ld.so.preload", O_RDONLY)    = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
close(3)                                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=10007, ...}) = 0
old_mmap(NULL, 10007, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40014000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0T\27\0\000"...,
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0644, st_size=8008, ...}) = 0
old_mmap(NULL, 11004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40017000
mprotect(0x40019000, 2812, PROT_NONE)   = 0
old_mmap(0x40019000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0x1000) = 0x40019000
close(3)                                = 0
open("/lib/libnsl.so.1", O_RDONLY)      = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 ;\0\000"...,
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0644, st_size=69472, ...}) = 0
old_mmap(NULL, 80988, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4001a000
mprotect(0x4002b000, 11356, PROT_NONE)  = 0
old_mmap(0x4002b000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0x10000) = 0x4002b000
old_mmap(0x4002c000, 7260, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4002c000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\30\222"...,
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1153784, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x4002e000
old_mmap(NULL, 1166560, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4002f000
mprotect(0x40142000, 40160, PROT_NONE)  = 0
old_mmap(0x40142000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED,
3, 0x113000) = 0x40142000
old_mmap(0x40148000, 15584, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40148000
close(3)                                = 0
munmap(0x40014000, 10007)               = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = -1 EPERM (Operation not permitted)
open("/proc/sys/kernel/modprobe", O_RDONLY) = 3
brk(0)                                  = 0x8056d48
brk(0x8057160)                          = 0x8057160
brk(0x8058000)                          = 0x8058000
read(3, "/sbin/modprobe\n", 1024)       = 15
close(3)                                = 0
fork()                                  = 7949
[pid  7949] execve("/sbin/modprobe", ["/sbin/modprobe", "ip_tables"],
[/* 13 vars */]) = 0
[pid  7949] uname({sys="Linux", node="tvmax", ...}) = 0
[pid  7949] brk(0)                      = 0x805dd20
[pid  7949] open("/etc/ld.so.preload", O_RDONLY) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
[pid  7949] close(3)                    = 0
[pid  7949] open("/etc/ld.so.cache", O_RDONLY) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=10007, ...}) = 0
[pid  7949] old_mmap(NULL, 10007, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40014000
[pid  7949] close(3)                    = 0
[pid  7949] open("/lib/libc.so.6", O_RDONLY) = 3
[pid  7949] read(3,
"\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\30\222"..., 1024) = 1024
[pid  7949] fstat64(3, {st_mode=S_IFREG|0755, st_size=1153784, ...}) = 0
[pid  7949] old_mmap(NULL, 1166560, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3,
0) = 0x40017000
[pid  7949] mprotect(0x4012a000, 40160, PROT_NONE) = 0
[pid  7949] old_mmap(0x4012a000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED, 3, 0x113000) = 0x4012a000
[pid  7949] old_mmap(0x40130000, 15584, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40130000
[pid  7949] close(3)                    = 0
[pid  7949] munmap(0x40014000, 10007)   = 0
[pid  7949] getuid32()                  = 0
[pid  7949] geteuid32()                 = 0
[pid  7949] uname({sys="Linux", node="tvmax", ...}) = 0
[pid  7949] brk(0)                      = 0x805dd20
[pid  7949] brk(0x805dd48)              = 0x805dd48
[pid  7949] brk(0x805e000)              = 0x805e000
[pid  7949] brk(0x805f000)              = 0x805f000
[pid  7949] brk(0x8060000)              = 0x8060000
[pid  7949] brk(0x8061000)              = 0x8061000
[pid  7949] brk(0x8062000)              = 0x8062000
[pid  7949] open("/etc/modules.conf", O_RDONLY) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=4001, ...}) = 0
[pid  7949] stat64("/etc/modules.conf", {st_mode=S_IFREG|0644,
st_size=4001, ...}) = 0
[pid  7949] stat64("/etc/conf.modules", 0xbfffad9c) = -1 ENOENT (No such
file or directory)
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=4001, ...}) = 0
[pid  7949] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40014000
[pid  7949] read(3, "### This file is automatically g"..., 4096) = 4001
[pid  7949] brk(0x8063000)              = 0x8063000
[pid  7949] read(3, "", 4096)           = 0
[pid  7949] close(3)                    = 0
[pid  7949] munmap(0x40014000, 4096)    = 0
[pid  7949] open("/lib/modules/2.4.23-grsec/modules.dep", O_RDONLY) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=6176, ...}) = 0
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=6176, ...}) = 0
[pid  7949] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40014000
[pid  7949] read(3, "/lib/modules/2.4.23-grsec/kernel"..., 4096) = 4096
[pid  7949] brk(0x8064000)              = 0x8064000
[pid  7949] brk(0x8065000)              = 0x8065000
[pid  7949] read(3, "et/ipv4/netfilter/ip_tables.o\n\n/"..., 4096) = 2080
[pid  7949] brk(0x8066000)              = 0x8066000
[pid  7949] read(3, "", 4096)           = 0
[pid  7949] close(3)                    = 0
[pid  7949] munmap(0x40014000, 4096)    = 0
[pid  7949] query_module(NULL, 0, NULL, 0) = 0
[pid  7949] query_module(NULL, QM_MODULES, { /* 22 entries */ }, 22) = 0
[pid  7949] query_module("ipt_MARK", QM_INFO, {address=0xc4a0b000,
size=800, flags=MOD_RUNNING|MOD_AUTOCLEAN|MOD_VISITED|MOD_USED_ONCE,
usecount=0}, 16) = 0
[pid  7949] query_module("sb", QM_INFO, {address=0xc4a03000, size=7360,
flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] query_module("sb_lib", QM_INFO, {address=0xc49fa000,
size=32288, flags=MOD_RUNNING|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] query_module("uart401", QM_INFO, {address=0xc49f7000,
size=6048, flags=MOD_RUNNING|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] query_module("sound", QM_INFO, {address=0xc49e9000,
size=52268, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=0},
16) = 0
[pid  7949] query_module("ipt_multiport", QM_INFO, {address=0xc49e7000,
size=640, flags=MOD_RUNNING|MOD_AUTOCLEAN|MOD_VISITED|MOD_USED_ONCE,
usecount=8}, 16) = 0
[pid  7949] query_module("ipt_state", QM_INFO, {address=0xc49dd000,
size=576, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=5}, 16) = 0
[pid  7949] query_module("ipt_mac", QM_INFO, {address=0xc49db000,
size=672, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=14}, 16) = 0
[pid 13415] wait4(-1,  <unfinished ...>
[pid  7949] query_module("ipt_TOS", QM_INFO, {address=0xc49d9000,
size=1088, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=18},
16) = 0
[pid  7949] query_module("ipt_LOG", QM_INFO, {address=0xc49d7000,
size=3296, flags=MOD_RUNNING, usecount=0}, 16) = 0
[pid  7949] query_module("ipt_TTL", QM_INFO, {address=0xc49d5000,
size=1152, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=2}, 16) = 0
[pid  7949] query_module("iptable_mangle", QM_INFO, {address=0xc49c5000,
size=2176, flags=MOD_RUNNING|MOD_AUTOCLEAN|MOD_VISITED|MOD_USED_ONCE,
usecount=1}, 16) = 0
[pid  7949] query_module("iptable_nat", QM_INFO, {address=0xc49c7000,
size=14932, flags=MOD_RUNNING|MOD_AUTOCLEAN|MOD_VISITED|MOD_USED_ONCE,
usecount=1}, 16) = 0
[pid  7949] query_module("iptable_filter", QM_INFO, {address=0xc49c3000,
size=1728, flags=MOD_RUNNING|MOD_AUTOCLEAN|MOD_VISITED|MOD_USED_ONCE,
usecount=1}, 16) = 0
[pid  7949] query_module("ip_tables", QM_INFO, {address=0xc49bf000,
size=11040, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=12},
16) = 0
[pid  7949] query_module("3c509", QM_INFO, {address=0xc490d000,
size=9472, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=1}, 16) = 0
[pid  7949] query_module("isa-pnp", QM_INFO, {address=0xc4905000,
size=27900, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=0},
16) = 0
[pid  7949] query_module("8139too", QM_INFO, {address=0xc48fd000,
size=11104, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=1},
16) = 0
[pid  7949] query_module("mii", QM_INFO, {address=0xc48fb000, size=2304,
flags=MOD_RUNNING|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] query_module("ne2k-pci", QM_INFO, {address=0xc48f8000,
size=4352, flags=MOD_RUNNING|MOD_VISITED|MOD_USED_ONCE, usecount=2}, 16) = 0
[pid  7949] query_module("8390", QM_INFO, {address=0xc48f5000,
size=6000, flags=MOD_RUNNING|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] query_module("crc32", QM_INFO, {address=0xc48f3000,
size=2848, flags=MOD_RUNNING|MOD_USED_ONCE, usecount=0}, 16) = 0
[pid  7949] chdir("/var/log/ksymoops")  = 0
[pid  7949] time(NULL)                  = 1073331685
[pid  7949] open("/etc/localtime", O_RDONLY) = -1 ENOENT (No such file
or directory)
[pid  7949] open("20040105.log", O_WRONLY|O_APPEND|O_CREAT, 0666) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
[pid  7949] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40014000
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
[pid  7949] _llseek(3, 0, [0], SEEK_SET) = 0
[pid  7949] write(3, "20040105 194125 start /sbin/modp"..., 58) = 58
[pid  7949] fdatasync(3)                = 0
[pid  7949] close(3)                    = 0
[pid  7949] munmap(0x40014000, 4096)    = 0
[pid  7949] chdir("/var/log/ksymoops")  = 0
[pid  7949] time(NULL)                  = 1073331685
[pid  7949] open("20040105.log", O_WRONLY|O_APPEND|O_CREAT, 0666) = 3
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=58, ...}) = 0
[pid  7949] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40014000
[pid  7949] fstat64(3, {st_mode=S_IFREG|0644, st_size=58, ...}) = 0
[pid  7949] _llseek(3, 58, [58], SEEK_SET) = 0
[pid  7949] write(3, "20040105 194125 probe ended\n", 28) = 28
[pid  7949] fdatasync(3)                = 0
[pid  7949] close(3)                    = 0
[pid  7949] munmap(0x40014000, 4096)    = 0
[pid  7949] _exit(0)                    = ?
<... wait4 resumed> NULL, 0, NULL)      = 7949
--- SIGCHLD (Child exited) ---
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = -1 EPERM (Operation not permitted)
write(2, "iptables v1.2.9: ", 17iptables v1.2.9: )       = 17
write(2, "can\'t initialize iptables table "..., 78can't initialize
iptables table `filter': Permission denied (you must be root)) = 78
write(2, "\n", 1
)                       = 1
write(2, "Perhaps iptables or your kernel "..., 54Perhaps iptables or
your kernel needs to be upgraded.
) = 54
_exit(3)                                = ?

Regards,
Maciej
