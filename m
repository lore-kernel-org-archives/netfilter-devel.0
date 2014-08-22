From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 1/5 v2] nft: adds nft_xt_ctx struct
Date: Fri, 22 Aug 2014 11:16:29 +0200
Message-ID: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38132 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaHVJMy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:12:54 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so9902086wiv.1
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:12:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch provides the context used to transfer
informaton between different nft_parse_* function calls.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c    | 16 ++++++++----
 iptables/nft-shared.c | 67 ++++++++++++++++++++++++++++++++-------------------
 iptables/nft-shared.h | 32 ++++++++++++------------
 3 files changed, 70 insertions(+), 45 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 8c06243..bc25de3 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -370,26 +370,32 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
 	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
+	struct nft_xt_ctx ctx = {
+		.state.fw = fw,
+		.family = family,
+		.flags = 0,
+	};
 
 	iter = nft_rule_expr_iter_create(r);
 	if (iter == NULL)
 		return;
 
+	ctx.iter = iter;
 	expr = nft_rule_expr_iter_next(iter);
 	while (expr != NULL) {
 		const char *name =
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
 		if (strcmp(name, "counter") == 0)
-			nft_parse_counter(expr, iter, &fw->counters);
+			nft_parse_counter(expr, &ctx.state.fw->counters);
 		else if (strcmp(name, "payload") == 0)
-			nft_parse_payload(expr, iter, family, fw);
+			nft_parse_payload(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
-			nft_parse_meta(expr, iter, family, fw);
+			nft_parse_meta(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
-			nft_parse_immediate(expr, iter, family, fw);
+			nft_parse_immediate(&ctx, expr);
 		else if (strcmp(name, "target") == 0)
-			nft_parse_target(expr, iter, family, fw);
+			nft_parse_target(&ctx, expr);
 
 		expr = nft_rule_expr_iter_next(iter);
 	}
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index deb2783..05fb29b 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -277,8 +277,20 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 	}
 }
 
-void nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		 int family, void *data)
+static void *nft_get_data(struct nft_xt_ctx *ctx)
+{
+	switch(ctx->family) {
+	case AF_INET:
+	case AF_INET6:
+		return ctx->state.cs;
+	case NFPROTO_ARP:
+		return ctx->state.fw;
+	default:
+		return NULL;
+	}
+}
+
+void nft_parse_target(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
 	uint32_t tg_len;
 	const char *targname = nft_rule_expr_get_str(e, NFT_EXPR_TG_NAME);
@@ -287,6 +299,7 @@ void nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	struct xt_entry_target *t;
 	struct nft_family_ops *ops;
 	size_t size;
+	void *data = nft_get_data(ctx);
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
 	if (target == NULL)
@@ -306,13 +319,12 @@ void nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 
 	target->t = t;
 
-	ops = nft_family_ops_lookup(family);
+	ops = nft_family_ops_lookup(ctx->family);
 	ops->parse_target(target, data);
 }
 
 static void
-nft_parse_match(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		struct iptables_command_state *cs)
+nft_parse_match(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
 	uint32_t mt_len;
 	const char *mt_name = nft_rule_expr_get_str(e, NFT_EXPR_MT_NAME);
@@ -320,7 +332,7 @@ nft_parse_match(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 	struct xtables_match *match;
 	struct xt_entry_match *m;
 
-	match = xtables_find_match(mt_name, XTF_TRY_LOAD, &cs->matches);
+	match = xtables_find_match(mt_name, XTF_TRY_LOAD, &ctx->state.cs->matches);
 	if (match == NULL)
 		return;
 
@@ -380,14 +392,14 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 }
 
 void
-nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       int family, void *data)
+nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
 	uint8_t key = nft_rule_expr_get_u32(e, NFT_EXPR_META_KEY);
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
+	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
 	const char *name;
+	void *data = nft_get_data(ctx);
 
-	e = nft_rule_expr_iter_next(iter);
+	e = nft_rule_expr_iter_next(ctx->iter);
 	if (e == NULL)
 		return;
 
@@ -401,34 +413,33 @@ nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 }
 
 void
-nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  int family, void *data)
+nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
+	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
 	uint32_t offset;
