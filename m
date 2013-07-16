From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 6/9] nft: Print chains in right order when listing rules
Date: Tue, 16 Jul 2013 15:38:50 +0300
Message-ID: <1373978333-17427-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab3GPMjI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:08 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes an output bug, it was:
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

where it should be:
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 230c4f7..2f03f63 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2464,10 +2464,12 @@ static void __nft_chain_rule_list(struct nft_handle *h, struct nft_chain *c,
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		  int rulenum, unsigned int format)
 {
+	const struct builtin_table *t;
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
 	bool round = false;
+	int i;
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
@@ -2482,6 +2484,22 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		goto out;
 	};
 
+	/* Let's print out builtin chains first, in right order */
+	t = nft_table_builtin_find(table);
+	if (t == NULL)
+		goto out;
+
+	for (i = 0; i < NF_IP_NUMHOOKS && t->chains[i].name != NULL; i++) {
+		if (round)
+			printf("\n");
+
+		c = nft_chain_list_find(list, table, t->chains[i].name);
+		if (c != NULL) {
+			__nft_chain_rule_list(h, c, table, rulenum, format);
+			round = true;
+		}
+	}
+
 	iter = nft_chain_list_iter_create(list);
 	if (iter == NULL)
 		goto out;
@@ -2494,12 +2512,12 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (strcmp(table, chain_table) != 0)
 			goto next;
 
-		if (round)
-			printf("\n");
+		/* we skip already listed builtin chains */
+		if (nft_chain_builtin(c))
+			goto next;
 
+		printf("\n");
 		__nft_chain_rule_list(h, c, table, rulenum, format);
-
-		round = true;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
-- 
1.8.2.1

