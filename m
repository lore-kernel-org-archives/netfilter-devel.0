From: Balazs Scheidler <bazsi@balabit.hu>
Subject: timeout storms make the box unresponsive
Date: Fri, 25 Jul 2003 20:56:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725185644.GA7625@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

Hi,

while trying to reproduce the oops in replace_in_hashes, I compiled a kernel
with netfilter debug enabled. From time-to-time the box simply freezes for a
minute or two, and then continues working as if nothing had happened.

I understand that a kernel with assertions enabled will be slower, but I did
not see this behaviour with the previous kernel and the same load. I've
pressed SysRq+ShowPC and fed that through a ksymoops to see what's going on.
It turned out that ip_nat_cleanup_conntrack() was working (or waiting for
ip_nat_lock).

My test setup is an SMP box (dual Athlon MP 1800+), and I'm downloading
files from a custom webserver using 7 client PCs, with apachebench, each
starting 500 concurrent threads. As there are many connections (each HTTP
session downloads 1k data without keepalive) many connections end at the
same time, thus many of them exit the TIME_WAIT state at the same time. (I
have about 100k entries in /proc/net/ip_conntrack) 

When the box is not frozen, it is otherwise completely responsive, and is
processing 30k interrupts/sec happily.

Maybe we should consider removing expired entries from the NAT hash at a
single go, instead of the current lock-remove-unlock for each entry. Or
create a cleanup thread which cleans up conntrack entries regularly, but not
in the timer interrupt context.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
