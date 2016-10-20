From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Thu, 20 Oct 2016 17:13:34 +0800
Message-ID: <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34003 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758376AbcJTJNh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 05:13:37 -0400
Received: by mail-vk0-f65.google.com with SMTP id 2so2545435vkb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 02:13:36 -0700 (PDT)
In-Reply-To: <1476902504.1161.24.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,
2016-10-20 2:41 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:

> +static void nft_rt_inet_get_eval(const struct nft_expr *expr,
> +                                struct nft_regs *regs,
> +                                const struct nft_pktinfo *pkt)
> +{
> +       const struct nft_rt *priv = nft_expr_priv(expr);
> +       const struct sk_buff *skb = pkt->skb;
> +       u32 *dest = &regs->data[priv->dreg];
> +
> +       if (unlikely(pkt->pf != priv->family)) {
> +               WARN_ONCE(1, "Address families do not match\n");

I think this WARN_ONCE seems unnecessary, in inet family, it's possible that
the family is mismatched.

> +               goto err;
> +       }
> +
> +       switch (pkt->pf) {
> +       case NFPROTO_IPV4:
> +               switch (priv->key) {
> +               case NFT_RT_NEXTHOP: {
> +                       const struct rtable *rt = skb_rtable(skb);
> +
> +                       if (!rt)
> +                               goto err;
> +                       *dest = rt_nexthop(rt, ip_hdr(skb)->daddr);
> +                       break;
> +               }
> +               default:
> +                       goto out;
> +               }
> +               break;
> +       case NFPROTO_IPV6:
> +               switch (priv->key) {
> +               case NFT_RT_NEXTHOP: {
> +                       struct rt6_info *rt =
> +                                       (struct rt6_info *)skb_dst(skb);
> +
> +                       if (!rt)
> +                               goto err;
> +                       memcpy(dest, rt6_nexthop(rt, &ipv6_hdr(skb)->daddr),
> +                              sizeof(struct in6_addr));
> +                       break;
> +               }
> +               default:
> +                       goto out;
> +               }
> +               break;
> +       }
> +

This code looks not clean, I think it can be converted to such:

switch (priv->key) {
        case NFT_RT_NEXTHOP:
                switch (pkt->pf)
                ...
        default:
                return nft_rt_get_eval(expr, regs, pkt);
}

> +       return;
> +out:
> +       return nft_rt_get_eval(expr, regs, pkt);
> +err:
> +       regs->verdict.code = NFT_BREAK;
> +}
> +
> +static int nft_rt_inet_get_init(const struct nft_ctx *ctx,
> +                               const struct nft_expr *expr,
> +                               const struct nlattr * const tb[])
> +{
> +       struct nft_rt *priv = nft_expr_priv(expr);
> +       unsigned int len;
> +
> +       if (tb[NFTA_RT_KEY] == NULL ||
> +           tb[NFTA_RT_DREG] == NULL ||
> +           tb[NFTA_RT_FAMILY] == NULL)
> +               return -EINVAL;
> +
> +       priv->key = ntohl(nla_get_be32(tb[NFTA_RT_KEY]));
> +       priv->family = ntohl(nla_get_be32(tb[NFTA_RT_FAMILY]));
> +       switch (priv->key) {
> +       case NFT_RT_NEXTHOP:
> +               switch (priv->family) {
> +               case NFPROTO_IPV4:
> +                       len = sizeof(u32);
> +                       break;
> +               case NFPROTO_IPV6:
> +                       len = sizeof(struct in6_addr);
> +                       break;
> +               }
> +               len = sizeof(u32);
> +               break;

If the family is invalid, you should report -EINVAL to the userspace.
And the code "len = sizeof(u32);" here makes no sense.
