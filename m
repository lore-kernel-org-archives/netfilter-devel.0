From: "Markus" <listuser@sally.epygi.de>
Subject: FW: pptp patch breaks nat-reservation patch (on ppc-machines)
Date: Fri, 9 Jul 2004 13:21:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BDEHJGPIKNLKJJBCCFPLKEIPCOAA.listuser@sally.epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

HiHo Philip!

I am merely using the nat-reservation. My understanding of 
netfilter internals are only very limited, that's why i 
point it to you Pros ;)

> It is dangerous only if there is broken code that doesn't expect this,
> so the solution is to fix the broken code.  There is no other solution
> that I can see; we need to add a 32 bit field to as part of u.all, so
> u.all has to grow.
I agree to the 32 bit field, simply because we need it. What i don't like is the 
combination of:
  1) a union of different sized structs -AND-
  2) the possibility to use it as memory mapping.

This is prone to faults as has happened now. Agreed the occuring
problem here can be fixed. But new modules may run into the same 
problem, further changes will cause similar problems.
But first let's display the problem, before we can start talking 
about solutions.

The Problem is alignment:
I had modified the Debug in __ip_nat_reserved_find_manip as follow:
	DEBUGP("__ip_nat_reserved_find_manip: find proto %u %u.%u.%u.%u:%u (test %u/%u)\n",
			proto, NIPQUAD(manip->ip), ntohl(manip->u.all), ntohs(manip->u.udp.port), manip->u.all);
which lead to:
	find proto 17 10.20.10.193:331612160 (test 0/331612160)

331612160 = 0x13c40000 and 0x13c4 = 5060

thus manip->u.all = 331612160 , whereas manip->u.udp.port = 0. 
It should both have been 5060. u.all is shifted compared to u.udp.port.
Thus we have an alignment problem (remember its PPC not INTEL).
So somewhere (i assume in vanilla nat_core) a tuple is created via 
u.udp.port = 5060, this tuple is handed down to the nat-reservation
which looked at it via: .u.all

The behaviour "was" ok, because the sizes were identical. After the
patch such a comparison is not ok anymore.

I don't know if your mentioned fixed cover this too.

> There were a few problems when the pptp patch was first developed,
> but those have mostly been fixed up.

Ok. let's cut it short. It seems you are aware of the problem and found 
the best solution is to make "all" other patches aware of this problem,
aka strengthen it. If that's the way to go no problem with me ;)
The alternatives i came up with are by no means better and most 
of them let my skin crawl ;)

ciao
  markus
