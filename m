From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 08:46:25 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
In-Reply-To: <1096339276.8660.30.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Sep 2004, jamal wrote:

> On Mon, 2004-09-27 at 09:30, KOVACS Krisztian wrote:
>> The main problem is with NAT and preserving the uniqueness of
>> tuples in the whole cluster, and unfortunately this would make a lot of
>> things much more complicated. So, even if the protocol would be
>> completely multi-master compatible ct_sync would be capable of
>> single-master operation.
>
> If you have two machines A and B, assuming they are symetric (exactly
> same internal and external IPs) then i should be able to send state from
> A->B and B->A and have both B and A updated (if such state doesnt exist).

No, this is about a different issue entirely.

Lets assume you have two Active-Active gateways G and H, two clients A and 
B and one server S. On the gateway NAT is used to masquerade all traffic 
to a single external IP address.

Due to the Active-Active setup traffic from A goes via the gateway G and 
traffic from B goes via H.

Now you have a SYN from A,31285 to S,80 and also a SYN sent by B,31285 to 
S,80. You then end up with two identical NAT assignments and the two 
connections will conflict with each other.

> With above if i decide i want to have two nodes as master, they both
> generate and accept state update messages.

Which in itself is not an issue, but the issue is how to ensure these 
updates does not conflict with each other as in the example above.

The active-active or active-backup aspect of the syncronization protocol 
is trivial. How to ensure there won't be serious session conflicts between 
the connection information of the two gateways is the tricky part in order 
to be able to provide active-active configurations.

Regards
Henrik
