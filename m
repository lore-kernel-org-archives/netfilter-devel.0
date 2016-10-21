From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 11:21:30 +0200
Message-ID: <20161021092130.GA1987@salvia>
References: <1476902043.1161.14.camel@cohaesio.com>
 <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com>
 <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com>
 <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com>
 <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934249AbcJUJVp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 05:21:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49FCB2273C5
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:21:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37F5EBAAAA
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:21:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7ABFBAAB8
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 11:21:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 02:17:11PM +0800, Liping Zhang wrote:
> hi Anders,
> 
> 2016-10-21 12:16 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
> >>
> >> But after I think it carefully, I think the NFTA_RT_FAMILY attr
> >> seems useless, we can combine these four files nft_rt.c,
> >> nft_rt_ipv4.c, nft_rt_ipv6.c and nft_rt_inet.c into a single one
> >> file nft_rt.c.
> >
> > My implementation is based on the suggestion from Pablo at
> > http://marc.info/?l=netfilter-devel&m=147438531502686&w=4 .
> 
> Yes, but after I carefully read your codes, I find that the related
> implementation code about the family attr is not very good.
> 
> Without the family attr, we can still make everything well, and
> the codes will become more clean and straightforward.
> 
> As a summary:
> For ip family, nexthop must be ipv4
> For ip6 family, nexthop must be ipv6
> For inet family, nexthop can be selected by pkt->pf and we can add
> an implict rule that the user cannot do wrong operation.
> 
> So I think the NFTA_RT_FAMILY attr is almost useless.
>
> >> For eval, we can use pkt->pf to decide which rt or rt6 nexthop
> >> to be loaded, so ip/ip6/inet family has the same logical now,
> >> for example:
> >
> > Yes, but pkt->pf is not available in init, where we have to answer what
> > the data size will be.
> 
> In init ctx->afi->family is available, a example code is in nft_ct_get_init(),
> you can take a look at this.

ctx->afi->family indicates NFPROTO_INET in this case, so we have no
way to know if the user is requesting rt IPv4 or rt IPv6 from there.
