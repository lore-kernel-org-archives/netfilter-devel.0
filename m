From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nft] src: ct: add connection counting support
Date: Mon, 15 Jan 2018 12:08:33 +0100
Message-ID: <20180115110833.upp7legzjiirc5ww@salvia>
References: <20180112134111.19132-1-fw@strlen.de>
 <20180115104639.6x55lm4tjrnz5nk6@salvia>
 <20180115105947.GC27085@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750852AbeAOLRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 06:17:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A8313EBAB3
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 12:16:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 897FCA8240
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 12:16:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180115105947.GC27085@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 15, 2018 at 11:59:47AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > NB: This uses {} to separate ct count statement from grouping to
> > > avoid shift/reduce conflicts in the parser, unlike fib we do not
> > > have distinct 'end marker' available.
> > 
> > If your concern is this {} curly braces, I think that should be fine
> > from a semantic point of view.
> 
> Ok, good to know.
> 
> > From the kernel perspective, I wonder if it would be good to place
> > this rbtree that allows us to count in a nftables set, so we can
> > create maps that people can flush and that can also populate from
> > userspace via API (me thinking of this usecase: userspace software,
> > updating reputation ranks for IP addresses based on more heuristics,
> > using this new set type, if that makes sense to you, of course).
> 
> I will need to think about this.

This is more than what iptables is doing, of course. But now that
we're on this, we have a chance to re-think if it makes sense to
leverage this infrastructure in nftables.

> Basically the rbtree is a kludge because we can't store it in the
> conntrack table and on-demand counting of the conntrack table would
> be way too expensive.

I see, actually we could even place this in a hashtable instead,
right? Not asking you to do this, just thinking aloud here.

> > I understand this might be more work - I haven't seen your patch to
> > add nf_conncount to nftables, but I suspect you already made a bit of
> > progress - so this turn may trigger some rework.
> 
> The current patch is here:
> 
> https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?id=82c931a0f896abf654c961859b9dc5c485f0a033

That's very much done work already, sorry I didn't rise this any
sooner.
