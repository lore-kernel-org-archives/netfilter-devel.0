From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: defense against conntrack attacks
Date: Sat, 15 Jun 2002 15:38:22 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15627.49630.258601.138681@isis.cs3-inc.com>
References: <20020615132638.84C444509@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I noticed in
http://www.linuxvirtualserver.org/Joseph.Mack/HOWTO/LVS-HOWTO-3.html#conntrack
reports that conntrack is a bottleneck.

==== section 1 ====
Here's a summary of some experiments that show this is true and
further suggest that the real expense is in creating new conntrack
records.  If this is a well known phenomenon, then I apologize for the
waste of bandwidth and invite you to skip to section 2.

These were done with 200MHz machines, one generating packets and
the other forwarding.  They're connected by a 100Mbit link.

First test:
 on router
 iptables -A PREROUTING -t mangle -j MARK --set-mark 2
 traffic generator sends 7000 syn's in 2.4 sec (to an address that
  won't reply) all packets the same except randomized destination ports
 result: all marked and forwarded

Second test:
 on router
 iptables -A PREROUTING -t mangle -m state --state new -j MARK --set-mark 1
 traffic generator sends 6131 syn's in 2.06 sec, just like before
 result: 1766 marked new (and I assume forwarded, the total number sent
  out that interface was a little more, I suppose arp, etc.)

This shows that conntrack is a bottleneck, at least dealing with new
packets.

Third test:
 router as in second test
 traffic generator now sends identical syn packets,
  8382 in 2.08 sec
 result: all marked new (and I presume forwarded, again the total
  number sent out that interface is a bit higher)

This shows, I think (please correct me if I'm wrong) that it's
creating new conntrack records (and perhaps garbage collecting old
ones) that is the real bottleneck.

Fourth and fifth tests:
 router as in first and second test
 traffic generator now creates a real connection, just does rcp of
  a large file to a third machine on the other side of the router
 result: no difference, in each case 25MBytes copied in ~4 sec.

Which shows that conntrack is not a bottleneck for packets in
established connections.

==== section 2 ====

So what?  You might argue that 
- in normal usage new connections are not generated very fast 
- if you're syn flooded then you're dead in any case

I argue that you're not necessarily dead in any case.
If the flood really fills up your bandwidth then you are.
But we see above that the amount of syn bandwidth needed to attack a
conntracking machine is far less than it can otherwise handle.
If, in the case above, the attacker could send "only" 1000 syn's/sec
then the attack would work.  But if conntrack could be improved, e.g.,
to make connection creation faster, the same attack would not work.
Also, even if the attacker really can fill the bandwidth between
himself and the firewall, an improved conntrack could maintain
communication between other interfaces. 

I conclude that if the code for creating new connections could be made
faster (it would have to be MUCH faster) there would be some benefit
in doing so.  I've not looked at that.  I presume whoever wrote it was
at least trying to make it efficient.  If anyone thinks this is a
promising approach, please feel free to say so.

What I'm really interested in is a defense that, e.g., rate limits
syns.  The problem I see in the current implementation (again, correct
me if I'm wrong) is that the very first thing that happens when a
packet arrives is that conntrack processes it, and this includes the
code for creating a conntrack record in the case where there is none.

Below is my proposal to fix this.  I hope for replies that address
the following:
- Does this seem like a good approach?
- What would go wrong?
- Any better ideas?

I propose that the code for creating the conntrack record be postponed
until after the point where a defense would have a chance to drop the
packet.

If you recall my posting in April, you won't be surprised that I want
to put the connection creation code well after the current postrouting
hook.  After that hook the packet is enqueued for traffic control, and
it can be dropped between then and when it is dequeued to be sent.  So
I'd like to create a new hook after that dequeue, and this is where I
propose to create the connection record.

It occurs to me that there may be code now that assumes that the
record will exist, e.g., when you try to do something like the
 -m state --state new
above.  If so, that code would have to be fixed, e.g., to use a
default conntrack record if none exists.  But I'd expect that
conntrack records might be garbage collected at arbitrary times,
including between the time of arrival of the packet that created them
and the time that packet goes through some later hook.  So perhaps
this is not a problem.

Another possible problem I see is that creating the connection record
might require data that is no longer available at the later point,
such as the IP addresses in the packet when it arrived (which might by
now be altered by NAT).  I recall this also arose in the April
exchange.  I proposed then that it would be useful to save a little
"historical" data per skbuff for use by later netfilter hooks.  I
propose now that this should specifically include source/dest IP
addresses and ports.  I think I mentioned before that it should
include the device where the packet arrived.

I look forward to your replies.
