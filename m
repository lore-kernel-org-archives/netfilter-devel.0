From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 3/9] nft: Refactor and optimize nft_rule_list
Date: Tue, 16 Jul 2013 15:38:47 +0300
Message-ID: <1373978333-17427-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab3GPMjD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:03 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 61 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index e62885b..09a4e95 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2444,13 +2444,35 @@ err:
 	return ret;
 }
 
+static void __nft_chain_rule_list(struct nft_handle *h, struct nft_chain *c,
+				  const char *table, int rulenum,
+				  unsigned int format)
+{
+	const char *chain_name = nft_chain_attr_get_str(c,
+							NFT_CHAIN_ATTR_NAME);
+	uint32_t policy = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
+	int32_t refs = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_USE);
+	struct xt_counters ctrs = {
+		.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
+		.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
+	};
+	bool basechain = false;
+
+	if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
+		basechain = true;
+
+	print_header(format, chain_name, policy_name[policy],
+						&ctrs, basechain, refs);
+	__nft_rule_list(h, c, table, rulenum, format, print_firewall);
+}
+
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		  int rulenum, unsigned int format)
 {
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
-	bool found = false;
+	bool round = false;
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
@@ -2458,50 +2480,37 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	list = nft_chain_dump(h);
 
+	if (chain != NULL) {
+		c = nft_chain_list_find(h, list, table, chain);
+		if (c != NULL)
+			__nft_chain_rule_list(h, c, table, rulenum, format);
+		goto out;
+	};
+
 	iter = nft_chain_list_iter_create(list);
 	if (iter == NULL)
-		goto err;
+		goto out;
 
 	c = nft_chain_list_iter_next(iter);
 	while (c != NULL) {
 		const char *chain_table =
 			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_TABLE);
-		const char *chain_name =
-			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_NAME);
-		uint32_t policy =
-			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
-		uint32_t refs =
-			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_USE);
-		struct xt_counters ctrs = {
-			.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
-			.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
-		};
-		bool basechain = false;
-
-		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
-			basechain = true;
 
 		if (strcmp(table, chain_table) != 0)
 			goto next;
-		if (chain && strcmp(chain, chain_name) != 0)
-			goto next;
 
-		if (found)
+		if (round)
 			printf("\n");
 
-		print_header(format, chain_name, policy_name[policy], &ctrs,
-			     basechain, refs);
-
-		__nft_rule_list(h, c, table, rulenum, format, print_firewall);
-
-		found = true;
+		__nft_chain_rule_list(h, c, table, rulenum, format);
 
+		round = true;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
 	nft_chain_list_iter_destroy(iter);
-err:
+out:
 	nft_chain_list_free(list);
 
 	return 1;
-- 
1.8.2.1

