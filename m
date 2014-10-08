From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH xtables-compat 1/4] iptables-compat: nft: fix user chain addition, deletion and rename
Date: Wed,  8 Oct 2014 22:17:48 +0200
Message-ID: <1412799471-7721-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaJHUQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:16:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the glue code to use the chain batching for user chain commands.

Reported-by: Giuseppe Longo <giuseppelng@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c |   87 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 27 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 91e9133..ad4e5f9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -260,6 +260,8 @@ static void mnl_nft_batch_end(struct mnl_nlmsg_batch *batch, uint32_t seq)
 enum obj_update_type {
 	NFT_COMPAT_TABLE_ADD,
 	NFT_COMPAT_CHAIN_ADD,
+	NFT_COMPAT_CHAIN_USER_ADD,
+	NFT_COMPAT_CHAIN_USER_DEL,
 	NFT_COMPAT_CHAIN_UPDATE,
 	NFT_COMPAT_RULE_APPEND,
 	NFT_COMPAT_RULE_INSERT,
@@ -1304,8 +1306,6 @@ err:
 
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nft_chain *c;
 	int ret;
 
@@ -1320,12 +1320,19 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
-					NLM_F_ACK|NLM_F_EXCL, h->seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-	nft_chain_free(c);
+	if (h->batch_support) {
+		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+	} else {
+		char buf[MNL_SOCKET_BUFFER_SIZE];
+		struct nlmsghdr *nlh;
 
-	ret = mnl_talk(h, nlh, NULL, NULL);
+		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+						h->family,
+						NLM_F_ACK|NLM_F_EXCL, h->seq);
+		nft_chain_nlmsg_build_payload(nlh, c);
+		nft_chain_free(c);
+		ret = mnl_talk(h, nlh, NULL, NULL);
+	}
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1376,7 +1383,11 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *tabl
 		if (chain != NULL && strcmp(chain, chain_name) != 0)
 			goto next;
 
-		ret = __nft_chain_del(h, c);
+		if (h->batch_support)
+			ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_DEL, c);
+		else
+			ret = __nft_chain_del(h, c);
+
 		if (ret < 0)
 			break;
 
@@ -1390,11 +1401,14 @@ next:
 
 	nft_chain_list_iter_destroy(iter);
 err:
-	nft_chain_list_free(list);
+	if (!h->batch_support)
+		nft_chain_list_free(list);
 
 	/* chain not found */
-	if (ret < 0 && deleted_ctr == 0)
+	if (deleted_ctr == 0) {
+		ret = -1;
 		errno = ENOENT;
+	}
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1448,8 +1462,6 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 			  const char *table, const char *newname)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nft_chain *c;
 	uint64_t handle;
 	int ret;
@@ -1475,12 +1487,19 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)newname);
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
-					NLM_F_ACK, h->seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-	nft_chain_free(c);
+	if (h->batch_support) {
+		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+	} else {
+		char buf[MNL_SOCKET_BUFFER_SIZE];
+		struct nlmsghdr *nlh;
 
-	ret = mnl_talk(h, nlh, NULL, NULL);
+		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+						h->family, NLM_F_ACK, h->seq);
+		nft_chain_nlmsg_build_payload(nlh, c);
+		nft_chain_free(c);
+
+		ret = mnl_talk(h, nlh, NULL, NULL);
+	}
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2238,6 +2257,15 @@ static int nft_action(struct nft_handle *h, int action)
 						   NLM_F_CREATE, seq++,
 						   n->chain);
 			break;
+		case NFT_COMPAT_CHAIN_USER_ADD:
+			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN,
+						   NLM_F_EXCL, seq++,
+						   n->chain);
+			break;
+		case NFT_COMPAT_CHAIN_USER_DEL:
+			nft_compat_chain_batch_add(h, NFT_MSG_DELCHAIN,
+						   0, seq++, n->chain);
+			break;
 		case NFT_COMPAT_CHAIN_UPDATE:
 			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN,
 						   h->restore ?
@@ -2528,8 +2556,6 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 	struct nft_chain_list *list;
 	struct nft_chain_list_iter *iter;
 	struct nft_chain *c;
-	struct nlmsghdr *nlh;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
 	int ret = 0;
 
 	list = nft_chain_list_get(h);
@@ -2558,12 +2584,18 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 
 		nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
 
-		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
-						h->family, NLM_F_ACK, h->seq);
-
-		nft_chain_nlmsg_build_payload(nlh, c);
-
-		ret = mnl_talk(h, nlh, NULL, NULL);
+		if (h->batch_support) {
+			ret = batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
+		} else {
+			struct nlmsghdr *nlh;
+			char buf[MNL_SOCKET_BUFFER_SIZE];
+
+			nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+							h->family, NLM_F_ACK,
+							h->seq);
+			nft_chain_nlmsg_build_payload(nlh, c);
+			ret = mnl_talk(h, nlh, NULL, NULL);
+		}
 
 		if (chain != NULL)
 			break;
@@ -2571,11 +2603,12 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	if (!h->batch_support)
+		nft_chain_list_free(list);
+
 	nft_chain_list_iter_destroy(iter);
 
 err:
-	nft_chain_list_free(list);
-
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
 }
-- 
1.7.10.4

