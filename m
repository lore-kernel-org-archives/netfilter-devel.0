From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 4/5] iptables: nft: Refactor __nft_rule_check to return rule handle when relevant
Date: Wed, 31 Oct 2012 11:31:07 +0200
Message-ID: <1351675868-14302-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:18 -0400
In-Reply-To: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index dfbffc7..5dfacd8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2194,7 +2194,7 @@ __nft_rule_del(struct nft_handle *h, struct nft_rule *r)
 static int
 __nft_rule_check(struct nft_handle *h, const char *chain, const char *table,
 		 struct iptables_command_state *cs,
-		 bool delete, int rulenum, bool verbose)
+		 bool delete, bool replace, int rulenum, bool verbose)
 {
 	struct nft_rule_list *list;
 	struct nft_rule_list_iter *iter;
@@ -2276,7 +2276,8 @@ next:
 		if (delete) {
 			DEBUGP("deleting rule\n");
 			__nft_rule_del(h, r);
-		}
+		} else if (replace)
+			ret = nft_rule_attr_get_u16(r, NFT_RULE_ATTR_HANDLE);
 	}
 
 	nft_rule_list_iter_destroy(iter);
@@ -2294,7 +2295,7 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 {
 	nft_fn = nft_rule_check;
 
-	return __nft_rule_check(h, chain, table, e, false, -1, verbose);
+	return __nft_rule_check(h, chain, table, e, false, false, -1, verbose);
 }
 
 int nft_rule_delete(struct nft_handle *h, const char *chain,
@@ -2303,7 +2304,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 {
 	nft_fn = nft_rule_delete;
 
-	return __nft_rule_check(h, chain, table, e, true, -1, verbose);
+	return __nft_rule_check(h, chain, table, e, true, false, -1, verbose);
 }
 
 int nft_rule_delete_num(struct nft_handle *h, const char *chain,
@@ -2312,7 +2313,8 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 {
 	nft_fn = nft_rule_delete_num;
 
-	return __nft_rule_check(h, chain, table, NULL, true, rulenum, verbose);
+	return __nft_rule_check(h, chain, table,
+				NULL, true, false, rulenum, verbose);
 }
 
 int nft_rule_replace(struct nft_handle *h, const char *chain,
@@ -2323,7 +2325,8 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_replace;
 
-	ret = __nft_rule_check(h, chain, table, NULL, true, rulenum, verbose);
+	ret = __nft_rule_check(h, chain, table,
+			       NULL, false, true, rulenum, verbose);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.12.4

