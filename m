From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Tue, 16 Nov 2004 16:28:41 +1100
Message-ID: <1100582922.18132.34.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: srisures@yahoo.com, baford@mit.edu,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>, dank@kegel.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-11-09 at 16:49 +0100, Harald Welte wrote:
> Hi!
> 
> On the IETF behave list, I received a link to a yet unpublished draft
> that can be seen as a successor to the old 'kegel draft' (now also
> authored by a whole group).  It should be a good reading for anyone who
> wans to thoroughly understand the problem and see proposed solutions.
> 
> It now covers both, UDP and TCP.
> 
> http://www.brynosaurus.com/pub/os/nat.pdf

OK, I actually like this draft (although the classic NAT terminology
still leaves me cold - no matter).  Kudos, Bryan/Pyda/Dan!

The exploration of the multiple layers problem was new to me, which was
a pleasant surprise (in my own exploration of these issues I never got
past "Ick, don't do that!").  I'm not sure whether we can implement
hairpin NAT sanely though.

In iptables-speak, assume:
	NAT A: does SNAT -> 10.0.1.1 on conns to external.
	NAT B: does SNAT -> 10.0.1.2 on conns to external.
	NAT C: does SNAT -> 155.99.25.11 on conns to external.

When Client A talks to B(public), NAT C will see:
	10.0.1.1:45000 -> 155.99.25.11:62005

It's a new connection, and without an explicit rule, it will simply be
sent to the NAT C box itself (assuming 155.99.25.11 is its real IP
address), in the assumption that it is an incoming local connection.
NAT C will send an ICMP error or TCP RST.  The packet from Client B to
A(public) will do the same thing.

Now, what do we want to happen?  NAT C should scour its tables and see
if anyone is using 155.99.25.11:62005 as an output address, and assume
that this connection should be DNATted towards them (the source-lookup
mapping should ensure that this will be SNATted to 155.99.25.11:62000
anyway).  "iptables -t nat -i eth0 -A PREROUTING -d 155.99.25.11 -j
HAIRPIN" anyone?  Not that we have a hash we can search for this case,
so it'd be incredibly slow, or we'd need to add one.  

Most NAT explanations and implementations assume that each connection
gets exclusive use of the port in the NAT space (exception connections
with same SRC already).  Unfortunately I decided that being able to
preserve source ports was generally more important, but this is looking
more questionable now.  One benefit is that we can put thousands of
hosts behind a single IP address, but maybe that's worth sacrificing?

Thoughts welcome,
Rusty.
PS.  Even before our "lookup previous connections from same source" fix,
we usually got the desired "cone" behaviour because we try to preserve
source ports.  So in practice that bug doesn't bite very hard.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
