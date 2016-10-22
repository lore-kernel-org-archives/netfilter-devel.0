From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Sat, 22 Oct 2016 09:44:35 +0800
Message-ID: <CAML_gOdU_pChiyd08O-BPPk=r42PJ-38kTyZdngwQxboS9ToKw@mail.gmail.com>
References: <1476902504.1161.24.camel@cohaesio.com> <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com> <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com> <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <20161021092130.GA1987@salvia> <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
 <20161021165830.GA1556@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35566 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755480AbcJVBoh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 21:44:37 -0400
Received: by mail-ua0-f196.google.com with SMTP id 10so424977ual.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 18:44:37 -0700 (PDT)
In-Reply-To: <20161021165830.GA1556@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
2016-10-22 0:58 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> We still need datatype information for the inet family, from the
> netlink_delinearize step, when dumping back the policy to userspace.
> Given that we cannot infer the datatype from the data size, as this
> would be 16 bytes for both cases, we would still need to annotate this
> context information somewhere. The existing approach is providing this
> datatype information.

Yes, the NFTA_RT_FAMILY attr will simplify our work, without this we
will have much more work in nft utility.

Since Anders suggests the following usage in INET family:
 # nft add rule inet filter postrouting ether type ip6 rt ip6 nexthop...
                                                         ^^^^^^^^^^^^^
So I think it's better to add implict dependency rules in inet family:
for rt ip nexthop: we add "meta nfproto ipv4"
for rt ip6 nexthop: we add "meta nfproto ipv6"

Then like NFT_CT_SRC do, we can implement a similar
*ct_expr_update_type*, and call it in netlink_delinearize step.

I agree this will add much more work in nft utility, and actually,
use the NFTA_RT_FAMILY attr, if we did not add "ether type ip6"
or "meta nfproto ipv6", "rt ip6 nexthop" can still work well in
INET family.
