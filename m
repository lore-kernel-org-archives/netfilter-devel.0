From: William Stearns <wstearns@pobox.com>
Subject: "ip_tables: table screwed up!" on pom 20031023 - raw patch?
Date: Thu, 20 Nov 2003 14:41:28 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201359480.17842-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <kadlec@netfilter.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, all,
	I'm using patch-o-matic on a UML virtual machine - details below.  
I can successfully add a new chain and add a rule to that chain, but as 
soon as I try to add a new rule to INPUT, OUTPUT, or FORWARD, I get a "too 
many levels of symbolic links" from the iptables binary, and "ip_tables: 
table screwed up!" on the console - the rule is not added to the built-in 
chain.

	The fact that _nobody_ seems to have reported this error on either 
netfilter mailing list or Google sends me running for a paper bag to put 
over my head; I'm convinced I've screwed something up.  :-)


bash-2.05a# uname -a
Linux redhat73.goober.org 2.4.23-pre8-5um #2 Sat Oct 25 18:07:50 EDT 2003 
i686 unknown
bash-2.05a# iptables -L -nxv
Chain INPUT (policy ACCEPT 215 packets, 17176 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 157 packets, 14183 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
bash-2.05a# iptables -N udpchk
bash-2.05a# iptables -A udpchk -p udp -s 99.99.99.99
bash-2.05a# iptables -L -nxv
Chain INPUT (policy ACCEPT 347 packets, 26088 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 225 packets, 20191 bytes)
    pkts      bytes target     prot opt in     out     source               
destination         

Chain udpchk (0 references)
    pkts      bytes target     prot opt in     out     source               destination         
       0        0            udp  --  *      *       99.99.99.99          0.0.0.0/0         

	Good so far.

bash-2.05a# iptables -A INPUT -s 99.99.99.99
iptables: Too many levels of symbolic links

	The "ip_tables: table screwed up!" shows up on the console here.

bash-2.05a# strace iptables -A INPUT -s 99.99.99.99 2>&1
execve("/usr/bin/iptables", ["iptables", "-A", "INPUT", "-s", 
"99.99.99.99"], [/* 19 vars */]) = 0

[early messages snipped and placed after my .sig]

munmap(0x40013000, 19205)               = 0
brk(0)                                  = 0x8056d48
brk(0x8056d78)                          = 0x8056d78
brk(0x8057000)                          = 0x8057000
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, [1953261926], [84]) = 0
brk(0x8058000)                          = 0x8058000
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, [1953261926], [1184]) = 0
open("/usr/lib/iptables/libipt_standard.so", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0|\3\0\000"..., 
1024) = 1024
fstat64(4, {st_mode=S_IFREG|0775, st_size=3093, ...}) = 0
old_mmap(NULL, 5548, PROT_READ|PROT_EXEC, MAP_PRIVATE, 4, 0) = 0x40013000
mprotect(0x40014000, 1452, PROT_NONE)   = 0
old_mmap(0x40014000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 4, 
0) = 0x40014000
close(4)                                = 0
brk(0x8059000)                          = 0x8059000
setsockopt(3, SOL_IP, 0x40 /* IP_??? */, [1953261926], 1396) = -1 ELOOP 
(Too many levels of symbolic links)
write(2, "iptables: Too many levels of sym"..., 44iptables: Too many 
levels of symbolic links
) = 44
_exit(1)                                = ?

	This doesn't truly look like a filesystem problem, but I've 
verified that none of /usr, /usr/bin/, /usr/bin/iptables, /usr/lib/, 
/usr/lib/iptables, /usr/lib/iptables/lib* are symbolic links at all.

	The error message comes from 
patch-o-matic-20031023/base/raw.patch, specifically in the patch to 
ip_tables.c (hence the CC to Jozsef):


diff -urN --exclude-from=/usr/src/diff.exclude linux-2.4.22-log/net/ipv4/netfilter/ip_tables.c linux-2.4.22-raw/net/ipv4/netfilter/ip_tables.c
--- linux-2.4.22-log/net/ipv4/netfilter/ip_tables.c	2003-08-25 13:44:44.000000000 +0200
+++ linux-2.4.22-raw/net/ipv4/netfilter/ip_tables.c	2003-09-29 09:59:19.000000000 +0200
[snip]

