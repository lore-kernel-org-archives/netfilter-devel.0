From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/3] netfilter: nft_dynset: fix panic if NFT_SET_HASH
 is not enabled
Date: Wed, 26 Oct 2016 21:14:36 +0800
Message-ID: <CAML_gOdOR2RPhd27RcV+6bAQ4s4L37ER-ZN8CLaYdm2P1B3djw@mail.gmail.com>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
 <1477133486-60686-2-git-send-email-zlpnobody@163.com> <CAML_gOeZgqToS0_V==or4drPPDg1FPYz3dT_+FXEmfdZp5W0Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33518 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932471AbcJZNOi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 09:14:38 -0400
Received: by mail-vk0-f67.google.com with SMTP id h7so192098vkf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Oct 2016 06:14:38 -0700 (PDT)
In-Reply-To: <CAML_gOeZgqToS0_V==or4drPPDg1FPYz3dT_+FXEmfdZp5W0Vw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-25 22:25 GMT+08:00 Liping Zhang <zlpnobody@gmail.com>:
> Maybe it's better to treat the NFT_SET_EVAL as features, I will send V2 latter:
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index b70d3ea..8a39b2a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2350,7 +2350,8 @@ nft_select_set_ops(const struct nlattr * const nla[],
>         features = 0;
>         if (nla[NFTA_SET_FLAGS] != NULL) {
>                 features = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
> -               features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT;
> +               features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT |
> +                           NFT_SET_EVAL;
>         }
>
>         bops       = NULL;
> diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
> index 3794cb2..328d23c 100644
> --- a/net/netfilter/nft_set_hash.c
> +++ b/net/netfilter/nft_set_hash.c
> @@ -382,7 +382,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
>         .lookup         = nft_hash_lookup,
>         .update         = nft_hash_update,
>         .walk           = nft_hash_walk,
> -       .features       = NFT_SET_MAP | NFT_SET_TIMEOUT,
> +       .features       = NFT_SET_MAP | NFT_SET_TIMEOUT | NFT_SET_EVAL,
>         .owner          = THIS_MODULE,
>  };

Sorry for this noise, the original patch should be fine. :(

After I have a careful look at the implementation of the dynset expr,
it's not appropriate to treat the NFT_SET_EVAL as the features.
The NFTA_DYNSET_EXPR attr is optional, and when it is not
specified, we will report -EINVAL if (set->flags & NFT_SET_EVAL)
is true:

static int nft_dynset_init()
{
    ...
    if (tb[NFTA_DYNSET_EXPR] != NULL) {
        if (!(set->flags & NFT_SET_EVAL))
            return -EINVAL;
        ...
    } else if (set->flags & NFT_SET_EVAL)
        return -EINVAL;

So for dynset, NFT_SET_EVAL is not a must option, but set->ops->update is.
