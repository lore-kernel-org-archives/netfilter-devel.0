From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 4/5] nft: Remove useless error message
Date: Tue, 11 Feb 2014 18:36:45 +0200
Message-ID: <1392136606-10339-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaBKQhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:37:00 -0500
In-Reply-To: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These are not helpful.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 45 +++++----------------------------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ac1afa4..32d3dbb 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -463,11 +463,6 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 #endif
 
 	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret < 0) {
-		if (errno != EEXIST)
-			perror("mnl-talk:nft_table_init_one");
-	}
-
 	if (ret == 0 || errno == EEXIST)
 		_t->initialized = true;
 
@@ -513,10 +508,7 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 	nft_chain_nlmsg_build_payload(nlh, c);
 	nft_chain_free(c);
 
-	if (mnl_talk(h, nlh, NULL, NULL) < 0) {
-		if (errno != EEXIST)
-			perror("mnl_talk:nft_chain_builtin_add");
-	}
+	mnl_talk(h, nlh, NULL, NULL);
 }
 
 /* find if built-in table already exists */
@@ -725,7 +717,6 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 	struct nft_chain *c;
 	struct builtin_table *_t;
 	struct builtin_chain *_c;
-	int ret;
 
 	_t = nft_table_builtin_find(h, table);
 	/* if this built-in table does not exists, create it */
@@ -759,11 +750,7 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 
 	nft_chain_free(c);
 
-	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret < 0)
-		perror("mnl_talk:__nft_chain_policy");
-
-	return ret;
+	return mnl_talk(h, nlh, NULL, NULL);
 }
 
 int nft_chain_set(struct nft_handle *h, const char *table,
@@ -1106,7 +1093,6 @@ static struct nft_chain_list *nft_chain_list_get(struct nft_handle *h)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	int ret;
 	struct nft_chain_list *list;
 
 	list = nft_chain_list_alloc();
@@ -1118,9 +1104,7 @@ static struct nft_chain_list *nft_chain_list_get(struct nft_handle *h)
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nft_chain_list_cb, list);
-	if (ret < 0)
-		perror("mnl_talk:nft_chain_list_get");
+	mnl_talk(h, nlh, nft_chain_list_cb, list);
 
 	return list;
 }
@@ -1228,7 +1212,6 @@ static struct nft_rule_list *nft_rule_list_get(struct nft_handle *h)
 
 	ret = mnl_talk(h, nlh, nft_rule_list_cb, list);
 	if (ret < 0) {
-		perror("mnl_talk:nft_rule_save");
 		nft_rule_list_free(list);
 		return NULL;
 	}
@@ -1363,10 +1346,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	nft_chain_free(c);
 
 	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret < 0) {
-		if (errno != EEXIST)
-			perror("mnl_talk:nft_chain_add");
-	}
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1376,19 +1355,12 @@ static int __nft_chain_del(struct nft_handle *h, struct nft_chain *c)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	int ret;
 
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN, h->family,
 					NLM_F_ACK, h->seq);
 	nft_chain_nlmsg_build_payload(nlh, c);
 
-	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret < 0) {
-		if (errno != EEXIST && errno != ENOENT)
-			perror("mnl_talk:__nft_chain_del");
-	}
-
-	return ret;
+	return mnl_talk(h, nlh, NULL, NULL);
 }
 
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table)
@@ -1529,10 +1501,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nft_chain_free(c);
 
 	ret = mnl_talk(h, nlh, NULL, NULL);
-	if (ret < 0) {
-		if (errno != EEXIST)
-			perror("mnl_talk:nft_chain_rename");
-	}
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1567,7 +1535,6 @@ static struct nft_table_list *nft_table_list_get(struct nft_handle *h)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	int ret;
 	struct nft_table_list *list;
 
 	list = nft_table_list_alloc();
@@ -1577,9 +1544,7 @@ static struct nft_table_list *nft_table_list_get(struct nft_handle *h)
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nft_table_list_cb, list);
-	if (ret < 0)
-		perror("mnl_talk:nft_table_list_get");
+	mnl_talk(h, nlh, nft_table_list_cb, list);
 
 	return list;
 }
-- 
1.8.3.2

