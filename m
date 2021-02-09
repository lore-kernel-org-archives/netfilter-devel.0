Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C232C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65B164E7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBINXI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:23:08 -0500
Received: from correo.us.es ([193.147.175.20]:37154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBINWu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 08:22:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFCF1110CC1
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 14:22:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB03BDA78C
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 14:22:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D0307DA78B; Tue,  9 Feb 2021 14:22:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 840C8DA704;
        Tue,  9 Feb 2021 14:22:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 14:22:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 620C842DC6DD;
        Tue,  9 Feb 2021 14:22:05 +0100 (CET)
Date:   Tue, 9 Feb 2021 14:22:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] erec: Sanitize erec location indesc
Message-ID: <20210209132204.GA28719@salvia>
References: <20210126175502.9171-1-phil@nwl.cc>
 <20210203003832.GA30866@salvia>
 <20210203104507.GO3158@orbyte.nwl.cc>
 <20210209131511.GA27807@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20210209131511.GA27807@salvia>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Feb 09, 2021 at 02:15:11PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Feb 03, 2021 at 11:45:07AM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Feb 03, 2021 at 01:38:32AM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Jan 26, 2021 at 06:55:02PM +0100, Phil Sutter wrote:
> > > > erec_print() unconditionally dereferences erec->locations->indesc, so
> > > > make sure it is valid when either creating an erec or adding a location.
> > > 
> > > I guess your're trigger a bug where erec is indesc is NULL, thing is
> > > that indesc should be always set on. Is there a reproducer for this bug?
> > 
> > Yes, exactly. I hit it when trying to clean up the netdev family reject
> > support, while just "hacking around". You can trigger it with the
> > following change:
> > 
> > | --- a/src/evaluate.c
> > | +++ b/src/evaluate.c
> > | @@ -2718,7 +2718,7 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
> > |         const struct proto_desc *desc;
> > |  
> > |         desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
> > | -       if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
> > | +       if (desc != &proto_eth && desc != &proto_vlan)
> > |                 return stmt_binary_error(ctx,
> > |                                          &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
> > |                                          stmt, "unsupported link layer protocol");
> 
> I'm attaching fix.
> 
> Looks like call to stmt_binary_error() parameters are not in the right
> order, &ctx->pctx.protocol[PROTO_BASE_LL_HDR] has indesc.

New patch fix, just do not use ctx->pctx.protocol[PROTO_BASE_LL_HDR]
since it's an internal generated dependency, it is not visible from
the rule, so stmt_binary_error() cannot really help with the error
printing.

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index 030bbde4ab2c..782a5bca98bb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2729,9 +2729,8 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
 
 	desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
 	if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
-		return stmt_binary_error(ctx,
-					 &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
-					 stmt, "unsupported link layer protocol");
+		return __stmt_binary_error(ctx, &stmt->location, NULL,
+					   "cannot reject from this link layer protocol");
 
 	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 	if (desc != NULL &&

--2fHTh5uZTiUOsy+g--
