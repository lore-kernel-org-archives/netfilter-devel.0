From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] mnl: fix crashes when using sets with many elements
Date: Wed, 23 Jul 2014 23:49:53 +0200
Message-ID: <1406152193-11497-3-git-send-email-pablo@netfilter.org>
References: <1406152193-11497-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49779 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaGWVtw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:49:52 -0400
In-Reply-To: <1406152193-11497-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft crashes when adding many elements into a set for two reasons:

1) The overflow of the nla_len field for the NFTA_SET_ELEM_LIST_ELEMENTS
   attribute.

2) Out-of-bound memory writes to the reserved area for the netlink
   message, which is solved by the patch entitled ("mnl: introduce
   NFT_NLMSG_MAXSIZE").

This patch adds the corresponding nla_len overflow check for
NFTA_SET_ELEM_LIST_ELEMENTS and it splits the elements in several
netlink messages. This should be enough when set updates are handled
by the transaction infrastructure

With this patch, nft should be now capable of adding an unlimited
number of elements to a given set.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=898
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 667aa3a..febf7c2 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -828,13 +828,24 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 {
 	char buf[NFT_NLMSG_MAXSIZE];
 	struct nlmsghdr *nlh;
+	struct nft_set_elems_iter *iter;
+	int ret, err;
 
-	nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			NLM_F_CREATE | NLM_F_ACK | flags, seq);
-	nft_set_elems_nlmsg_build_payload(nlh, nls);
+	iter = nft_set_elems_iter_create(nls);
+	if (iter == NULL)
+		memory_allocation_error();
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	do {
+		nlh = nft_set_elem_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
+				nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				NLM_F_CREATE | NLM_F_ACK | flags, seq);
+		ret = nft_set_elems_nlmsg_build_payload_iter(nlh, iter);
+		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	} while (ret > 0 && err >= 0);
+
+	nft_set_elems_iter_destroy(iter);
+
+	return err;
 }
 
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
@@ -861,13 +872,23 @@ int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			      unsigned int flags, uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
+	struct nft_set_elems_iter *iter;
+	int ret;
 
-	nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
-			NFT_MSG_NEWSETELEM,
-			nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-			NLM_F_CREATE | flags, seqnum);
-	nft_set_elems_nlmsg_build_payload(nlh, nls);
-	nft_batch_continue();
+	iter = nft_set_elems_iter_create(nls);
+	if (iter == NULL)
+		memory_allocation_error();
+
+	do {
+		nlh = nft_set_elem_nlmsg_build_hdr(nft_nlmsg_batch_current(),
+				NFT_MSG_NEWSETELEM,
+				nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
+				NLM_F_CREATE | flags, seqnum);
+		ret = nft_set_elems_nlmsg_build_payload_iter(nlh, iter);
+		nft_batch_continue();
+	} while (ret > 0);
+
+	nft_set_elems_iter_destroy(iter);
 
 	return 0;
 }
-- 
1.7.10.4

