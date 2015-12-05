From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/7] netlink_delinearize: postprocess expression before range merge
Date: Sat,  5 Dec 2015 20:04:22 +0100
Message-ID: <1449342266-2756-3-git-send-email-pablo@netfilter.org>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51086 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbbLETEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CFB98DA86D
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C12A2DA795
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E8DA9DA795
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:36 +0100 (CET)
In-Reply-To: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dependency statement go away after postprocess, so we should consider
them for possible range merges.

This problem was uncovered when adding support for sub-byte payload
ranges.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e5cee16..8cbabc3 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1558,11 +1558,11 @@ static void stmt_expr_postprocess(struct rule_pp_ctx *ctx, struct stmt *prev)
 {
 	enum ops op;
 
-	if (prev && ctx->stmt->ops->type == prev->ops->type &&
+	expr_postprocess(ctx, &ctx->stmt->expr);
+
+	if (prev && ctx->stmt && ctx->stmt->ops->type == prev->ops->type &&
 	    expr_may_merge_range(ctx->stmt->expr, prev->expr, &op))
 		expr_postprocess_range(ctx, prev, op);
-
-	expr_postprocess(ctx, &ctx->stmt->expr);
 }
 
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
-- 
2.1.4

