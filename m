From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/3] mnl: add nft_batch_continue() helper
Date: Tue, 15 Jul 2014 17:47:16 +0200
Message-ID: <1405439238-10186-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ycnian@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43992 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbaGOPrS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:47:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Save some LOC with this function that wrap typical handling
after pushing the netlink message into the batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index a843fdc..d9ccff3 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -126,6 +126,12 @@ static void mnl_batch_page_add(void)
 	mnl_nlmsg_batch_next(batch);
 }
 
+static void nft_batch_continue(void)
+{
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+}
+
 static uint32_t mnl_batch_put(int type)
 {
 	struct nlmsghdr *nlh;
@@ -140,9 +146,7 @@ static uint32_t mnl_batch_put(int type)
 	nfg->nfgen_family = AF_INET;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return nlh->nlmsg_seq;
 }
@@ -303,8 +307,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 			NLM_F_CREATE | flags, seqnum);
 
 	nft_rule_nlmsg_build_payload(nlh, nlr);
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -320,9 +323,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 			0, seqnum);
 
 	nft_rule_nlmsg_build_payload(nlh, nlr);
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -431,9 +432,7 @@ int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -462,9 +461,7 @@ int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -560,9 +557,7 @@ int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			flags, seqnum);
 	nft_table_nlmsg_build_payload(nlh, nlt);
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -591,9 +586,7 @@ int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
 	nft_table_nlmsg_build_payload(nlh, nlt);
-
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -709,8 +702,7 @@ int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
 	nft_set_nlmsg_build_payload(nlh, nls);
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -725,8 +717,7 @@ int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			flags, seqnum);
 	nft_set_nlmsg_build_payload(nlh, nls);
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -853,8 +844,7 @@ int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
 	nft_set_elems_nlmsg_build_payload(nlh, nls);
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
@@ -869,8 +859,7 @@ int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			0, seqnum);
 	nft_set_elems_nlmsg_build_payload(nlh, nls);
-	if (!mnl_nlmsg_batch_next(batch))
-		mnl_batch_page_add();
+	nft_batch_continue();
 
 	return 0;
 }
-- 
1.7.10.4

