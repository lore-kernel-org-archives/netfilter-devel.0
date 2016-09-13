From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_hash: Add hash offset value
Date: Tue, 13 Sep 2016 14:25:03 +0800
Message-ID: <CAML_gOefwHzNg=PNEPKTpUMxjLZkJQcnQkKchL3Np3vNpA_Ehw@mail.gmail.com>
References: <20160906064416.GA32396@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:36171 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbcIMGZF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 02:25:05 -0400
Received: by mail-ua0-f196.google.com with SMTP id b7so308815uab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 23:25:04 -0700 (PDT)
In-Reply-To: <20160906064416.GA32396@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laura,

2016-09-06 14:44 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
>  static int nft_hash_init(const struct nft_ctx *ctx,
> @@ -60,6 +62,11 @@ static int nft_hash_init(const struct nft_ctx *ctx,
>             !tb[NFTA_HASH_MODULUS])
>                 return -EINVAL;
>
> +       if (tb[NFTA_HASH_SUM])
> +               priv->sum = ntohl(nla_get_be32(tb[NFTA_HASH_SUM]));
> +       else
> +               priv->sum = 0;
> +
>         priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
>         if (priv->sreg < 0)
>                 return -ERANGE;
> @@ -77,6 +84,9 @@ static int nft_hash_init(const struct nft_ctx *ctx,
>         if (priv->modulus <= 1)
>                 return -ERANGE;
>
> +       if (priv->sum + priv->modulus - 1 < U32_MAX)
> +               return -EOVERFLOW;

I think this judgement here is wrong, it is likely to be true...

When two integer a and b do addition operation, and the calculation
results satisfy the
following conditions: (a + b < a) or (a + b < b), then we can assure
that integer overflow
happened.

So the judgement should be converted to:
     if (priv->sum + priv->modulus - 1 < priv->sum)

> +
>         priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
>
>         return nft_validate_register_load(priv->sreg, priv->len) &&
