From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: New draft document on nat / traversal / hole punching (with Dan
 Kegel)
Date: Wed, 17 Nov 2004 17:04:33 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411171646370.17188@filer.marasystems.com>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100582922.18132.34.camel@localhost.localdomain>
	<200411161538.48528.baford@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, dank@kegel.com,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Ford <baford@mit.edu>
In-Reply-To: <200411161538.48528.baford@mit.edu>
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

On Tue, 16 Nov 2004, Bryan Ford wrote:

> 2. Second, the NAT has to have a "port table" or "mapping table" of some kind,
> which records the association between the NAT's own public ports and the
> private endpoints (private IP, private port pairs) they currently represent.

And this is what you do not have in netfilter/iptables NAT.

The netfilter/iptables NAT always work with full tuples, one original 
(before NAT) and one reply (inverse after NAT). The port is not reserved 
and can be reused by any number of different connections from any number 
of clients, what is guaranteed is that the resulting tuples is always 
unique on both sides.

The netfilter/iptables NAT tries to preserve as much as possible of the 
original tuple, and almost always preserves the original source port used 
by the client. Only if there is conflicts after NAT with already 
established sessions is the source port rewritten to keep the NAT:ed tuple 
unique.

Also, netfilter/iptables NAT does not have a concept of internal or 
external. Only original and reply. The concept of internal vs external is 
mainly an administrative concept, not a technical one.

> Again, I don't know the details of iptables, and I know this high-level
> viewpoint probably doesn't line up very closely with how iptables currently
> does translation.  The important point, however, is that hairpin translation
> "in theory" should require just a slight generalization of the hash tables or
> other lookup facilities that need to be implemented anyway in any
> port-restricted cone NAT.  Does this make sense?

Yes.

And the issue here is that iptables is not port-restricted cone NAT and 
does not reserve any ports.

> By trying to preserve source ports, I assume you mean that if a client on the
> internal network uses source port number 1234 for a connection, the NAT first
> tries to allocate port number 1234 at its IP address as the public port for
> that connection?  That's a sensible feature, but it of course has very
> limited benefit as soon as multiple hosts behind the same NAT make outgoing
> connections from the same source port number.

As long as they make connections to different destinations their source 
ports is still preserved.

The source port need only to be rewritten if you have two clients using 
the exact same source port going to the exact same destination ip:port and 
being masqueraded/NAT:ed to a single external IP address.

> For P2P-friendliness the important requirement is that the NAT 
> preserves the _identity_ of an internal-to-external translation across 
> multiple sessions originating from the same internal port, regardless of 
> whether it can preserve the actual _port number_ (which is often 
> impossible).

And as you might see from the above netfilter NAT currently does not have 
this property. Instead it has many nice properties which makes it work 
extremely well in high traffic situations with millions of 
concurrent connections, all being masqueraded/NAT:ed to the same IP 
address if you like (in such case limited to ca 65K connetions per 
destination ip:port, per external IP NAT:ed to, or 1K connections per .. 
for low ports)

I think most of the Netfilter developers understands the problems and 
approaches quite well by now. The question is how much of the quite nice 
properties we have today should/need to be sacrified in order to become 
more P2P friendly.

Regards
Henrik
