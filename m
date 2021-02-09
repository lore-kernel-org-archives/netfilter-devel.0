Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFD6C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 15:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A4C64E75
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 15:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhBIPyF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 10:54:05 -0500
Received: from correo.us.es ([193.147.175.20]:51904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232294AbhBIPyE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 10:54:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 159112788C2
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 16:53:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 006DBDA704
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 16:53:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F2979DA73F; Tue,  9 Feb 2021 16:53:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0A74DA704;
        Tue,  9 Feb 2021 16:53:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 16:53:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A039042DC6DD;
        Tue,  9 Feb 2021 16:53:19 +0100 (CET)
Date:   Tue, 9 Feb 2021 16:53:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] erec: Sanitize erec location indesc
Message-ID: <20210209155319.GA29313@salvia>
References: <20210126175502.9171-1-phil@nwl.cc>
 <20210203003832.GA30866@salvia>
 <20210203104507.GO3158@orbyte.nwl.cc>
 <20210209131511.GA27807@salvia>
 <20210209141151.GO3158@orbyte.nwl.cc>
 <20210209155030.GA16191@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210209155030.GA16191@salvia>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 09, 2021 at 04:50:30PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 09, 2021 at 03:11:51PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Feb 09, 2021 at 02:15:11PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Feb 03, 2021 at 11:45:07AM +0100, Phil Sutter wrote:
> > > > On Wed, Feb 03, 2021 at 01:38:32AM +0100, Pablo Neira Ayuso wrote:
> > > > > On Tue, Jan 26, 2021 at 06:55:02PM +0100, Phil Sutter wrote:
> > > > > > erec_print() unconditionally dereferences erec->locations->indesc, so
> > > > > > make sure it is valid when either creating an erec or adding a location.
> > > > > 
> > > > > I guess your're trigger a bug where erec is indesc is NULL, thing is
> > > > > that indesc should be always set on. Is there a reproducer for this bug?
> > > > 
> > > > Yes, exactly. I hit it when trying to clean up the netdev family reject
> > > > support, while just "hacking around". You can trigger it with the
> > > > following change:
> > > > 
> > > > | --- a/src/evaluate.c
> > > > | +++ b/src/evaluate.c
> > > > | @@ -2718,7 +2718,7 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
> > > > |         const struct proto_desc *desc;
> > > > |  
> > > > |         desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
> > > > | -       if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
> > > > | +       if (desc != &proto_eth && desc != &proto_vlan)
> > > > |                 return stmt_binary_error(ctx,
> > > > |                                          &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
> > > > |                                          stmt, "unsupported link layer protocol");
> > > 
> > > I'm attaching fix.
> > > 
> > > Looks like call to stmt_binary_error() parameters are not in the right
> > > order, &ctx->pctx.protocol[PROTO_BASE_LL_HDR] has indesc.
> > 
> > Thanks for addressing the root problem!
> > 
> > > Probably add a bugtrap to erec to check that indesc is always set on
> > > accordingly instead?
> > 
> > Is it better than just sanitizing input to error functions? After all we
> > just want to make sure users see the error message, right? Catching
> > the programming mistake (wrong args passed to __stmt_binary_error())
> > IMHO is useful only if we can compile-time assert it. Otherwise we risk
> > hiding error info from user.
> 
> I see. I don't see a way to catch this at compile time.
> 
> Push out your patch and I'll push mine too for correctness.

Hm, one second: Probably set internal_indesc for autogenerated
dependencies?
