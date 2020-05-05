Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B21C47254
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 12:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D18A20735
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 12:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgEEMTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 08:19:08 -0400
Received: from correo.us.es ([193.147.175.20]:36852 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgEEMTI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 08:19:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33537EF42A
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:19:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5442206058
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 14:19:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99EFA206049; Tue,  5 May 2020 14:19:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EDD41B3019;
        Tue,  5 May 2020 14:17:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 14:17:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F320F42EF9E5;
        Tue,  5 May 2020 14:17:56 +0200 (CEST)
Date:   Tue, 5 May 2020 14:17:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] rule: fix out of memory write if num_stmts is too low
Message-ID: <20200505121756.GA8781@salvia>
References: <20200504204858.15009-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20200504204858.15009-1-michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 04, 2020 at 10:48:58PM +0200, Michael Braun wrote:
> Running bridge/vlan.t with ASAN, results in the following error.
> This patch fixes this
> 
> flush table bridge test-bridge
> add rule bridge test-bridge input vlan id 1 ip saddr 10.0.0.1

Thanks for your patch. Probably this patch instead?

--tThc/1wpZn/ma/RB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fix-num-stmts.patch"

diff --git a/src/evaluate.c b/src/evaluate.c
index 597141317000..26dfba2c6a74 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -645,6 +645,12 @@ static bool proto_is_dummy(const struct proto_desc *desc)
 	return desc == &proto_inet || desc == &proto_netdev;
 }
 
+static void ctx_stmt_add(struct eval_ctx *ctx, struct stmt *nstmt)
+{
+	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	ctx->rule->num_stmts++;
+}
+
 static int resolve_protocol_conflict(struct eval_ctx *ctx,
 				     const struct proto_desc *desc,
 				     struct expr *payload)
@@ -659,7 +665,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 		if (err < 0)
 			return err;
 
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
+		ctx_stmt_add(ctx, nstmt);
 	}
 
 	assert(base <= PROTO_BASE_MAX);
@@ -673,7 +679,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 		return 1;
 
 	payload->payload.offset += ctx->pctx.protocol[base].offset;
-	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	ctx_stmt_add(ctx, nstmt);
 
 	return 0;
 }
@@ -698,7 +704,8 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 	if (desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 			return -1;
-		list_add_tail(&nstmt->list, &ctx->stmt->list);
+
+		ctx_stmt_add(ctx, nstmt);
 	} else {
 		/* No conflict: Same payload protocol as context, adjust offset
 		 * if needed.
@@ -841,7 +848,7 @@ static int ct_gen_nh_dependency(struct eval_ctx *ctx, struct expr *ct)
 
 	nstmt = expr_stmt_alloc(&dep->location, dep);
 
-	list_add_tail(&nstmt->list, &ctx->stmt->list);
+	ctx_stmt_add(ctx, nstmt);
 	return 0;
 }
 

--tThc/1wpZn/ma/RB--
