From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Mon, 12 Sep 2016 14:21:07 +0200
Message-ID: <20160912122107.GB27566@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55976 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756103AbcILMVJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 08:21:09 -0400
Content-Disposition: inline
In-Reply-To: <20160912120437.GA9323@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Sep 10, 2016 at 10:01:02PM +0200, Florian Westphal wrote:
> > Hi.
> > 
> > Linux has a builtin rp filter for ipv4, but not for ipv6.
> > xtables has rpfilter match for both ipv4 and ipv6.
> > nftables currently does not have such a feature.
> > 
> > Any idea on how specific or generic this should be for nft?
> > 
> > Current idea is to add 'fib' expression that initially supports
> > lookup of outinterface index for reply direction, i.e.:
> > 
> > nft ... fib reply oif ne 0 accept (found something)
> 
> Probably use 'fib lookup' instead of 'fib reply'?

I was thinking that we might want to support lookup in original
direction as well at some point, so 'fib original oif' would do
a route lookup for daddr (fib reply/rpf uses saddr).

> > nft ... fib reply oif eq 0 drop   (no route)
> 
> We need something similar for nft_exthdr in other to check for
> presence of the extension header (ie. no need to access any extension
> header field, just say it's there or not). So from the linearize path,
> we can set on a NFT_EXTHDR_F_PRESENT to indicate that we only care for
> its presence.
> 
> We would end up having a expression that returns a boolean or a value,
> so the datatype needs to be attached in runtime.

That doesn't seem too bad since kernel doesn't have to care
beyond making sure that the dreg is writeable (i.e., we don't need
a lot of extra code in kernel to make this work).

> Regarding syntax, it would be good to explore something like:
> 
>         nft ... fib lookup oif found accept
>         nft ... fib lookup oif not found drop

I dislike this, this seems to add expression specific negation
which i think is a big no-no.

> And introduce a boolean datatype, only problem with this is that we'll
> have an expression that returns boolean...

Ah, wait, you mean the found/not found is syntax sugar for
'oif != 0' and 'oif == 0'... ok, will think about this.

> > Problem is that we might need some options to influence/control
> > input to the fib lookup routines, e.g. if we want to consider
> > skb->mark or if we're only interested in routes via particular interface
> > (ipv6 needs this, this is what the --loose option does for -m rpfilter
> > in iptables).
> > 
> > Unfortunately, use of 'mark' results in grammar ambiguity in the parser.
> 
> What syntax would be causing the ambiguity? I guess this is related to
> meta unqualified.

Yes, it goes away when I remove MARK from meta_unqialified list.

> > What would work is this:
> > 
> > fib_expr                :       FIB     STRING  fib_args fib_type
> >                         {
> >                                 $$ = fib_expr_alloc(&@$, $4, get_dir($2));
> >                         }
> >                         ;
> > 
> > fib_type                :       OIF     { $$ = NFT_FIB_OIF; }
> >                         ;
> > 
> > fib_args                :       fib_arg
> >                         {
> >                                 $<expr>$        = $<expr>0;
> >                         }
> >                         |       fib_args        fib_arg
> >                         ;
> > 
> > fib_arg                 :       MARK
> >                         {
> >                                 $<expr>0->fib.use_mark = 1;
> >                         }
> >                         |       LOOSE
> >                         {
> >                                 $<expr>0->fib.loose = 1;
> >                         }
> >                         ;
> > 
> > 
> > Which results in following syntax:
> > 
> > nft .. fib reply mark loose oif eq 0 drop   # no route at all
> > nft .. fib reply mark oif eq 0 drop   # no route via iif
> > nft .. fib reply oif eq 0 drop   # no route via iif, do not use skb->mark
> > 
> > Other features that might make sense to implement for fib:
> > - query mtu on the route  (maybe useful with future tcp option mangling
> > to create TCPMSS target equvalent...?)
> > 
> > - query what fib says about type of saddr/daddr (iptables -m addrtype match)
> 
> Having addrtype into this generic expression looks very interesting.

Good, I will think about this some more so this can be added later
without syntax changes.

