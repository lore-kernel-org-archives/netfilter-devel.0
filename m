From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: immediate: fix leak in expression destroy path
Date: Tue, 18 Aug 2015 02:04:04 +0200
Message-ID: <1439856244-10337-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbbHQX6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Aug 2015 19:58:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The verdict can be a chain string, make sure we release it when the expression
is destroyed. This patch adds a new nft_free_data() for this purpose and use it
from the immediate expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/data_reg.h   |    1 +
 src/expr/data_reg.c  |   11 +++++++++++
 src/expr/immediate.c |    9 +++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/data_reg.h b/include/data_reg.h
index cf14988..e0fdd10 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -28,5 +28,6 @@ int nft_data_reg_snprintf(char *buf, size_t size, union nft_data_reg *reg,
 struct nlattr;
 
 int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
+void nft_free_verdict(union nft_data_reg *data);
 
 #endif
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index b5fbdf2..b375db4 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -499,3 +499,14 @@ int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type)
 	return ret;
 }
 
+void nft_free_verdict(union nft_data_reg *data)
+{
+	switch(data->verdict) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		xfree(data->chain);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 692d9e9..cf06190 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -309,10 +309,19 @@ nft_rule_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static void nft_rule_expr_immediate_free(struct nft_rule_expr *e)
+{
+	struct nft_expr_immediate *imm = nft_expr_data(e);
+
+	if (e->flags & (1 << NFT_EXPR_IMM_VERDICT))
+		nft_free_verdict(&imm->data);
+}
+
 struct expr_ops expr_ops_immediate = {
 	.name		= "immediate",
 	.alloc_len	= sizeof(struct nft_expr_immediate),
 	.max_attr	= NFTA_IMMEDIATE_MAX,
+	.free		= nft_rule_expr_immediate_free,
 	.set		= nft_rule_expr_immediate_set,
 	.get		= nft_rule_expr_immediate_get,
 	.parse		= nft_rule_expr_immediate_parse,
-- 
1.7.10.4

