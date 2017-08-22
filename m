From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/6] mnl: pass struct netlink_ctx to mnl_nft_socket_sendmsg()
Date: Tue, 22 Aug 2017 19:05:10 +0200
Message-ID: <1503421511-17814-6-git-send-email-pablo@netfilter.org>
References: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751843AbdHVRFd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EFC37D25FC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E355BCFDC9
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:16 +0200 (CEST)
In-Reply-To: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reduce function footprint.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 4f9c30c25d8f..e51c3294f76d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -210,13 +210,12 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 	nlbuffsiz = newbuffsiz;
 }
 
-static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
-				      struct nftnl_batch *batch)
+static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
-	uint32_t iov_len = nftnl_batch_iovec_len(batch);
+	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	struct iovec iov[iov_len];
 	struct msghdr msg = {
 		.msg_name	= (struct sockaddr *) &snl,
@@ -226,8 +225,8 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 	};
 	uint32_t i;
 
-	mnl_set_sndbuffer(nl, batch);
-	nftnl_batch_iovec(batch, iov, iov_len);
+	mnl_set_sndbuffer(ctx->nf_sock, ctx->batch);
+	nftnl_batch_iovec(ctx->batch, iov, iov_len);
 
 	for (i = 0; i < iov_len; i++) {
 		if (debug_level & DEBUG_MNL) {
@@ -237,7 +236,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl,
 		}
 	}
 
-	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+	return sendmsg(mnl_socket_get_fd(ctx->nf_sock), &msg, 0);
 }
 
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
@@ -251,7 +250,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		.tv_usec	= 0
 	};
 
-	ret = mnl_nft_socket_sendmsg(nl, ctx->batch);
+	ret = mnl_nft_socket_sendmsg(ctx);
 	if (ret == -1)
 		return -1;
 
-- 
2.1.4


