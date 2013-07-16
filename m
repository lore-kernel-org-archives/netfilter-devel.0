From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 5/9] nft: Une one unique function to test for a builtin chain
Date: Tue, 16 Jul 2013 15:38:49 +0300
Message-ID: <1373978333-17427-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab3GPMjG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:06 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index bcb834e..230c4f7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -381,6 +381,14 @@ out:
 	return ret;
 }
 
+static bool nft_chain_builtin(struct nft_chain *c)
+{
+	/* Check if this chain has hook number, in that case is built-in.
+	 * Should we better export the flags to user-space via nf_tables?
+	 */
+	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
+}
+
 int nft_init(struct nft_handle *h)
 {
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
@@ -1132,9 +1140,7 @@ int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list,
 		if (strcmp(table, chain_table) != 0)
 			goto next;
 
-		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
-			basechain = true;
-
+		basechain = nft_chain_builtin(c);
 		nft_chain_print_save(c, basechain);
 next:
 		c = nft_chain_list_iter_next(iter);
@@ -1362,14 +1368,6 @@ static int __nft_chain_del(struct nft_handle *h, struct nft_chain *c)
 	return ret;
 }
 
-static bool nft_chain_builtin(struct nft_chain *c)
-{
-	/* Check if this chain has hook number, in that case is built-in.
-	 * Should we better export the flags to user-space via nf_tables?
-	 */
-	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
-}
-
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table)
 {
 	struct nft_chain_list *list;
@@ -2456,10 +2454,7 @@ static void __nft_chain_rule_list(struct nft_handle *h, struct nft_chain *c,
 		.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
 		.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
 	};
-	bool basechain = false;
-
-	if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
-		basechain = true;
+	bool basechain = nft_chain_builtin(c);
 
 	print_header(format, chain_name, policy_name[policy],
 						&ctrs, basechain, refs);
@@ -2547,7 +2542,7 @@ nft_rule_list_chain_save(struct nft_handle *h, const char *table,
 			goto next;
 
 		/* this is a base chain */
-		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM)) {
+		if (nft_chain_builtin(c)) {
 			printf("-P %s %s", chain_name, policy_name[policy]);
 
 			if (counters) {
-- 
1.8.2.1

