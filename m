From: jamal <hadi@cyberus.ca>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: 28 Sep 2004 06:56:42 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096369001.8661.165.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
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
In-Reply-To: <Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-09-28 at 02:46, Henrik Nordstrom wrote:

> Lets assume you have two Active-Active gateways G and H, two clients A and 
> B and one server S. On the gateway NAT is used to masquerade all traffic 
> to a single external IP address.
> 
> Due to the Active-Active setup traffic from A goes via the gateway G and 
> traffic from B goes via H.
> 
> Now you have a SYN from A,31285 to S,80 and also a SYN sent by B,31285 to 
> S,80. You then end up with two identical NAT assignments and the two 
> connections will conflict with each other.

if we even look at the 5 tuples {srcIP,DstIP, proto, srcport,dstport} we
already have a distinction, no?
i.e in the example you provide srcIP would be different.

I can see an issue if those 5 tuples match and you have to find
something else to distinguish them since Linux contracking doesnt keep
track of TCP sequence numbers and window dilations. If it did i dont see
why this would be a problem. I think i am having a hard time visualizing
when you would even need to kick in sequence number checks,


> > With above if i decide i want to have two nodes as master, they both
> > generate and accept state update messages.
> 
> Which in itself is not an issue, but the issue is how to ensure these 
> updates does not conflict with each other as in the example above.
> 
> The active-active or active-backup aspect of the syncronization protocol 
> is trivial. How to ensure there won't be serious session conflicts between 
> the connection information of the two gateways is the tricky part in order 
> to be able to provide active-active configurations.

See my comment above.
I dont think i see a serious issue of conflict. I may be missing
something of course. At least the srcIP may endup being a tiebreaker.
To get exactly the same 5 tuples from the same physical machine for a
different flow is impossible i would think. 
Again i may be missing something.

cheers,
jamal
