From: Jamal Hadi Salim <hadi@znyx.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 29 Sep 2004 07:13:10 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096456390.1044.212.camel@jzny.localdomain>
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
	<1096424069.1046.84.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409291000490.11661@filer.marasystems.com>
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
In-Reply-To: <Pine.LNX.4.61.0409291000490.11661@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-09-29 at 04:12, Henrik Nordstrom wrote:
> On Wed, 28 Sep 2004, Jamal Hadi Salim wrote:

> > Unfortunately i am not sure if you can force current to always get
> > its port allocation from the allocated range _only_. Is this doable?
> 
> iptables NAT allows you to specify the IP and port range acceptable.
> 

My brain access is getting slow - I knew this. But does the machine then
only restrict itself to those ports for that IP defined?

> > Caveat: You just limited your active connections for your cluster to 64K
> > flows.
> 
> Not really. But if you only have a single IP address then the port 
> allocation limits you to 64K flows per "other" IP. As already discussed 
> the tuple needs to be unique between different flows, not neccesarily the 
> port.

To clarify what you are saying: you will have (in the case of
masquareding single external realm IP) 64K possible flows per internal
realm _src_ IP?

> > I think we should make the issue of balancing a separate item.
> 
> It is separate from the matter of syncronization. But the reason why the 
> syncronization protocol has not yet been designed for active-active is 
> because no load balancing scheme has been designed which would work. The 
> two goes hand in hand and both needs to be solved.

The cluster shouldnt care how the packet got there. Put LVS infront of
cluster or play ARP tricks - It doesnt matter.
Maybe iam missing something.

> Most likely the first load balancing method which will get implemented 
> (and forcing ct_sync to add the two minor pieces missing for active-active 
> syncronization) is the multicast balancing method in a no-NAT clused where 
> each firewall sees all traffic and selects what it looks closer at.

I am not saying this shouldnt be supported, but why the restiction
to _only_ this? 

>  This 
> is by far the easiest to implement. But even this is not entirely trivial 
> as there may be conflicts in flow key balance IDs depending on the 
> direction of the flow, but most likely this problem is more theoretical 
> than practical.
> 

Thats what it seems to me. 
Maybe the piece i am missing is this "flow key balance IDs"...
If i have all the state of peer firewall, why should i not be able
to process packets you throw at me?

> > It shouldnt matter how the packet gets delivered to an active node
> > (pigeons, expensive loadbalancers, LVS, some routing tricks,
> > etc all is fine by me).
> > Assuming:
> >
> > - The state is already synced across all the nodes;
> >
> > - assuming theres no conflict and
> >
> > - assuming asymetry (ok, maybe thats too restrictive) but a good start.
> 
> Allowing for assymetric flows is not something which is realistic to aim 
> for unless you also aim for absolute syncronization by delaying packets 
> until the firewalls have been syncronized. Such design will scale very 
> badly.

Sorry, I meant symetric setup .. i.e equal looking machines with same or
similar set of addresses. Two masquareding examples:

I:
Machine A: internal IP: 10.0.0.1, external 1.1.1.1
Machine B: internal IP: 10.0.0.2, external 1.1.1.2

On failover, all addresses taken over by peer; state synced, things 
run as before.

II:
Machine A: internal IP: 10.0.0.1, external 1.1.1.1
Machine B: internal IP: 10.0.0.2, external 1.1.1.1

cheers,
jamal
