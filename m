From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Sun, 23 Oct 2016 13:01:51 +0800
Message-ID: <CAML_gOeoT43PGgk02peStbpecitefrRO_tXA1TXJXc3k09yaYA@mail.gmail.com>
References: <1476902504.1161.24.camel@cohaesio.com> <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com> <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com> <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <20161021092130.GA1987@salvia> <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
 <20161021165830.GA1556@salvia> <CAML_gOdU_pChiyd08O-BPPk=r42PJ-38kTyZdngwQxboS9ToKw@mail.gmail.com>
 <1477152531.5024.53.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:32916 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbcJWFBx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 01:01:53 -0400
Received: by mail-ua0-f194.google.com with SMTP id m26so682662uaa.0
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2016 22:01:52 -0700 (PDT)
In-Reply-To: <1477152531.5024.53.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-10-23 0:08 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
[...]
> But ct_expr_update_type is only used during the netlink_delinearize
> postprocess step, and that causes problems, when it is used in
> combination with flow statements as described in other mail.

I think this is a bug and should be fixed.

> Would you object to dropping (i.e. kernel will not require it and
> userspace will not include it) the NFTA_RT_FAMILY attribute for ip and
> ip6 families, but unconditionally including it for the inet family?

After I read your and Pablo's explanation, now I'm not sure which one
is better. :)

Maybe from this rt nexthop expression, we can get a relatively
consistent way to handle the INET family properly, either
explicitly add a _FAMILY_ attribute, or just like ct original saddr,
completely handle it properly in the nft utility.
