From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 6/6] netfilter: do not omit re-route check on NF_QUEUE
 verdict
Date: Tue, 18 Jan 2011 16:31:46 +0100
Message-ID: <20110118153146.GH7849@Chamillionaire.breakpoint.cc>
References: <1295183947-12786-1-git-send-email-fw@strlen.de>
 <1295183947-12786-7-git-send-email-fw@strlen.de>
 <4D35AE71.6010301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41227 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab1ARPbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:31:47 -0500
Content-Disposition: inline
In-Reply-To: <4D35AE71.6010301@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > However, NF_QUEUE no longer DROPs the skb unconditionally if queueing
> > fails (due to NF_VERDICT_FLAG_QUEUE_BYPASS verdict flag), so the
> > re-route test should also be performed if this flag is set in the
> > verdict.
> > 
> > The full test would then look something like
> > 
> > && ((ret & NF_VERDICT_MASK) == NF_QUEUE && (ret & NF_VERDICT_FLAG_QUEUE_BYPASS))
> > 
> > This is rather ugly, so just remove the NF_QUEUE test altogether.
> > 
> > The only effect is that we might perform an unnecessary route lookup
> > in the NF_QUEUE case.
> 
> Alternatively we could have nf_queue.c perform the rerouting when
> a packet is marked for queue bypass, just as it already does when
> reinjecting a packet. mangle just needs to check for NF_ACCEPT,
> since that is the only verdict we can return from the table that
> doesn't cause the packet to be dropped or queued.

Good point, thanks!

I'll look into it.
