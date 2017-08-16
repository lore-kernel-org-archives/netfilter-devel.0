From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 5/5] src: mnl: Remove unused functions.
Date: Wed, 16 Aug 2017 19:48:17 +0530
Message-ID: <20170816141817.20179-6-rvarsha016@gmail.com>
References: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36717 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdHPOTX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:19:23 -0400
Received: by mail-pg0-f66.google.com with SMTP id y129so5379703pgy.3
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:19:23 -0700 (PDT)
In-Reply-To: <20170816141817.20179-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Functions mnl_nft_chain_get(), mnl_nft_rule_add(),
mnl_nft_rule_delete(), mnl_nft_set_get(), mnl_nft_table_get(),
set_get_cb(), table_get_cb() and chain_get_cb() are only defined
but not used, so remove them.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 include/mnl.h | 10 -------
 src/mnl.c     | 94 -----------------------------------------------------------
 2 files changed, 104 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 7df0823..affbf74 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -33,10 +33,6 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 			       unsigned int flags, uint32_t seqnum);
 
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-		     unsigned int flags, uint32_t seqnum);
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-			unsigned int flags, uint32_t seqnum);
 struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					  int family, uint32_t seqnum);
 
@@ -50,8 +46,6 @@ int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
 struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					    int family, uint32_t seqnum);
-int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 		      unsigned int flags, uint32_t seqnum);
@@ -63,8 +57,6 @@ int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
 struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					    int family, uint32_t seqnum);
-int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags, uint32_t seqnum);
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		    unsigned int flags, uint32_t seqnum);
@@ -76,8 +68,6 @@ int mnl_nft_set_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
 struct nftnl_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
 					const char *table, uint32_t seqnum);
-int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    uint32_t seqnum);
 
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			unsigned int flags, uint32_t seqnum);
diff --git a/src/mnl.c b/src/mnl.c
index b0f5191..f5859c9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -336,33 +336,6 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 /*
  * Rule
  */
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-		     unsigned int flags, uint32_t seqnum)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
-				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK | NLM_F_CREATE | flags, seqnum);
-	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
-}
-
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-			unsigned int flags, uint32_t seqnum)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
-				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK, seqnum);
-	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
-}
 
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -524,27 +497,6 @@ err:
 	return NULL;
 }
 
-static int chain_get_cb(const struct nlmsghdr *nlh, void *data)
-{
-	nftnl_chain_nlmsg_parse(nlh, data);
-	return MNL_CB_OK;
-}
-
-int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags, uint32_t seqnum)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
-				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    seqnum, NLM_F_ACK | flags);
-	nftnl_chain_nlmsg_build_payload(nlh, nlc);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, chain_get_cb,
-			    nlc);
-}
-
 /*
  * Table
  */
@@ -655,29 +607,6 @@ err:
 	return NULL;
 }
 
-static int table_get_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nftnl_table *t = data;
-
-	nftnl_table_nlmsg_parse(nlh, t);
-	return MNL_CB_OK;
-}
-
-int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags, uint32_t seqnum)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
-				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK, seqnum);
-	nftnl_table_nlmsg_build_payload(nlh, nlt);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, table_get_cb,
-			    nlt);
-}
-
 /*
  * Set
  */
@@ -906,29 +835,6 @@ err:
 	return NULL;
 }
 
-static int set_get_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nftnl_set *s = data;
-
-	nftnl_set_nlmsg_parse(nlh, s);
-	return MNL_CB_OK;
-}
-
-int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    uint32_t seqnum)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET,
-				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_ACK, seqnum);
-	nftnl_set_nlmsg_build_payload(nlh, nls);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_get_cb,
-			    nls);
-}
-
 /*
  * Set elements
  */
-- 
2.13.5

