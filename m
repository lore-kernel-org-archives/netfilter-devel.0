From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Eliminate struct mnl_ctx
Date: Sat, 11 Nov 2017 00:06:17 +0100
Message-ID: <20171110230617.15449-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41094 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdKJXGa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 18:06:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The issue leading to this patch was that debug output in nft_mnl_talk()
bypasses the application-defined output_fp. While investigating, another
problem was discovered: Most of the ad-hoc defined mnl_ctx objects have
their field 'debug_mask' set to zero regardless of what netlink_ctx
contains (this affects non-batch code path only).

The intuitive solution to both of those issues required to extend
function parameters of all the non-batch functions as well as the common
nft_mnl_talk() one. Instead of complicating them even further, this
patch instead makes them accept a pointer to netlink_ctx as first
parameter to gather both the old (nf_sock, seqnum) and the new values
(debug_mask, octx) from.

Since after the above change struct mnl_ctx was not really used anymore,
so the remaining places were adjusted as well to allow for removing the
struct altogether.

Note that cache routines needed special treatment: Although parameters
of cache_update() make it a candidate for the same change, it can't be
converted since it is called in evaluation phase sometimes in which
there is no netlink context available (but just eval context instead).
Since netlink_genid_get() needs a netlink context though, the ad-hoc
netlink_ctx definition from cache_init() is moved into cache_update() to
have it available there already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/mnl.h     |  72 ++++++++----------
 include/netlink.h |   2 +-
 src/mnl.c         | 219 ++++++++++++++++++++----------------------------------
 src/netlink.c     |  48 ++++++------
 src/rule.c        |  30 ++++----
 5 files changed, 150 insertions(+), 221 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 84c362a23bd79..4662cd04df9b2 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -5,17 +5,11 @@
 #include <netlink.h>
 #include <libmnl/libmnl.h>
 
-struct mnl_ctx {
-	struct mnl_socket	*nf_sock;
-	unsigned int		seqnum;
-	unsigned int		debug_mask;
-};
-
 struct mnl_socket *netlink_open_sock(void);
 void netlink_close_sock(struct mnl_socket *nf_sock);
 
 uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
-uint16_t mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
+uint16_t mnl_genid_get(struct netlink_ctx *ctx);
 
 struct mnl_err {
 	struct list_head	head;
@@ -38,57 +32,56 @@ int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 			       unsigned int flags, uint32_t seqnum);
 
-struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
-					  int family, uint32_t seqnum);
+struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
+					  int family);
 
-int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags, uint32_t seqnum);
+int mnl_nft_chain_add(struct netlink_ctx *ctx, struct nftnl_chain *nlc,
+		      unsigned int flags);
 int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
-int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-                         unsigned int flags, uint32_t seqnum);
+int mnl_nft_chain_delete(struct netlink_ctx *ctx, struct nftnl_chain *nlc,
+                         unsigned int flags);
 int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
-struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
-					    int family, uint32_t seqnum);
+struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
+					    int family);
 
-int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags, uint32_t seqnum);
+int mnl_nft_table_add(struct netlink_ctx *ctx, struct nftnl_table *nlt,
+		      unsigned int flags);
 int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
-int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-			 unsigned int flags, uint32_t seqnum);
+int mnl_nft_table_delete(struct netlink_ctx *ctx, struct nftnl_table *nlt,
+			 unsigned int flags);
 int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
 			    unsigned int flags, uint32_t seqnum);
-struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
-					    int family, uint32_t seqnum);
+struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
+					    int family);
 
-int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    unsigned int flags, uint32_t seqnum);
+int mnl_nft_set_add(struct netlink_ctx *ctx, struct nftnl_set *nls,
+		    unsigned int flags);
 int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
-int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		       unsigned int flags, uint32_t seqnum);
+int mnl_nft_set_delete(struct netlink_ctx *ctx, struct nftnl_set *nls,
+		       unsigned int flags);
 int mnl_nft_set_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
-struct nftnl_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
-					const char *table, uint32_t seqnum);
+struct nftnl_set_list *mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
+					const char *table);
 
