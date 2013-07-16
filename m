From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 7/9] nft: Print chains in right order when saving rules
Date: Tue, 16 Jul 2013 15:38:51 +0300
Message-ID: <1373978333-17427-8-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab3GPMjJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:09 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes the output which was:
-P OUTPUT ACCEPT
-P FORWARD ACCEPT
-P INPUT ACCEPT

Where it should be:
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 46 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2f03f63..4ca1cec 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2540,8 +2540,36 @@ static int
 nft_rule_list_chain_save(struct nft_handle *h, const char *table,
 			 struct nft_chain_list *list, int counters)
 {
+	const struct builtin_table *t;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
+	int i;
+
+	/* Let's print out builtin chains first, in right order */
+	t = nft_table_builtin_find(table);
+	if (t == NULL)
+		return 0;
+
+	for (i = 0; i < NF_IP_NUMHOOKS && t->chains[i].name != NULL; i++) {
+		uint32_t policy;
+
+		c = nft_chain_list_find(list, table, t->chains[i].name);
+		if (c == NULL)
+			return 0;
+
+		policy = nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
+
+		printf("-P %s %s", t->chains[i].name, policy_name[policy]);
+		if (counters) {
+			printf(" -c %"PRIu64" %"PRIu64"\n",
+				nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_PACKETS),
+				nft_chain_attr_get_u64(c,
+						NFT_CHAIN_ATTR_BYTES));
+		}
+
+		printf("\n");
+	}
 
 	iter = nft_chain_list_iter_create(list);
 	if (iter == NULL)
@@ -2553,25 +2581,15 @@ nft_rule_list_chain_save(struct nft_handle *h, const char *table,
 			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_TABLE);
 		const char *chain_name =
 			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_NAME);
-		uint32_t policy =
-			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
 
 		if (strcmp(table, chain_table) != 0)
 			goto next;
 
-		/* this is a base chain */
-		if (nft_chain_builtin(c)) {
-			printf("-P %s %s", chain_name, policy_name[policy]);
+		/* we already handled builtin chains */
+		if (nft_chain_builtin(c))
+			goto next;
 
-			if (counters) {
-				printf(" -c %"PRIu64" %"PRIu64"\n",
-					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
-					nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES));
-			} else
-				printf("\n");
-		} else {
-			printf("-N %s\n", chain_name);
-		}
+		printf("-N %s\n", chain_name);
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
-- 
1.8.2.1

