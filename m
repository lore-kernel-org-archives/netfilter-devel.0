From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 2/9] nft: Handle error on adding rule expressions
Date: Tue, 16 Jul 2013 15:38:46 +0300
Message-ID: <1373978333-17427-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab3GPMjC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:02 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If adding one of match/target/jumpto/verdit/counters fails, adding a rule will
return an error.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 78 +++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f475d28..e62885b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -548,7 +548,7 @@ int nft_chain_set(struct nft_handle *h, const char *table,
 	return ret == 0 ? 1 : 0;
 }
 
-static void __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
+static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 {
 	void *info;
 
@@ -557,25 +557,30 @@ static void __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 
 	info = calloc(1, m->u.match_size);
 	if (info == NULL)
-		return;
+		return -ENOMEM;
 
 	memcpy(info, m->data, m->u.match_size);
 	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
+
+	return 0;
 }
 
-static void add_match(struct nft_rule *r, struct xt_entry_match *m)
+static int add_match(struct nft_rule *r, struct xt_entry_match *m)
 {
 	struct nft_rule_expr *expr;
+	int ret;
 
 	expr = nft_rule_expr_alloc("match");
 	if (expr == NULL)
-		return;
+		return -ENOMEM;
 
-	__add_match(expr, m);
+	ret = __add_match(expr, m);
 	nft_rule_add_expr(r, expr);
+
+	return ret;
 }
 
-static void __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
+static int __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 {
 	void *info = NULL;
 
@@ -586,51 +591,60 @@ static void __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
 	if (info == NULL) {
 		info = calloc(1, t->u.target_size);
 		if (info == NULL)
-			return;
+			return -ENOMEM;
 
 		memcpy(info, t->data, t->u.target_size);
 	}
 
 	nft_rule_expr_set(e, NFT_EXPR_TG_INFO, info, t->u.target_size - sizeof(*t));
+
+	return 0;
 }
 
-static void add_target(struct nft_rule *r, struct xt_entry_target *t)
+static int add_target(struct nft_rule *r, struct xt_entry_target *t)
 {
 	struct nft_rule_expr *expr;
+	int ret;
 
 	expr = nft_rule_expr_alloc("target");
 	if (expr == NULL)
-		return;
+		return -ENOMEM;
 
-	__add_target(expr, t);
+	ret = __add_target(expr, t);
 	nft_rule_add_expr(r, expr);
+
+	return ret;
 }
 
-static void add_jumpto(struct nft_rule *r, const char *name, int verdict)
+static int add_jumpto(struct nft_rule *r, const char *name, int verdict)
 {
 	struct nft_rule_expr *expr;
 
 	expr = nft_rule_expr_alloc("immediate");
 	if (expr == NULL)
-		return;
+		return -ENOMEM;
 
 	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DREG, NFT_REG_VERDICT);
 	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_VERDICT, verdict);
 	nft_rule_expr_set_str(expr, NFT_EXPR_IMM_CHAIN, (char *)name);
 	nft_rule_add_expr(r, expr);
+
+	return 0;
 }
 
-static void add_verdict(struct nft_rule *r, int verdict)
+static int add_verdict(struct nft_rule *r, int verdict)
 {
 	struct nft_rule_expr *expr;
 
 	expr = nft_rule_expr_alloc("immediate");
 	if (expr == NULL)
-		return;
+		return -ENOMEM;
 
 	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DREG, NFT_REG_VERDICT);
 	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_VERDICT, verdict);
 	nft_rule_add_expr(r, expr);
+
+	return 0;
 }
 
 static void nft_rule_print_debug(struct nft_rule *r, struct nlmsghdr *nlh)
@@ -644,18 +658,20 @@ static void nft_rule_print_debug(struct nft_rule *r, struct nlmsghdr *nlh)
 #endif
 }
 
-static void add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
+static int add_counters(struct nft_rule *r, uint64_t packets, uint64_t bytes)
 {
 	struct nft_rule_expr *expr;
 
 	expr = nft_rule_expr_alloc("counter");
 	if (expr == NULL)
-		return;
+		return -ENOMEM;
 
 	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_BYTES, packets);
 	nft_rule_expr_set_u64(expr, NFT_EXPR_CTR_PACKETS, bytes);
 
 	nft_rule_add_expr(r, expr);
+
+	return 0;
 }
 
 void add_compat(struct nft_rule *r, uint32_t proto, bool inv)
@@ -696,31 +712,43 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 
 	ip_flags = h->ops->add(r, cs);
 
-	for (matchp = cs->matches; matchp; matchp = matchp->next)
-		add_match(r, matchp->match->m);
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (add_match(r, matchp->match->m) < 0) {
+			ret = 0;
+			goto err;
+		}
+	}
 
 	/* Counters need to me added before the target, otherwise they are
 	 * increased for each rule because of the way nf_tables works.
 	 */
-	add_counters(r, cs->counters.pcnt, cs->counters.bcnt);
+	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0) {
+		ret = 0;
+		goto err;
+	}
 
 	/* If no target at all, add nothing (default to continue) */
 	if (cs->target != NULL) {
 		/* Standard target? */
 		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
-			add_verdict(r, NF_ACCEPT);
+			ret = add_verdict(r, NF_ACCEPT);
 		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
-			add_verdict(r, NF_DROP);
+			ret = add_verdict(r, NF_DROP);
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
-			add_verdict(r, NFT_RETURN);
+			ret = add_verdict(r, NFT_RETURN);
 		else
-			add_target(r, cs->target->t);
+			ret = add_target(r, cs->target->t);
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (ip_flags & IPT_F_GOTO)
-			add_jumpto(r, cs->jumpto, NFT_GOTO);
+			ret = add_jumpto(r, cs->jumpto, NFT_GOTO);
 		else
-			add_jumpto(r, cs->jumpto, NFT_JUMP);
+			ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
+	}
+
+	if (ret < 0) {
+		ret = 0;
+		goto err;
 	}
 
 	/* NLM_F_CREATE autoloads the built-in table if it does not exists */
-- 
1.8.2.1

