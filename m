From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: use nftnl_set_elems_nlmsg_build_payload_iter() when deleting elements
Date: Mon, 14 Nov 2016 22:41:59 +0100
Message-ID: <1479159719-1893-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932462AbcKNVmL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 16:42:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D380209420
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:42:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EE78DA849
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:42:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C294DA849
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 22:42:07 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise, nft crashes when deleting a very large number of elements.

*** stack smashing detected ***: nft terminated
Segmentation fault

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 52875f4a16da..137ecf0d1e01 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -867,8 +867,9 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
-			      uint32_t seqnum)
+static int mnl_nft_setelem_batch(struct nftnl_set *nls,
+				 enum nf_tables_msg_types cmd,
+				 unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 	struct nftnl_set_elems_iter *iter;
@@ -880,8 +881,7 @@ int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
 
 	do {
 		nlh = nftnl_set_elem_nlmsg_build_hdr(nftnl_batch_buffer(batch),
-				NFT_MSG_NEWSETELEM,
-				nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
+				cmd, nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 				NLM_F_CREATE | flags, seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
 		mnl_nft_batch_continue();
@@ -892,19 +892,16 @@ int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
 	return 0;
 }
 
-int mnl_nft_setelem_batch_del(struct nftnl_set *nls, unsigned int flags,
+int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
 			      uint32_t seqnum)
 {
-	struct nlmsghdr *nlh;
-
-	nlh = nftnl_set_elem_nlmsg_build_hdr(nftnl_batch_buffer(batch),
-			NFT_MSG_DELSETELEM,
-			nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-			0, seqnum);
-	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
-	mnl_nft_batch_continue();
+	return mnl_nft_setelem_batch(nls, NFT_MSG_NEWSETELEM, flags, seqnum);
+}
 
-	return 0;
+int mnl_nft_setelem_batch_del(struct nftnl_set *nls, unsigned int flags,
+			      uint32_t seqnum)
+{
+	return mnl_nft_setelem_batch(nls, NFT_MSG_DELSETELEM, flags, seqnum);
 }
 
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
-- 
2.1.4

