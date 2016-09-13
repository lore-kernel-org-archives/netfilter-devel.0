From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_hash: Add hash offset value
Date: Tue, 13 Sep 2016 09:59:32 +0200
Message-ID: <20160913075931.GA4977@sonyv>
References: <20160906064416.GA32396@sonyv>
 <CAML_gOefwHzNg=PNEPKTpUMxjLZkJQcnQkKchL3Np3vNpA_Ehw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33339 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755235AbcIMH7g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 03:59:36 -0400
Received: by mail-wm0-f65.google.com with SMTP id b187so17024808wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 00:59:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAML_gOefwHzNg=PNEPKTpUMxjLZkJQcnQkKchL3Np3vNpA_Ehw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 02:25:03PM +0800, Liping Zhang wrote:
> Hi Laura,
> 
> 2016-09-06 14:44 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
> >  static int nft_hash_init(const struct nft_ctx *ctx,
> > @@ -60,6 +62,11 @@ static int nft_hash_init(const struct nft_ctx *ctx,
> >             !tb[NFTA_HASH_MODULUS])
> >                 return -EINVAL;
> >
> > +       if (tb[NFTA_HASH_SUM])
> > +               priv->sum = ntohl(nla_get_be32(tb[NFTA_HASH_SUM]));
> > +       else
> > +               priv->sum = 0;
> > +
> >         priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> >         if (priv->sreg < 0)
> >                 return -ERANGE;
> > @@ -77,6 +84,9 @@ static int nft_hash_init(const struct nft_ctx *ctx,
> >         if (priv->modulus <= 1)
> >                 return -ERANGE;
> >
> > +       if (priv->sum + priv->modulus - 1 < U32_MAX)
> > +               return -EOVERFLOW;
> 
> I think this judgement here is wrong, it is likely to be true...
> 
> When two integer a and b do addition operation, and the calculation
> results satisfy the
> following conditions: (a + b < a) or (a + b < b), then we can assure
> that integer overflow
> happened.
> 
> So the judgement should be converted to:
>      if (priv->sum + priv->modulus - 1 < priv->sum)
> 

Absolutely true, i'll send a patch to fix that.

Thank you!

> > +
> >         priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
> >
> >         return nft_validate_register_load(priv->sreg, priv->len) &&
