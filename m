From: Christian Birchinger <joker@netswarm.net>
Subject: limit rule on sparc-linux
Date: Thu, 9 Jan 2003 09:58:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109085840.GA1086@netswarm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello
Is there a known patch for the non-working limit rule on
sparc/linux? The last version Kernel i've tested is 2.4.20
and it still refuses limit rules.

I'm not sure if the problem has been reported on this list.
I saw it on many places (Google also found it on some Debian
mailinglists).

Heres a quick example of a rule which perfectly works on x86 but
fails on sparc64:
# iptables -A INPUT -j ACCEPT -p icmp -m limit --limit 120/minute
iptables: Invalid argument
#

If it helps, here are the last lines of a strace with this
command:
open("/lib/iptables/libipt_limit.so", O_RDONLY) = 3
read(3,"\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\22\0\0\0\1\0\0\6"... ,1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=5758, ...}) = 0
mmap(NULL, 69552, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x701b8000
mprotect(0x701ba000, 61360, PROT_NONE)  = 0
mmap(0x701c8000, 8192, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x701c8000
close(3)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, [1718185076], [84]) = 0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, [1718185076], [672]) = 0
rt_sigtimedwait(ptrace: umoven: Input/output error
[?], 0x3)               = -1 EINVAL (Invalid argument)
write(2, "iptables: Invalid argument\n", 27iptables: Invalid argument
) = 27
exit(1)                                 = ?

-- 
Christian Birchinger
