From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] src: add chain netlink messages to the batch
Date: Fri,  4 Apr 2014 15:57:31 +0200
Message-ID: <1396619852-28465-2-git-send-email-pablo@netfilter.org>
References: <1396619852-28465-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49605 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbaDDN6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:58:06 -0400
In-Reply-To: <1396619852-28465-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the chain netlink messages to the big netlink
batch that is sent to kernel-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |    4 ++
 src/mnl.c     |   35 ++++++++++++++++
 src/netlink.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 159 insertions(+), 7 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 03dae22..72cb5cc 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -35,8 +35,12 @@ struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
+int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			    unsigned int flags, uint32_t seq);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
                          unsigned int flags);
+int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			    unsigned int flags, uint32_t seq);
 struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					  int family);
 int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
diff --git a/src/mnl.c b/src/mnl.c
index 7b10663..e694d55 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -412,6 +412,24 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			    unsigned int flags, uint32_t seqnum)
+
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_CREATE | flags, seqnum);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			 unsigned int flags)
 {
@@ -426,6 +444,23 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+			    unsigned int flags, uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELCHAIN,
+			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
+			NLM_F_ACK, seqnum);
+	nft_chain_nlmsg_build_payload(nlh, nlc);
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 static int chain_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_chain_list *nlc_list = data;
diff --git a/src/netlink.c b/src/netlink.c
index 71e6c10..e36d30d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -441,9 +441,10 @@ void netlink_dump_chain(struct nft_chain *nlc)
 #endif
 }
 
-int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, const struct chain *chain,
-		      bool excl)
+static int netlink_add_chain_compat(struct netlink_ctx *ctx,
+				    const struct handle *h,
+				    const struct location *loc,
+				    const struct chain *chain, bool excl)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -467,8 +468,53 @@ int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc, const char *name)
+static int netlink_add_chain_batch(struct netlink_ctx *ctx,
+				   const struct handle *h,
+				   const struct location *loc,
+				   const struct chain *chain, bool excl)
+{
+	struct nft_chain *nlc;
+	int err;
+
+	nlc = alloc_nft_chain(h);
+	if (chain != NULL && chain->flags & CHAIN_F_BASECHAIN) {
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM,
+				       chain->hooknum);
+		nft_chain_attr_set_u32(nlc, NFT_CHAIN_ATTR_PRIO,
+				       chain->priority);
+		nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_TYPE,
+				       chain->type);
+	}
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_batch_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0,
+				      ctx->seqnum);
+	nft_chain_free(nlc);
+
+	if (err < 0) {
+		netlink_io_error(ctx, loc, "Could not add chain: %s",
+				 strerror(errno));
+	}
+	return err;
+}
+
+int netlink_add_chain(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc, const struct chain *chain,
+		      bool excl)
+{
+	int ret;
+
+	if (ctx->batch_supported)
+		ret = netlink_add_chain_batch(ctx, h, loc, chain, excl);
+	else
+		ret = netlink_add_chain_compat(ctx, h, loc, chain, excl);
+
+	return ret;
+}
+
+static int netlink_rename_chain_compat(struct netlink_ctx *ctx,
+				       const struct handle *h,
+				       const struct location *loc,
+				       const char *name)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -485,8 +531,43 @@ int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc)
+static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
+				      const struct handle *h,
+				      const struct location *loc,
+				      const char *name)
+{
+	struct nft_chain *nlc;
+	int err;
+
+	nlc = alloc_nft_chain(h);
+	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_batch_add(nf_sock, nlc, 0, ctx->seqnum);
+	nft_chain_free(nlc);
+
+	if (err < 0) {
+		netlink_io_error(ctx, loc, "Could not rename chain: %s",
+				 strerror(errno));
+	}
+	return err;
+}
+
+int netlink_rename_chain(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc, const char *name)
+{
+	int ret;
+
+	if (ctx->batch_supported)
+		ret = netlink_rename_chain_batch(ctx, h, loc, name);
+	else
+		ret = netlink_rename_chain_compat(ctx, h, loc, name);
+
+	return ret;
+}
+
+static int netlink_del_chain_compat(struct netlink_ctx *ctx,
+				    const struct handle *h,
+				    const struct location *loc)
 {
 	struct nft_chain *nlc;
 	int err;
@@ -496,12 +577,44 @@ int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
 	err = mnl_nft_chain_delete(nf_sock, nlc, 0);
 	nft_chain_free(nlc);
 
+	if (err < 0) {
+		netlink_io_error(ctx, loc, "Could not delete chain: %s",
+				 strerror(errno));
+	}
+	return err;
+}
+
+static int netlink_del_chain_batch(struct netlink_ctx *ctx,
+				   const struct handle *h,
+				   const struct location *loc)
+{
+	struct nft_chain *nlc;
+	int err;
+
+	nlc = alloc_nft_chain(h);
+	netlink_dump_chain(nlc);
+	err = mnl_nft_chain_batch_del(nf_sock, nlc, 0, ctx->seqnum);
+	nft_chain_free(nlc);
+
 	if (err < 0)
 		netlink_io_error(ctx, loc, "Could not delete chain: %s",
 				 strerror(errno));
 	return err;
 }
 
+int netlink_delete_chain(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc)
+{
+	int ret;
+
+	if (ctx->batch_supported)
+		ret = netlink_del_chain_batch(ctx, h, loc);
+	else
+		ret = netlink_del_chain_compat(ctx, h, loc);
+
+	return ret;
+}
+
 static int list_chain_cb(struct nft_chain *nlc, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
-- 
1.7.10.4

