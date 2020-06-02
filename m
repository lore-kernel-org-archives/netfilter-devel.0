Return-Path: <SRS0=DvnY=7P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C88EC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78A662068D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdKNmTu9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBLed (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:34:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbgFBLed (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 07:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591097671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APPso8SmvnnOp4Dv0Sfkx5AFaSya8aWECXtjHdRoMxM=;
        b=KdKNmTu9IShNz+lP6v7jfpPuW9SeZmDYlJrnRq92j8rf3JS3sjsSVluAlVt0X5CoFWCiVi
        +DHwfItZTiUxvhj3DRLpLsJ+eChY3qC+sRZQG3TvA1YGhct+c+KRxMQILCkJ8iO+2mTrRn
        Z49gCOTQiI13UL0YwthRjdpmCuMvI8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-omEDP3A6MjuDFhd3Dccq6A-1; Tue, 02 Jun 2020 07:34:29 -0400
X-MC-Unique: omEDP3A6MjuDFhd3Dccq6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20E0518FE864;
        Tue,  2 Jun 2020 11:34:28 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 402B4579A3;
        Tue,  2 Jun 2020 11:34:19 +0000 (UTC)
Date:   Tue, 2 Jun 2020 07:34:17 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v2] audit: log nftables configuration change
 events
Message-ID: <20200602113417.kfrmwm57snkaiv3y@madcap2.tricolour.ca>
References: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
 <CAHC9VhTuUdc565fPU=P1sXEM8hFm5P+ESm3Bv=kyebb19EsQuQ@mail.gmail.com>
 <20200601225833.ut2wayc6xqefwveo@madcap2.tricolour.ca>
 <CAHC9VhRnM78=F7_qd8bi=4cfo=bZj_K9YFe1KM2nYRqJiLbsRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRnM78=F7_qd8bi=4cfo=bZj_K9YFe1KM2nYRqJiLbsRQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-01 20:12, Paul Moore wrote:
> On Mon, Jun 1, 2020 at 6:58 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-06-01 12:10, Paul Moore wrote:
> > > On Thu, May 28, 2020 at 9:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> ...
> 
> > > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > > index 4471393da6d8..7a386eca6e04 100644
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
> > > > @@ -693,6 +694,14 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> > > >  {
> > > >         struct sk_buff *skb;
> > > >         int err;
> > > > +       char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > > > +                             ctx->table->name, ctx->table->handle);
> > > > +
> > > > +       audit_log_nfcfg(buf,
> > > > +                       ctx->family,
> > > > +                       ctx->table->use,
> > > > +                       audit_nftcfgs[event].op);
> > >
> > > As an example, the below would work, yes?
> > >
> > > audit_log_nfcfg(...,
> > >  (event == NFT_MSG_NEWTABLE ?
> > >   AUDIT_NFT_OP_TABLE_REGISTER :
> > >   AUDIT_NFT_OP_TABLE_UNREGISTER)
> >
> > Ok, I see what you are getting at now...  Yes, it could be done this
> > way, but it seems noisier to me.
> 
> I'll admit it is not as clean, but it doesn't hide the mapping between
> the netfilter operation and the audit operation which hopefully makes
> it clear to those modifying the netfilter/nf_tables/etc. code that
> there is an audit impact.  I'm basically trying to make sure the code
> is as robust as possible in the face of subsystem changes beyond the
> audit subsystem.

Yup, I agree, a compile time check to make sure they aren't out of sync.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

