From: don-netfil@isis.cs3-inc.com (Don Cohen)
Subject: Re: SNAT and IP ID -> what can be mangled by routers?
Date: Tue, 6 May 2003 16:08:24 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <16056.16488.160331.524283@isis.cs3-inc.com>
References: <20030502222622.31281.56108.Mailman@kashyyyk>
	<16053.26244.510867.656383@isis.cs3-inc.com>
	<20030506205815.GK14822@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030506205815.GK14822@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

(finally a reply!)

 > > It seems to me that some parts of an IP packet can be arbitrarily
 > > changed by the forwarding infrastructure.
 > yes.
 > > The TOS field seems like one good example.  When I send a packet to
 > > my ISP it can (I believe, or at least should be allowed to) change
 > > the TOS field as it wishes to influence where and when that packet
 > > is forwarded.  What arrives at the ultimate destination need not bear 
 > > any resemblance to what I sent.
 > indeed. However, the TOS bits have never been used in any larger scope
 > larger than a particular site, since their interpretation changed three
 > times over the years...

It has changed, but I think it has always been used in a larger scope.
Originally I think it was not supposed to be changed and the entire
forwarding path was meant to use it.  Now I think it's allowed to be
changed anywhere and any place can use it.  Certainly the diffserve
per-hop-behaviors do use it throughout the forwarding infrastructure. 

 > > The possible danger I see from this is that, after the TOS is altered,
 > > some router might decide to send me an ICMP reply saying that it could
 > > not forward this packet.  
 > I don't think this would be a valid operation.   Of course you can
 > configure a packet filter to do so - but I don't think you will find any
 > valid RFC telling you that this is a valid means of operation for the
 > TOS bits.  Of course the packet can get a lower priority, probably
 > dropped by some queuing mechanism - but send an ICMP back ? 
You must have misunderstood me.  I imagine that I send a packet with
TOS=13 and DF bit set.  My ISP immediately changes TOS to 3 and
forwards it.  Later on in the path some router has a small MTU and
is required to drop the packet.  It then sends me back an ICMP about
dropping the packet due to DF and this reply contains a header with
TOS=3.

 > > This means that when I receive that reply I should NOT expect the TOS
 > > field in the reply (I mean the one in the ICMP content part containing
 > > the beginning of the packet as it was received at that router) to be
 > > the same as the one I sent.
 > yes.

 > > Perhaps I should also not expect, e.g., the IP ID field to be the
 > > same?  If I can rely on the ID field to be the same then it becomes
 > > an expensive proposition to mangle IDs at the firewall since you have
 > > to be able to UNmangle the ICMP replies, which requires possibly a lot
 > > of memory.
It now occurs to me that it could also take a lot of memory to do this
ID mangling in the first place.  You effectively have to defragment.
Then if you want to unmangle you have to remember the mapping until
you're sure no ICMP replies for that packet can return.

 > Interesting issue.  But IMHO you should not make assumptions on the IP
 > ID field.  The IP ID field has a single purpose: fragment reassembly at
 > the destination.

Who should not assume what?
The firewall implementer should not assume that the OS at the
end point will NOT compare the ID it sent with the ID it received?
Then the firewall must unmangle the ID, which is expensive.
Or the implementer of the OS at the end point should not assume that
that ID it receives will be the same as the one it sent?

Your second sentence, about the single purpose of the ID, suggests 
that you take the second view.  Of course, this is the view that's 
better for you, the firewall implementer.  I like that view because 
it's better for me too.  It allows me to use that ID for other things 
that were never intended by the spec without having to worry about 
unmangling them (which would be even harder for what I have in mind 
than for a firewall).

 > > So if the TOS or ID were mangled on the way to the router sending the
 > > reply this would have no effect, I believe.  (Any other opinions?)
 > At least not to the linux (and any other sane) TCP/IP stack.
Things would be much simpler if we could assume sanity.

 > > The real question:
 > > Are there any standards that indicate what parts of the ICMP reply the
 > > recipient can count on to be the same as the packet originally sent?
 > > If so, which are they and what do they say?
 > 
 > I've re-read the respective RFC's (1122,792,1812,...) and I didn't come
 > up with a clear answer.  The closest we get is:
 > 
 > "The returned IP header (and user data) MUST be identical to that which
 > was received, except that the router is not required to undo any
 > modifications to the IP header that are normally performed in forwarding
 > that were performed before the error was detected (e.g., decrementing
 > the TTL, or updating options)."
 > 
 > An IP ID change is certainly nothing 'normally performed in forwarding'.

But this means what was received by the router, right?  
Not necessarily the same that was sent by the originator of the packet.
So the question remains about which fields can be changed along the
forwarding path.
