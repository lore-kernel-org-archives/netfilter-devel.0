From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Wed, 29 Sep 2004 15:41:03 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291527520.13941@filer.marasystems.com>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jamal Hadi Salim <hadi@znyx.com>
In-Reply-To: <1096463006.1041.310.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 29 Sep 2004, Jamal Hadi Salim wrote:

> Ok, so my math was off. A relief. But if all were going to the same
> external IP then limit is 64K.

Yes, unless you have more than one masquerade IP or they go to different 
ports.

Basic limitation of TCP/IP. Not much netfilter can do about. Between two 
IP addresses where one is server (single port) the other client (dynamic 
port) there can be no more than 64K connections as the only piece of the 
tuple identifying such connections is the source port of the client, 
limited to 2^16.

>> For a firewall you have to care about traffic on both sides, unless you
>> are doing multicast balancing.
>
> I am assuming ct_sync is creating these states for me.

ct_sync or not does not really matter in this part discussion. ct_sync 
only allows for graceful failover of the session from one firewall to 
another.

if you want to have an active-active firewall using unicast distribution 
then your network (not the firewall) must somehow ensure that traffic in 
both directions goes via the correct firewall with no asymmetric data 
flows. If not the state syncronization becomes impractical.

Internal Network -> Firewall

Internet -> Firewall

>> Your distribution must be 100% equal on
>> both sides.
>
> Given above assumption, why do i need this?

because syncronosation of the firewalls is not instantaneous or atomic. 
There is a delay before a state change on one firewall is replicated to 
all other firewalls.

>> Beause you don't have the all the state. There is significant delays in
>> the state distribution unless you accept to make the state syncronization
>> syncronous with the packet flow (no packet forwarded before the state
>> change this packet implies have been verifiable syncronized to all
>> firewalls) which would in effect make the total cluster performance some
>> orders of magnitude worse than having a single firewall with no or very
>> little options for load balancing.
>
> I was assuming all along we have agreed that all necessary state would
> be synced. Yes, this may generate a lot of traffic, but it does seem to
> be neccessary evil.

Syncing state in absolute realtime is in my opinion not an option. This 
would require delaying forwarding of every packet until the state change 
inflicted by this packet has been fully replicated to all nodes in the 
cluster, which in terms of performance is some orders of magnitude worse 
than using the multicast approach to have the traffic distributed among 
the nodes.

Regards
Henrik
