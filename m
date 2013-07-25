From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  12/17] nft: Refactor firewall printing so it reuses already parsed cs struct
Date: Thu, 25 Jul 2013 20:16:32 +0300
Message-ID: <1374772597-20548-13-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab3GYRRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:17:00 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into a
command structure, it's now easier to print the rule from that command
structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 122 ++++++---------------------------------------------------
 1 file changed, 11 insertions(+), 111 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7b619b5..2a0fa77 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2357,95 +2357,18 @@ print_header(unsigned int format, const char *chain, const char *pol,
 }
 
 static void
-print_match(struct nft_rule_expr *expr, int numeric)
-{
-	size_t len;
-	const char *match_name = nft_rule_expr_get_str(expr, NFT_EXPR_MT_NAME);
-	const void *match_info = nft_rule_expr_get(expr, NFT_EXPR_MT_INFO, &len);
-	const struct xtables_match *match =
-		xtables_find_match(match_name, XTF_TRY_LOAD, NULL);
-	struct xt_entry_match *m =
-		calloc(1, sizeof(struct xt_entry_match) + len);
-
-	/* emulate struct xt_entry_match since ->print needs it */
-	memcpy((void *)&m->data, match_info, len);
-
-	if (match) {
-		if (match->print)
-			/* FIXME missing first parameter */
-			match->print(NULL, m, numeric);
-		else
-			printf("%s ", match_name);
-	} else {
-		if (match_name[0])
-			printf("UNKNOWN match `%s' ", match_name);
-	}
-
-	free(m);
-}
-
-static void
 print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 	       unsigned int num, unsigned int format)
 {
-	const struct xtables_target *target = NULL;
-	const char *targname = NULL;
-	const void *targinfo = NULL;
-	int family;
+	struct xtables_rule_match *matchp;
 	struct nft_family_ops *ops;
 	uint8_t flags = 0;
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	struct xt_entry_target *t;
-	size_t target_len = 0;
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "target") == 0) {
-			targname = nft_rule_expr_get_str(expr,
-							 NFT_EXPR_TG_NAME);
-			targinfo = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO,
-						     &target_len);
-			break;
-		} else if (strcmp(name, "immediate") == 0) {
-			uint32_t verdict =
-			nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
-
-			switch(verdict) {
-			case NF_ACCEPT:
-				targname = "ACCEPT";
-				break;
-			case NF_DROP:
-				targname = "DROP";
-				break;
-			case NFT_RETURN:
-				targname = "RETURN";
-				break;
-			case NFT_GOTO:
-				targname = nft_rule_expr_get_str(expr,
-							NFT_EXPR_IMM_CHAIN);
-				break;
-			case NFT_JUMP:
-				targname = nft_rule_expr_get_str(expr,
-							NFT_EXPR_IMM_CHAIN);
-			break;
-			}
-		}
-		expr = nft_rule_expr_iter_next(iter);
-	}
-	nft_rule_expr_iter_destroy(iter);
+	int family;
 
 	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
 	ops = nft_family_ops_lookup(family);
 
-	flags = ops->print_firewall(cs, targname, num, format);
+	flags = ops->print_firewall(cs, cs->jumpto, num, format);
 
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
@@ -2455,40 +2378,17 @@ print_firewall(const struct iptables_command_state *cs, struct nft_rule *r,
 		printf("[goto] ");
 #endif
 
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "match") == 0)
-			print_match(expr, format & FMT_NUMERIC);
-
-		expr = nft_rule_expr_iter_next(iter);
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (matchp->match->print != NULL)
+			matchp->match->print(NULL, matchp->match->m,
+							format & FMT_NUMERIC);
 	}
-	nft_rule_expr_iter_destroy(iter);
 
-	t = calloc(1, sizeof(struct xt_entry_target) + target_len);
-	if (t == NULL)
-		return;
-
-	/* emulate struct xt_entry_match since ->print needs it */
-	memcpy((void *)&t->data, targinfo, target_len);
-
-	if (targname) {
-		target = xtables_find_target(targname, XTF_TRY_LOAD);
-		if (target) {
-			if (target->print)
-				/* FIXME missing first parameter */
-				target->print(NULL, t, format & FMT_NUMERIC);
-		} else
-			printf("[%ld bytes of unknown target data] ",
-				target_len);
+	if (cs->target != NULL) {
+		if (cs->target->print != NULL)
+			cs->target->print(NULL, cs->target->t,
+							format & FMT_NUMERIC);
 	}
-	free(t);
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
-- 
1.8.3.2

