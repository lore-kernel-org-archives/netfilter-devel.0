From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables-compat: fix empty chains after first invocation of iptables-compat -L
Date: Thu, 23 Oct 2014 13:36:10 +0200
Message-ID: <1414064170-14712-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbaJWLen (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:34:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # iptables-compat -L
 # iptables-compat -L
 Chain INPUT (policy ACCEPT)
 target     prot opt source               destination

 Chain FORWARD (policy ACCEPT)
 target     prot opt source               destination

 Chain OUTPUT (policy ACCEPT)
 target     prot opt source               destination

Note that the second (and follow up) invocations after the first one
display the chains.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 52c89b9..5492a8f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1937,8 +1937,14 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	bool found = false;
 
 	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
+	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
 		nft_xt_builtin_init(h, table);
+		/* Force table and chain creation, otherwise first iptables -L
+		 * lists no table/chains.
+		 */
+		if (!list_empty(&h->obj_list))
+			nft_commit(h);
+	}
 
 	ops = nft_family_ops_lookup(h->family);
 
-- 
1.7.10.4

