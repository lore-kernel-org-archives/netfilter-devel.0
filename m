Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE8EC18E5A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB3520575
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgCKOgB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:36:01 -0400
Received: from correo.us.es ([193.147.175.20]:43724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgCKOgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:36:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC294FB365
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:35:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAD02DA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:35:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C080DDA38F; Wed, 11 Mar 2020 15:35:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9C6EDA7B2;
        Wed, 11 Mar 2020 15:35:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:35:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C65EA42EF42B;
        Wed, 11 Mar 2020 15:35:34 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH nft 1/2] netlink: remove unused parameter from netlink_gen_stmt_stateful()
Date:   Wed, 11 Mar 2020 15:35:52 +0100
Message-Id: <20200311143553.4698-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove context from netlink_gen_stmt_stateful().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index de461775a7e1..5b3c43c6c641 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -822,9 +822,7 @@ static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
-static struct nftnl_expr *
-netlink_gen_connlimit_stmt(struct netlink_linearize_ctx *ctx,
-			   const struct stmt *stmt)
+static struct nftnl_expr *netlink_gen_connlimit_stmt(const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 
@@ -837,9 +835,7 @@ netlink_gen_connlimit_stmt(struct netlink_linearize_ctx *ctx,
 	return nle;
 }
 
-static struct nftnl_expr *
-netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
-			 const struct stmt *stmt)
+static struct nftnl_expr *netlink_gen_counter_stmt(const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 
@@ -856,9 +852,7 @@ netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 	return nle;
 }
 
-static struct nftnl_expr *
-netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
-		       const struct stmt *stmt)
+static struct nftnl_expr *netlink_gen_limit_stmt(const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 
@@ -874,9 +868,7 @@ netlink_gen_limit_stmt(struct netlink_linearize_ctx *ctx,
 	return nle;
 }
 
-static struct nftnl_expr *
-netlink_gen_quota_stmt(struct netlink_linearize_ctx *ctx,
-		       const struct stmt *stmt)
+static struct nftnl_expr *netlink_gen_quota_stmt(const struct stmt *stmt)
 {
 	struct nftnl_expr *nle;
 
@@ -888,19 +880,17 @@ netlink_gen_quota_stmt(struct netlink_linearize_ctx *ctx,
 	return nle;
 }
 
-static struct nftnl_expr *
-netlink_gen_stmt_stateful(struct netlink_linearize_ctx *ctx,
-			  const struct stmt *stmt)
+static struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 {
 	switch (stmt->ops->type) {
 	case STMT_CONNLIMIT:
-		return netlink_gen_connlimit_stmt(ctx, stmt);
+		return netlink_gen_connlimit_stmt(stmt);
 	case STMT_COUNTER:
-		return netlink_gen_counter_stmt(ctx, stmt);
+		return netlink_gen_counter_stmt(stmt);
 	case STMT_LIMIT:
-		return netlink_gen_limit_stmt(ctx, stmt);
+		return netlink_gen_limit_stmt(stmt);
 	case STMT_QUOTA:
-		return netlink_gen_quota_stmt(ctx, stmt);
+		return netlink_gen_quota_stmt(stmt);
 	default:
 		BUG("unknown stateful statement type %s\n", stmt->ops->name);
 	}
@@ -1378,7 +1368,7 @@ static void netlink_gen_set_stmt(struct netlink_linearize_ctx *ctx,
 
 	if (stmt->set.stmt)
 		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-			       netlink_gen_stmt_stateful(ctx, stmt->set.stmt), 0);
+			       netlink_gen_stmt_stateful(stmt->set.stmt), 0);
 }
 
 static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
@@ -1408,7 +1398,7 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 
 	if (stmt->map.stmt)
 		nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-			       netlink_gen_stmt_stateful(ctx, stmt->map.stmt), 0);
+			       netlink_gen_stmt_stateful(stmt->map.stmt), 0);
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
@@ -1440,7 +1430,7 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set.name);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
 	nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
-		       netlink_gen_stmt_stateful(ctx, stmt->meter.stmt), 0);
+		       netlink_gen_stmt_stateful(stmt->meter.stmt), 0);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
@@ -1486,7 +1476,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	case STMT_COUNTER:
 	case STMT_LIMIT:
 	case STMT_QUOTA:
-		nle = netlink_gen_stmt_stateful(ctx, stmt);
+		nle = netlink_gen_stmt_stateful(stmt);
 		nftnl_rule_add_expr(ctx->nlr, nle);
 		break;
 	case STMT_NOTRACK:
-- 
2.11.0

