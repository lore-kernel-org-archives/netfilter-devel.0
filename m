Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F3C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B8320738
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SqHy+V/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbgFXN0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:26:34 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37317 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728794AbgFXN0e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593005192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wIjlutJVnQ4JyLVWV0SJbJ1KwaR2ltVhkWmEFPhP4jw=;
        b=SqHy+V/x3itLi3MktC2h2X3dfze6mHcnuDRl+mKfovH243O36gz7mgFrPUfQkJm67b1BXN
        d1D7FboUlHi6+4lTTDXA1lOyqMcYCJDr1iWACcAKEzvNmbqFPvnsBBk2wVaq4/QuXSuBBk
        C+rCGb7CNo4GC/jX1ijlnNoQBZPbO44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-5o7VNEWsOf6D9biLQcYOvg-1; Wed, 24 Jun 2020 09:26:30 -0400
X-MC-Unique: 5o7VNEWsOf6D9biLQcYOvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229B6EC1A3;
        Wed, 24 Jun 2020 13:26:29 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CF5060C80;
        Wed, 24 Jun 2020 13:26:15 +0000 (UTC)
Date:   Wed, 24 Jun 2020 09:26:12 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20200624132612.fj36hwgom7qryvn7@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20200624100346.GA11986@salvia>
 <20200624123423.r2gypsdii6xgiywy@madcap2.tricolour.ca>
 <20200624130304.GA549@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624130304.GA549@salvia>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-24 15:03, Pablo Neira Ayuso wrote:
> On Wed, Jun 24, 2020 at 08:34:23AM -0400, Richard Guy Briggs wrote:
> > On 2020-06-24 12:03, Pablo Neira Ayuso wrote:
> > > On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
> [...]
> > > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > > index 3558e76e2733..b9e7440cc87d 100644
> > > > --- a/net/netfilter/nf_tables_api.c
> > > > +++ b/net/netfilter/nf_tables_api.c
> > > > @@ -12,6 +12,7 @@
> > > >  #include <linux/netlink.h>
> > > >  #include <linux/vmalloc.h>
> > > >  #include <linux/rhashtable.h>
> > > > +#include <linux/audit.h>
> > > >  #include <linux/netfilter.h>
> > > >  #include <linux/netfilter/nfnetlink.h>
> > > >  #include <linux/netfilter/nf_tables.h>
> > > > @@ -693,6 +694,16 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> > > >  {
> > > >  	struct sk_buff *skb;
> > > >  	int err;
> > > > +	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > > > +			      ctx->table->name, ctx->table->handle);
> > > > +
> > > > +	audit_log_nfcfg(buf,
> > > > +			ctx->family,
> > > > +			ctx->table->use,
> > > > +			event == NFT_MSG_NEWTABLE ?
> > > > +				AUDIT_NFT_OP_TABLE_REGISTER :
> > > > +				AUDIT_NFT_OP_TABLE_UNREGISTER);
> > > > +	kfree(buf);
> > > 
> > > As a follow up: Would you wrap this code into a function?
> > > 
> > >         nft_table_audit()
> > > 
> > > Same thing for other pieces of code below.
> > 
> > If I'm guessing right, you are asking for a supplementary follow-up
> > cleanup patch to this one (or are you nacking this patch)?
> 
> No nack, it's just that I'd prefer to see this wrapped in a function.
> I think your patch is already in the audit tree.
> 
> > Also, I gather you would like to see the kasprintf and kfree hidden in
> > nft_table_audit(), handing this function at least 8 parameters?  This
> > sounds pretty messy given the format of the table field.
> 
> I think you can pass ctx and the specific object, e.g. table, in most
> cases? There is also event and the gfp_flags. That counts 4 here, but
> maybe I'm overlooking something.

Since every event is sufficiently different, it isn't as simple as
passing ctx, unfortunately, and the table field I've overloaded with 4
bits of information for tracking the chain as well, some of which are ?
that would need an in-band representation (such as -1? that might
already be valid).  So 4 right there, family, nentries, event, gfp for 8.

I did try in the first patch to make it just one call keyed on event,
but there was enough variety of information available for each message
type that it became necessary to break it out.

> Thanks.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

