From: Jamal Hadi Salim <hadi@znyx.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 28 Sep 2004 22:14:29 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096424069.1046.84.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
Reply-To: hadi@znyx.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-09-28 at 11:07, Henrik Nordstrom wrote:
> On Tue, 28 Sep 2004, KOVACS Krisztian wrote:

> 
> If you only have a single IP using division by IP addresses is clearly not 
> an option.

Like you said earlier, the allocation is IPaddress:portrange. I do think
this will require some extra hack for the mapping. Am i mistaken? 
So instead if you just zeroed out the IPaddres piece, then the only
change left is por range.
I believe this is already supported in the form of
/proc/sys/net/ipv4/ip_local_port_range
So even if the protocol is not ready, make this a static config
in each node. Ensure unique ranges on each node whose alloaction is 
synchronized by a human to start with. 
Unfortunately i am not sure if you can force current to always get
its port allocation from the allocated range _only_. Is this doable?
Caveat: You just limited your active connections for your cluster to 64K
flows. Clearly ability to get IPaddress:port range mapping will fix
that; I ma just thinking first steps.

> The full re-sync is just one more facet of the same problem. If one is 
> solved you can solve both. It needs to be known per connection which node 
> is currently the master, and the addressing/forwarding scheme needs to 
> make sure the node who is master for a connection sees the traffic it 
> needs to se.
> 
> > But if we maintain some per-conntrack mark indicating
> > which node "owns" that entry, then even full re-sync could be
> > implemented quite easily: each node dumps all entries it is responsible
> > for. The protocol itself should be extended as well, we would need
> > per-node sequence numbers and per-node recovery requests.
> 
> Indeed.
> 
> And the flow question of existing connections is also not such big problem 
> as all you need is to look up the connection in conntrack and if not 
> master you either drop the packet (multicast forwarding model) or 
> request to become master of the connection (unicast forwarding model). 
> The multicast forwarding model is a lot easier to implement but does not 
> scale as well as all nodes need to see all traffic and drop the traffic 
> for which they are not master.
> 
> This moves the "clusterIP" decision to after the conntrack lookup but 
> before creating new conntrack sessions.

I think we should make the issue of balancing a separate item.
It shouldnt matter how the packet gets delivered to an active node
(pigeons, expensive loadbalancers, LVS, some routing tricks,
 etc all is fine by me). 
Assuming:
- The state is already synced across all the nodes;
- assuming theres no conflict and 
- assuming asymetry (ok, maybe thats too restrictive) but a good start. 

Then:
any node should be able to masquarade any packet. And any packet coming
from the external realm should get to its origin just fine.

cheers,
jamal
