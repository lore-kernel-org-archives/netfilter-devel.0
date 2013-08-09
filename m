From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 02/16] xtables: add support for injecting xtables matches into nft rule
Date: Fri,  9 Aug 2013 16:31:16 +0300
Message-ID: <1376055090-26551-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINbk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:40 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
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
index 68861a8..d92e8bb 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -558,17 +558,21 @@ static int __add_match(struct nft_rule_expr *e, struct xt_entry_match *m)
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
@@ -697,7 +701,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	ip_flags = h->ops->add(r, cs);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (add_match(r, matchp->match->m) < 0)
+		if (add_match(r, matchp->match) < 0)
 			goto err;
 	}
 
-- 
1.8.3.2

