From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v3 1/4] mnl: Consolidate mnl_batch_talk() parameters
Date: Fri, 28 Jul 2017 13:55:45 +0200
Message-ID: <20170728115548.5171-2-phil@nwl.cc>
References: <20170728115548.5171-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47077 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751834AbdG1L4T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2017 07:56:19 -0400
In-Reply-To: <20170728115548.5171-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The single caller of this function passes struct netlink_ctx fields as
the first two parameters. This can be simplified by passing the context
object itself and having mnl_batch_talk() access it's fields instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/mnl.h | 4 ++--
 src/mnl.c     | 6 +++---
 src/netlink.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 3d2d7fef93ba2..7b1db07bb823e 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -2,6 +2,7 @@
 #define _NFTABLES_MNL_H_
 
 #include <list.h>
+#include <netlink.h>
 
 struct mnl_socket;
 
@@ -24,8 +25,7 @@ bool mnl_batch_ready(struct nftnl_batch *batch);
 void mnl_batch_reset(struct nftnl_batch *batch);
 uint32_t mnl_batch_begin(struct nftnl_batch *batch);
 void mnl_batch_end(struct nftnl_batch *batch);
-int mnl_batch_talk(struct mnl_socket *nl, struct nftnl_batch *batch,
-		   struct list_head *err_list);
+int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list);
 int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
 			   unsigned int flags, uint32_t seqnum);
 int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, struct nftnl_batch *batch,
diff --git a/src/mnl.c b/src/mnl.c
index 3db80de6da02d..a3a6bd3fff1e7 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -246,9 +246,9 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
 }
 
-int mnl_batch_talk(struct mnl_socket *nl, struct nftnl_batch *batch,
-		   struct list_head *err_list)
+int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 {
+	struct mnl_socket *nl = ctx->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
 	fd_set readfds;
@@ -257,7 +257,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct nftnl_batch *batch,
 		.tv_usec	= 0
 	};
 
-	ret = mnl_nft_socket_sendmsg(nl, batch);
+	ret = mnl_nft_socket_sendmsg(nl, ctx->batch);
 	if (ret == -1)
 		return -1;
 
diff --git a/src/netlink.c b/src/netlink.c
index 9cef4c48f805a..b4386ad4ecf01 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1903,7 +1903,7 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct handle *h,
 
 int netlink_batch_send(struct netlink_ctx *ctx, struct list_head *err_list)
 {
-	return mnl_batch_talk(ctx->nf_sock, ctx->batch, err_list);
+	return mnl_batch_talk(ctx, err_list);
 }
 
 int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
-- 
2.13.1

