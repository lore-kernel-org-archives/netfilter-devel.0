From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: nfqueue: batch verdict support
Date: Thu, 7 Jul 2011 15:45:52 +0200
Message-ID: <20110707134552.GX16021@Chamillionaire.breakpoint.cc>
References: <1307657659-30266-1-git-send-email-fw@strlen.de>
 <4E1310EC.1030401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59882 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590Ab1GGNpx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:45:53 -0400
Content-Disposition: inline
In-Reply-To: <4E1310EC.1030401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 10.06.2011 00:14, Florian Westphal wrote:
> > Introduces a new nfnetlink type that applies a given
> > verdict to all queued packets with an id <= the id in the verdict
> > message.
> > 
> > If a mark is provided it is applied to all matched packets.
> > 
> > This reduces the number of verdicts that have to be sent.
> > Applications that make use of this feature need to maintain
> > a timeout to send a batchverdict periodically to avoid starvation.
> 
> Thanks Florian. Do you have any throughput numbers with this patch?

I re-ran some tests via lo, with Eric Dumazets
"netfilter: nfqueue: assert monotonic packet ids" patch applied on top of
a 2.6.39.2 kernel.

With "one accept per packet", the rest program needs
about two minutes to process 10000000 1024-Byte udp packets
sent via lo (queueing via
-t mangle -I INPUT -i lo -p udp -m udp --dport 6666 -j NFQUEUE --queue-num 0
; no other queueing rules active)

When sending batch accept verdicts for every tenth packet received,
run time was reduced to about 72 seconds.

I ran this several times and the results were similar.

Just to be sure I also tried with the Erics RCU patch applied but I
did not see any changes (not surprising because nfnl_mutex should
not cause contention in the "single queue" case).

If anyone else wants to do some tests or verify these results, i've
put the test program and a patch for libnetfilter_queue here:
http://strlen.de/nfqueue/

Some earlier tests (which i cannot reproduce at the moment because the
setup no longer exists) showed throughput increases from ~800 mbit
to about 1050 mbit, also using UDP frames (but via 10G Ethernet instead
of lo; this was with a 2.6.32.y based kernel).
