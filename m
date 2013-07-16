From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 4/9] xtables: Remove useless parameter to nft_chain_list_find
Date: Tue, 16 Jul 2013 15:38:48 +0300
Message-ID: <1373978333-17427-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab3GPMjE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:04 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c             | 6 +++---
 iptables/nft.h             | 2 +-
 iptables/xtables-restore.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 09a4e95..bcb834e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1428,7 +1428,7 @@ err:
 }
 
 struct nft_chain *
-nft_chain_list_find(struct nft_handle *h, struct nft_chain_list *list,
+nft_chain_list_find(struct nft_chain_list *list,
 		    const char *table, const char *chain)
 {
 	struct nft_chain_list_iter *iter;
@@ -1469,7 +1469,7 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 	if (list == NULL)
 		return NULL;
 
-	return nft_chain_list_find(h, list, table, chain);
+	return nft_chain_list_find(list, table, chain);
 }
 
 int nft_chain_user_rename(struct nft_handle *h,const char *chain,
@@ -2481,7 +2481,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	list = nft_chain_dump(h);
 
 	if (chain != NULL) {
-		c = nft_chain_list_find(h, list, table, chain);
+		c = nft_chain_list_find(list, table, chain);
 		if (c != NULL)
 			__nft_chain_rule_list(h, c, table, rulenum, format);
 		goto out;
diff --git a/iptables/nft.h b/iptables/nft.h
index 082260e..a647671 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -37,7 +37,7 @@ struct nft_chain;
 int nft_chain_add(struct nft_handle *h, const struct nft_chain *c);
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 struct nft_chain_list *nft_chain_dump(struct nft_handle *h);
-struct nft_chain *nft_chain_list_find(struct nft_handle *h, struct nft_chain_list *list, const char *table, const char *chain);
+struct nft_chain *nft_chain_list_find(struct nft_chain_list *list, const char *table, const char *chain);
 int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list, const char *table);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index e66f10c..8469ba1 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -326,7 +326,7 @@ xtables_restore_main(int argc, char *argv[])
 				exit(1);
 			}
 
-			chain_obj = nft_chain_list_find(&h, chain_list,
+			chain_obj = nft_chain_list_find(chain_list,
 							curtable, chain);
 			/* This chain has been found, delete from list. Later
 			 * on, unvisited chains will be purged out.
-- 
1.8.2.1

