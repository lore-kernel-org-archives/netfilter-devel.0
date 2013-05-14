From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 5/6] xtables: add support for translating xtables matches into nft expressions
Date: Tue, 14 May 2013 13:52:06 +0300
Message-ID: <1368528727-10127-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab3ENKwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:18 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h.in |  3 +++
 iptables/nft.c       | 21 ++++++++++++++-------
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 74df61f..407c382 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -261,6 +261,9 @@ struct xtables_match
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* NFT related */
+	struct nft_rule_expr_list *(*translate_to_nft)(struct xt_entry_match *);
+
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 341d092..70aa1f8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -562,16 +562,23 @@ static void __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 	nft_rule_expr_set(e, NFT_EXPR_MT_INFO, info, m->u.match_size - sizeof(*m));
 }
 
-static void add_match(struct nft_rule *r, struct xt_entry_match *m)
+static void add_match(struct nft_rule *r, struct xtables_match *match)
 {
 	struct nft_rule_expr *expr;
+	struct nft_rule_expr_list *expr_list;
 
-	expr = nft_rule_expr_alloc("match");
-	if (expr == NULL)
-		return;
+	if (match->translate_to_nft == NULL) {
+		expr = nft_rule_expr_alloc("match");
+		if (expr == NULL)
+			return;
 
-	__add_match(expr, m);
-	nft_rule_add_expr(r, expr);
+		__add_match(expr, match->m);
+		nft_rule_add_expr(r, expr);
+	} else {
+		expr_list = match->translate_to_nft(match->m);
+		if (expr_list != NULL)
+			nft_rule_add_expr_list(r, expr_list);
+	}
 }
 
 static void __add_target(struct nft_rule_expr *e, struct xt_entry_target *t)
@@ -702,7 +709,7 @@ nft_rule_add(struct nft_handle *h, const char *chain, const char *table,
 	ip_flags = h->ops->add(r, cs);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next)
-		add_match(r, matchp->match->m);
+		add_match(r, matchp->match);
 
 	/* Counters need to me added before the target, otherwise they are
 	 * increased for each rule because of the way nf_tables works.
-- 
1.8.2.1