-int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			unsigned int flags, uint32_t seqnum);
+int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			unsigned int flags);
 int mnl_nft_setelem_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
 			      unsigned int flags, uint32_t seqnum);
-int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			   unsigned int flags, uint32_t seqnum);
+int mnl_nft_setelem_delete(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			   unsigned int flags);
 int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
-			      unsigned int flags, uint32_t seq);
+			      unsigned int flags, uint32_t seqnum);
 int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, struct nftnl_batch *batch,
 				unsigned int flags, uint32_t seqnum);
-int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			uint32_t seqnum);
+int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls);
 
-struct nftnl_obj_list *mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family,
-					uint32_t seqnum, const char *table,
+struct nftnl_obj_list *mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
+					const char *table,
 					const char *name, uint32_t type,
 					bool dump, bool reset);
 int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
@@ -96,9 +89,10 @@ int mnl_nft_obj_batch_add(struct nftnl_obj *nln, struct nftnl_batch *batch,
 int mnl_nft_obj_batch_del(struct nftnl_obj *nln, struct nftnl_batch *batch,
 			  unsigned int flags, uint32_t seqnum);
 
-struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
-					   uint32_t family, uint32_t seqnum);
-int mnl_nft_event_listener(struct mnl_ctx *ctx,
+struct nftnl_ruleset *mnl_nft_ruleset_dump(struct netlink_ctx *ctx,
+					   uint32_t family);
+int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
+			   struct output_ctx *octx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data);
 
diff --git a/include/netlink.h b/include/netlink.h
index b30c05f833554..51cd5c9d1b94d 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -191,7 +191,7 @@ extern void netlink_dump_obj(struct nftnl_obj *nlo, struct netlink_ctx *ctx);
 
 extern int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list);
 
-extern uint16_t netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum);
+extern uint16_t netlink_genid_get(struct netlink_ctx *ctx);
 extern void netlink_restart(struct mnl_socket *nf_sock);
 #define netlink_abi_error()	\
 	__netlink_abi_error(__FILE__, __LINE__, strerror(errno));
diff --git a/src/mnl.c b/src/mnl.c
index 3be6ebaf1f682..5587e1589cdaa 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -44,7 +44,7 @@ uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
 #define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
 
 static int
-nft_mnl_recv(struct mnl_ctx *ctx, uint32_t portid,
+nft_mnl_recv(struct netlink_ctx *ctx, uint32_t portid,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
@@ -66,13 +66,14 @@ out:
 }
 
 static int
-nft_mnl_talk(struct mnl_ctx *ctx, const void *data, unsigned int len,
+nft_mnl_talk(struct netlink_ctx *ctx, const void *data, unsigned int len,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	uint32_t portid = mnl_socket_get_portid(ctx->nf_sock);
 
 	if (ctx->debug_mask & NFT_DEBUG_MNL)
-		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
+		mnl_nlmsg_fprintf(ctx->octx->output_fp, data, len,
+				  sizeof(struct nfgenmsg));
 
 	if (mnl_socket_sendto(ctx->nf_sock, data, len) < 0)
 		return -1;
@@ -94,18 +95,14 @@ static int genid_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-uint16_t mnl_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
+uint16_t mnl_genid_get(struct netlink_ctx *ctx)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seqnum);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, ctx->seqnum);
 	/* Skip error checking, old kernels sets res_id field to zero. */
-	nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, genid_cb, NULL);
+	nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, genid_cb, NULL);
 
 	return nft_genid;
 }
@@ -232,7 +229,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 
 	for (i = 0; i < iov_len; i++) {
 		if (ctx->debug_mask & NFT_DEBUG_MNL) {
-			mnl_nlmsg_fprintf(stdout,
+			mnl_nlmsg_fprintf(ctx->octx->output_fp,
 					  iov[i].iov_base, iov[i].iov_len,
 					  sizeof(struct nfgenmsg));
 		}
@@ -361,15 +358,11 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
-					  int family, uint32_t seqnum)
+struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx,
+					  int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_rule_list *nlr_list;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -378,9 +371,9 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
-				    NLM_F_DUMP, seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 
-	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
 	if (ret < 0)
 		goto err;
 
@@ -393,23 +386,19 @@ err:
 /*
  * Chain
  */
-int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-		      unsigned int flags, uint32_t seqnum)
+int mnl_nft_chain_add(struct netlink_ctx *ctx, struct nftnl_chain *nlc,
+		      unsigned int flags)
 
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
+				    NLM_F_CREATE | NLM_F_ACK | flags, ctx->seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -427,22 +416,18 @@ int mnl_nft_chain_batch_add(struct nftnl_chain *nlc, struct nftnl_batch *batch,
 	return 0;
 }
 
