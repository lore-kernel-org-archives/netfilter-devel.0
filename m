From: Paul Tipper <tipper@wintermute.me.uk>
Subject: A question about reinjecting packets
Date: Wed, 11 Feb 2004 15:58:07 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040211155807.GA3146@lain.localnet>
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

Greetings, 

I'm working on an implementation of an IPv4 to IPv6 bump in the stack (yes
I admit it, I'm a student) and while doing this I've gotten stuck at the
stage of reinjecting packets into the network.  The model I'm working with
is a little kludgey but in short translates v6 addresses to Class E v4
addresses so that they can be consistently addressed.

I've written a module that hooks into NF_IP_LOCAL_OUT and intercepts
outgoing v4 packets, checks to see if there is a v6 mapping and if there
is translates the packet to v6.

Currently this translation consists of using skb_unshare() on the packet
to ensure its not a clone, then skb_copy_expand() to create an entirely
new copy of the packet including its data.

The sk_buff->protocol field is changed and the new struct ipv6hdr is
constructed (with the local v6 address in the saddr and the destination
the 240.x.x.x address maps onto in the daddr field.  Finally the new
sk_buff has its ->nh changed to point at the new ipv6hdr and the csum is
recalculated.

So as far as I can see I've modified everything I need to change to make
this v4 sk_buff into a v6 one, the problem I then run into is I can find
no way of getting it successfully out onto the network.

I've tried using ip6_xmit() (for which I constructed a struct flowi).
When I couldn't get that work I prodded about some more and tried to use
the NF_HOOK macro to send it out on PF_INET6, NF_IP6_POST_ROUTING, however
the packet never seems to make it out onto the network and just vanishes
without a trace, which leads me to believe I've not converted it properly
and some nice peice of code further down the line is dropping it for
safety reasons.

Is anyone feeling generous enough to make a stab at what I must have
missed?  Or point me in the right direction?


-- 
   /\   Paul Tipper -- Code Monkey & Caffeine Junky
  /<>\   Email: tipper at wintermute dot me dot uk
 /____\   WWW: http://www.wintermute.me.uk/
