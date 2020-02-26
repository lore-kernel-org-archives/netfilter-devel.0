Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1203C4BA0E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1CD24656
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgBZLxl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:53:41 -0500
Received: from correo.us.es ([193.147.175.20]:46422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgBZLxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:53:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE552303D0A
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 12:53:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2B15DA38D
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 12:53:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8113DA8E6; Wed, 26 Feb 2020 12:53:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03B84DA390;
        Wed, 26 Feb 2020 12:53:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 12:53:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DC08F42EF42A;
        Wed, 26 Feb 2020 12:53:29 +0100 (CET)
Date:   Wed, 26 Feb 2020 12:53:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200226115337.o5mgrhhbvtk6cpsg@salvia>
References: <20200225141346.7406e06b@redhat.com>
 <20200225134236.sdz5ujufvxm2in3h@salvia>
 <20200225153435.17319874@redhat.com>
 <20200225202143.tqsfhggvklvhnsvs@salvia>
 <20200225213815.3c0a1caa@redhat.com>
 <20200225205847.s5pjjp652unj6u7v@salvia>
 <20200226105804.xramr6duqkvrtop3@salvia>
 <20200226120253.71e9f0e0@redhat.com>
 <20200226112935.bdsz733f2gltkbpu@salvia>
 <20200226123626.561451e7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226123626.561451e7@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 26, 2020 at 12:36:26PM +0100, Stefano Brivio wrote:
> On Wed, 26 Feb 2020 12:29:35 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > From a17f22eac1dfd599ff97bb262fc97d64333b06fe Mon Sep 17 00:00:00 2001
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date: Wed, 26 Feb 2020 12:11:53 +0100
> > Subject: [PATCH] netfilter: nf_tables: report ENOTEMPTY on element
> >  intersection
> > 
> > The set backend uses ENOTEMPTY to report an intersection between two
> > range elements.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index d1318bdf49ca..48ad273a273e 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -5059,7 +5059,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
> >  	err = set->ops->insert(ctx->net, set, &elem, &ext2);
> >  	if (err) {
> > -		if (err == -EEXIST) {
> > +		if (err == -EEXIST || err == -ENOTEMPTY) {
> >  			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
> >  			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
> >  			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
> > @@ -5073,10 +5073,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
> >  				    nft_set_ext_data(ext2), set->dlen) != 0) ||
> >  			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
> >  			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
> > -			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
> > +			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2))) {
> >  				err = -EBUSY;
> > -			else if (!(nlmsg_flags & NLM_F_EXCL))
> > -				err = 0;
> > +			} else {
> > +				/* ENOTEMPTY reports an intersection between
> > +				 * this element and an existing one.
> > +				 */
> > +				if (err == -ENOTEMPTY)
> > +					err = -EEXIST;
> > +				else if (!(nlmsg_flags & NLM_F_EXCL))
> > +					err = 0;
> > +			}
> >  		}
> >  		goto err_element_clash;
> >  	}
> 
> I haven't tested it, but isn't:
> 
> @@ -5077,6 +5077,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
>                                 err = -EBUSY;
>                         else if (!(nlmsg_flags & NLM_F_EXCL))
>                                 err = 0;
> +               } else if (err == -ENOTEMPTY) {
> +                       /* ENOTEMPTY reports overlapping between this element
> +                        * and an existing one.
> +                        */
> +                       err = -EEXIST;
>                 }
>                 goto err_element_clash;
>         }
> 
> simpler and equivalent?

Indeed, there is no chance to do the special EBUSY handling in the
-ENOTEMPTY case.

You patch is much better.

Thanks.
