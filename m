From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Wed, 29 Sep 2004 01:36:19 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409290111570.3760@filer.marasystems.com>
References: <1096374273.7192.27.camel@nienna.balabit>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<20040928180425.GA21097@zion.homelinux.com>
	<Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
	<20040928205723.GA23352@zion.homelinux.com>
	<876ef97a04092815306fa270f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: KOVACS Krisztian <hidden@balabit.hu>, Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Sven Schuster <schuster.sven@gmx.de>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@znyx.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a04092815306fa270f@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004, Tobias DiPasquale wrote:

> Also, I'm not exactly sure how you can do active-active without either
> multicast or multicast-by-way-of-MAC-address-cloning. This is because
> of the fact that I'm not really sure how you can do active-active
> without all of the nodes having the same IP address. (otherwise, what
> would it be?)

There is many ways to get traffic on an node, each having their 
complications and limitations.

For unicast you need to find some method to divide the address space using 
existing metrics supported by your network. If we assume the trivial setup 
of an HA active-active server then this can for example be done by routing 
the traffic based on the source IP or by client based balancing by 
publishing the service using multiple IPs. In a forwarding NAT firewall it 
gets a little more complex as you have two sides with slightly different 
metrics to care about.  And N node setups gets even more complex as you 
then need to be able to divide and merge contexts across several nodes 
when adding/removing nodes unless you accept a imbalance in the load if a 
node member has failed (fixed contexts, where one node at a time is master 
per context).

If you do not have any reasonable support for balancing in your network 
layer then you can either introduce a load balancer layer or use multicast 
(broadcast MAC, or by MAC cloning if supported by the network equipment.. 
not all switches like MAC cloning)

The multicast approach provides full flexibility in how connections are 
migrated among the nodes, but does not scale very well as all nodes sees 
all traffic.

A simple unicast load balancing which does work with most equipment is 
policy routing based on IP's. Ports is also doable in most equipment but 
limits the protocols which can be supported.

Statically divide the "clients" in N groups, each group assigned to one 
virtual firewall with a virtual MAC address.

failover this virtual firewall among the nodes in the cluster as needed. 
there may only be one master at a time per virtual firewall but each node 
can be master for several virtual firewalls.

connections need to be ct_sync:ed from the current master to all potential 
backups, multiplied by each virtual firewall.


For virtual MAC address support to Linux see the mac_vlan patch. Allows 
you to create any number of virtual ethernet interfaces per real 
interface, each with their own MAC.



Regards
Henrik
