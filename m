From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] expr: fix leak in target and match expressions
Date: Thu, 14 Nov 2013 23:29:11 +0100
Message-ID: <1384468151-6887-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41300 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab3KNW3S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:29:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release internal data area for match and target expressions.

==30104== 68 bytes in 1 blocks are definitely lost in loss record 1 of 1
==30104==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
==30104==    by 0x400C2F: main (nft-expr_match-test.c:65)

Reported-by: Ana Rey Botello <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr.c        |    3 +++
 src/expr/match.c  |    8 ++++++++
 src/expr/target.c |    8 ++++++++
 src/expr_ops.h    |    1 +
 4 files changed, 20 insertions(+)

diff --git a/src/expr.c b/src/expr.c
index 2605029..aeb717e 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -49,6 +49,9 @@ EXPORT_SYMBOL(nft_rule_expr_alloc);
 
 void nft_rule_expr_free(struct nft_rule_expr *expr)
 {
+	if (expr->ops->free)
+		expr->ops->free(expr);
+
 	xfree(expr);
 }
 EXPORT_SYMBOL(nft_rule_expr_free);
diff --git a/src/expr/match.c b/src/expr/match.c
index db2b987..5d02ee7 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -258,10 +258,18 @@ nft_rule_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static void nft_rule_expr_match_free(struct nft_rule_expr *e)
+{
+	struct nft_expr_match *match = nft_expr_data(e);
+
+	xfree(match->data);
+}
+
 struct expr_ops expr_ops_match = {
 	.name		= "match",
 	.alloc_len	= sizeof(struct nft_expr_match),
 	.max_attr	= NFTA_MATCH_MAX,
+	.free		= nft_rule_expr_match_free,
 	.set		= nft_rule_expr_match_set,
 	.get		= nft_rule_expr_match_get,
 	.parse		= nft_rule_expr_match_parse,
diff --git a/src/expr/target.c b/src/expr/target.c
index 7994bcd..20bf2af 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -260,10 +260,18 @@ nft_rule_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static void nft_rule_expr_target_free(struct nft_rule_expr *e)
+{
+	struct nft_expr_target *target = nft_expr_data(e);
+
+	xfree(target->data);
+}
+
 struct expr_ops expr_ops_target = {
 	.name		= "target",
 	.alloc_len	= sizeof(struct nft_expr_target),
 	.max_attr	= NFTA_TARGET_MAX,
+	.free		= nft_rule_expr_target_free,
 	.set		= nft_rule_expr_target_set,
 	.get		= nft_rule_expr_target_get,
 	.parse		= nft_rule_expr_target_parse,
diff --git a/src/expr_ops.h b/src/expr_ops.h
index becc85a..26e0b82 100644
--- a/src/expr_ops.h
+++ b/src/expr_ops.h
@@ -23,6 +23,7 @@ struct expr_ops {
 	const char *name;
 	uint32_t alloc_len;
 	int	max_attr;
+	void	(*free)(struct nft_rule_expr *e);
 	int	(*set)(struct nft_rule_expr *e, uint16_t type, const void *data, uint32_t data_len);
 	const void *(*get)(const struct nft_rule_expr *e, uint16_t type, uint32_t *data_len);
 	int 	(*parse)(struct nft_rule_expr *e, struct nlattr *attr);
-- 
1.7.10.4

