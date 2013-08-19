From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 1/5] nft: Parse fully and properly at once a rule into a cs
Date: Mon, 19 Aug 2013 15:04:02 +0300
Message-ID: <1376913846-15996-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab3HSMEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:04:12 -0400
In-Reply-To: <1376913846-15996-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will help reducing code complexity in printing, saving, deleting
etc...

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft-shared.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index dd4766b..842523f 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -334,6 +334,57 @@ const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
 	return targname;
 }
 
+static void
+_nft_parse_target(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		 struct iptables_command_state *cs)
+{
+	size_t target_len;
+	const char *targname = nft_rule_expr_get_str(e, NFT_EXPR_TG_NAME);
+	const void *targinfo = nft_rule_expr_get(e,
+					NFT_EXPR_TG_INFO, &target_len);
+	struct xtables_target *target;
+	struct xt_entry_target *t;
+
+	target = xtables_find_target(targname, XTF_TRY_LOAD);
+	if (target == NULL)
+		return;
+
+	t = calloc(1, sizeof(struct xt_entry_target) + target_len);
+	memcpy(&t->data, targinfo, target_len);
+	t->u.target_size = target_len +
+				XT_ALIGN(sizeof(struct xt_entry_target));
+	t->u.user.revision = nft_rule_expr_get_u32(e, NFT_EXPR_TG_REV);
+	strcpy(t->u.user.name, target->name);
+
+	target->t = t;
+	cs->target = target;
+}
+
+static void
+nft_parse_match(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
+		struct iptables_command_state *cs)
+{
+	size_t match_len;
+	const char *match_name = nft_rule_expr_get_str(e, NFT_EXPR_MT_NAME);
+	const void *match_info = nft_rule_expr_get(e,
+						NFT_EXPR_MT_INFO, &match_len);
+	struct xtables_match *match;
+	struct xt_entry_match *m;
+
+	match = xtables_find_match(match_name, XTF_TRY_LOAD, &cs->matches);
+	if (match == NULL)
+		return;
+
+	m = calloc(1, sizeof(struct xt_entry_match) + match_len);
+
+	memcpy(&m->data, match_info, match_len);
+	m->u.match_size = match_len + XT_ALIGN(sizeof(struct xt_entry_match));
+	m->u.user.revision = nft_rule_expr_get_u32(e, NFT_EXPR_TG_REV);
+	strcpy(m->u.user.name, match->name);
+
+	match->m = m;
+}
+
 void print_proto(uint16_t proto, int invert)
 {
 	const struct protoent *pent = getprotobynumber(proto);
@@ -460,20 +511,30 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 		const char *name =
 			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
 
-		if (strcmp(name, "counter") == 0) {
+		if (strcmp(name, "counter") == 0)
 			nft_parse_counter(expr, iter, &cs->counters);
-		} else if (strcmp(name, "payload") == 0) {
+		else if (strcmp(name, "payload") == 0)
 			nft_parse_payload(expr, iter, family, cs);
-		} else if (strcmp(name, "meta") == 0) {
+		else if (strcmp(name, "meta") == 0)
 			nft_parse_meta(expr, iter, family, cs);
-		} else if (strcmp(name, "immediate") == 0) {
+		else if (strcmp(name, "immediate") == 0)
 			nft_parse_immediate(expr, iter, family, cs);
-		}
+		else if (strcmp(name, "target") == 0)
+			_nft_parse_target(expr, iter, cs);
+		else if (strcmp(name, "match") == 0)
+			nft_parse_match(expr, iter, cs);
 
 		expr = nft_rule_expr_iter_next(iter);
 	}
 
 	nft_rule_expr_iter_destroy(iter);
+
+	if (cs->target != NULL)
+		cs->jumpto = cs->target->name;
+	else if (cs->jumpto != NULL)
+		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+	else
+		cs->jumpto = "";
 }
 
 static void
-- 
1.8.3.2

