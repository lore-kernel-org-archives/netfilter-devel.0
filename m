Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DEEC06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 11:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E0FA20659
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 11:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGBLGq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:06:46 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42242 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbfGBLGq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 07:06:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hiGcU-0004AK-OJ; Tue, 02 Jul 2019 13:06:42 +0200
Date:   Tue, 2 Jul 2019 13:06:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nat: Update obsolete comment on
 get_unique_tuple()
Message-ID: <20190702110642.hexagvgfcnev7fq4@breakpoint.cc>
References: <20190627212307.GB4897@jong.localdomain>
 <20190628090748.e42ymhe3huvuduhj@salvia>
 <20190701204222.GA1068@jong.localdomain>
 <20190702105902.gcsd4mgtzy4k777p@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702105902.gcsd4mgtzy4k777p@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Would you re-submit this again? This is not showing in my patchwork:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/list/
> 
> Please, also include a new subject title and patch description
> according to this change.

Yon, if you submit this again, would you make these small changes?

> > diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
> > index 91d6275292a5..a3844e2cd531 100644
> > --- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
> > +++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
> > @@ -1,6 +1,6 @@
> >  /* SPDX-License-Identifier: GPL-2.0-only */
> >  /****************************************************************************
> > - * ip_conntrack_h323_asn1.h - BER and PER decoding library for H.323
> > + * nf_conntrack_h323_asn1.h - BER and PER decoding library for H.323
> >   * 			      conntrack/NAT module.
> >   *

I suggest to drop the file name here, its a self-reference.

> >  	hash = clusterip_hashfn(skb, cipinfo->config);
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index f4f9b8344a32..fd7d317951d4 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1817,7 +1817,7 @@ EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
> >  #include <linux/mutex.h>
> >  
> >  /* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
> > - * in ip_conntrack_core, since we don't want the protocols to autoload
> > + * in nf_conntrack_core, since we don't want the protocols to autoload
> >   * or depend on ctnetlink */

The protocols are not modular anymore.

"Generic function for tcp/udp/sctp/dccp and alike."
is enough i think.

> >  int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
> >  			       const struct nf_conntrack_tuple *tuple)
> > diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> > index 8f6ba8162f0b..e86b12bd19ed 100644
> > --- a/net/netfilter/nf_conntrack_h323_asn1.c
> > +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> > @@ -1,11 +1,11 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /*
> > - * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
> > + * nf_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
> >   * 			      	     conntrack/NAT module.
> >   *

I would just drop the name above, as its a self-reference.

> >   * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
> >   *
> > - * See ip_conntrack_helper_h323_asn1.h for details.
> > + * See nf_conntrack_helper_h323_asn1.h for details.

This is fine.

> > diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
> > --- a/net/netfilter/nf_conntrack_proto_gre.c
> > +++ b/net/netfilter/nf_conntrack_proto_gre.c
> > @@ -1,6 +1,6 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  /*
> > - * ip_conntrack_proto_gre.c - Version 3.0
> > + * nf_conntrack_proto_gre.c - Version 3.0
> >   *

Consider removing the "ip_conntrack" line completely, version doesn't
make sense given this is in mainline kernel.

Rest looks good to me.
