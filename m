From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 4/4] netfilter: rt: add support to fetch path mss
Date: Tue, 8 Aug 2017 15:47:39 +0200
Message-ID: <20170808134739.GB5151@breakpoint.cc>
References: <20170808131530.29194-1-fw@strlen.de>
 <20170808131530.29194-5-fw@strlen.de>
 <1502199450.4487.15.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34716 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752070AbdHHNts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 09:49:48 -0400
Content-Disposition: inline
In-Reply-To: <1502199450.4487.15.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Tue, 2017-08-08 at 15:15 +0200, Florian Westphal wrote:
> > +	struct dst_entry *dst;
> > +	struct flowi fl;

[..]

> > +	ai = nf_get_afinfo(nft_pf(pkt));
> > +	if (ai)
> > +		ai->route(nft_net(pkt), &dst, &fl, false);
> > +
> 
> if ai is NULL,
> 
> dst is not initialized and might contain garbage.

Right, thanks for pointing this out, I sent a v2.