+	void *data = nft_get_data(ctx);
 
 	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
 
-	ops->parse_payload(iter, offset, data);
+	ops->parse_payload(ctx->iter, offset, data);
 }
 
 void
-nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  struct xt_counters *counters)
+nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters)
 {
 	counters->pcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS);
 	counters->bcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES);
 }
 
 void
-nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    int family, void *data)
+nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
 	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
 	struct nft_family_ops *ops;
 	const char *jumpto = NULL;
 	bool nft_goto = false;
+	void *data = nft_get_data(ctx);
 
 	/* Standard target? */
 	switch(verdict) {
@@ -448,7 +459,7 @@ nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
 		break;
 	}
 
-	ops = nft_family_ops_lookup(family);
+	ops = nft_family_ops_lookup(ctx->family);
 	ops->parse_immediate(jumpto, nft_goto, data);
 }
 
@@ -458,28 +469,34 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 	struct nft_rule_expr_iter *iter;
 	struct nft_rule_expr *expr;
 	int family = nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
+	struct nft_xt_ctx ctx = {
+		.state.cs = cs,
+		.family = family,
+		.flags = 0,
+	};
 
 	iter = nft_rule_expr_iter_create(r);
 	if (iter == NULL)
 		return;
 
+	ctx.iter = iter;
 	expr = nft_rule_expr_iter_next(iter);
 	while (expr != NULL) {
 		const char *name =
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
 		if (strcmp(name, "counter") == 0)
-			nft_parse_counter(expr, iter, &cs->counters);
+			nft_parse_counter(expr, &ctx.state.cs->counters);
 		else if (strcmp(name, "payload") == 0)
-			nft_parse_payload(expr, iter, family, cs);
+			nft_parse_payload(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
-			nft_parse_meta(expr, iter, family, cs);
+			nft_parse_meta(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
-			nft_parse_immediate(expr, iter, family, cs);
+			nft_parse_immediate(&ctx, expr);
 		else if (strcmp(name, "match") == 0)
-			nft_parse_match(expr, iter, cs);
+			nft_parse_match(&ctx, expr);
 		else if (strcmp(name, "target") == 0)
-			nft_parse_target(expr, iter, family, cs);
+			nft_parse_target(&ctx, expr);
 
 		expr = nft_rule_expr_iter_next(iter);
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 1c06b5f..c4936dd 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -6,6 +6,8 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
+#include <linux/netfilter_arp/arp_tables.h>
+
 #include "xshared.h"
 
 #if 0
@@ -36,6 +38,16 @@
 
 struct xtables_args;
 
+struct nft_xt_ctx {
+	union {
+		struct iptables_command_state *cs;
+		struct arpt_entry *fw;
+	} state;
+	struct nft_rule_expr_iter *iter;
+	int family;
+	uint32_t flags;
+};
+
 struct nft_family_ops {
 	int (*add)(struct nft_rule *r, void *data);
 	bool (*is_same)(const void *data_a,
@@ -88,19 +100,11 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 void print_proto(uint16_t proto, int invert);
 void get_cmp_data(struct nft_rule_expr_iter *iter,
 		  void *data, size_t dlen, bool *inv);
-void nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		      int family, void *data);
-void nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    int family, void *data);
-void nft_parse_payload(struct nft_rule_expr *e,
-		       struct nft_rule_expr_iter *iter,
-		       int family, void *data);
-void nft_parse_counter(struct nft_rule_expr *e,
-		       struct nft_rule_expr_iter *iter,
-		       struct xt_counters *counters);
-void nft_parse_immediate(struct nft_rule_expr *e,
-			 struct nft_rule_expr_iter *iter,
-			 int family, void *data);
+void nft_parse_target(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters);
+void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs);
 void print_firewall_details(const struct iptables_command_state *cs,
@@ -182,8 +186,6 @@ struct xtables_args {
 extern char *opcodes[];
 #define NUMOPCODES 9
 
-#include <linux/netfilter_arp/arp_tables.h>
-
 static inline struct xt_entry_target *nft_arp_get_target(struct arpt_entry *fw)
 {
 	struct xt_entry_target **target;
-- 
1.8.3.2

