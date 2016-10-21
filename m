From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 14:17:11 +0800
Message-ID: <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com> <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36608 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754338AbcJUGRN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 02:17:13 -0400
Received: by mail-vk0-f66.google.com with SMTP id b186so4290586vkb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 23:17:13 -0700 (PDT)
In-Reply-To: <1477023411.1161.83.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi Anders,

2016-10-21 12:16 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
>>
>> But after I think it carefully, I think the NFTA_RT_FAMILY attr
>> seems useless, we can combine these four files nft_rt.c,
>> nft_rt_ipv4.c, nft_rt_ipv6.c and nft_rt_inet.c into a single one
>> file nft_rt.c.
>
> My implementation is based on the suggestion from Pablo at
> http://marc.info/?l=netfilter-devel&m=147438531502686&w=4 .

Yes, but after I carefully read your codes, I find that the related
implementation code about the family attr is not very good.

Without the family attr, we can still make everything well, and
the codes will become more clean and straightforward.

As a summary:
For ip family, nexthop must be ipv4
For ip6 family, nexthop must be ipv6
For inet family, nexthop can be selected by pkt->pf and we can add
an implict rule that the user cannot do wrong operation.

So I think the NFTA_RT_FAMILY attr is almost useless.

>
>> For eval, we can use pkt->pf to decide which rt or rt6 nexthop
>> to be loaded, so ip/ip6/inet family has the same logical now,
>> for example:
>
> Yes, but pkt->pf is not available in init, where we have to answer what
> the data size will be.

In init ctx->afi->family is available, a example code is in nft_ct_get_init(),
you can take a look at this.
