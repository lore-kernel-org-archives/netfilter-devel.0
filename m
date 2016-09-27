From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: xt_nfacct: Use not operation instead
 of condition check
Date: Tue, 27 Sep 2016 02:39:24 +0200
Message-ID: <20160927003924.GC17426@breakpoint.cc>
References: <1474899184-30187-1-git-send-email-fgao@ikuai8.com>
 <20160926151756.GA17426@breakpoint.cc>
 <CA+6hz4qxwzV7YME8Nzo-uTJH9n7jz8cO8GWd4P-5GV90Httyqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Gao Feng <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50780 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755001AbcI0Ajb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Sep 2016 20:39:31 -0400
Content-Disposition: inline
In-Reply-To: <CA+6hz4qxwzV7YME8Nzo-uTJH9n7jz8cO8GWd4P-5GV90Httyqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gao Feng <fgao@ikuai8.com> wrote:
> >> diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
> >> index cf32759..7abb5b5 100644
> >> --- a/net/netfilter/xt_nfacct.c
> >> +++ b/net/netfilter/xt_nfacct.c
> >> @@ -28,7 +28,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >>
> >>       overquota = nfnl_acct_overquota(par->net, skb, info->nfacct);
> >>
> >> -     return overquota == NFACCT_UNDERQUOTA ? false : true;
> >> +     return !(overquota == NFACCT_UNDERQUOTA);
> >
> > I don't find one better than the other.  If you need to change
> > it for some reason consider
> >
> > "return overquota != NFACCT_UNDERQUOTA"
> >
> > instead of this strange negation.
> 
> Thanks, it is more simple use "!=".
> >
> > But really, I think its fine as-is.
> 
> It could decrease one condition check and jump.

gcc should emit same instructions for all these variants.
