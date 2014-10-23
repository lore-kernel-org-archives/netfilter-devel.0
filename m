From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] iptables-compat: assume chain policy NF_ACCEPT when creating built-in chains
Date: Thu, 23 Oct 2014 13:18:49 +0200
Message-ID: <1414063129-10091-3-git-send-email-pablo@netfilter.org>
References: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58881 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbaJWLRT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:17:19 -0400
In-Reply-To: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Newly created (emulated) xt built-in chain have to use NF_ACCEPT. Remove
extra unused chain parameter and rename nft_chain_builtin_init to
nft_xt_builtin_init too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 33afae4..ac72bfa 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -563,11 +563,11 @@ int nft_chain_add(struct nft_handle *h, struct nft_chain *c, uint16_t flags)
 
 static void nft_chain_builtin_add(struct nft_handle *h,
 				  struct builtin_table *table,
-				  struct builtin_chain *chain, int policy)
+				  struct builtin_chain *chain)
 {
 	struct nft_chain *c;
 
-	c = nft_chain_builtin_alloc(table, chain, policy);
+	c = nft_chain_builtin_alloc(table, chain, NF_ACCEPT);
 	if (c == NULL)
 		return;
 
@@ -578,8 +578,8 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 }
 
 /* find if built-in table already exists */
-struct builtin_table *
-nft_table_builtin_find(struct nft_handle *h, const char *table)
+static struct builtin_table *nft_table_builtin_find(struct nft_handle *h,
+						    const char *table)
 {
 	int i;
 	bool found = false;
@@ -615,12 +615,10 @@ nft_chain_builtin_find(struct builtin_table *t, const char *chain)
 	return found ? &t->chains[i] : NULL;
 }
 
-static void
-__nft_chain_builtin_init(struct nft_handle *h,
-			 struct builtin_table *table, const char *chain,
-			 int policy)
+static void nft_chain_builtin_init(struct nft_handle *h,
+				   struct builtin_table *table)
 {
-	int i, default_policy;
+	int i;
 	struct nft_chain_list *list = nft_chain_dump(h);
 	struct nft_chain *c;
 
@@ -632,20 +630,13 @@ __nft_chain_builtin_init(struct nft_handle *h,
 		if (c != NULL)
 			continue;
 
-		if (chain && strcmp(table->chains[i].name, chain) == 0)
-			default_policy = policy;
-		else
-			default_policy = NF_ACCEPT;
-
-		nft_chain_builtin_add(h, table, &table->chains[i],
-					default_policy);
+		nft_chain_builtin_add(h, table, &table->chains[i]);
 	}
 
 	nft_chain_list_free(list);
 }
 
-static int nft_chain_builtin_init(struct nft_handle *h, const char *table,
-				  const char *chain, int policy)
+static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
 {
 	int ret = 0;
 	struct builtin_table *t;
@@ -660,7 +651,7 @@ static int nft_chain_builtin_init(struct nft_handle *h, const char *table,
 		if (errno == EEXIST)
 			goto out;
 	}
-	__nft_chain_builtin_init(h, t, chain, policy);
+	nft_chain_builtin_init(h, t);
 out:
 	return ret;
 }
@@ -1003,7 +994,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
+		nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_append;
 
@@ -1309,7 +1300,7 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+		nft_xt_builtin_init(h, table);
 
 	c = nft_chain_alloc();
 	if (c == NULL)
@@ -1466,7 +1457,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+		nft_xt_builtin_init(h, table);
 
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
@@ -1793,7 +1784,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
+		nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_insert;
 
@@ -1947,7 +1938,7 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+		nft_xt_builtin_init(h, table);
 
 	ops = nft_family_ops_lookup(h->family);
 
-- 
1.7.10.4

