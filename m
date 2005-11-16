From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: problems with libnetfilter_conntrack / cntl_test
Date: Wed, 16 Nov 2005 14:39:04 +0100
Message-ID: <200511161439.04498.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4ZzeDQTtlG2W1Lf"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_4ZzeDQTtlG2W1Lf
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have installed a 2.6.14.2 kernel + grsecurity-2.1.7-2.6.14.2-$latest,
libnfnetlink-0.0.13 and libnetfilter_conntrack-0.0.28.

./ctnl_test fails:

Test for libnetfilter_conntrack

NFNETLINK answers: Invalid argument
TEST 1: create conntrack (-22)
TEST 2: dump conntrack table and reset (-22)
TEST 3: dump conntrack table (-22)
TEST 4: get conntrack (-22)
TEST 5: update conntrack (-22)
NFNETLINK answers: Invalid argument
TEST 6: delete conntrack (-22)
nfnl_open: bind(netlink): Operation not permitted
Can't open handler
Test failed with error -2. Errors=3D7

Is this a grsec issue?

Regards,
Pawe=C5=82.

--=20
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_4ZzeDQTtlG2W1Lf
Content-Type: text/x-log;
  charset="utf-8";
  name="ctnl_test.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="ctnl_test.log"

execve("./ctnl_test", ["./ctnl_test"], [/* 39 vars */]) = 0
uname({sys="Linux", node="vmx", ...})   = 0
brk(0)                                  = 0x804a33c
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=87177, ...}) = 0
mmap2(NULL, 87177, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f78000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\v\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=9508, ...}) = 0
mmap2(NULL, 12392, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f74000
mmap2(0xb7f76000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7f76000
close(3)                                = 0
open("/usr/lib/libnetfilter_conntrack.so.1", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\21"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=18648, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f73000
mmap2(NULL, 17840, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f6e000
mmap2(0xb7f72000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x4) = 0xb7f72000
close(3)                                = 0
open("/usr/lib/libnfnetlink.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\v\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=10388, ...}) = 0
mmap2(NULL, 13676, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f6a000
mmap2(0xb7f6d000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7f6d000
close(3)                                = 0
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20Q\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1148008, ...}) = 0
mmap2(NULL, 1154236, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e50000
mmap2(0xb7f64000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x114) = 0xb7f64000
mmap2(0xb7f68000, 7356, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f68000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e4f000
mprotect(0xb7f64000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e4f6c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7f78000, 87177)               = 0
fstat64(1, {st_mode=S_IFREG|0644, st_size=2691, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f8d000
brk(0)                                  = 0x804a33c
brk(0x806b33c)                          = 0x806b33c
brk(0x806c000)                          = 0x806c000
socket(PF_NETLINK, SOCK_RAW, 12)        = 3
bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(3, {sa_family=AF_NETLINK, pid=32589, groups=00000000}, [12]) = 0
time(NULL)                              = 1132148197
open("/usr/lib/libnetfilter_conntrack//nfct_proto_tcp-0.0.28.so", O_RDONLY) = 5
read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320\5\0"..., 512) = 512
fstat64(5, {st_mode=S_IFREG|0755, st_size=4140, ...}) = 0
mmap2(NULL, 7152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 5, 0) = 0xb7f8b000
mmap2(0xb7f8c000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 5, 0) = 0xb7f8c000
close(5)                                = 0
sendmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"\234\0\0\0\0\1\5\6\3475{C\0\0\0\0\2\0\0\0004\0\1\200\24"..., 156}], msg_controllen=0, msg_flags=0}, 0) = 156
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3475{CM\177\0\0\352\377\377\377\234\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
dup(2)                                  = 5
fcntl64(5, F_GETFL)                     = 0x1 (flags O_WRONLY)
close(5)                                = 0
write(2, "NFNETLINK answers: Invalid argum"..., 36NFNETLINK answers: Invalid argument
) = 36
sendto(3, "\24\0\0\0\3\1\1\3\3505{C\0\0\0\0\2\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3505{CM\177\0\0\352\377\377\377\24\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
sendto(3, "\24\0\0\0\1\1\1\3\3515{C\0\0\0\0\2\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 20
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3515{CM\177\0\0\352\377\377\377\24\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
sendto(3, "H\0\0\0\1\1\5\0\3525{C\0\0\0\0\2\0\0\0004\0\1\200\24\0"..., 72, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 72
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3525{CM\177\0\0\352\377\377\377H\0\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
sendto(3, "\234\0\0\0\0\1\5\0\3535{C\0\0\0\0\2\0\0\0004\0\1\200\24"..., 156, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 156
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3535{CM\177\0\0\352\377\377\377\234\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
sendmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"H\0\0\0\2\1\5\3\3555{C\0\0\0\0\2\0\0\0004\0\1\200\24\0"..., 72}], msg_controllen=0, msg_flags=0}, 0) = 72
recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000000}, msg_iov(1)=[{"$\0\0\0\2\0\0\0\3555{CM\177\0\0\352\377\377\377H\0\0\0"..., 8192}], msg_controllen=0, msg_flags=0}, 0) = 36
write(2, "NFNETLINK answers: Invalid argum"..., 36NFNETLINK answers: Invalid argument
) = 36
close(3)                                = 0
socket(PF_NETLINK, SOCK_RAW, 12)        = 3
bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000007}, 12) = -1 EPERM (Operation not permitted)
write(2, "nfnl_open: bind(netlink): Operat"..., 50nfnl_open: bind(netlink): Operation not permitted
) = 50
write(2, "Can\'t open handler\n", 19Can't open handler
)   = 19
write(1, "Test for libnetfilter_conntrack\n"..., 270Test for libnetfilter_conntrack

TEST 1: create conntrack (-22)
TEST 2: dump conntrack table and reset (-22)
TEST 3: dump conntrack table (-22)
TEST 4: get conntrack (-22)
TEST 5: update conntrack (-22)
TEST 6: delete conntrack (-22)
Test failed with error -2. Errors=7
) = 270
munmap(0xb7f8d000, 4096)                = 0
exit_group(36)                          = ?

--Boundary-00=_4ZzeDQTtlG2W1Lf--
