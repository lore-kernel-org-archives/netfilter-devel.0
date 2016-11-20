From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_dynset: fix incorrect element
 expiration calculation
Date: Sun, 20 Nov 2016 18:31:58 +0800
Message-ID: <CAML_gOfY9zPM+hr1eN05CoEerOcvjmcnSVOr8apxwHr_ZDzB6g@mail.gmail.com>
References: <1479622687-17266-1-git-send-email-zlpnobody@163.com> <1479634719.25188.1.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
        "zlpnobody@163.com" <zlpnobody@163.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34223 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbcKTKcA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 05:32:00 -0500
Received: by mail-vk0-f65.google.com with SMTP id p9so21648213vkd.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Nov 2016 02:31:59 -0800 (PST)
In-Reply-To: <1479634719.25188.1.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-11-20 17:38 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
[...]
> I believe that updating elements in dynsets can happen much more
> frequently than interactions with userspace. One of my own use cases is

Make sense. Considering the performance cost, your patch looks better:)

> traffic accounting via flow tables, where there will be many updates
> per second. So I would much prefer to do the conversion between msec
> and jiffies, when data are sent to or received from userspace.
>
> Would the patch below be okay?
>
> Regards,
> Anders K. Pedersen
> ---
>  net/netfilter/nf_tables_api.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
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
>         } else if (set->flags & NFT_SET_TIMEOUT) {
>                 timeout = set->timeout;
>         }
