From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 10:06:43 +0800
Message-ID: <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33429 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbcJUCGp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 22:06:45 -0400
Received: by mail-vk0-f66.google.com with SMTP id 83so4070975vkd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 19:06:45 -0700 (PDT)
In-Reply-To: <1476971559.1161.58.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-10-20 21:52 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
>
> OK, so would it be okay to replace it with
>
> printk_once(KERN_WARNING KBUILD_MODNAME " Address families do not match\n");
>
> ?
>

To this question, I think it's better to do NFT_BREAK sliently, the warning
message seems useless. Actually this can be avoided in userspace,
i.e. in nft.

For example, if you add the following rule in the inet family:
  # nft add rule inet filter output ip daddr 1.1.1.1

An implict rule will be added, and this can also be applied to rt expr,
we should first compare nfproto is AF_INET or not:
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]

But after I think it carefully, I think the NFTA_RT_FAMILY attr
seems useless, we can combine these four files nft_rt.c,
nft_rt_ipv4.c, nft_rt_ipv6.c and nft_rt_inet.c into a single one
file nft_rt.c.

For eval, we can use pkt->pf to decide which rt or rt6 nexthop
to be loaded, so ip/ip6/inet family has the same logical now,
for example:

static void nft_rt_get_eval(const struct nft_expr *expr,
                                struct nft_regs *regs,
                                const struct nft_pktinfo *pkt)
{
       const struct nft_rt *priv = nft_expr_priv(expr);
       const struct dst_entry *dst = skb_dst(skb);

       if (!dst)
            goto err;

       switch (key) {
              case NEXTHOP:
              switch(pkt->pf) {
                    case IPV4:
                    case IPV6:
               }
               case RTCLASSID:
                     ....
        }
        ....
}
