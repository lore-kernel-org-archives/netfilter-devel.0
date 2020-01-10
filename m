Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF4BC33CA4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C27482072E
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FX3W50E8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39856 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgAJMiI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:38:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lv4X4kAVQOvzyLyhpubFOYibq+0CIwICTUNN7L+vzyw=; b=FX3W50E8kMmQvpwHGeftBKHjTd
        Kj5+t9vPYvSvltHRzc73mdJeVLW8clzB0ddU8aMQABJhZcSjCK+KHwrK3ziQHk/O7k6NTPFANVSAq
        W8MPxxRADEfLrbS9FKfr/B5UY028PeQaANz65Csg3CYsgJngGDNfdSQhkEc0c+NxAMY3evlxoIzii
        BarFIrb0yVqsik02pCe/ZimB3VmW7JJJsF2H5+AA1fUhd9z/RWLX/lvcEzOeRZeQE0/GkgDNbbBgm
        C3JPGbw0eNqSGZWXiG6VtkIUa0fFOUwOGdjha3N6dJB33Foajef2EOY8t6c9GJPQOJKTeErPyeg9V
        Wn8ZkvAw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptYE-0003im-Sy
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:38:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/7] src: white-space fixes.
Date:   Fri, 10 Jan 2020 12:38:01 +0000
Message-Id: <20200110123806.106546-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123806.106546-1-jeremy@azazel.net>
References: <20200110123806.106546-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove some trailing white-space and fix some indentation.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c            | 11 +++++------
 src/netlink_delinearize.c |  2 +-
 src/netlink_linearize.c   |  2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 34e4473e4c9a..6af681f0f7a8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2343,14 +2343,13 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 static int stmt_evaluate_ct(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt_evaluate_arg(ctx, stmt,
-				 stmt->ct.tmpl->dtype,
-				 stmt->ct.tmpl->len,
-				 stmt->ct.tmpl->byteorder,
-				 &stmt->ct.expr) < 0)
+			      stmt->ct.tmpl->dtype,
+			      stmt->ct.tmpl->len,
+			      stmt->ct.tmpl->byteorder,
+			      &stmt->ct.expr) < 0)
 		return -1;
 
-	if (stmt->ct.key == NFT_CT_SECMARK &&
-	    expr_is_constant(stmt->ct.expr))
+	if (stmt->ct.key == NFT_CT_SECMARK && expr_is_constant(stmt->ct.expr))
 		return stmt_error(ctx, stmt,
 				  "ct secmark must not be set to constant value");
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 154353b8161a..387e4b046c6b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -171,7 +171,7 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 	struct expr *expr;
 
 	if (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_VERDICT)) {
-		nld.verdict = nftnl_expr_get_u32(nle, NFTNL_EXPR_IMM_VERDICT); 
+		nld.verdict = nftnl_expr_get_u32(nle, NFTNL_EXPR_IMM_VERDICT);
 		if  (nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN)) {
 			nld.chain = nftnl_expr_get(nle, NFTNL_EXPR_IMM_CHAIN,
 						   &nld.len);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 498326d0087a..d5e177d5e75c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1243,7 +1243,7 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 }
 
 static void netlink_gen_ct_stmt(struct netlink_linearize_ctx *ctx,
-				  const struct stmt *stmt)
+				const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 	enum nft_registers sreg;
-- 
2.24.1

