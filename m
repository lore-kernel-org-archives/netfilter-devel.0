From: Brad Parker <brad@parker.boston.ma.us>
Subject: default behavior & skb_linearize
Date: Fri, 15 Aug 2003 13:56:54 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308151756.h7FHus514738@p2.parker.boston.ma.us>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Part of this may be better for the users list, but part of it is internals
so bear with me... (or is that "bare" with me? :-)

I want to so some work with iptables in a 2.4.20 kernel.  I'm booting
with a NFS root.  The stock kernel works fine and the nfs client works
fine.

But, when I turn on netfilter, the nfs client stops workings - sort of.

aside: I am assuming that if I turn on netfilter and connection tracking
the "default" (i.e. no external rules loaded via iptables) should pass
everything and the kernel nfs client should continue to work.  This is
true, yes?

I can send the interesting parts of my .config if needed.

It looks to me like nfs continues to work but the nfs read response
udp fragements cause some sort of problem...

I attempt to short circuit nf_hook_slow and this works, but only if I
comment out the call to "skb_linearize".  Any idea why that is?

(it's obvious, but I'll point out that if I short circuit nf_hook_slow -
by calling okfn and returning - the nfs client works fine)

I'll keep digging but I thought there might be something obvious I'm
missing...

-brad
