From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 23:00:23 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a040928200055db3741@mail.gmail.com>
References: <1096374273.7192.27.camel@nienna.balabit>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<20040928180425.GA21097@zion.homelinux.com>
	<Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
	<20040928205723.GA23352@zion.homelinux.com>
	<876ef97a04092815306fa270f@mail.gmail.com>
	<Pine.LNX.4.61.0409290111570.3760@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: KOVACS Krisztian <hidden@balabit.hu>, Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Sven Schuster <schuster.sven@gmx.de>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@znyx.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409290111570.3760@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004 01:36:19 +0200 (CEST), Henrik Nordstrom
<hno@marasystems.com> wrote:
> There is many ways to get traffic on an node, each having their
> complications and limitations.
> 
> For unicast you need to find some method to divide the address space using
> existing metrics supported by your network. If we assume the trivial setup
> of an HA active-active server then this can for example be done by routing
> the traffic based on the source IP or by client based balancing by
> publishing the service using multiple IPs. In a forwarding NAT firewall it
> gets a little more complex as you have two sides with slightly different
> metrics to care about.  And N node setups gets even more complex as you
> then need to be able to divide and merge contexts across several nodes
> when adding/removing nodes unless you accept a imbalance in the load if a
> node member has failed (fixed contexts, where one node at a time is master
> per context).

The idea of what I was saying is still the same: active-active implies
making multiple machines answer for a single address, whether its a
firewall, load-balancer, DNS server, HTTP server or anything else.
Advertising the service on multiple IPs just means you have x * y
machines, where x == number of advertised addresses and y == number of
machines that actively service each individual advertised address.

> If you do not have any reasonable support for balancing in your network
> layer then you can either introduce a load balancer layer or use multicast
> (broadcast MAC, or by MAC cloning if supported by the network equipment..
> not all switches like MAC cloning)

I thought that having all of the active nodes respond to ARP requests
for the virtual IP would handle that, as the switch could no longer
bind an IP address to a particular switch port? Is that not the case
with some hardware?
 
> The multicast approach provides full flexibility in how connections are
> migrated among the nodes, but does not scale very well as all nodes sees
> all traffic.

Yeah, that's for sure.
 
> A simple unicast load balancing which does work with most equipment is
> policy routing based on IP's. Ports is also doable in most equipment but
> limits the protocols which can be supported.
> 
> Statically divide the "clients" in N groups, each group assigned to one
> virtual firewall with a virtual MAC address.
> 
> failover this virtual firewall among the nodes in the cluster as needed.
> there may only be one master at a time per virtual firewall but each node
> can be master for several virtual firewalls.

Right, but same situation as above. There are still multiple machines
acting as one by way of a virtual address.
 
> connections need to be ct_sync:ed from the current master to all potential
> backups, multiplied by each virtual firewall.

Is that desired? I'm now thinking that perhaps the goals of ct_sync
are not in line with in-cluster active-active load-balancing.

Here's what I mean: if you have a 4-node cluster of firewalls in
active-active configuration, then the states of all connections
flowing through ALL the boxes are replicated on all of the boxes. This
defeats the purpose of active-active load-balancing as each of the
boxes would then handle almost all of the load of the whole cluster. I
don't see why I'd want to synchronize the connection states between
_all_ of the machines in an active-active cluster.

> For virtual MAC address support to Linux see the mac_vlan patch. Allows
> you to create any number of virtual ethernet interfaces per real
> interface, each with their own MAC.

Nice, that sounds better than the hidden patch I was looking at. Thanks :)

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