-int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nftnl_chain *nlc,
-			 unsigned int flags, uint32_t seqnum)
+int mnl_nft_chain_delete(struct netlink_ctx *ctx, struct nftnl_chain *nlc,
+			 unsigned int flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
 				    nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY),
-				    NLM_F_ACK, seqnum);
+				    NLM_F_ACK, ctx->seqnum);
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_chain_batch_del(struct nftnl_chain *nlc, struct nftnl_batch *batch,
@@ -483,15 +468,11 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
-					    int family, uint32_t seqnum)
+struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
+					    int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_chain_list *nlc_list;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	int ret;
 
@@ -500,9 +481,9 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-				    NLM_F_DUMP, seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 
-	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
 	if (ret < 0)
 		goto err;
 
@@ -515,22 +496,18 @@ err:
 /*
  * Table
  */
-int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-		      unsigned int flags, uint32_t seqnum)
+int mnl_nft_table_add(struct netlink_ctx *ctx, struct nftnl_table *nlt,
+		      unsigned int flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK | flags, seqnum);
+				    NLM_F_ACK | flags, ctx->seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -548,22 +525,18 @@ int mnl_nft_table_batch_add(struct nftnl_table *nlt, struct nftnl_batch *batch,
 	return 0;
 }
 
-int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nftnl_table *nlt,
-			 unsigned int flags, uint32_t seqnum)
+int mnl_nft_table_delete(struct netlink_ctx *ctx, struct nftnl_table *nlt,
+			 unsigned int flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELTABLE,
 				    nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY),
-				    NLM_F_ACK, seqnum);
+				    NLM_F_ACK, ctx->seqnum);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_table_batch_del(struct nftnl_table *nlt, struct nftnl_batch *batch,
@@ -604,26 +577,22 @@ err_free:
 	return MNL_CB_OK;
 }
 
-struct nftnl_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
-					    int family, uint32_t seqnum)
+struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
+					    int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_table_list *nlt_list;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	int ret;
 
 	nlt_list = nftnl_table_list_alloc();
 	if (nlt_list == NULL)
-		memory_allocation_error();
+		return NULL;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-				    NLM_F_DUMP, seqnum);
+				    NLM_F_DUMP, ctx->seqnum);
 
-	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, table_cb, nlt_list);
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, table_cb, nlt_list);
 	if (ret < 0)
 		goto err;
 
@@ -642,40 +611,32 @@ static int set_add_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		    unsigned int flags, uint32_t seqnum)
+int mnl_nft_set_add(struct netlink_ctx *ctx, struct nftnl_set *nls, unsigned int flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSET,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_CREATE | NLM_F_ACK | flags, seqnum);
+				    NLM_F_CREATE | NLM_F_ACK | flags,
+				    ctx->seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_add_cb, nls);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_add_cb, nls);
 }
 
-int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-		       unsigned int flags, uint32_t seqnum)
+int mnl_nft_set_delete(struct netlink_ctx *ctx, struct nftnl_set *nls,
+		       unsigned int flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSET,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    flags | NLM_F_ACK, seqnum);
+				    flags | NLM_F_ACK, ctx->seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_set_batch_add(struct nftnl_set *nls, struct nftnl_batch *batch,
@@ -732,15 +693,10 @@ err_free:
 }
 
 struct nftnl_set_list *
-mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
-		 uint32_t seqnum)
+mnl_nft_set_dump(struct netlink_ctx *ctx, int family, const char *table)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_set_list *nls_list;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	struct nftnl_set *s;
 	int ret;
