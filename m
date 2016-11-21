From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix inconsistent element
 expiration calculation
Date: Mon, 21 Nov 2016 09:48:40 +0800
Message-ID: <CAML_gOfNuXeeUeqNMET39pawDLGf5_vs3gy84J=2SxuS4gbp9Q@mail.gmail.com>
References: <1479659927.10079.3.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:33061 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbcKUBsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 20:48:41 -0500
Received: by mail-ua0-f196.google.com with SMTP id 20so23925334uak.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Nov 2016 17:48:41 -0800 (PST)
In-Reply-To: <1479659927.10079.3.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-11-21 0:38 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
> From: Anders K. Pedersen <akp@cohaesio.com>
>
> As Liping Zhang reports, after commit a8b1e36d0d1d ("netfilter: nft_dynset:
> fix element timeout for HZ != 1000"), priv->timeout was stored in jiffies,
> while set->timeout was stored in milliseconds. This is inconsistent and
> incorrect.
>
> Firstly, we already call msecs_to_jiffies in nft_set_elem_init, so
> priv->timeout will be converted to jiffies twice.
>
> Secondly, if the user did not specify the NFTA_DYNSET_TIMEOUT attr,
> set->timeout will be used, but we forget to call msecs_to_jiffies
> when do update elements.
>
> Fix this by using jiffies internally for traditional sets and doing the
> conversions to/from msec when interacting with userspace - as dynset
> already does.
>
> This is preferable to doing the conversions, when elements are inserted or
> updated, because this can happen very frequently on busy dynsets.
>
> Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
> Reported-by: Liping Zhang <zlpnobody@gmail.com>
> Signed-off-by: Anders K. Pedersen <akp@cohaesio.com>

Acked-by: Liping Zhang <zlpnobody@gmail.com>

But there's some small indent issues, see below.

> ---
>  include/net/netfilter/nf_tables.h |  2 +-
>  net/netfilter/nf_tables_api.c     | 14 +++++++++-----
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index d79d1e9..4be7dd7 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -313,7 +313,7 @@ void nft_unregister_set(struct nft_set_ops *ops);
>   *     @size: maximum set size
>   *     @nelems: number of elements
>   *     @ndeact: number of deactivated elements queued for removal
> - *     @timeout: default timeout value in msecs
> + *     @timeout: default timeout value in jiffies
>   *     @gc_int: garbage collection interval in msecs
>   *     @policy: set parameterization (see enum nft_set_policies)
>   *     @udlen: user data length
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 026581b..e5194f6f 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2570,7 +2570,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
>         }
>
>         if (set->timeout &&
> -           nla_put_be64(skb, NFTA_SET_TIMEOUT, cpu_to_be64(set->timeout),
> +           nla_put_be64(skb, NFTA_SET_TIMEOUT,
> +                        cpu_to_be64(jiffies_to_msecs(set->timeout)),
>                          NFTA_SET_PAD))
>                 goto nla_put_failure;
>         if (set->gc_int &&
> @@ -2859,7 +2860,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
>         if (nla[NFTA_SET_TIMEOUT] != NULL) {
>                 if (!(flags & NFT_SET_TIMEOUT))
>                         return -EINVAL;
> -               timeout = be64_to_cpu(nla_get_be64(nla[NFTA_SET_TIMEOUT]));
> +               timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
> +                                               nla[NFTA_SET_TIMEOUT])));

nla[NFTA_SET_TIMEOUT] should be kept indent consistent with be64_to_cpu.
You can add some spaces after tab.

>         }
>         gc_int = 0;
>         if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
> @@ -3178,7 +3180,8 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
>
>         if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
>             nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
> -                        cpu_to_be64(*nft_set_ext_timeout(ext)),
> +                        cpu_to_be64(jiffies_to_msecs(
> +                                               *nft_set_ext_timeout(ext))),
>                          NFTA_SET_ELEM_PAD))
>                 goto nla_put_failure;
>
> @@ -3447,7 +3450,7 @@ void *nft_set_elem_init(const struct nft_set *set,
>                 memcpy(nft_set_ext_data(ext), data, set->dlen);
>         if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION))
>                 *nft_set_ext_expiration(ext) =
> -                       jiffies + msecs_to_jiffies(timeout);
> +                       jiffies + timeout;
>         if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT))
>                 *nft_set_ext_timeout(ext) = timeout;
>
> @@ -3535,7 +3538,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>         if (nla[NFTA_SET_ELEM_TIMEOUT] != NULL) {
>                 if (!(set->flags & NFT_SET_TIMEOUT))
>                         return -EINVAL;
> -               timeout = be64_to_cpu(nla_get_be64(nla[NFTA_SET_ELEM_TIMEOUT]));
> +               timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
> +                                       nla[NFTA_SET_ELEM_TIMEOUT])));

Same remark here.

>         } else if (set->flags & NFT_SET_TIMEOUT) {
>                 timeout = set->timeout;
>         }
