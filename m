From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Netfilter and source address selection
Date: Wed, 5 Nov 2003 00:39:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311050029170.16903-100000@filer.marasystems.com>
References: <20031104112421.GC30148@iwoars.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Themel <themel@iwoars.net>
In-Reply-To: <20031104112421.GC30148@iwoars.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 Nov 2003, Thomas Themel wrote:

> This results in the packet being sent out via the route it matches after
> being mangled, but with the source address of the route it matched
> before being mangled.

Yes, and there is two solutions to this

a) Teach the application to bind to the correct address before initiating 
the connection.

b) Use SNAT in the OUTPUT nat chain to assign the correct source address 
to the connection.


The reason why this happens is because the TCP/UDP kernel needs to know 
the source IP address when generating the SYN packet, and with netfilter 
running outside of the TCP/UDP kernel it has no influence over this 
process.

> 1. The source address selection code (that would be ip_route_connect in
>    include/net/route.h?)does not only a routing table lookup, but the
>    full code path (ie routing, OUTPUT chain, rerouting) including
>    netfilter and thus gets the source address right immediately. 

Problem is that for the packet to be sent to netfilter it first needs to 
exists, and for the packet to exists the upper level protocol needs to 
know the source address..

> 2. The socket/skb (I know very little about the networking code, so my
>    terminology might be all wrong) is somehow flagged as 'locally
>    originating' and its source address is replaced when it is routed
>    again.

This might be doable.. add a flag to the skb indicating that the source 
address is dynamically assigned, hinting to the mangle table that it needs 
to SNAT the connection if the resulting route is using another source 
address..

> [3. Explicitly do a SNAT in POSTROUTING. However, this requires that
>     the netfilter rules be kept in sync with the routing and strikes
>     me as Not The Right Thing to do.]

But.. it would not be hard to write a SNAT target which takes the address 
fom the route entry, and I think this is the best solution to the problem. 
To not break local socket binding the flag discussed above should also be 
added.

Regards
Henrik
