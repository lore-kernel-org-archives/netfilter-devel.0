From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_tables: add hash expression
Date: Wed, 10 Aug 2016 09:21:53 +0200
Message-ID: <20160810072152.GA11256@sonyv>
References: <20160809182215.GA3721@sonyv>
 <CAML_gOfwxzPqVRtBjQFa5aAX1wDAXPMebjwpEspXqF_Lzyh5oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33602 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938918AbcHJTC0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:02:26 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so11370497wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:02:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAML_gOfwxzPqVRtBjQFa5aAX1wDAXPMebjwpEspXqF_Lzyh5oQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 10:38:08AM +0800, Liping Zhang wrote:
> Hi Laura,
> 
> 2016-08-10 2:22 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
> > This patch adds a new hash expression, this provides jhash support but
> > this can be extended to support for other hash functions.
> >
> > The modulus and seed already comes embedded into this new expression.
> >
> > Use case example:
> > meta mark set hash ip saddr mod 10
> >
> > +static int nft_hash_init(const struct nft_ctx *ctx,
> > +                        const struct nft_expr *expr,
> > +                        const struct nlattr * const tb[])
> > +{
> > +       struct nft_hash *priv = nft_expr_priv(expr);
> > +       u32 len;
> > +
> > +       if (!tb[NFTA_HASH_SREG] ||
> > +           !tb[NFTA_HASH_DREG] ||
> > +           !tb[NFTA_HASH_LEN])
> > +               return -EINVAL;
> 
> I think tb[NFTA_HASH_MODULUS] and tb[NFTA_HASH_SEED] should also be
> checked is NULL or not? :)
> 

tb[NFTA_HASH_MODULUS] is not optional now so we can check it here, but
tb[NFTA_HASH_SEED] is optional so we can check and if it's null, then
assign 0 to the seed value.

> > +
> > +       priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> > +       priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
> 
> Should we use nft_validate_register_load and
> nft_validate_register_store here to check the validity ?
> 

Yes, I'll include that.

Thank you Liping.
