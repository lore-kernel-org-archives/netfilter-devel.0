Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D127C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377E52082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbgFXNDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:03:10 -0400
Received: from correo.us.es ([193.147.175.20]:42556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390580AbgFXNDJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:03:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A690C1C4427
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 15:03:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97DECDA84A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 15:03:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8ABCEDA853; Wed, 24 Jun 2020 15:03:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 483A8DA73D;
        Wed, 24 Jun 2020 15:03:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 15:03:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 10BDD42EF42B;
        Wed, 24 Jun 2020 15:03:05 +0200 (CEST)
Date:   Wed, 24 Jun 2020 15:03:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20200624130304.GA549@salvia>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20200624100346.GA11986@salvia>
 <20200624123423.r2gypsdii6xgiywy@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624123423.r2gypsdii6xgiywy@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 24, 2020 at 08:34:23AM -0400, Richard Guy Briggs wrote:
> On 2020-06-24 12:03, Pablo Neira Ayuso wrote:
> > On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
[...]
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 3558e76e2733..b9e7440cc87d 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/netlink.h>
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/rhashtable.h>
> > > +#include <linux/audit.h>
> > >  #include <linux/netfilter.h>
> > >  #include <linux/netfilter/nfnetlink.h>
> > >  #include <linux/netfilter/nf_tables.h>
> > > @@ -693,6 +694,16 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> > >  {
> > >  	struct sk_buff *skb;
> > >  	int err;
> > > +	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > > +			      ctx->table->name, ctx->table->handle);
> > > +
> > > +	audit_log_nfcfg(buf,
> > > +			ctx->family,
> > > +			ctx->table->use,
> > > +			event == NFT_MSG_NEWTABLE ?
> > > +				AUDIT_NFT_OP_TABLE_REGISTER :
> > > +				AUDIT_NFT_OP_TABLE_UNREGISTER);
> > > +	kfree(buf);
> > 
> > As a follow up: Would you wrap this code into a function?
> > 
> >         nft_table_audit()
> > 
> > Same thing for other pieces of code below.
> 
> If I'm guessing right, you are asking for a supplementary follow-up
> cleanup patch to this one (or are you nacking this patch)?

No nack, it's just that I'd prefer to see this wrapped in a function.
I think your patch is already in the audit tree.

> Also, I gather you would like to see the kasprintf and kfree hidden in
> nft_table_audit(), handing this function at least 8 parameters?  This
> sounds pretty messy given the format of the table field.

I think you can pass ctx and the specific object, e.g. table, in most
cases? There is also event and the gfp_flags. That counts 4 here, but
maybe I'm overlooking something.

Thanks.
