From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ICMP unreachable (DF) does not report the NATed IP
Date: 29 Apr 2003 21:13:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051643586.8214.37.camel@tux.rsn.bth.se>
References: <4F9AFAF72B246745B6847C7EECD8FF6901D17A81@EXCHANGE1.charite.de>
	 <1051552224.5946.239.camel@tux.rsn.bth.se>
	 <20030429145046.GF684@naboo.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030429145046.GF684@naboo.intranet.astaro.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-04-29 at 16:50, Harald Welte wrote:

> > That's the wrong way to do it, fix the cause of the problem. It's the
> > code in icmp_reply_translation() in ip_nat_core.c
> 
> please don't tell me there is still an unhandled ICMP reply translation
> problem.  If yes, I think I need a new brain.

I actually havn't verified it :) I see problems with kernels without the
inner-icmp-translation-fix. I see two cases:

1. no NAT rules but ip_conntrack_ftp and ip_nat_ftp are loaded.
   router which has these modules loaded generate an icmp frag needed
   packet and the outer header is rewritten to the ip of the ftpserver.
   Internal header is probably untouched, hard to tell from a tcpdump.

2. DNAT and the icmp frag needed gets the outer header rewritten but not
   the internal.

So with the fix both headers will be rewritten if I understand it
correctly. It's been a little while since I looked at it.
Case 1 won't happen anymore because of pending/25_natcore-nohelper.patch

Case 2 will get both headers rewritten and hosts do not expect to get an
icmp frag needed from the ip they are trying to send packets to. I've
tested and Linux ipstack will drop those packets.

This can't always be avoided, think about the case where the DNAT is for
packets destined for the router itself. But if the DNAT is for other
ip's the external header shouldn't be rewritten, just the internal.

It's tricky, I understand why it's always been a problematic area :)

> > Also look at the submitted/11_inner-icmp-translation-fix.patch patch in
> > patch-o-matic as it modifies this function.
> 
> This patch was supposed to handle all the remaining cases we had with
> fixing ICMP translation.  The case Oliver Hillmann was talking about
> sounds exactly like one of them.

I hope I'm wrong :)

-- 
/Martin