@@ -750,7 +706,7 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-				    NLM_F_DUMP | NLM_F_ACK, seqnum);
+				    NLM_F_DUMP | NLM_F_ACK, ctx->seqnum);
 	if (table != NULL)
 		nftnl_set_set(s, NFTNL_SET_TABLE, table);
 	nftnl_set_nlmsg_build_payload(nlh, s);
@@ -760,7 +716,7 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table,
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
 	if (ret < 0)
 		goto err;
 
@@ -825,17 +781,13 @@ err_free:
 
 
 struct nftnl_obj_list *
-mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
+mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 		 const char *table, const char *name,  uint32_t type, bool dump,
 		 bool reset)
 {
 	uint16_t nl_flags = dump ? NLM_F_DUMP : 0;
 	struct nftnl_obj_list *nln_list;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	struct nftnl_obj *n;
 	int msg_type, ret;
@@ -850,7 +802,7 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
 		memory_allocation_error();
 
 	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
-				    nl_flags | NLM_F_ACK, seqnum);
+				    nl_flags | NLM_F_ACK, ctx->seqnum);
 	if (table != NULL)
 		nftnl_obj_set_str(n, NFTNL_OBJ_TABLE, table);
 	if (name != NULL)
@@ -864,7 +816,7 @@ mnl_nft_obj_dump(struct mnl_socket *nf_sock, int family, uint32_t seqnum,
 	if (nln_list == NULL)
 		memory_allocation_error();
 
-	ret = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, obj_cb, nln_list);
+	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, obj_cb, nln_list);
 	if (ret < 0)
 		goto err;
 
@@ -877,15 +829,11 @@ err:
 /*
  * Set elements
  */
-int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			unsigned int flags, uint32_t seqnum)
+int mnl_nft_setelem_add(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			unsigned int flags)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
 	struct nftnl_set_elems_iter *iter;
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 	int ret, err = 0;
 
@@ -897,9 +845,9 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSETELEM,
 					    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
 					    NLM_F_CREATE | NLM_F_ACK | flags,
-					    seqnum);
+					    ctx->seqnum);
 		ret = nftnl_set_elems_nlmsg_build_payload_iter(nlh, iter);
-		err = nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+		err = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 		if (ret <= 0 || err < 0)
 			break;
 	}
@@ -909,22 +857,18 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 	return err;
 }
 
-int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			   unsigned int flags, uint32_t seqnum)
+int mnl_nft_setelem_delete(struct netlink_ctx *ctx, struct nftnl_set *nls,
+			   unsigned int flags)
 {
 	char buf[NFT_NLMSG_MAXSIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_DELSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_ACK, seqnum);
+				    NLM_F_ACK, ctx->seqnum);
 	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
@@ -996,29 +940,24 @@ int mnl_nft_setelem_batch_del(struct nftnl_set *nls, struct nftnl_batch *batch,
 				     seqnum);
 }
 
-int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls,
-			uint32_t seqnum)
+int mnl_nft_setelem_get(struct netlink_ctx *ctx, struct nftnl_set *nls)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.seqnum		= seqnum,
-	};
 	struct nlmsghdr *nlh;
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM,
 				    nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
-				    NLM_F_DUMP|NLM_F_ACK, seqnum);
+				    NLM_F_DUMP|NLM_F_ACK, ctx->seqnum);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
-	return nft_mnl_talk(&ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
+	return nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
 
 /*
  * ruleset
  */
-struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
-					   uint32_t family, uint32_t seqnum)
+struct nftnl_ruleset *mnl_nft_ruleset_dump(struct netlink_ctx *ctx,
+					   uint32_t family)
 {
 	struct nftnl_ruleset *rs;
 	struct nftnl_table_list *t;
@@ -1033,26 +972,26 @@ struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 	if (rs == NULL)
 		memory_allocation_error();
 
-	t = mnl_nft_table_dump(nf_sock, family, seqnum);
+	t = mnl_nft_table_dump(ctx, family);
 	if (t == NULL)
 		goto err;
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_TABLELIST, t);
 
-	c = mnl_nft_chain_dump(nf_sock, family, seqnum);
+	c = mnl_nft_chain_dump(ctx, family);
 	if (c == NULL)
 		goto err;
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_CHAINLIST, c);
 
