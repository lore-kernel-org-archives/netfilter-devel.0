From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Wed, 29 Sep 2004 13:44:25 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409291337001.13132@filer.marasystems.com>
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
	<
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jamal Hadi Salim <hadi@znyx.com>
In-Reply-To: <1096456390.1044.212.camel@jzny.localdomain>
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

> To clarify what you are saying: you will have (in the case of
> masquareding single external realm IP) 64K possible flows per internal
> realm _src_ IP?

No, per external IP,port contacted by your internal addresses.

Original tuples

internal_station_ip,port external_server_ip,port

Masqueraded tuples

masquerade_ip,port(*) external_server_ip,port

> The cluster shouldnt care how the packet got there. Put LVS infront of
> cluster or play ARP tricks - It doesnt matter.
> Maybe iam missing something.

For a firewall you have to care about traffic on both sides, unless you 
are doing multicast balancing.  Your distribution must be 100% equal on 
both sides.

>> Most likely the first load balancing method which will get implemented
>> (and forcing ct_sync to add the two minor pieces missing for active-active
>> syncronization) is the multicast balancing method in a no-NAT clused where
>> each firewall sees all traffic and selects what it looks closer at.
>
> I am not saying this shouldnt be supported, but why the restiction
> to _only_ this?

Who have said this? It is certainly not my intentions to imply multicast 
load balancing is the only way to go.

>>  This is by far the easiest to implement. But even this is not entirely 
>> trivial as there may be conflicts in flow key balance IDs depending on 
>> the direction of the flow, but most likely this problem is more 
>> theoretical than practical.
>>
>
> Thats what it seems to me.
> Maybe the piece i am missing is this "flow key balance IDs"...
> If i have all the state of peer firewall, why should i not be able
> to process packets you throw at me?

Beause you don't have the all the state. There is significant delays in 
the state distribution unless you accept to make the state syncronization 
syncronous with the packet flow (no packet forwarded before the state 
change this packet implies have been verifiable syncronized to all 
firewalls) which would in effect make the total cluster performance some 
orders of magnitude worse than having a single firewall with no or very 
little options for load balancing.

> Sorry, I meant symetric setup .. i.e equal looking machines with same or
> similar set of addresses. Two masquareding examples:
>
> I:
> Machine A: internal IP: 10.0.0.1, external 1.1.1.1
> Machine B: internal IP: 10.0.0.2, external 1.1.1.2
>
> On failover, all addresses taken over by peer; state synced, things
> run as before.
>
> II:
> Machine A: internal IP: 10.0.0.1, external 1.1.1.1
> Machine B: internal IP: 10.0.0.2, external 1.1.1.1

I don't quite follow what you aim for here. Please outline this in terms 
of connections (full tuples), masquerading/NAT (modified tuples) and 
routing/forwarding of traffic in both directions.

Regards
Henrik
