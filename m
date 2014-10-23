From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] iptables-compat: statify unused built-in table/chain functions
Date: Thu, 23 Oct 2014 13:18:48 +0200
Message-ID: <1414063129-10091-2-git-send-email-pablo@netfilter.org>
References: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Cc: anarey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58880 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbaJWLRT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:17:19 -0400
In-Reply-To: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The functions that allows you to create built-in table and chains are
required out of the scope of nft.c

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   14 +++++++-------
 iptables/nft.h |    5 -----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index b68b275..33afae4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -518,7 +518,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
 	return ret;
 }
 
-struct nft_chain *
+static struct nft_chain *
 nft_chain_builtin_alloc(struct builtin_table *table,
 			struct builtin_chain *chain, int policy)
 {
@@ -561,8 +561,9 @@ int nft_chain_add(struct nft_handle *h, struct nft_chain *c, uint16_t flags)
 	return mnl_talk(h, nlh, NULL, NULL);
 }
 
-void nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
-			   struct builtin_chain *chain, int policy)
+static void nft_chain_builtin_add(struct nft_handle *h,
+				  struct builtin_table *table,
+				  struct builtin_chain *chain, int policy)
 {
 	struct nft_chain *c;
 
@@ -598,7 +599,7 @@ nft_table_builtin_find(struct nft_handle *h, const char *table)
 }
 
 /* find if built-in chain already exists */
-struct builtin_chain *
+static struct builtin_chain *
 nft_chain_builtin_find(struct builtin_table *t, const char *chain)
 {
 	int i;
@@ -643,9 +644,8 @@ __nft_chain_builtin_init(struct nft_handle *h,
 	nft_chain_list_free(list);
 }
 
-int
-nft_chain_builtin_init(struct nft_handle *h, const char *table,
-		       const char *chain, int policy)
+static int nft_chain_builtin_init(struct nft_handle *h, const char *table,
+				  const char *chain, int policy)
 {
 	int ret = 0;
 	struct builtin_table *t;
diff --git a/iptables/nft.h b/iptables/nft.h
index 339d7bc..0db2ed6 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -54,7 +54,6 @@ void nft_fini(struct nft_handle *h);
 struct nft_table;
 struct nft_chain_list;
 
-struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
 int nft_table_add(struct nft_handle *h, struct nft_table *t, uint16_t flags);
 int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, const char *tablename, bool counters), bool counters);
 bool nft_table_find(struct nft_handle *h, const char *tablename);
@@ -65,10 +64,6 @@ int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nft_c
  */
 struct nft_chain;
 
-struct nft_chain *nft_chain_builtin_alloc(struct builtin_table *table, struct builtin_chain *chain, int policy);
-void nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table, struct builtin_chain *chain, int policy);
-struct builtin_chain *nft_chain_builtin_find(struct builtin_table *t, const char *chain);
-int nft_chain_builtin_init(struct nft_handle *h, const char *table, const char *chain, int policy);
 int nft_chain_add(struct nft_handle *h, struct nft_chain *c, uint16_t flags);
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
 struct nft_chain_list *nft_chain_dump(struct nft_handle *h);
-- 
1.7.10.4

