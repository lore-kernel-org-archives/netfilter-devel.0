From: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Subject: performance issues (nat / conntrack)
Date: Thu, 20 Jun 2002 21:48:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <027b01c21893$72bbe1d0$0289cb8a@etbx180>
Reply-To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

dear netdevels,

I'm doing some tcp benches on a netfilter enabled box and noticed
huge and surprising perf decrease when loading iptable_nat module. 

- ip_conntrack is of course also loading the system, but with huge memory
and a large bucket size, the problem can be solved. The big issue with
ip_conntrack are the state timeouts: it simply kill the system and drops
all the traffic with the default ones, because the ip_conntrack table
becomes quickly full, and it seems that there is no way to recover from
that  situation... Keeping unused entries (time_close) even 1 minute in
the cache is really not suitable for configurations handling (relatively)
large number of connections/s. 
o The cumulative effect should be reconsidered.
o Are there ways/plans to tune the timeouts dynamically? and what are
  the valid/invalid ranges of timeouts?
o looking at the code, it seems that one timer is started by tuple...
  wouldn't it be more efficient to have a unique periodic callback
  scanning the whole or part of the table for aged entries?

- The annoying point is iptable_nat: normally the number of entries in
the nat table is much lower than the number of entries in the conntrack
table. So even if the hash function itself could be less efficient than
the ip_conntrack one (because it takes less arguments: src+dst+proto),
the load of nat, should be much lower than the load of conntrack.
o So... why is it the opposite??
o Are there ways to tune the nat performances?

- Another (old) question: why are conntrack or nat active when there are
no rules configured (using them or not)? If not fixed it should be at
least documented... Somebody doing "iptables -t nat -L" takes the risk
of killing its system if it's already under load... In the same spirit,
iptables -F should unload all unused modules (the ip_tables modules 
doesn't hurt). Just one quick fix: replace the 'iptables' executable by
one 'iptables' script calling the exe (located somewhere else) and 
doing an rmmod at the end...

comments are welcome;


here is my test bed:

tested target:
 -kernel 2.4.18 + non_local_bind + small conntrack timeouts...
 -PIII~500MHz, RAM=256MB
 -2*100Mb/s NIC

The target acts as a forwarding gateway between a load generator client
running httperf, and an apache proxy serving cached pages. 100Mb/s NICs
and requests/response sizes insure that BW and packet collisions is not
an issue.

Since in my test, each connection is ephemeral (<10ms), i recompiled the 
kernel with very short conntrack timeouts (i.e: 1 sec for close_wait, 
and about 60 sec for established!) This was also the only way to restrict
the conntrack hash table size (given my RAM) and avoid exagerated hash
collisions. Another limitation comes from my load generator creating traffic
from one source to one destination ipa, with only source port variation 
(but given my configured hash table size and the hash function itself
it shouldn't have been an issue).

results are averages from procinfo -n10 [d]

test results:

1) target = forwarding only (no iptables module or rule)
 -  rate          : 100        conn/s (=request-response/s)
 -> CPU load      : 0%         system
 -> context       : 7          context/s
 -> irq(eth0/eth1): 0.9 / 0.9  kpps   (# of packet/sec = #irq/s)

 -  rate          : 500        conn/s
 -> CPU load      : 10%        system
 -> context       : 18->100    context/s (varying!)
 -> irq(eth0/eth1): 4.4 / 4.4  kpps

 -  rate (max)    : 1050       conn/s (max from my load generator)
 -> CPU load      : 25%        system
 -> context       : 1000       context/s
 -> irq(eth0/eth1): 10 / 10    kpps

2) (1) + insmod ip_conntrack 16384 (no rules)

 -  rate          : 100        conn/s
 -> CPU load      : 0.8%       system
 -> context       : 7          context/s
 -> irq(eth0/eth1): 0.9 / 0.9  kpps
 -> conntrack size: 970        concurrent entries

 -  rate          : 250        conn/s
 -> CPU load      : 10%        system
 -> context       : 12         context/s
 -> irq(eth0/eth1): 2.2 / 2.2  kpps
 -> conntrack size: 2390       concurrent entries

 -  rate          : 500        conn/s
 -> CPU load      : 30-70%     system  (varying)
 -> context       : 45-90      context/s
 -> irq(eth0/eth1): 4 / 4      kpps
 -> conntrack size: 4770       concurrent entries

3) (2) + iptables -t nat -L  [=iptable_nat] (no rules)
 -  rate          : 100        conn/s
 -> CPU load      : 1%         system
 -> context       : 8          context/s
 -> irq(eth0/eth1): 0.9 / 0.9  kpps
 -> conntrack size: 970        concurrent entries

 -  rate          : 250        conn/s
 -> CPU load      : 40%        system
 -> context       : 20         context/s
 -> irq(eth0/eth1): 2.2 / 2.2  kpps
 -> conntrack size: 2390       concurrent entries

 -  rate  (max)   : 420        conn/s (all failed)
 -> CPU load      : 97%        system
 -> context       : 28         context/s
 -> irq(eth0/eth1): 3.1 / 4.1  kpps
 -> conntrack size: 4050       concurrent entries

 -  rate (killing): [500]->0   conn/s (all failed)
 -> CPU load      : 100%       system (no response)
 -> context       : ?          context/s
 -> irq(eth0/eth1): ?          kpps
 -> conntrack size: 10500???   concurrent entries

other results with active rules (i.e. REDIRECT) are dependent
of the load generated by the local process handling the traffic,
and are thus not relevant (FYI: max conn/s < 200 with one process
handling the REDIRECTed traffic)

kr,
_______________________________________________________________________

-jmhe-
