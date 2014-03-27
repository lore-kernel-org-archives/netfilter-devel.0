From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 nft] src: add table netlink messages to the batch
Date: Thu, 27 Mar 2014 22:54:51 +0100
Message-ID: <1395957291-5018-3-git-send-email-pablo@netfilter.org>
References: <1395957291-5018-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410AbaC0VzA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:55:00 -0400
In-Reply-To: <1395957291-5018-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves the table messages to the netlink batch that
is sent to kernel-space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |    6 ++++-
 src/mnl.c     |   34 ++++++++++++++++++++++++++
 src/netlink.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 461f2c2..dab2b76 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -48,8 +48,12 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
+int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			    unsigned int flags);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
-		      unsigned int flags);
+			 unsigned int flags);
+int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			    unsigned int flags);
 struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					  int family);
 int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
diff --git a/src/mnl.c b/src/mnl.c
index d1a21f9..edfae82 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -542,6 +542,23 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			    unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_NEWTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_ACK | flags, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags)
 {
@@ -556,6 +573,23 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
+int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
+			    unsigned int flags)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+			NFT_MSG_DELTABLE,
+			nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
+			NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, nlt);
+
+	if (!mnl_nlmsg_batch_next(batch))
+		mnl_batch_page_add();
+
+	return 0;
+}
+
 static int table_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_table_list *nlt_list = data;
diff --git a/src/netlink.c b/src/netlink.c
index a78b284..91cc62a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -728,9 +728,10 @@ int netlink_flush_chain(struct netlink_ctx *ctx, const struct handle *h,
 	return netlink_del_rule_batch(ctx, h, loc);
 }
 
-int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
-		      const struct location *loc, const struct table *table,
-		      bool excl)
+static int netlink_add_table_compat(struct netlink_ctx *ctx,
+				    const struct handle *h,
+				    const struct location *loc,
+				    const struct table *table, bool excl)
 {
 	struct nft_table *nlt;
 	int err;
@@ -745,8 +746,42 @@ int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
-			 const struct location *loc)
+static int netlink_add_table_batch(struct netlink_ctx *ctx,
+				   const struct handle *h,
+				   const struct location *loc,
+				   const struct table *table, bool excl)
+{
+	struct nft_table *nlt;
+	int err;
+
+	nlt = alloc_nft_table(h);
+	err = mnl_nft_table_batch_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0);
+	nft_table_free(nlt);
+
+	if (err < 0) {
+		netlink_io_error(ctx, loc, "Could not add table: %s",
+				 strerror(errno));
+	}
+	return err;
+}
+
+int netlink_add_table(struct netlink_ctx *ctx, const struct handle *h,
+		      const struct location *loc,
+		      const struct table *table, bool excl)
+{
+	int ret;
+
+	if (ctx->batch_supported)
+		ret = netlink_add_table_batch(ctx, h, loc, table, excl);
+	else
+		ret = netlink_add_table_compat(ctx, h, loc, table, excl);
+
+	return ret;
+}
+
+static int netlink_del_table_compat(struct netlink_ctx *ctx,
+				    const struct handle *h,
+				    const struct location *loc)
 {
 	struct nft_table *nlt;
 	int err;
@@ -761,6 +796,37 @@ int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
+static int netlink_del_table_batch(struct netlink_ctx *ctx,
+				   const struct handle *h,
+				   const struct location *loc)
+{
+	struct nft_table *nlt;
+	int err;
+
+	nlt = alloc_nft_table(h);
+	err = mnl_nft_table_batch_del(nf_sock, nlt, 0);
+	nft_table_free(nlt);
+
+	if (err < 0) {
+		netlink_io_error(ctx, loc, "Could not delete table: %s",
+				 strerror(errno));
+	}
+	return err;
+}
+
+int netlink_delete_table(struct netlink_ctx *ctx, const struct handle *h,
+			 const struct location *loc)
+{
+	int ret;
+
+	if (ctx->batch_supported)
+		ret = netlink_del_table_batch(ctx, h, loc);
+	else
+		ret = netlink_del_table_compat(ctx, h, loc);
+
+	return ret;
+}
+
 void netlink_dump_table(struct nft_table *nlt)
 {
 #ifdef DEBUG
-- 
1.7.10.4

