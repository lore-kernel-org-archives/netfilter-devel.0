From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Wed, 29 Sep 2004 10:34:46 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291012530.11661@filer.marasystems.com>
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
	<876ef97a040928200055db3741@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: KOVACS Krisztian <hidden@balabit.hu>, Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Sven Schuster <schuster.sven@gmx.de>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@znyx.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a040928200055db3741@mail.gmail.com>
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

> I thought that having all of the active nodes respond to ARP requests
> for the virtual IP would handle that, as the switch could no longer
> bind an IP address to a particular switch port? Is that not the case
> with some hardware?

Switches dont work with IP addreses, they work with MAC addresses.

There is some odd switches which only allows one port per MAC, cutting the 
traffic on the old port when seeing the MAC on a new port. But we are not 
likely to see these switches in environments where this type of firewalls 
are intended to be deployed.

>> failover this virtual firewall among the nodes in the cluster as needed.
>> there may only be one master at a time per virtual firewall but each node
>> can be master for several virtual firewalls.
>
> Right, but same situation as above. There are still multiple machines
> acting as one by way of a virtual address.

Well, to be honest I am not at all considering load balancing of a host, 
only load balancing of firewalls. A firewall does not really have a 
address in such sense, it has a ruleset on what is allowed to be forwarded 
and how the traffic should be mangled (NAT:ed) while it is forwarded. 
Traffic is not addressed TO the firewall, it is addressed to something on 
the other side of the firewall.  The load balancing of hosts is already 
done very well by LVS and is not really a problem which iptables/netfilter 
ct_sync needs to address. Because of this I do not restrict my thinking to 
load balancing methods which would work for a single host/service.

The network simply needs to know which firewall to send the traffic to 
depending on the type of flow. Depending on how smart your network is this 
places certain limitaitons on the type of load balancing methods you can 
select and what restrictions there is on the firewall/NAT rules.

>> connections need to be ct_sync:ed from the current master to all potential
>> backups, multiplied by each virtual firewall.
>
> Is that desired? I'm now thinking that perhaps the goals of ct_sync
> are not in line with in-cluster active-active load-balancing.

Let me reprhase the above

connections need to be ct_sync:ed from the current master to all potential 
backups of this virtual firewall. The potential backup nodes can be a 
subset of the total nodes of the clusted, at least one. This is multiplied 
by each virtual firewall as each virtual firewall needs to have it's 
connections syncronized from it's current master to it's potential 
backups.

The syncronization needs to be online, allowing a backup to recover the 
traffic in case the current master crashes and it's connection table is 
lost.

> Here's what I mean: if you have a 4-node cluster of firewalls in
> active-active configuration, then the states of all connections
> flowing through ALL the boxes are replicated on all of the boxes.

Not neccesarily, this cluster can be divided into 4 virtual firewalls each 
handling a subset of the traffic and each having with at least one 
potential backup node assigned. Each virtual firewall has a unique MAC 
shared among the potential nodes of this virtual firewall.

The drawback is that if one node fails then the load will be doubled on 
it's backup node as that node then gets two virtual firewalls. But the 
benefit is that this design allows for relatively easy unicast 
partitioning of the traffic flows using standard equipment.

If you want more granular load balancing then "simply" divide the setup in 
more virtual firewalls just as you would do if there was more nodes in the 
cluster. With 4 * 3 virtual firewalls you can get very good load 
distribution even in case of one, two or three node failures. The drawback 
is that the network setup gets more complex.

> This defeats the purpose of active-active load-balancing as each of the 
> boxes would then handle almost all of the load of the whole cluster. I 
> don't see why I'd want to synchronize the connection states between 
> _all_ of the machines in an active-active cluster.

Which is exacly what I am saying. Just different words.

Regards
Henrik
