From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU (Patrick McHardy)
Date: Sat, 15 Feb 2003 17:43:55 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15950.60635.389199.836425@isis.cs3-inc.com>
References: <20030215232635.25928.78900.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030215232635.25928.78900.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


 > I guess some cruel decisions have to be made here, and we haven't even
 > started to think about mangling nat helpers ..

Clearly when you alter packet sizes PMTU can only be approximate,
with an error of the amount that a packet size could change.
On the other hand, internet routes are supposed to be somewhat
dynamic, so it's clear that PMTU discovery must be treated as only
heuristic, i.e., you have to be prepared for a size that worked before
to not work now.

 > I hope this discussion is not already over. Sorry, but it took me a
 > while to understand all the implications and to skip through some RFC's.

I'm also more than a little confused.
My understanding is that the UDP user can't receive fragments, just a 
defragmented "datagram", from which he can't tell whether or how it
was fragmented.  Is this correct?
The only thing the program can do to determine PMTU then is to set the
DF flag and find out whether the data(*) is delivered (either from a
reply that indicates it was or an ICMP that indicates otherwise).
Is that still correct?  I don't even see the word "fragment" in rfc
768 (UDP).
(*) the term data here in intentionally ambiguous, trying to not yet
deal with issues below

Is there some other RFC I should be looking for?

 > > >>ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
 > > >>refragments them at POST_ROUTING without careing about IP_DF. packets
 > > >>with IP_DF|IP_MF can be refragmented with a different size, so path
 > > >>mtu discovery is broken.  Linux nfs itself sends out packets with
 > > >>IP_DF|IP_MF.

 > both are set. "|" is logical or. nfs (always?) generates packets bigger 
 > than mtu
 > so they are fragmented and have IP_MF set (except last one). If linux 
 > wants to
 > know path mtu it sets IP_DF on these, so the fragments may not be _further_
 > fragmented.

This already seems suspicious to me.  Is there any RFC that
specifically says this is allowed or does this fall into the area
that violates the robustness principle (i.e., not being conservative 
in what you send to others)?

Is a user program allowed to specify what fragments to send?
I guess you're saying it's the system that's doing this, perhaps in
order to decide what size fragments to send.  In that case you might
even argue that the system on the other side should react differently
to different size fragments that arrive.  

So the scenario is:
You want to test PMTU <=1000
You send a "datagram" of size 2000 in fragments of size 1000 and 1000
both with DF set, expecting to get an icmp complaint only if PMTU
<1000.
A conntracking firewall (FW) defragments to a single datagram of size
2000.
At this point it has to refragment to forward the datagram.
Several possibilities:
- FW notices DF and rejects the datagram, telling you that fragmentation
was needed when DF was set
This might be considered incorrect since fragmentation was not needed
for the packets you sent.  On the other hand, the IP header in the icmp 
packet shows that the size that was too big was 2000.
- FW refragments to sizes 1500 and 500.  It's entirely unclear to me
whether those should be marked DF.  What if some of the incoming
fragments were DF and others were not?
In any case, the danger again is that one has to be fragmented later
on, but again the icmp reply contains the header showing the size of
the packet that was rejected.

In other words, when you do this DF PMTU discovery you ought to look
at the size of the packet that was rejected and draw conclusions from
that.  

 > What about storing the biggest fragment size of a packet at
 > defragmentation and refragmenting the packet with that size at
 > POST_ROUTING if MTU is not smaller.
So at this point I gather the goal is the other side of the
robustness principle - trying to make something work that probably 
shouldn't have been tried to begin with.  Are there lots of other
things out there that play the same (questionable?) tricks?

The suggestion above seems fair enough, but if the problem that
we're trying to fix is specifically in linux, perhaps the other 
end should also be fixed?

 > >I think we have to store fragment sizes of each connection, but storing
 > >
 > even worse we need to store the fragment sizes of each reassembled 
 > packet. if we consider
 > the case not all fragments have DF set and we would want to handle nat 
 > resizing correctly
 > besides fragment sizes we also need fragment boundaries and fragment 
 > flags (-> iph->frag_off).
Keeping in mind that PMTU can change as path changes, it seems 
reasonable to do this on a -per-datagram basis rather than
per-connection.  That still doesn't seem so expensive.
