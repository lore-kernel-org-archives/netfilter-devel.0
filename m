From: Robert Hardy <rhardy@webcon.ca>
Subject: Optimizing rule loading, iptables-1.3.0 and iptables-batch
Date: Tue, 7 Sep 2004 00:45:10 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409070017220.23341@vortex.int.webcon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I've been trying out various ways of optimizing the loading of large
iptables rule sets.

I recently tried out iptables-batch. It loaded 30000 iprange rules in
roughly 26 minutes, on an fairly idle P4 2.4GHz w/ 1GB of ram. Obviously
that it quite painful but I don't believe it is a reflection on how well
iptables-batch works... It may be better than running a bunch of iptables
commands in series from a shell script but I must admit I got bored and
didn't finish the test without iptables-batch....

iptables-batch has the advantage of being able to batch install a single
chain (or part of a chain) of a table in a more optimal manner. This was
sorely lacking in iptables-restore. Even when patched with the recent "fixes
patch" off the devel list, iptables-restore still only allows you to save
and restore whole tables.

Given some of the comments in CVS I because quite excited about iptables
1.3.0. I took a CVS snapshot from 20040906 (all the automatic snapshot
tarballs stopped on 2004/08/23 BTW.)

While it does compile nicely, it unforunately segfaults after every
command. Even something simple like iptables -L with no rules loaded.

Is there something I'm missing?

Like a hidden kernel patch or some kind of kernel requirement I'm missing?

It may be pointless but here is a diff between the working and failing
commands.

With empty tables: strace -fF iptables-1.2.11 -L >& strace1211.log
With empty tables: strace -fF iptables-1.3.0 -L >& strace130.log

iptables-1.3.0 segfaults

# diff -urNbB strace1211.log strace130.log
--- strace1211.log      2004-09-06 22:48:12.253187032 -0400
+++ strace130.log       2004-09-06 22:47:48.442806760 -0400
@@ -1,6 +1,6 @@
execve("/sbin/iptables", ["iptables", "-L"], [/* 31 vars */]) = 0
uname({sys="Linux", node="vortex.int.webcon.net", ...}) = 0
-brk(0)                                  = 0x8054000
+brk(0)                                  = 0x8053000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=109104, ...}) = 0
@@ -25,21 +25,13 @@
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7fe4880, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7fe5000, 109104)              = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
-getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\301\1\0\0\0\10\335p\364\320\334p\364\0\0\0\0\0"..., [84]) = 0
-brk(0)                                  = 0x8054000
-brk(0x8075000)                          = 0x8075000
+getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\301\1\0\0\0\10\375K\331\320\374K\331\0\0\0\0\0"..., [84]) = 0
+brk(0)                                  = 0x8053000
+brk(0x8074000)                          = 0x8074000
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [656]) = 0
-fstat64(1, {st_mode=S_IFREG|0644, st_size=2230, ...}) = 0
+brk(0x8095000)                          = 0x8095000
+fstat64(1, {st_mode=S_IFREG|0644, st_size=2282, ...}) = 0
mmap2(NULL, 131072, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fc4000
close(3)                                = 0
-write(1, "Chain INPUT (policy ACCEPT)\ntarg"..., 273Chain INPUT (policy ACCEPT)
-target     prot opt source               destination
-
-Chain FORWARD (policy DROP)
-target     prot opt source               destination
-
-Chain OUTPUT (policy ACCEPT)
-target     prot opt source               destination
-) = 273
-munmap(0xb7fc4000, 131072)              = 0
-exit_group(0)                           = ?
+--- SIGSEGV (Segmentation fault) @ 0 (0) ---
++++ killed by SIGSEGV (core dumped) +++

Regards,
Rob

-- 
---------------------"Happiness is understanding."----------------------
Robert Hardy, B.Eng Computer Systems                  C.E.O. Webcon Inc.
rhardy <at> webcon <dot> ca    GPG Key available          (613) 276-7327
