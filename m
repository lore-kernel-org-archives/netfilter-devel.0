From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-nftables 2/3] iptables: nft: remove unused code
Date: Tue, 10 Jun 2014 11:30:38 +0200
Message-ID: <1402392639-8071-2-git-send-email-pablo@netfilter.org>
References: <1402392639-8071-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49667 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaFJJar (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:30:47 -0400
In-Reply-To: <1402392639-8071-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove code to set table in dormant state, this is not required from
the iptables over nft compatibility layer.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   56 ++++----------------------------------------------------
 iptables/nft.h |    3 ---
 2 files changed, 4 insertions(+), 55 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 919b64d..884462c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -427,9 +427,8 @@ struct builtin_table xtables_arp[TABLES_MAX] = {
 	},
 };
 
-int
-nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
-			bool dormant)
+static int nft_table_builtin_add(struct nft_handle *h,
+				 struct builtin_table *_t)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -444,10 +443,6 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 		return -1;
 
 	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, (char *)_t->name);
-	if (dormant) {
-		nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS,
-					NFT_TABLE_F_DORMANT);
-	}
 
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
 					NLM_F_ACK|NLM_F_EXCL, h->seq);
@@ -582,7 +577,7 @@ nft_chain_builtin_init(struct nft_handle *h, const char *table,
 		ret = -1;
 		goto out;
 	}
-	if (nft_table_builtin_add(h, t, false) < 0) {
+	if (nft_table_builtin_add(h, t) < 0) {
 		/* Built-in table already initialized, skip. */
 		if (errno == EEXIST)
 			goto out;
@@ -653,49 +648,6 @@ int nft_chain_add(struct nft_handle *h, const struct nft_chain *c)
 	return mnl_talk(h, nlh, NULL, NULL);
 }
 
-int nft_table_set_dormant(struct nft_handle *h, const char *table)
-{
-	int ret = 0, i;
-	struct builtin_table *t;
-
-	t = nft_table_builtin_find(h, table);
-	if (t == NULL) {
-		ret = -1;
-		goto out;
-	}
-	/* Add this table as dormant */
-	if (nft_table_builtin_add(h, t, true) < 0) {
-		/* Built-in table already initialized, skip. */
-		if (errno == EEXIST)
-			goto out;
-	}
-	for (i=0; t->chains[i].name != NULL && i<NF_INET_NUMHOOKS; i++)
-		__nft_chain_builtin_init(h, t, t->chains[i].name, NF_ACCEPT);
-out:
-	return ret;
-}
-
-int nft_table_wake_dormant(struct nft_handle *h, const char *table)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	struct nft_table *t;
-
-	t = nft_table_alloc();
-	if (t == NULL)
-		return -1;
-
-	nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, (char *)table);
-	nft_table_attr_set_u32(t, NFT_TABLE_ATTR_FLAGS, 0);
-
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, h->family,
-					NLM_F_ACK, h->seq);
-	nft_table_nlmsg_build_payload(nlh, t);
-	nft_table_free(t);
-
-	return mnl_talk(h, nlh, NULL, NULL);
-}
-
 static void nft_chain_print_debug(struct nft_chain *c, struct nlmsghdr *nlh)
 {
 #ifdef NLDEBUG
@@ -721,7 +673,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 	_t = nft_table_builtin_find(h, table);
 	/* if this built-in table does not exists, create it */
 	if (_t != NULL)
-		nft_table_builtin_add(h, _t, false);
+		nft_table_builtin_add(h, _t);
 
 	_c = nft_chain_builtin_find(_t, chain);
 	if (_c != NULL) {
diff --git a/iptables/nft.h b/iptables/nft.h
index ddc5201..1e78edd 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -53,13 +53,10 @@ void nft_fini(struct nft_handle *h);
 struct nft_table;
 struct nft_chain_list;
 
-int nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t, bool dormant);
 struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
 int nft_table_add(struct nft_handle *h, const struct nft_table *t);
 int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, const char *tablename, bool counters), bool counters);
 bool nft_table_find(struct nft_handle *h, const char *tablename);
-int nft_table_set_dormant(struct nft_handle *h, const char *table);
-int nft_table_wake_dormant(struct nft_handle *h, const char *table);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nft_chain_list *list);
 
 /*
-- 
1.7.10.4

