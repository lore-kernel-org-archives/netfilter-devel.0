From: Thomas Themel <themel@iwoars.net>
Subject: Netfilter and source address selection
Date: Tue, 4 Nov 2003 12:24:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031104112421.GC30148@iwoars.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Currently, a local TCP socket that connect(2)s to the outside gets its
source address from the routing table entry that is used to send it out.

However, with iproute2, it is possible that this routing table entry is
selected based on the netfilter fwmark. This causes the packet to be
routed twice, but only the first time is considered for source address
selection. 

The process is something like this:

* SYN packet is generated
* SYN packet goes through routing, gets local source address
* SYN packet goes through netfilter OUTPUT chain and is mangled
* SYN packet is then routed again
* SYN packet already has a source address and thus doesn't get the
  source address of the route it is actually sent out on

This results in the packet being sent out via the route it matches after
being mangled, but with the source address of the route it matched
before being mangled.

I think that the behaviour would be more consistent if the last step was
something like 'SYN packet gets the source address of the new route'. 

I can see two ways to achieve a correct end result:

1. The source address selection code (that would be ip_route_connect in
   include/net/route.h?)does not only a routing table lookup, but the
   full code path (ie routing, OUTPUT chain, rerouting) including
   netfilter and thus gets the source address right immediately. 

2. The socket/skb (I know very little about the networking code, so my
   terminology might be all wrong) is somehow flagged as 'locally
   originating' and its source address is replaced when it is routed
   again.

[3. Explicitly do a SNAT in POSTROUTING. However, this requires that
    the netfilter rules be kept in sync with the routing and strikes
    me as Not The Right Thing to do.]

Which of those two is the better idea? Is this the way it is by design
or do you consider that a bug?

ciao,
-- 
[*Thomas  Themel*] I just want an EDitor!! Not a "viitor". Not a "emacsitor".
[extended contact] Those aren't even WORDS!!!! ED! ED! ED IS THE STANDARD!!!
[info provided in] 
[*message header*] Paul J. LoPresti in <1991Jul11.031731.9260@athena.mit.edu>
