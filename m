Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003EEC28CC2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78B5257A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfE3Kzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 06:55:41 -0400
Received: from mail.us.es ([193.147.175.20]:35342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfE3Kzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 06:55:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B8A3C1DE0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C198DA702
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 719D2DA704; Thu, 30 May 2019 12:55:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C7EBDA702;
        Thu, 30 May 2019 12:55:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 12:55:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 482D24265A5B;
        Thu, 30 May 2019 12:55:36 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 4/7] mnl: add mnl_nft_batch_to_msg()
Date:   Thu, 30 May 2019 12:55:26 +0200
Message-Id: <20190530105529.12657-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530105529.12657-1-pablo@netfilter.org>
References: <20190530105529.12657-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function transforms the batch into a msghdr object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index b3999d5f1d9f..6c85b1855c86 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -257,49 +257,67 @@ static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
 	return ret;
 }
 
-static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
+static size_t mnl_nft_batch_to_msg(struct netlink_ctx *ctx, struct msghdr *msg,
+				   const struct sockaddr_nl *snl,
+				   struct iovec *iov, unsigned int iov_len)
 {
-	static const struct sockaddr_nl snl = {
-		.nl_family = AF_NETLINK
-	};
-	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
-	struct iovec iov[iov_len];
-	struct msghdr msg = {
-		.msg_name	= (struct sockaddr *) &snl,
-		.msg_namelen	= sizeof(snl),
-		.msg_iov	= iov,
-		.msg_iovlen	= iov_len,
-	};
-	uint32_t i;
+	unsigned int i;
+	size_t len = 0;
+
+	msg->msg_name		= (struct sockaddr_nl *)snl;
+	msg->msg_namelen	= sizeof(*snl);
+	msg->msg_iov		= iov;
+	msg->msg_iovlen		= iov_len;
 
 	nftnl_batch_iovec(ctx->batch, iov, iov_len);
 
-	for (i = 0; i < iov_len; i++) {
-		if (ctx->nft->debug_mask & NFT_DEBUG_MNL) {
+	for (i = 0; i < iov_len; i++)
+		len += msg->msg_iov[i].iov_len;
+
+	return len;
+}
+
+static ssize_t mnl_nft_socket_sendmsg(struct netlink_ctx *ctx,
+				      const struct msghdr *msg)
+{
+	uint32_t iov_len = msg->msg_iovlen;
+	struct iovec *iov = msg->msg_iov;
+	unsigned int i;
+
+	if (ctx->nft->debug_mask & NFT_DEBUG_MNL) {
+		for (i = 0; i < iov_len; i++) {
 			mnl_nlmsg_fprintf(ctx->nft->output.output_fp,
 					  iov[i].iov_base, iov[i].iov_len,
 					  sizeof(struct nfgenmsg));
 		}
 	}
 
-	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), &msg, 0);
+	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), msg, 0);
 }
 
 int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 {
 	struct mnl_socket *nl = ctx->nft->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
+	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
-	fd_set readfds;
+	const struct sockaddr_nl snl = {
+		.nl_family = AF_NETLINK
+	};
 	struct timeval tv = {
 		.tv_sec		= 0,
 		.tv_usec	= 0
 	};
+	fd_set readfds;
+	struct iovec iov[iov_len];
+	struct msghdr msg = {};
 	int err = 0;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
-	ret = mnl_nft_socket_sendmsg(ctx);
+	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
+
+	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
 		return -1;
 
-- 
2.11.0

