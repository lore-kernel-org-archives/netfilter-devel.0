From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] mnl: add nft_nlmsg_batch_current() helper
Date: Tue, 15 Jul 2014 17:47:17 +0200
Message-ID: <1405439238-10186-2-git-send-email-pablo@netfilter.org>
References: <1405439238-10186-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, ycnian@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaGOPrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:47:20 -0400
In-Reply-To: <1405439238-10186-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index d9ccff3..e4f0339 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -106,13 +106,18 @@ struct batch_page {
 	struct mnl_nlmsg_batch *batch;
 };
 
+static void *nft_nlmsg_batch_current(void)
+{
+	return mnl_nlmsg_batch_current(batch);
+}
+
 static void mnl_batch_page_add(void)
 {
 	struct batch_page *batch_page;
 	struct nlmsghdr *last_nlh;
 
 	/* Get the last message not fitting in the batch */
-	last_nlh = mnl_nlmsg_batch_current(batch);
+	last_nlh = nft_nlmsg_batch_current();
 
 	batch_page = xmalloc(sizeof(struct batch_page));
 	batch_page->batch = batch;
@@ -121,7 +126,7 @@ static void mnl_batch_page_add(void)
 	batch = mnl_batch_alloc();
 
 	/* Copy the last message not fitting to the new batch page */
-	memcpy(mnl_nlmsg_batch_current(batch), last_nlh, last_nlh->nlmsg_len);
+	memcpy(nft_nlmsg_batch_current(), last_nlh, last_nlh->nlmsg_len);
 	/* No overflow may happen as this is a new empty batch page */
 	mnl_nlmsg_batch_next(batch);
 }
@@ -137,7 +142,7 @@ static uint32_t mnl_batch_put(int type)
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfg;
 
-	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh = mnl_nlmsg_put_header(nft_nlmsg_batch_current());
 	nlh->nlmsg_type = type;
 	nlh->nlmsg_flags = NLM_F_REQUEST;
 	nlh->nlmsg_seq = mnl_seqnum_alloc();
@@ -301,7 +306,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_rule_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -317,7 +322,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_rule_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_DELRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			0, seqnum);
@@ -427,7 +432,7 @@ int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_chain_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_NEWCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -456,7 +461,7 @@ int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_chain_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_DELCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
@@ -552,7 +557,7 @@ int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_table_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_NEWTABLE,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			flags, seqnum);
@@ -581,7 +586,7 @@ int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_table_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_DELTABLE,
 			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
@@ -697,7 +702,7 @@ int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_set_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_NEWSET,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -712,7 +717,7 @@ int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_set_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_DELSET,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			flags, seqnum);
@@ -839,7 +844,7 @@ int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_elem_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_NEWSETELEM,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			NLM_F_CREATE | flags, seqnum);
@@ -854,7 +859,7 @@ int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_set_elem_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
 			NFT_MSG_DELSETELEM,
 			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
 			0, seqnum);
-- 
1.7.10.4

