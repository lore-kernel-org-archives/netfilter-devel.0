From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 8/9] xtables-save: Print chains in right order
Date: Tue, 16 Jul 2013 15:38:52 +0300
Message-ID: <1373978333-17427-9-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab3GPMjK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:39:10 -0400
In-Reply-To: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes the output which was:
:OUTPUT ACCEPT [4271:670423]
:FORWARD ACCEPT [0:0]
:INPUT ACCEPT [6434:597396]

Where it should be:
:INPUT ACCEPT [6434:597396]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [4271:670423]

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4ca1cec..2056032 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1124,8 +1124,21 @@ static void nft_chain_print_save(struct nft_chain *c, bool basechain)
 int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list,
 		   const char *table)
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
+		c = nft_chain_list_find(list, table, t->chains[i].name);
+		if (c != NULL)
+			nft_chain_print_save(c, true);
+	}
 
 	iter = nft_chain_list_iter_create(list);
 	if (iter == NULL)
@@ -1135,13 +1148,15 @@ int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list,
 	while (c != NULL) {
 		const char *chain_table =
 			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_TABLE);
-		bool basechain = false;
 
 		if (strcmp(table, chain_table) != 0)
 			goto next;
 
-		basechain = nft_chain_builtin(c);
-		nft_chain_print_save(c, basechain);
+		/* We already handled builtin chain */
+		if (nft_chain_builtin(c))
+			goto next;
+
+		nft_chain_print_save(c, false);
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
-- 
1.8.2.1