@@ -574,6 +626,17 @@
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
+					e->counters.bcnt = rulenum++;
+					rulenum = 1;
+					e = (struct ipt_entry *)
+						(newinfo->entries + newpos);
+					if (IPT_ENTRY_ITERATE(newinfo->entries,
+							      newinfo->size,
+							      find_error_target,
+							      e, &chainname) == 0) {
+						printk("ip_tables: table screwed up!\n");
+						return 0;
+					}
 				} else {
 					/* ... this is a fallthru */
 					newpos = pos + e->next_offset;

	Just for reference, using the stock compiled iptables rpm from 
Redhat 7.3's updates collection (after cleaning out every trace of the 
self-compiled iptables and modules) gives:

bash-2.05a# iptables -L INPUT
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
bash-2.05a# iptables -A INPUT -s 99.99.99.99     
iptables: Invalid argument

	and no kernel message.  The end of the strace:

socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, [1953261926], [84]) = 0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, [1953261926], [1184]) = 0
open("/lib/iptables/libipt_standard.so", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\3\0"..., 
1024) = 1024
fstat64(4, {st_mode=S_IFREG|0755, st_size=3229, ...}) = 0
old_mmap(NULL, 5612, PROT_READ|PROT_EXEC, MAP_PRIVATE, 4, 0) = 0x40013000
mprotect(0x40014000, 1516, PROT_NONE)   = 0
old_mmap(0x40014000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 4, 
0) = 0x40014000
close(4)                                = 0
brk(0x8059000)                          = 0x8059000
setsockopt(3, SOL_IP, 0x40 /* IP_??? */, [1953261926], 1388) = -1 EINVAL 
(Invalid argument)
write(2, "iptables: Invalid argument\n", 27iptables: Invalid argument
) = 27
_exit(1)                                = ?


	The kernel is a 2.4.23-pre8 with systrace 1.4, most of 
patch-o-matic 20031023, and user-mode-linux 2.4.22-5 patched in.  I have 
done no systrace setup at all; the systrace patch should be idle.  The uml 
kernel is at 
http://www.stearns.org/uml/linux-2.4.23-pre8-systrace14-netfilter20031023-ul24225-stuml.bz2
Its config is at 
http://www.stearns.org/uml/config-2.4.23-pre8-systrace14-netfilter20031023-uml24225-stuml 
and its System.map is at
http://www.stearns.org/uml/System.map-2.4.23-pre8-systrace14-netfilter20031023-uml24225-stuml 
 
	The iptables binary is a self-compiled iptables v1.2.9rc1-20031023 
compiled against the above kernel tree.  The complete compiled binary 
package can be found at 
http://www.stearns.org/uml/iptables-compiled-1.2.9rc1-20031023.tar.gz

	Again, my sincere apologies if this turns out to be a PEBCAK *
error, as I suspect it is.
	Cheers,
	- Bill

* Problems Exists Between Chair And Keyboard.  :-)

---------------------------------------------------------------------------
	My desk has a security flaw.  If I bang my forehead at it for 
two days continuously I can make a hole in it.
	Wuss, bang harder.
	-- Slashdot debate on a Unix security issue
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------



#Early systrace messages from strace iptables -A INPUT -s 99.99.99.99 2>&1

uname({sys="Linux", node="redhat73.goober.org", ...}) = 0
brk(0)                                  = 0x8056d48
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=19205, ...}) = 0
old_mmap(NULL, 19205, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40013000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260\30"..., 1024) 
= 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=11728, ...}) = 0
old_mmap(NULL, 11300, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40018000
mprotect(0x4001a000, 3108, PROT_NONE)   = 0
old_mmap(0x4001a000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 
0x1000) = 0x4001a000
close(3)                                = 0
open("/lib/libnsl.so.1", O_RDONLY)      = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 :\0\000"..., 
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=85262, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 
0) = 0x4001b000
old_mmap(NULL, 80508, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4001c000
mprotect(0x4002d000, 10876, PROT_NONE)  = 0
old_mmap(0x4002d000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 
0x11000) = 0x4002d000
old_mmap(0x4002e000, 6780, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4002e000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0hr\1\000"..., 
1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1344152, ...}) = 0
old_mmap(NULL, 1207648, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 
0x40030000
mprotect(0x4014e000, 36192, PROT_NONE)  = 0
old_mmap(0x4014e000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 
3, 0x11e000) = 0x4014e000
old_mmap(0x40153000, 15712, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40153000
close(3)                                = 0
