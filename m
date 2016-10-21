From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v3 nf-next 2/5] netfilter: nft: basic routing expression
Date: Fri, 21 Oct 2016 10:17:09 +0800
Message-ID: <CAML_gOcy1NRpPbPf0tTsuMgnrM28x36rbRn1WO4dm3xCTo4pTA@mail.gmail.com>
References: <1476990430.1161.60.camel@cohaesio.com> <1476990576.1161.64.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36251 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcJUCRL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 22:17:11 -0400
Received: by mail-vk0-f66.google.com with SMTP id b186so4069462vkb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 19:17:10 -0700 (PDT)
In-Reply-To: <1476990576.1161.64.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-10-21 3:09 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:

> +int nft_rt_get_init(const struct nft_ctx *ctx,
> +                   const struct nft_expr *expr,
> +                   const struct nlattr * const tb[])
> +{
> +       struct nft_rt *priv = nft_expr_priv(expr);
> +       unsigned int len;
> +
> +       if (tb[NFTA_RT_KEY] == NULL ||
> +           tb[NFTA_RT_DREG] == NULL ||
> +           tb[NFTA_RT_FAMILY] == NULL)

The judgement here is also confusing to me, we do not use family
in NFT_RT_CLASSID key, so why we force the user that they
must specify the NFTA_RT_FAMILY attribute?

As I mentioned in another reply, I think the NFTA_RT_FAMILY attr
is redundant.

> +               return -EINVAL;
> +
> +       priv->key = ntohl(nla_get_be32(tb[NFTA_RT_KEY]));
> +       switch (priv->key) {
> +#ifdef CONFIG_IP_ROUTE_CLASSID
> +       case NFT_RT_CLASSID:
> +               len = sizeof(u32);
> +               break;
> +#endif
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +
> +       priv->family = ntohl(nla_get_be32(tb[NFTA_RT_FAMILY]));
> +       priv->dreg = nft_parse_register(tb[NFTA_RT_DREG]);
> +       return nft_validate_register_store(ctx, priv->dreg, NULL,
> +                                          NFT_DATA_VALUE, len);
> +}
