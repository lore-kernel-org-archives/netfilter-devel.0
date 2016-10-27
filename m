From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Thu, 27 Oct 2016 19:50:27 +0200
Message-ID: <20161027175027.GA20553@salvia>
References: <1476971559.1161.58.camel@cohaesio.com>
 <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com>
 <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <20161021092130.GA1987@salvia>
 <CAML_gOfecSTOHk-qSGhSwO4pFY9MW5FcBiFyZkqKZM4RAgL2NQ@mail.gmail.com>
 <20161021165830.GA1556@salvia>
 <CAML_gOdU_pChiyd08O-BPPk=r42PJ-38kTyZdngwQxboS9ToKw@mail.gmail.com>
 <1477152531.5024.53.camel@cohaesio.com>
 <CAML_gOeoT43PGgk02peStbpecitefrRO_tXA1TXJXc3k09yaYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752728AbcJ0Rud (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:50:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E70F626E12
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D25FADA84A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:50:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B92BDA7E9
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:50:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOeoT43PGgk02peStbpecitefrRO_tXA1TXJXc3k09yaYA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 01:01:51PM +0800, Liping Zhang wrote:
> Hi Anders,
> 
> 2016-10-23 0:08 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
> [...]
> > But ct_expr_update_type is only used during the netlink_delinearize
> > postprocess step, and that causes problems, when it is used in
> > combination with flow statements as described in other mail.
> 
> I think this is a bug and should be fixed.
> 
> > Would you object to dropping (i.e. kernel will not require it and
> > userspace will not include it) the NFTA_RT_FAMILY attribute for ip and
> > ip6 families, but unconditionally including it for the inet family?
> 
> After I read your and Pablo's explanation, now I'm not sure which one
> is better. :)
> 
> Maybe from this rt nexthop expression, we can get a relatively
> consistent way to handle the INET family properly, either
> explicitly add a _FAMILY_ attribute, or just like ct original saddr,
> completely handle it properly in the nft utility.

Please, use the layer 3 network context as you said. For the inet family,
we would need to bail out in case no context is available.

We can probably get rid of the _FAMILY attribute by introducing
explicit rt keys, ie.

        NFTA_RT_NH_IPV4
        NFTA_RT_NH_IPV6

I agree the _FAMILY attribute is getting ugly, specifically we don't
need this attribute with classid, so better if we can avoid it.

Thanks!
