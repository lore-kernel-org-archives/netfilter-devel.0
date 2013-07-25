From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  03/17] xtables: add support for injecting xtables matches into nft rule
Date: Thu, 25 Jul 2013 20:16:23 +0300
Message-ID: <1374772597-20548-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383Ab3GYRQq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:46 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This bring the support for xtables matches extentions to be translated to
pure nft expression list in the given rule.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/xtables.h |  3 +++
 iptables/nft.c    | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 4d8874c..5bd8a59 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -271,6 +271,9 @@ struct xtables_match
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* NFT related */
+	int (*to_nft)(struct nft_rule *r, struct xt_entry_match *);
+
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
 
diff --git a/iptables/nft.c b/iptables/nft.c
index d178f19..685a203 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -573,17 +573,21 @@ static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
 	return 0;
 }
 
-static int add_match(struct nft_rule *r, struct xt_entry_match *m)
+static int add_match(struct nft_rule *r, struct xtables_match *match)
 {
-	struct nft_rule_expr *expr;
 	int ret;
 
-	expr = nft_rule_expr_alloc("match");
-	if (expr == NULL)
-		return -ENOMEM;
+	if (match->to_nft == NULL) {
+		struct nft_rule_expr *expr;
 
-	ret = __add_match(expr, m);
-	nft_rule_add_expr(r, expr);
+		expr = nft_rule_expr_alloc("match");
+		if (expr == NULL)
+			return -ENOMEM;
+
+		ret = __add_match(expr, match->m);
+		nft_rule_add_expr(r, expr);
+	} else
+		ret = match->to_nft(r, match->m);
 
 	return ret;
 }
@@ -712,7 +716,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	ip_flags = h->ops->add(r, cs);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (add_match(r, matchp->match->m) < 0)
+		if (add_match(r, matchp->match) < 0)
 			goto err;
 	}
 
-- 
1.8.3.2

