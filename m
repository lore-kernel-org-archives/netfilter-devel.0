From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 12/16] nft: Refactor rule deletion so it compares both cs structure
Date: Fri,  9 Aug 2013 16:31:26 +0300
Message-ID: <1376055090-26551-13-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINb6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:58 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that we parse properly, in one place and at once, the rule back into a
command structure, it's now easier to compare the rule from that command
structure when deleting.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 195 +++++++++++----------------------------------------------
 1 file changed, 35 insertions(+), 160 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7171752..2cd2f77 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1672,188 +1672,63 @@ next:
 	return 0;
 }
 
-static int matches_howmany(struct xtables_rule_match *matches)
-{
-	struct xtables_rule_match *matchp;
-	int matches_ctr = 0;
-
-	for (matchp = matches; matchp; matchp = matchp->next)
-		matches_ctr++;
-
-	return matches_ctr;
-}
-
 static bool
-__find_match(struct nft_rule_expr *expr, struct xtables_rule_match *matches)
+compare_matches(struct xtables_rule_match *matches_1,
+		struct xtables_rule_match *matches_2)
 {
-	const char *matchname = nft_rule_expr_get_str(expr, NFT_EXPR_MT_NAME);
-	/* Netlink aligns this match info, don't trust this length variable */
-	const char *data = nft_rule_expr_get_str(expr, NFT_EXPR_MT_INFO);
-	struct xtables_rule_match *matchp;
-	bool found = false;
+	struct xtables_rule_match *mp_1;
+	struct xtables_rule_match *mp_2;
 
-	for (matchp = matches; matchp; matchp = matchp->next) {
-		struct xt_entry_match *m = matchp->match->m;
+	for (mp_1 = matches_1, mp_2 = matches_2;
+			mp_1 && mp_2; mp_1 = mp_1->next, mp_2 = mp_2->next) {
+		struct xt_entry_match *m_1 = mp_1->match->m;
+		struct xt_entry_match *m_2 = mp_2->match->m;
 
-		if (strcmp(m->u.user.name, matchname) != 0) {
+		if (strcmp(m_1->u.user.name, m_2->u.user.name) != 0) {
 			DEBUGP("mismatching match name\n");
-			continue;
+			return false;
 		}
 
-		if (memcmp(data, m->data, m->u.user.match_size - sizeof(*m)) != 0) {
-			DEBUGP("mismatch match data\n");
-			continue;
+		if (m_1->u.user.match_size != m_2->u.user.match_size) {
+			DEBUGP("mismatching match size\n");
+			return false;
 		}
-		found = true;
-		break;
-	}
-
-	return found;
-}
-
-static bool find_matches(struct xtables_rule_match *matches, struct nft_rule *r)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	int kernel_matches = 0;
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return false;
 
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "match") == 0) {
-			if (!__find_match(expr, matches))
-				return false;
-
-			kernel_matches++;
+		if (memcmp(m_1->data, m_2->data,
+				m_1->u.user.match_size - sizeof(*m_1)) != 0) {
+			DEBUGP("mismatch match data\n");
+			return false;
 		}
-		expr = nft_rule_expr_iter_next(iter);
 	}
-	nft_rule_expr_iter_destroy(iter);
 
-	/* same number of matches? */
-	if (matches_howmany(matches) != kernel_matches)
-		return false;
-
-	return true;
-}
-
-static bool __find_target(struct nft_rule_expr *expr, struct xt_entry_target *t)
-{
-	size_t len;
-	const char *tgname = nft_rule_expr_get_str(expr, NFT_EXPR_TG_NAME);
-	/* Netlink aligns this target info, don't trust this length variable */
-	const char *data = nft_rule_expr_get(expr, NFT_EXPR_TG_INFO, &len);
-
-	if (strcmp(t->u.user.name, tgname) != 0) {
-		DEBUGP("mismatching target name\n");
+	/* Both cursor should be NULL */
+	if (mp_1 != mp_2) {
+		DEBUGP("mismatch matches amount\n");
 		return false;
 	}
 
-	if (memcmp(data, t->data,  t->u.user.target_size - sizeof(*t)) != 0)
-		return false;
-
 	return true;
 }
 
-static int targets_howmany(struct xtables_target *target)
-{
-	return target != NULL ? 1 : 0;
-}
-
 static bool
-find_target(struct xtables_target *target, struct nft_rule *r)
+compare_targets(struct xtables_target *target_1,
+		struct xtables_target *target_2)
 {
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	int kernel_targets = 0;
-
-	/* Special case: we use native immediate expressions to emulated
-	 * standard targets. Also, we don't want to crash with no targets.
-	 */
-	if (target == NULL || strcmp(target->name, "standard") == 0)
+	if (target_1 == NULL && target_2 == NULL)
 		return true;
 
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
+	if ((target_1 == NULL && target_2 != NULL) ||
+				(target_1 != NULL && target_2 == NULL))
 		return false;
 
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "target") == 0) {
-			/* we may support several targets in the future */
-			if (!__find_target(expr, target->t))
-				return false;
-
-			kernel_targets++;
-		}
-		expr = nft_rule_expr_iter_next(iter);
-	}
-	nft_rule_expr_iter_destroy(iter);
-
-	/* same number of targets? */
-	if (targets_howmany(target) != kernel_targets) {
-		DEBUGP("kernel targets is %d but we passed %d\n",
-		kernel_targets, targets_howmany(target));
+	if (strcmp(target_1->t->u.user.name, target_2->t->u.user.name) != 0)
 		return false;
-	}
 
-	return true;
-}
-
-static bool
-find_immediate(struct nft_rule *r, const char *jumpto)
-{
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
+	if (memcmp(target_1->t->data, target_2->t->data,
+					target_1->t->u.user.target_size -
+						sizeof(*target_1->t)) != 0)
 		return false;
 
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
-
-		if (strcmp(name, "immediate") == 0) {
-			int verdict = nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_VERDICT);
-			const char *verdict_name = NULL;
-
-			/* No target specified but immediate shows up, this
-			 * is not the rule we are looking for.
-			 */
-			if (strlen(jumpto) == 0)
-				return false;
-
-			switch(verdict) {
-			case NF_ACCEPT:
-				verdict_name = "ACCEPT";
-				break;
-			case NF_DROP:
-				verdict_name = "DROP";
-				break;
-			case NFT_RETURN:
-				verdict_name = "RETURN";
-				break;
-			}
-
-			/* Standard target? */
-			if (verdict_name && strcmp(jumpto, verdict_name) != 0)
-				return false;
-		}
-		expr = nft_rule_expr_iter_next(iter);
-	}
-	nft_rule_expr_iter_destroy(iter);
-
 	return true;
 }
 
@@ -1932,18 +1807,18 @@ nft_rule_find(struct nft_rule_list *list, const char *chain, const char *table,
 			if (!ops->is_same(cs, &this))
 				goto next;
 
-			if (!find_matches(cs->matches, r)) {
-				DEBUGP("matches not found\n");
+			if (!compare_matches(cs->matches, this.matches)) {
+				DEBUGP("Different matches\n");
 				goto next;
 			}
 
-			if (!find_target(cs->target, r)) {
-				DEBUGP("target not found\n");
+			if (!compare_targets(cs->target, this.target)) {
+				DEBUGP("Different target\n");
 				goto next;
 			}
 
-			if (!find_immediate(r, cs->jumpto)) {
-				DEBUGP("immediate not found\n");
+			if (strcmp(cs->jumpto, this.jumpto) != 0) {
+				DEBUGP("Different verdict\n");
 				goto next;
 			}
 
-- 
1.8.3.2

