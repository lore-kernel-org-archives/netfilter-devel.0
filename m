From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nft] src: ct: add connection counting support
Date: Mon, 15 Jan 2018 11:59:47 +0100
Message-ID: <20180115105947.GC27085@breakpoint.cc>
References: <20180112134111.19132-1-fw@strlen.de>
 <20180115104639.6x55lm4tjrnz5nk6@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40476 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbeAOLCO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 06:02:14 -0500
Content-Disposition: inline
In-Reply-To: <20180115104639.6x55lm4tjrnz5nk6@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > NB: This uses {} to separate ct count statement from grouping to
> > avoid shift/reduce conflicts in the parser, unlike fib we do not
> > have distinct 'end marker' available.
> 
> If your concern is this {} curly braces, I think that should be fine
> from a semantic point of view.

Ok, good to know.

> From the kernel perspective, I wonder if it would be good to place
> this rbtree that allows us to count in a nftables set, so we can
> create maps that people can flush and that can also populate from
> userspace via API (me thinking of this usecase: userspace software,
> updating reputation ranks for IP addresses based on more heuristics,
> using this new set type, if that makes sense to you, of course).

I will need to think about this.  Basically the rbtree is a kludge
because we can't store it in the conntrack table and on-demand counting
of the conntrack table would be way too expensive.

> I understand this might be more work - I haven't seen your patch to
> add nf_conncount to nftables, but I suspect you already made a bit of
> progress - so this turn may trigger some rework.

The current patch is here:

https://git.breakpoint.cc/cgit/fw/nf-next.git/commit/?id=82c931a0f896abf654c961859b9dc5c485f0a033
