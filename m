From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 4/6] src: add struct mnl_ctx
Date: Tue, 22 Aug 2017 19:05:09 +0200
Message-ID: <1503421511-17814-5-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751679AbdHVRFd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C519D25FA
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58B1EDA2D0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:16 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new structure contains the netlink socket and the sequence number.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |   6 ++-
 src/mnl.c     | 127 ++++++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 94 insertions(+), 39 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index affbf746688e..72072f7f9a00 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -3,8 +3,12 @@
 
 #include <list.h>
 #include <netlink.h>
+#include <libmnl/libmnl.h>
 
-struct mnl_socket;
+struct mnl_ctx {
+	struct mnl_socket	*nf_sock;
+	unsigned int		seqnum;
+};
 
 struct mnl_socket *netlink_open_sock(void);
 void netlink_close_sock(struct mnl_socket *nf_sock);
diff --git a/src/mnl.c b/src/mnl.c
index f57982da1bc5..4f9c30c25d8f 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -44,19 +44,19 @@ uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
 #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
 
 static int
-nft_mnl_recv(struct mnl_socket *nf_sock, uint32_t seqnum, uint32_t portid,
+nft_mnl_recv(struct mnl_ctx *ctx, uint32_t portid,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
 	int ret;
 
-	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+	ret = mnl_socket_recvfrom(ctx->nf_sock, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seqnum, portid, cb, cb_data);
+		ret = mnl_cb_run(buf, ret, ctx->seqnum, portid, cb, cb_data);
 		if (ret <= 0)
 			goto out;
 
-		ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
+		ret = mnl_socket_recvfrom(ctx->nf_sock, buf, sizeof(buf));
 	}
 out:
 	if (ret < 0 && errno == EAGAIN)
@@ -66,19 +66,18 @@ out:
 }
 
 static int
-nft_mnl_talk(struct mnl_socket *nf_sock, const void *data,
-	     unsigned int len, uint32_t seqnum,
+nft_mnl_talk(struct mnl_ctx *ctx, const void *data, unsigned int len,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
-	uint32_t portid = mnl_socket_get_portid(nf_sock);
+	uint32_t portid = mnl_socket_get_portid(ctx->nf_sock);
 
 	if (debug_level & DEBUG_MNL)
 		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
 
-	if (mnl_socket_sendto(nf_sock, data, len) < 0)
+	if (mnl_socket_sendto(ctx->nf_sock, data, len) < 0)
 		return -1;
 
-	return nft_mnl_recv(nf_sock, seqnum, portid, cb, cb_data);
+	return nft_mnl_recv(ctx, portid, cb, cb_data);
 }
 
 /*
@@ -98,11 +97,15 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 void mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seqnum);
 	/* Skip error checking, old kernels sets res_id field to zero. */
-	nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, genid_cb, NULL);
+	nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, genid_cb, NULL);
 }
 
 static int check_genid(const struct nlmsghdr *nlh)
@@ -358,8 +361,12 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 					  int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nftnl_rule_list *nlr_list;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
+	struct nlmsghdr *nlh;
 	int ret;
 
 	nlr_list = nftnl_rule_list_alloc();
@@ -369,8 +376,7 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, rule_cb,
-			   nlr_list);
+	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
 	if (ret < 0)
 		goto err;
 
@@ -389,13 +395,17 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
 				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -417,6 +427,10 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 			 unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
@@ -424,7 +438,7 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
 				    NLM_F_ACK, seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -469,8 +483,12 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					    int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nftnl_chain_list *nlc_list;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
+	struct nlmsghdr *nlh;
 	int ret;
 
 	nlc_list = nftnl_chain_list_alloc();
@@ -480,8 +498,7 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
 				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, chain_cb,
-			   nlc_list);
+	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
 	if (ret < 0)
 		goto err;
 
@@ -498,6 +515,10 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 		      unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
@@ -505,7 +526,7 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 				    NLM_F_ACK | flags, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -527,6 +548,10 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 			 unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
@@ -534,7 +559,7 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
 				    NLM_F_ACK, seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -579,8 +604,12 @@ struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					    int family, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct nftnl_table_list *nlt_list;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
+	struct nlmsghdr *nlh;
 	int ret;
 
 	nlt_list = nftnl_table_list_alloc();
@@ -590,8 +619,7 @@ struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 				    NLM_F_DUMP, seqnum);
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, table_cb,
-			   nlt_list);
+	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, table_cb, nlt_list);
 	if (ret < 0)
 		goto err;
 
@@ -614,6 +642,10 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		    unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
@@ -621,14 +653,17 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum,
-			    set_add_cb, nls);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_add_cb, nls);
 }
 
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		       unsigned int flags, uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
@@ -636,7 +671,7 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 				    flags | NLM_F_ACK, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
@@ -697,9 +732,13 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
 		 uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nftnl_set_list *nls_list;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 	struct nftnl_set *s;
-	struct nftnl_set_list *nls_list;
 	int ret;
 
 	s = nftnl_set_alloc();
@@ -717,8 +756,7 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_cb,
-			   nls_list);
+	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
 	if (ret < 0)
 		goto err;
 
@@ -790,8 +828,12 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
 	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nftnl_obj *n;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
+	struct nftnl_obj *n;
 	int msg_type, ret;
 
 	if (reset)
@@ -818,8 +860,7 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
 	if (nln_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, obj_cb,
-			   nln_list);
+	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, obj_cb, nln_list);
 	if (ret < 0)
 		goto err;
 
@@ -836,8 +877,12 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			unsigned int flags, uint32_t seqnum)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
-	struct nlmsghdr *nlh;
 	struct nftnl_set_elems_iter *iter;
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
+	struct nlmsghdr *nlh;
 	int ret, err = 0;
 
 	iter = nftnl_set_elems_iter_create(nls);
@@ -850,8 +895,7 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 					    NLM_F_CREATE | NLM_F_ACK | flags,
 					    seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		err = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum,
-				   NULL, NULL);
+		err = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 		if (ret <= 0 || err < 0)
 			break;
 	}
@@ -865,6 +909,10 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			   unsigned int flags, uint32_t seqnum)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
@@ -872,7 +920,7 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 				    NLM_F_ACK, seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, NULL, NULL);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
@@ -945,6 +993,10 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			uint32_t seqnum)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_ctx ctx = {
+		.nf_sock	= nf_sock,
+		.seqnum		= seqnum,
+	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
@@ -952,8 +1004,7 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 				    NLM_F_DUMP|NLM_F_ACK, seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, seqnum, set_elem_cb,
-			    nls);
+	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
 
 /*
-- 
2.1.4


