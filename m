From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 18:58:30 +0200
Message-ID: <20161021165830.GA1556@salvia>
References: <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com>
 <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com>
 <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com>
 <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <20161021092130.GA1987@salvia>
 <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbcJUQ6i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 12:58:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62C8362D09
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 18:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E60FBAC2F
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 18:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14CD9BAC28
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 18:58:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 09:22:09PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2016-10-21 17:21 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> >> In init ctx->afi->family is available, a example code is in nft_ct_get_init(),
> >> you can take a look at this.
> >
> > ctx->afi->family indicates NFPROTO_INET in this case, so we have no
> > way to know if the user is requesting rt IPv4 or rt IPv6 from there.
> 
> Yes, but I find that the NFTA_RT_FAMILY attr seems only useful
> in init routine. For INET family, the length can simply to be setted
> to sizeof(struct in6_addr), i.e:
>     switch (ctx->afi->family) {
>         case IPV4:
>               len = 4;
>               break;
>         case IPV6:
>         case INET:
>               len = 16;
>               break;
>      }
>      ...
>      return nft_validate_register_store(..., len, ...);
> 
> The drawback of this implementation is that the user cannot
> specify dreg to NFT_REG32_13, NFT_REG32_14 and
> NFT_REG32_15 when we use rt4 nexthop in INET family.
> 
> But since the same problem exists when we use rt6 nexthop in
> INET/IPV6 family, so I think this will not be a problem.
>
> And for eval, nft rules can be interpreted as following:
> (1) nft add rule filter inet output rt ip nexthop ... --debug=netlink
> [ meta load nfproto => reg 1 ]
> [ cmp eq reg 1 0x00000002 ]
> [ rt nexthop => reg 1 ]
> ...
> 
> (2) nft add rule filter inet output rt ip6 nexthop ... --debug=netlink
> [ meta load nfproto => reg 1 ]
> [ cmp eq reg 1 0x0000000a ]
> [ rt nexthop => reg 1 ]
> ...
> 
> So I think we cannot earn much benefits from the NFTA_RT_FAMILY attr.
> Or I missed something?

We still need datatype information for the inet family, from the
netlink_delinearize step, when dumping back the policy to userspace.
Given that we cannot infer the datatype from the data size, as this
would be 16 bytes for both cases, we would still need to annotate this
context information somewhere. The existing approach is providing this
datatype information.