-	sl = mnl_nft_set_dump(nf_sock, family, NULL, seqnum);
+	sl = mnl_nft_set_dump(ctx, family, NULL);
 	if (sl == NULL)
 		goto err;
 
 	i = nftnl_set_list_iter_create(sl);
 	s = nftnl_set_list_iter_next(i);
 	while (s != NULL) {
-		ret = mnl_nft_setelem_get(nf_sock, s, seqnum);
+		ret = mnl_nft_setelem_get(ctx, s);
 		if (ret < 0)
 			goto err;
 
@@ -1062,7 +1001,7 @@ struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
 
 	nftnl_ruleset_set(rs, NFTNL_RULESET_SETLIST, sl);
 
-	r = mnl_nft_rule_dump(nf_sock, family, seqnum);
+	r = mnl_nft_rule_dump(ctx, family);
 	if (r == NULL)
 		goto err;
 
@@ -1079,7 +1018,8 @@ err:
  */
 #define NFTABLES_NLEVENT_BUFSIZ	(1 << 24)
 
-int mnl_nft_event_listener(struct mnl_ctx *ctx,
+int mnl_nft_event_listener(struct mnl_socket *nf_sock, unsigned int debug_mask,
+			   struct output_ctx *octx,
 			   int (*cb)(const struct nlmsghdr *nlh, void *data),
 			   void *cb_data)
 {
@@ -1087,7 +1027,7 @@ int mnl_nft_event_listener(struct mnl_ctx *ctx,
  	 * message loss due to ENOBUFS.
 	 */
 	unsigned int bufsiz = NFTABLES_NLEVENT_BUFSIZ;
-	int fd = mnl_socket_get_fd(ctx->nf_sock);
+	int fd = mnl_socket_get_fd(nf_sock);
 	char buf[NFT_NLMSG_MAXSIZE];
 	fd_set readfds;
 	int ret;
@@ -1100,8 +1040,8 @@ int mnl_nft_event_listener(struct mnl_ctx *ctx,
 		 */
 		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &bufsiz,
 				 sizeof(socklen_t));
-		printf("# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
-		       NFTABLES_NLEVENT_BUFSIZ, bufsiz);
+		nft_print(octx, "# Cannot set up netlink socket buffer size to %u bytes, falling back to %u bytes\n",
+			  NFTABLES_NLEVENT_BUFSIZ, bufsiz);
 	}
 
 	while (1) {
@@ -1113,19 +1053,20 @@ int mnl_nft_event_listener(struct mnl_ctx *ctx,
 			return -1;
 
 		if (FD_ISSET(fd, &readfds)) {
-			ret = mnl_socket_recvfrom(ctx->nf_sock, buf, sizeof(buf));
+			ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
 			if (ret < 0) {
 				if (errno == ENOBUFS) {
-					printf("# ERROR: We lost some netlink events!\n");
+					nft_print(octx, "# ERROR: We lost some netlink events!\n");
 					continue;
 				}
-				fprintf(stdout, "# ERROR: %s\n", strerror(errno));
+				nft_print(octx, "# ERROR: %s\n",
+					  strerror(errno));
 				break;
 			}
 		}
 
-		if (ctx->debug_mask & NFT_DEBUG_MNL) {
-			mnl_nlmsg_fprintf(stdout, buf, sizeof(buf),
+		if (debug_mask & NFT_DEBUG_MNL) {
+			mnl_nlmsg_fprintf(octx->output_fp, buf, sizeof(buf),
 					  sizeof(struct nfgenmsg));
 		}
 		ret = mnl_cb_run(buf, ret, 0, 0, cb, cb_data);
diff --git a/src/netlink.c b/src/netlink.c
index 845eeeffd7387..6735971ac1f39 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -75,9 +75,9 @@ void netlink_restart(struct mnl_socket *nf_sock)
 	nf_sock = netlink_open_sock();
 }
 
-uint16_t netlink_genid_get(struct mnl_socket *nf_sock, uint32_t seqnum)
+uint16_t netlink_genid_get(struct netlink_ctx *ctx)
 {
-	return mnl_genid_get(nf_sock, seqnum);
+	return mnl_genid_get(ctx);
 }
 
 void __noreturn __netlink_abi_error(const char *file, int line,
@@ -556,7 +556,7 @@ static int netlink_list_rules(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_rule_list *rule_cache;
 
-	rule_cache = mnl_nft_rule_dump(ctx->nf_sock, h->family, ctx->seqnum);
+	rule_cache = mnl_nft_rule_dump(ctx, h->family);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -611,7 +611,7 @@ static int netlink_add_chain_compat(struct netlink_ctx *ctx,
 	}
 
 	netlink_dump_chain(nlc, ctx);
-	err = mnl_nft_chain_add(ctx->nf_sock, nlc, flags, ctx->seqnum);
+	err = mnl_nft_chain_add(ctx, nlc, flags);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -677,7 +677,7 @@ static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
 	nlc = alloc_nftnl_chain(h);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, name);
 	netlink_dump_chain(nlc, ctx);
-	err = mnl_nft_chain_add(ctx->nf_sock, nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_add(ctx, nlc, 0);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -724,7 +724,7 @@ static int netlink_del_chain_compat(struct netlink_ctx *ctx,
 
 	nlc = alloc_nftnl_chain(h);
 	netlink_dump_chain(nlc, ctx);
-	err = mnl_nft_chain_delete(ctx->nf_sock, nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_delete(ctx, nlc, 0);
 	nftnl_chain_free(nlc);
 
 	if (err < 0)
@@ -827,7 +827,7 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_chain_list *chain_cache;
 	struct chain *chain;
 
-	chain_cache = mnl_nft_chain_dump(ctx->nf_sock, h->family, ctx->seqnum);
+	chain_cache = mnl_nft_chain_dump(ctx, h->family);
 	if (chain_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -870,7 +870,7 @@ static int netlink_add_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_add(ctx->nf_sock, nlt, flags, ctx->seqnum);
+	err = mnl_nft_table_add(ctx, nlt, flags);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -920,7 +920,7 @@ static int netlink_del_table_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nftnl_table(h);
-	err = mnl_nft_table_delete(ctx->nf_sock, nlt, 0, ctx->seqnum);
+	err = mnl_nft_table_delete(ctx, nlt, 0);
 	nftnl_table_free(nlt);
 
 	if (err < 0)
@@ -984,7 +984,7 @@ int netlink_list_tables(struct netlink_ctx *ctx, const struct handle *h,
 {
 	struct nftnl_table_list *table_cache;
 
-	table_cache = mnl_nft_table_dump(ctx->nf_sock, h->family, ctx->seqnum);
+	table_cache = mnl_nft_table_dump(ctx, h->family);
 	if (table_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1173,8 +1173,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	}
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_set_add(ctx->nf_sock, nls, NLM_F_ECHO | flags,
-			      ctx->seqnum);
+	err = mnl_nft_set_add(ctx, nls, NLM_F_ECHO | flags);
 	if (err < 0)
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1270,7 +1269,7 @@ static int netlink_del_set_compat(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nftnl_set(h);
-	err = mnl_nft_set_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
+	err = mnl_nft_set_delete(ctx, nls, 0);
 	nftnl_set_free(nls);
 
 	if (err < 0)
@@ -1323,8 +1322,7 @@ int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_set_list *set_cache;
 	int err;
 
-	set_cache = mnl_nft_set_dump(ctx->nf_sock, h->family, h->table,
-				     ctx->seqnum);
+	set_cache = mnl_nft_set_dump(ctx, h->family, h->table);
 	if (set_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -1379,7 +1377,7 @@ static int netlink_add_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_add(ctx->nf_sock, nls, flags, ctx->seqnum);
+	err = mnl_nft_setelem_add(ctx, nls, flags);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1429,7 +1427,7 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls, ctx);
 
-	err = mnl_nft_setelem_delete(ctx->nf_sock, nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_delete(ctx, nls, 0);
 	nftnl_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1634,7 +1632,7 @@ int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	nls = alloc_nftnl_set(h);
 
-	err = mnl_nft_setelem_get(ctx->nf_sock, nls, ctx->seqnum);
+	err = mnl_nft_setelem_get(ctx, nls);
 	if (err < 0) {
 		nftnl_set_free(nls);
 		if (errno == EINTR)
@@ -1780,7 +1778,7 @@ int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, ctx->seqnum,
+	obj_cache = mnl_nft_obj_dump(ctx, h->family,
 				     h->table, NULL, 0, true, false);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
@@ -1800,7 +1798,7 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 	struct nftnl_obj_list *obj_cache;
 	int err;
 
-	obj_cache = mnl_nft_obj_dump(ctx->nf_sock, h->family, ctx->seqnum,
+	obj_cache = mnl_nft_obj_dump(ctx, h->family,
 				     h->table, h->obj, type, dump, true);
 	if (obj_cache == NULL) {
 		if (errno == EINTR)
@@ -1846,7 +1844,7 @@ struct nftnl_ruleset *netlink_dump_ruleset(struct netlink_ctx *ctx,
 {
 	struct nftnl_ruleset *rs;
 
-	rs = mnl_nft_ruleset_dump(ctx->nf_sock, h->family, ctx->seqnum);
+	rs = mnl_nft_ruleset_dump(ctx, h->family);
 	if (rs == NULL) {
 		if (errno == EINTR)
 			return NULL;
@@ -3011,10 +3009,6 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 int netlink_monitor(struct netlink_mon_handler *monhandler,
 		    struct mnl_socket *nf_sock)
 {
-	struct mnl_ctx ctx = {
-		.nf_sock	= nf_sock,
-		.debug_mask	= monhandler->debug_mask,
-	};
 	int group;
 
 	if (monhandler->monitor_flags & (1 << NFT_MSG_TRACE)) {
@@ -3036,7 +3030,9 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
 						strerror(errno));
 	}
 
-	return mnl_nft_event_listener(&ctx, netlink_events_cb, monhandler);
+	return mnl_nft_event_listener(nf_sock, monhandler->debug_mask,
+				      monhandler->ctx->octx, netlink_events_cb,
+				      monhandler);
 }
 
 bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum)
diff --git a/src/rule.c b/src/rule.c
index 9bbd9a5b14998..8d211548f2ca5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -121,28 +121,17 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	return 0;
 }
 
-static int cache_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
-		      enum cmd_ops cmd, struct list_head *msgs,
-		      bool debug, struct output_ctx *octx)
+static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
 	};
-	struct netlink_ctx ctx = {
-		.list		= LIST_HEAD_INIT(ctx.list),
-		.nf_sock	= nf_sock,
-		.cache		= cache,
-		.msgs		= msgs,
-		.seqnum		= cache->seqnum++,
-		.debug_mask	= debug ? NFT_DEBUG_NETLINK : 0,
-		.octx		= octx,
-	};
 	int ret;
 
-	ret = cache_init_tables(&ctx, &handle, cache);
+	ret = cache_init_tables(ctx, &handle, ctx->cache);
 	if (ret < 0)
 		return ret;
-	ret = cache_init_objects(&ctx, cmd);
+	ret = cache_init_objects(ctx, cmd);
 	if (ret < 0)
 		return ret;
 
@@ -155,13 +144,22 @@ int cache_update(struct mnl_socket *nf_sock, struct nft_cache *cache,
 {
 	uint16_t genid;
 	int ret;
+	struct netlink_ctx ctx = {
+		.list		= LIST_HEAD_INIT(ctx.list),
+		.nf_sock	= nf_sock,
+		.cache		= cache,
+		.msgs		= msgs,
+		.debug_mask	= debug ? NFT_DEBUG_NETLINK : 0,
+		.octx		= octx,
+	};
 
 replay:
-	genid = netlink_genid_get(nf_sock, cache->seqnum++);
+	ctx.seqnum = cache->seqnum++;
+	genid = netlink_genid_get(&ctx);
 	if (genid && genid == cache->genid)
 		return 0;
 	cache_release(cache);
-	ret = cache_init(nf_sock, cache, cmd, msgs, debug, octx);
+	ret = cache_init(&ctx, cmd);
 	if (ret < 0) {
 		cache_release(cache);
 		if (errno == EINTR) {
-- 
2.13.1

