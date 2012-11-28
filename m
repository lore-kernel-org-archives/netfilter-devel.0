From: Florian Westphal <fw@strlen.de>
Subject: Re: lnf_conntrack: nfct_cmp NFCT_CMP_TIMEOUT_* flags not supported?
Date: Wed, 28 Nov 2012 16:33:51 +0100
Message-ID: <20121128153351.GG14156@breakpoint.cc>
References: <20121128125930.GF14156@breakpoint.cc>
 <20121128151606.GA13155@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54241 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189Ab2K1Pdw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:33:52 -0500
Content-Disposition: inline
In-Reply-To: <20121128151606.GA13155@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > So, my question is:
> > How are the NFCT_CMP_TIMEOUT flags supposed to be used?
> 
> They planned to be used by the conntrack utility. To obtain timers
> that are over/under some given timeout. But that was never
> implemented, so that code has remain untested there so far until
> someone has come to show some interest on it ;-).

Alright, I'll hold off with this change, then.
Problem is that this change:

> > diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
> > index b18f7fc..7cd28e7 100644
> > --- a/src/conntrack/compare.c
> > +++ b/src/conntrack/compare.c
> > @@ -407,5 +407,8 @@ int __compare(const struct nf_conntrack *ct1,
> >         if (flags & NFCT_CMP_REPL && !cmp_repl(ct1, ct2, flags))
> >                 return 0;
> >  
> > +       if (flags & (NFCT_CMP_TIMEOUT_GT|NFCT_CMP_TIMEOUT_LE))
> > +               return cmp_meta(ct1, ct2, flags);
> > +
> >         return 1;
> >  }

... is wrong after all.
IMO e.g. NFCT_CMP_TIMEOUT_EQ means that the comparision is valid
when the timeout is equal.  But above code means that its
valid when the timeout is equal AND all the other meta flags are
equal, too.  And thats very un-intuitive.

Regards,
Florian
