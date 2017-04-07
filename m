From: =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?=
        <laura.garcia@zevenet.com>
Subject: Re: [PATCH nf] netfilter: nft_hash: do not dump the auto generated seed
Date: Fri, 7 Apr 2017 23:19:55 +0200
Message-ID: <CAE=SJfBZmZD8YuEd0XzZ3ejuoVncfOGBOqh50fu1ENBWr7Qdww@mail.gmail.com>
References: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:32857 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933733AbdDGVT4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 17:19:56 -0400
Received: by mail-ua0-f173.google.com with SMTP id v24so2104447uav.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Apr 2017 14:19:56 -0700 (PDT)
In-Reply-To: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 3, 2017 at 10:34 AM, Liping Zhang <zlpnobody@163.com> wrote:
>
> From: Liping Zhang <zlpnobody@gmail.com>
>
> This can prevent the nft utility from printing out the auto generated
> seed to the user, which is unnecessary and confusing.
>
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  net/netfilter/nft_hash.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index eb2721a..c4dad12 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -21,6 +21,7 @@ struct nft_hash {
>         enum nft_registers      sreg:8;
>         enum nft_registers      dreg:8;
>         u8                      len;
> +       bool                    autogen_seed:1;

Hi Liping, I don't think that hiding the seed value would be useful, and
even adding this attribute doesn't worth it just to hide the seed.

>         u32                     modulus;
>         u32                     seed;
>         u32                     offset;
> @@ -82,10 +83,12 @@ static int nft_hash_init(const struct nft_ctx *ctx,
>         if (priv->offset + priv->modulus - 1 < priv->offset)
>                 return -EOVERFLOW;
>
> -       if (tb[NFTA_HASH_SEED])
> +       if (tb[NFTA_HASH_SEED]) {
>                 priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
> -       else
> +       } else {
> +               priv->autogen_seed = true;
>                 get_random_bytes(&priv->seed, sizeof(priv->seed));
> +       }
>
>         return nft_validate_register_load(priv->sreg, len) &&
>                nft_validate_register_store(ctx, priv->dreg, NULL,
> @@ -105,7 +108,8 @@ static int nft_hash_dump(struct sk_buff *skb,
>                 goto nla_put_failure;
>         if (nla_put_be32(skb, NFTA_HASH_MODULUS, htonl(priv->modulus)))
>                 goto nla_put_failure;
> -       if (nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
> +       if (!priv->autogen_seed &&
> +           nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
>                 goto nla_put_failure;
>         if (priv->offset != 0)
>                 if (nla_put_be32(skb, NFTA_HASH_OFFSET, htonl(priv->offset)))
> --
> 2.5.5
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
