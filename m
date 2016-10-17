From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [PATCH nf-next 2/5] netfilter: nft: basic routing expression
Date: Mon, 17 Oct 2016 09:41:04 +0200
Message-ID: <CAOkSjBjevzzsf9abD=uHcdzg98X3adRB4LzHef1-QMTYa_NKrg@mail.gmail.com>
References: <1476625229.1038.3.camel@cohaesio.com> <1476625378.1038.6.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36311 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757558AbcJQHl0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 03:41:26 -0400
Received: by mail-lf0-f68.google.com with SMTP id b75so25029107lfg.3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 00:41:25 -0700 (PDT)
Received: from mail-lf0-f50.google.com (mail-lf0-f50.google.com. [209.85.215.50])
        by smtp.gmail.com with ESMTPSA id h88sm7234562lfi.6.2016.10.17.00.41.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2016 00:41:24 -0700 (PDT)
Received: by mail-lf0-f50.google.com with SMTP id b75so274265151lfg.3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 00:41:24 -0700 (PDT)
In-Reply-To: <1476625378.1038.6.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 October 2016 at 15:42, Anders K. Pedersen | Cohaesio
<akp@cohaesio.com> wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
>
> Introduce basic infrastructure for nftables rt expression for routing
> related data. Initially "rt classid" is implemented identical to "meta
> rtclassid", since it is more logical to have this match in the routing
> expression going forward.
>
> Signed-off-by: Anders K. Pedersen <akp@cohaesio.com>
> ---
>  include/net/netfilter/nft_rt.h           |  23 +++++
>  net/netfilter/Kconfig                    |   6 ++
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_rt.c                   | 145 ++++++++++++++++++++++++++++++
>  4 files changed, 175 insertions(+)
>
> diff --git a/include/net/netfilter/nft_rt.h b/include/net/netfilter/nft_rt.h
> --- /dev/null
> +++ b/include/net/netfilter/nft_rt.h
> @@ -0,0 +1,23 @@
> +#ifndef _NFT_RT_H_
> +#define _NFT_RT_H_
> +
> +struct nft_rt {
> +       enum nft_rt_keys        key:8;
> +       enum nft_registers      dreg:8;
> +       u8                      family;
> +};
> +
> +extern const struct nla_policy nft_rt_policy[];
> +
> +int nft_rt_get_init(const struct nft_ctx *ctx,
> +                   const struct nft_expr *expr,
> +                   const struct nlattr * const tb[]);
> +
> +int nft_rt_get_dump(struct sk_buff *skb,
> +                   const struct nft_expr *expr);
> +
> +void nft_rt_get_eval(const struct nft_expr *expr,
> +                    struct nft_regs *regs,
> +                    const struct nft_pktinfo *pkt);
> +
> +#endif
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -474,6 +474,12 @@ config NFT_META
>           This option adds the "meta" expression that you can use to match and
>           to set packet metainformation such as the packet mark.
>
> +config NFT_RT
> +       tristate "Netfilter nf_tables routing module"
> +       help
> +         This option adds the "rt" expression that you can use to match
> +         packet routing information such as the packet nexthop.
> +
>  config NFT_NUMGEN
>         tristate "Netfilter nf_tables number generator module"
>         help
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -81,6 +81,7 @@ obj-$(CONFIG_NF_TABLES_NETDEV)        += nf_tables_netdev.o
>  obj-$(CONFIG_NFT_COMPAT)       += nft_compat.o
>  obj-$(CONFIG_NFT_EXTHDR)       += nft_exthdr.o
>  obj-$(CONFIG_NFT_META)         += nft_meta.o
> +obj-$(CONFIG_NFT_RT)           += nft_rt.o
>  obj-$(CONFIG_NFT_NUMGEN)       += nft_numgen.o
>  obj-$(CONFIG_NFT_CT)           += nft_ct.o
>  obj-$(CONFIG_NFT_LIMIT)                += nft_limit.o
> diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
> --- /dev/null
> +++ b/net/netfilter/nft_rt.c
> @@ -0,0 +1,145 @@
> +/*
> + * Copyright (c) 2016 Anders K. Pedersen <akp@cohaesio.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/dst.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +#include <net/netfilter/nft_rt.h>
> +
> +void nft_rt_get_eval(const struct nft_expr *expr,
> +                    struct nft_regs *regs,
> +                    const struct nft_pktinfo *pkt)
> +{
> +       const struct nft_rt *priv = nft_expr_priv(expr);
> +       const struct sk_buff *skb = pkt->skb;
> +       u32 *dest = &regs->data[priv->dreg];
> +
> +       switch (priv->key) {
> +#ifdef CONFIG_IP_ROUTE_CLASSID
> +       case NFT_RT_CLASSID: {
> +               const struct dst_entry *dst = skb_dst(skb);
> +
> +               if (dst == NULL)
> +                       goto err;
> +               *dest = dst->tclassid;
> +               break;
> +       }
> +#endif
> +       default:
> +               WARN_ON(1);
> +               goto err;
> +       }
> +       return;
> +
> +err:
> +       regs->verdict.code = NFT_BREAK;
> +}
> +EXPORT_SYMBOL_GPL(nft_rt_get_eval);
> +
> +const struct nla_policy nft_rt_policy[NFTA_RT_MAX + 1] = {
> +       [NFTA_RT_DREG]          = { .type = NLA_U32 },
> +       [NFTA_RT_KEY]           = { .type = NLA_U32 },
> +       [NFTA_RT_FAMILY]        = { .type = NLA_U32 },
> +};
> +EXPORT_SYMBOL_GPL(nft_rt_policy);
> +
> +int nft_rt_get_init(const struct nft_ctx *ctx,
> +                   const struct nft_expr *expr,
> +                   const struct nlattr * const tb[])
> +{
> +       struct nft_rt *priv = nft_expr_priv(expr);
> +       unsigned int len;
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
> +EXPORT_SYMBOL_GPL(nft_rt_get_init);
> +
> +int nft_rt_get_dump(struct sk_buff *skb,
> +                   const struct nft_expr *expr)
> +{
> +       const struct nft_rt *priv = nft_expr_priv(expr);
> +
> +       if (nla_put_be32(skb, NFTA_RT_KEY, htonl(priv->key)))
> +               goto nla_put_failure;
> +       if (nft_dump_register(skb, NFTA_RT_DREG, priv->dreg))
> +               goto nla_put_failure;
> +       if (nla_put_be32(skb, NFTA_RT_FAMILY, htonl(priv->family)))
> +               goto nla_put_failure;
> +       return 0;
> +
> +nla_put_failure:
> +       return -1;
> +}
> +EXPORT_SYMBOL_GPL(nft_rt_get_dump);
> +
> +static struct nft_expr_type nft_rt_type;
> +static const struct nft_expr_ops nft_rt_get_ops = {
> +       .type           = &nft_rt_type,
> +       .size           = NFT_EXPR_SIZE(sizeof(struct nft_rt)),
> +       .eval           = nft_rt_get_eval,
> +       .init           = nft_rt_get_init,
> +       .dump           = nft_rt_get_dump,
> +};
> +
> +static const struct nft_expr_ops *
> +nft_rt_select_ops(const struct nft_ctx *ctx,
> +                 const struct nlattr * const tb[])
> +{
> +       if (tb[NFTA_RT_KEY] == NULL)
> +               return ERR_PTR(-EINVAL);
> +
> +       if (tb[NFTA_RT_DREG])
> +               return &nft_rt_get_ops;
> +
> +       return ERR_PTR(-EINVAL);
> +}

I don't understand why you use select_ops.

Do you plan to extend this expr behaviour in the near future?
