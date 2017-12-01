From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: meta: secpath support
Date: Fri, 1 Dec 2017 13:53:16 +0100
Message-ID: <CAOkSjBjtc2EUCK5e-50uy6dvwPjhFdc91PyAe1_=cvDMRwMj9A@mail.gmail.com>
References: <20171201124021.20973-1-fw@strlen.de> <20171201124021.20973-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34293 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbdLAMxj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 07:53:39 -0500
Received: by mail-wm0-f67.google.com with SMTP id y82so5481836wmg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Dec 2017 04:53:38 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com. [74.125.82.53])
        by smtp.gmail.com with ESMTPSA id h16sm4755865edj.34.2017.12.01.04.53.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Dec 2017 04:53:37 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id y82so5481807wmg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Dec 2017 04:53:37 -0800 (PST)
In-Reply-To: <20171201124021.20973-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 December 2017 at 13:40, Florian Westphal <fw@strlen.de> wrote:
> replacement for iptables "-m policy --dir in --policy {ipsec,none}".
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 39 ++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
>
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index a3ee277b17a1..2efbf9744c2a 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -777,6 +777,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_OIFGROUP: packet output interface group
>   * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
>   * @NFT_META_PRANDOM: a 32bit pseudo-random number
> + * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>   */
>  enum nft_meta_keys {
>         NFT_META_LEN,
> @@ -804,6 +805,7 @@ enum nft_meta_keys {
>         NFT_META_OIFGROUP,
>         NFT_META_CGROUP,
>         NFT_META_PRANDOM,
> +       NFT_META_SECPATH,
>  };
>
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 5a60eb23a7ed..63a013ad4077 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -210,6 +210,11 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>                 *dest = prandom_u32_state(state);
>                 break;
>         }
> +#ifdef CONFIG_XFRM
> +       case NFT_META_SECPATH:
> +               nft_reg_store8(dest, !!skb->sp);
> +               break;
> +#endif
>         default:
>                 WARN_ON(1);
>                 goto err;
> @@ -308,6 +313,11 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>                 prandom_init_once(&nft_prandom_state);
>                 len = sizeof(u32);
>                 break;
> +#ifdef CONFIG_XFRM
> +       case NFT_META_SECPATH:
> +               len = sizeof(u8);
> +               break;
> +#endif
>         default:
>                 return -EOPNOTSUPP;
>         }
> @@ -318,6 +328,34 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>  }
>  EXPORT_SYMBOL_GPL(nft_meta_get_init);
>
> +int nft_meta_get_validate(const struct nft_ctx *ctx,
> +                         const struct nft_expr *expr,
> +                         const struct nft_data **data)
> +{
> +       const struct nft_meta *priv = nft_expr_priv(expr);
> +       unsigned int hooks;
> +
> +       if (priv->key != NFT_META_SECPATH)
> +               return 0;
> +

Would it worth adding here something like this?

#ifnfdef CONFIG_XFRM
            return -EOPNOTSUPP;
#endif

I mean, if CONFIG_XFRM is not defined, then _get_eval() is doing nothing, right?

> +       switch (ctx->afi->family) {
> +       case NFPROTO_NETDEV:
> +               hooks = 1 << NF_NETDEV_INGRESS;
> +               break;
> +       case NFPROTO_IPV4:
> +       case NFPROTO_IPV6:
> +       case NFPROTO_INET:
> +               hooks = (1 << NF_INET_PRE_ROUTING) |
> +                       (1 << NF_INET_LOCAL_IN) |
> +                       (1 << NF_INET_FORWARD);
> +               break;
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return nft_chain_validate_hooks(ctx->chain, hooks);
> +}
