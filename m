From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] set_expr: Allow passing the parent set to
 set_expr_alloc()
Date: Wed, 12 Jul 2017 14:03:15 +0200
Message-ID: <20170712120315.GR16375@orbyte.nwl.cc>
References: <20170711215952.11056-1-phil@nwl.cc>
 <CAOkSjBi0c2RJMtSw1KADjEkH-djevs=ZYVHkfzCfKJyej-SDTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53073 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756241AbdGLMDR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:03:17 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBi0c2RJMtSw1KADjEkH-djevs=ZYVHkfzCfKJyej-SDTQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 08:43:10AM +0200, Arturo Borrero Gonzalez wrote:
> On 11 July 2017 at 23:59, Phil Sutter <phil@nwl.cc> wrote:
> > diff --git a/src/expression.c b/src/expression.c
> > index f90ca6035bd3a..f51fbae281b95 100644
> > --- a/src/expression.c
> > +++ b/src/expression.c
> > @@ -824,9 +824,16 @@ static const struct expr_ops set_expr_ops = {
> >         .destroy        = compound_expr_destroy,
> >  };
> >
> > -struct expr *set_expr_alloc(const struct location *loc)
> > +struct expr *set_expr_alloc(const struct location *loc, const struct set *set)
> >  {
> > -       return compound_expr_alloc(loc, &set_expr_ops);
> > +       struct expr *set_expr = compound_expr_alloc(loc, &set_expr_ops);
> > +
> > +       if (set) {
> > +               set_expr->set_flags = set->flags;
> > +               set_expr->dtype = set->keytype;
> > +       }
> > +
> > +       return set_expr;
> >  }
> 
> What about:
> 
> if (!set)
>      return set_expr;
> 
> set_expr->set_flags = set->flags;
> [..]
> return set_expr;

Yes, why not. I did it the other way around to point out that the extra
parameter is purely optional. But OTOH, kill all the indenting! ;)

> > diff --git a/src/segtree.c b/src/segtree.c
> > index a2316a7b98041..f53536210018d 100644
> > --- a/src/segtree.c
> > +++ b/src/segtree.c
> > @@ -602,10 +602,12 @@ static int expr_value_cmp(const void *p1, const void *p2)
> >         int ret;
> >
> >         ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
> > -       if (ret == 0 && (e1->flags & EXPR_F_INTERVAL_END))
> > -               return -1;
> > -       else
> > -               return 1;
> > +       if (ret == 0) {
> > +               if (e1->flags & EXPR_F_INTERVAL_END)
> > +                       return -1;
> > +               else if (e2->flags & EXPR_F_INTERVAL_END)
> > +                       return 1;
> > +       }
> >
> >         return ret;
> >  }
> > --
> 
> ^^^
> this last chunk belongs to another patch?

Oh crap, no idea how I managed to combine these commits while rebasing.
Thanks for the review, I'll follow-up with a v2.

Cheers, Phil
