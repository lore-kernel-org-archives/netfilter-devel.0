From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 20:47:15 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
References: <Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<20040928180425.GA21097@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, Jamal Hadi Salim <hadi@znyx.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20040928180425.GA21097@zion.homelinux.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004, Sven Schuster wrote:

> Shouldn't a node be able to handle a connection for which it isn't the master??

No.

> Say, if we have just one public IP address, we must divide our source 
> ports for NAT into, say N parts for N firewall cluster nodes. Now, 
> shouldn't the division of the ports just be to avoid ambiguous tuples on 
> the cluster at connection (NAT) setup time?? If a node got an update for 
> a tuple, then it should be able to handle this connection fully, no??

You are mixing up NAT assignment and being master of a connection. The two 
are separate.

> Ok, now (2 seconds ago :) it just made 'click' in my brain. This of course only
> applies when it is guaranteed that one (reply) packet is seen by only one node in
> our firewall cluster.

Which is not the case. In a multicast style setup all firewalls sees all 
traffic. Each firewall needs to be able to determine what of this traffic 
it is supposed to forward.

> Of course, when we have some kind of multicasting so that
> each node will see all the traffic, this won't work and we have to make sure that
> only one node (preferrably the master of this connection) is handling the packet.
> But, as you wrote, multicasting does not scale as well as unicast.

Correct.

> And when using multicast, we also would have to make sure that the 
> initial packet which causes a new connection to be set up is handled by 
> only one node...how??

By hashing of the original tuple, dividing the address space among the 
currently active firewalls.


The main problem for unicast active-active firewalls is how to handle load 
distribution, failover and recovery in an sane manner without requiring a 
load balancer infront of the firewalls.

Regards
Henrik
