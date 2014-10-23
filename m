From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] iptables-compat: fix chain policy reset with iptables -L -n
Date: Thu, 23 Oct 2014 13:18:47 +0200
Message-ID: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58879 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbaJWLRT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:17:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Initialize built-in tables/chains if they don't exists, otherwise
simply skip.

This avoids the chain policy reset to NF_ACCEPT by when you call
iptables -L -n.

Reported-by: Ana Rey <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ca199cd..b68b275 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -620,11 +620,17 @@ __nft_chain_builtin_init(struct nft_handle *h,
 			 int policy)
 {
 	int i, default_policy;
+	struct nft_chain_list *list = nft_chain_dump(h);
+	struct nft_chain *c;
 
-	/* Initialize all built-in chains. Exception, for e one received as
-	 * parameter, set the default policy as requested.
-	 */
+	/* Initialize built-in chains if they don't exist yet */
 	for (i=0; i<NF_IP_NUMHOOKS && table->chains[i].name != NULL; i++) {
+
+		c = nft_chain_list_find(list, table->name,
+					table->chains[i].name);
+		if (c != NULL)
+			continue;
+
 		if (chain && strcmp(table->chains[i].name, chain) == 0)
 			default_policy = policy;
 		else
@@ -633,6 +639,8 @@ __nft_chain_builtin_init(struct nft_handle *h,
 		nft_chain_builtin_add(h, table, &table->chains[i],
 					default_policy);
 	}
+
+	nft_chain_list_free(list);
 }
 
 int
-- 
1.7.10.4

