From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 1/3] xtables-compat: remove useless functions
Date: Sun, 21 Aug 2016 20:10:25 +0200
Message-ID: <20160821181027.14622-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35280 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752958AbcHUSLO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2016 14:11:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id i5so10389304wmg.2
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2016 11:11:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The static function nft_rule_list_get was exposed outside nft.c through
the nft_rule_list_create function, but this was never used out there.

A similar situation occurs with nftnl_rule_list_free and
nft_rule_list_destroy.

This patch removes nft_rule_list_create and nft_rule_list_destroy for
the sake of simplicity.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft.c | 38 ++++++++++++++------------------------
 iptables/nft.h |  3 ---
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 05ba57a..247a60a 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1766,16 +1766,6 @@ static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule_list *list,
 	return 1;
 }
 
-struct nftnl_rule_list *nft_rule_list_create(struct nft_handle *h)
-{
-	return nft_rule_list_get(h);
-}
-
-void nft_rule_list_destroy(struct nftnl_rule_list *list)
-{
-	nftnl_rule_list_free(list);
-}
-
 static struct nftnl_rule *
 nft_rule_find(struct nft_handle *h, struct nftnl_rule_list *list,
 	      const char *chain, const char *table, void *data, int rulenum)
@@ -1831,7 +1821,7 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_check;
 
-	list = nft_rule_list_create(h);
+	list = nft_rule_list_get(h);
 	if (list == NULL)
 		return 0;
 
@@ -1839,7 +1829,7 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 	if (ret == 0)
 		errno = ENOENT;
 
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 
 	return ret;
 }
@@ -1853,7 +1843,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_delete;
 
-	list = nft_rule_list_create(h);
+	list = nft_rule_list_get(h);
 	if (list == NULL)
 		return 0;
 
@@ -1865,7 +1855,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 
 	return ret;
 }
@@ -1906,7 +1896,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	nft_fn = nft_rule_insert;
 
 	if (rulenum > 0) {
-		list = nft_rule_list_create(h);
+		list = nft_rule_list_get(h);
 		if (list == NULL)
 			goto err;
 
@@ -1918,7 +1908,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 			r = nft_rule_find(h, list, chain, table, data,
 					  rulenum - 1);
 			if (r != NULL) {
-				nft_rule_list_destroy(list);
+				nftnl_rule_list_free(list);
 				return nft_rule_append(h, chain, table, data,
 						       0, verbose);
 			}
@@ -1930,12 +1920,12 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 		handle = nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE);
 		DEBUGP("adding after rule handle %"PRIu64"\n", handle);
 
-		nft_rule_list_destroy(list);
+		nftnl_rule_list_free(list);
 	}
 
 	return nft_rule_add(h, chain, table, data, handle, verbose);
 err:
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 	return 0;
 }
 
@@ -1948,7 +1938,7 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_delete_num;
 
-	list = nft_rule_list_create(h);
+	list = nft_rule_list_get(h);
 	if (list == NULL)
 		return 0;
 
@@ -1963,7 +1953,7 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 
 	return ret;
 }
@@ -1977,7 +1967,7 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_replace;
 
-	list = nft_rule_list_create(h);
+	list = nft_rule_list_get(h);
 	if (list == NULL)
 		return 0;
 
@@ -1993,7 +1983,7 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 
 	return ret;
 }
@@ -2256,7 +2246,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 
 	nft_fn = nft_rule_delete;
 
-	list = nft_rule_list_create(h);
+	list = nft_rule_list_get(h);
 	if (list == NULL)
 		return 0;
 
@@ -2276,7 +2266,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 			       false);
 
 error:
-	nft_rule_list_destroy(list);
+	nftnl_rule_list_free(list);
 
 	return ret;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 52f2136..bcabf42 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -92,9 +92,6 @@ int nft_rule_save(struct nft_handle *h, const char *table, bool counters);
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table);
 int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *table, int rulenum);
 
-struct nftnl_rule_list *nft_rule_list_create(struct nft_handle *h);
-void nft_rule_list_destroy(struct nftnl_rule_list *list);
-
 /*
  * Operations used in userspace tools
  */
-- 
2.9.3

