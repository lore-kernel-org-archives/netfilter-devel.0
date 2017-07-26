From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] mnl: Remove dead code
Date: Wed, 26 Jul 2017 18:16:30 +0200
Message-ID: <20170726161630.12919-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36567 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750970AbdGZQQm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 12:16:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the functions mnl_nft_rule_add() and *_delete() since they are
not used throughout the code. Commit a72315d2bad47 ("src: add rule
batching support") changed their only caller to use the batch variant
introduced at the same time.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/mnl.h |  4 ----
 src/mnl.c     | 28 ----------------------------
 2 files changed, 32 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 9f5b34f60d023..3d2d7fef93ba2 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -33,10 +33,6 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 			       unsigned int flags, uint32_t seqnum);
 
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-		     unsigned int flags);
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *r,
-			unsigned int flags);
 struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					int family);
 
diff --git a/src/mnl.c b/src/mnl.c
index 7639312381507..3db80de6da02d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -339,34 +339,6 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 /*
  * Rule
  */
-int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-		     unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
-				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK | NLM_F_CREATE | flags, seq);
-	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
-int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nftnl_rule *nlr,
-			unsigned int flags)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
-				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
-				    NLM_F_ACK, seq);
-	nftnl_rule_nlmsg_build_payload(nlh, nlr);
-
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
-}
-
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nftnl_rule_list *nlr_list = data;
-- 
2.13.1

