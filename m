From: jamal <hadi@cyberus.ca>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 29 Sep 2004 10:23:59 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096467839.1021.59.camel@jzny.localdomain>
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
	<10964
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409291527520.13941@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-09-29 at 09:41, Henrik Nordstrom wrote:
> On Wed, 29 Sep 2004, Jamal Hadi Salim wrote:

[..]

> if you want to have an active-active firewall using unicast distribution 
> then your network (not the firewall) must somehow ensure that traffic in 
> both directions goes via the correct firewall with no asymmetric data 
> flows.

Lets assume symetry.
My goal is to make _all_ firewalls in the cluster the "correct" firewall

> >> Your distribution must be 100% equal on
> >> both sides.
> >
> > Given above assumption, why do i need this?
> 
> because syncronosation of the firewalls is not instantaneous or atomic. 
> There is a delay before a state change on one firewall is replicated to 
> all other firewalls.

Where this becomes an issue is if your responses come back faster than
you can synchronize state. If you are going across big bad internet
where latencies start in the ms range, then the issue becomes less
challenging. 

> > I was assuming all along we have agreed that all necessary state would
> > be synced. Yes, this may generate a lot of traffic, but it does seem to
> > be neccessary evil.
> 
> Syncing state in absolute realtime is in my opinion not an option. This 
> would require delaying forwarding of every packet until the state change 
> inflicted by this packet has been fully replicated to all nodes in the 
> cluster, which in terms of performance is some orders of magnitude worse 
> than using the multicast approach to have the traffic distributed among 
> the nodes.

I think what you describe above needs to be done in the case of response
latency being lower than update latency. i.e its not a bad option. It
will slow down the setup time but thats only for the firts new packet.
The impact on susbequent packets in the flow should be low.

cheers,
jamal
