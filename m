From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 16:43:05 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311201626560.12803-100000@filer.marasystems.com>
References: <3FBCCBA0.7020309@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FBCCBA0.7020309@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 20 Nov 2003, Emmanuel Guiton wrote:

> I wonder... Can every NAT applications be replaced by ipv6? Now, the 
> application area of NAT is much bigger than the original goals (e.g. 
> security applications, easing network administration), so I wonder if 
> ipv6 can make NAT useless. Without proof of the contrary I would say 
> that NAT will still be usefull.

Lets put it this way instead:

Now that we are on the edge of starting to deploy a new Internet network
addressing scheme, try not to repeat the mistakes done in IPv4 in IPv6
only because they happens to solve what it thought to be real problems in
IPv4, such as abusing NAT for other purposes than NAT was intended for.
IPv6 completely eleminates the original purpose of NAT (compression of 
the IPv4 address space).

It is true that NAT in IPv4 is used for a lot of other applications today
than was originally envisioned when designing NAT for IPv4, but most is
there to work around application protocol braindamage, not to solve IPv4
level networking problems. Some of these applications are pretty neat such
as server load balancing, but still using NAT for such purposes is
fundamentally broken from a IPv4 networking point of view.

Undoubtly similar abuses of the IPv6 protocol to do "amasing" things is
likely to appear over time just as has had happened with IPv4 in the last
decade, but it is pointless to start discussing breaking the protocol
before investigating what solutions exists for solving the problem within
the protocol. A lot of thought has been put into the IPv6 protocol to
solve many of the problems experienced over the years with IPv4, and at
the same time the transition from IPv4 to IPv6 also allows for a nice
transition from old braindead applications to more capable applications.

So instead of focusing on IPv4 problems in a IPv6 packet level, take a
step back and look at the problem as such and how it is best solved in
IPv6. If this involves slight changes to applications to add behaviour not
yet existing, no big deal as the applications need to be changed anyway.

Regards
Henrik
