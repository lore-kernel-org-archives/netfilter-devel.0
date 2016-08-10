From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_tables: add hash expression
Date: Wed, 10 Aug 2016 10:38:08 +0800
Message-ID: <CAML_gOfwxzPqVRtBjQFa5aAX1wDAXPMebjwpEspXqF_Lzyh5oQ@mail.gmail.com>
References: <20160809182215.GA3721@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36053 "EHLO
	mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbcHJCxO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 22:53:14 -0400
Received: by mail-ua0-f193.google.com with SMTP id 74so2543028uau.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2016 19:53:13 -0700 (PDT)
In-Reply-To: <20160809182215.GA3721@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laura,

2016-08-10 2:22 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
> This patch adds a new hash expression, this provides jhash support but
> this can be extended to support for other hash functions.
>
> The modulus and seed already comes embedded into this new expression.
>
> Use case example:
> meta mark set hash ip saddr mod 10
>
> +static int nft_hash_init(const struct nft_ctx *ctx,
> +                        const struct nft_expr *expr,
> +                        const struct nlattr * const tb[])
> +{
> +       struct nft_hash *priv = nft_expr_priv(expr);
> +       u32 len;
> +
> +       if (!tb[NFTA_HASH_SREG] ||
> +           !tb[NFTA_HASH_DREG] ||
> +           !tb[NFTA_HASH_LEN])
> +               return -EINVAL;

I think tb[NFTA_HASH_MODULUS] and tb[NFTA_HASH_SEED] should also be
checked is NULL or not? :)

> +
> +       priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
> +       priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);

Should we use nft_validate_register_load and
nft_validate_register_store here to check the validity ?

> +
> +       len = ntohl(nla_get_be32(tb[NFTA_HASH_LEN]));
> +       if (len == 0 || len > U8_MAX)
> +               return -EINVAL;
