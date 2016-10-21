From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 21:22:09 +0800
Message-ID: <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com> <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com> <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <20161021092130.GA1987@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32793 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932944AbcJUNWL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 09:22:11 -0400
Received: by mail-vk0-f65.google.com with SMTP id 83so4830048vkd.0
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 06:22:10 -0700 (PDT)
In-Reply-To: <20161021092130.GA1987@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-10-21 17:21 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> In init ctx->afi->family is available, a example code is in nft_ct_get_init(),
>> you can take a look at this.
>
> ctx->afi->family indicates NFPROTO_INET in this case, so we have no
> way to know if the user is requesting rt IPv4 or rt IPv6 from there.

Yes, but I find that the NFTA_RT_FAMILY attr seems only useful
in init routine. For INET family, the length can simply to be setted
to sizeof(struct in6_addr), i.e:
    switch (ctx->afi->family) {
        case IPV4:
              len = 4;
              break;
        case IPV6:
        case INET:
              len = 16;
              break;
     }
     ...
     return nft_validate_register_store(..., len, ...);

The drawback of this implementation is that the user cannot
specify dreg to NFT_REG32_13, NFT_REG32_14 and
NFT_REG32_15 when we use rt4 nexthop in INET family.

But since the same problem exists when we use rt6 nexthop in
INET/IPV6 family, so I think this will not be a problem.

And for eval, nft rules can be interpreted as following:
(1) nft add rule filter inet output rt ip nexthop ... --debug=netlink
[ meta load nfproto => reg 1 ]
[ cmp eq reg 1 0x00000002 ]
[ rt nexthop => reg 1 ]
...

(2) nft add rule filter inet output rt ip6 nexthop ... --debug=netlink
[ meta load nfproto => reg 1 ]
[ cmp eq reg 1 0x0000000a ]
[ rt nexthop => reg 1 ]
...

So I think we cannot earn much benefits from the NFTA_RT_FAMILY attr.
Or I missed something?
