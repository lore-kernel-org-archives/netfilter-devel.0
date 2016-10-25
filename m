From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/3] netfilter: nft_dynset: fix panic if NFT_SET_HASH
 is not enabled
Date: Tue, 25 Oct 2016 22:25:41 +0800
Message-ID: <CAML_gOeZgqToS0_V==or4drPPDg1FPYz3dT_+FXEmfdZp5W0Vw@mail.gmail.com>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com> <1477133486-60686-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:34164 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753338AbcJYOZm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2016 10:25:42 -0400
Received: by mail-ua0-f194.google.com with SMTP id 6so2327162uat.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2016 07:25:42 -0700 (PDT)
In-Reply-To: <1477133486-60686-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-22 18:51 GMT+08:00 Liping Zhang <zlpnobody@163.com>:
> From: Liping Zhang <zlpnobody@gmail.com>
>
> When CONFIG_NFT_SET_HASH is not enabled and I input the following rule:
> "nft add rule filter output flow table test {ip daddr counter }", kernel
> panic happened on my system:
>  BUG: unable to handle kernel NULL pointer dereference at (null)
> ---
>  net/netfilter/nft_dynset.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> index e3b83c3..6a631cb 100644
> --- a/net/netfilter/nft_dynset.c
> +++ b/net/netfilter/nft_dynset.c
> @@ -139,6 +139,9 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
>                         return PTR_ERR(set);
>         }
>
> +       if (set->ops->update == NULL)
> +               return -EOPNOTSUPP;
> +

Maybe it's better to treat the NFT_SET_EVAL as features, I will send V2 latter:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b70d3ea..8a39b2a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2350,7 +2350,8 @@ nft_select_set_ops(const struct nlattr * const nla[],
        features = 0;
        if (nla[NFTA_SET_FLAGS] != NULL) {
                features = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
-               features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT;
+               features &= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_TIMEOUT |
+                           NFT_SET_EVAL;
        }

        bops       = NULL;
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 3794cb2..328d23c 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -382,7 +382,7 @@ static struct nft_set_ops nft_hash_ops __read_mostly = {
        .lookup         = nft_hash_lookup,
        .update         = nft_hash_update,
        .walk           = nft_hash_walk,
-       .features       = NFT_SET_MAP | NFT_SET_TIMEOUT,
+       .features       = NFT_SET_MAP | NFT_SET_TIMEOUT | NFT_SET_EVAL,
        .owner          = THIS_MODULE,
 };
