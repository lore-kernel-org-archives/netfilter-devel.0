Return-Path: <SRS0=xYKs=CX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FB7C433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CBD2078D
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgINKJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 06:09:58 -0400
Received: from correo.us.es ([193.147.175.20]:42970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgINKJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 06:09:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7AB3CD2AE2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65163DA855
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62860DA853; Mon, 14 Sep 2020 12:09:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAE9EE1509
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Sep 2020 12:09:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AE18742EF9E1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] mnl: larger receive socket buffer for netlink errors
Date:   Mon, 14 Sep 2020 12:09:46 +0200
Message-Id: <20200914100947.880-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assume each error in the batch will result in a 1k notification for the
non-echo flag set on case as described in 860671662d3f ("mnl: fix --echo
buffer size again").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index ca4f4b2acda9..6699b917c450 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -273,24 +273,16 @@ static int mnl_set_rcvbuffer(const struct mnl_socket *nl, socklen_t bufsiz)
 	return ret;
 }
 
-static size_t mnl_nft_batch_to_msg(struct netlink_ctx *ctx, struct msghdr *msg,
-				   const struct sockaddr_nl *snl,
-				   struct iovec *iov, unsigned int iov_len)
+static void mnl_nft_batch_to_msg(struct netlink_ctx *ctx, struct msghdr *msg,
+				 const struct sockaddr_nl *snl,
+				 struct iovec *iov, unsigned int iov_len)
 {
-	unsigned int i;
-	size_t len = 0;
-
 	msg->msg_name		= (struct sockaddr_nl *)snl;
 	msg->msg_namelen	= sizeof(*snl);
 	msg->msg_iov		= iov;
 	msg->msg_iovlen		= iov_len;
 
 	nftnl_batch_iovec(ctx->batch, iov, iov_len);
-
-	for (i = 0; i < iov_len; i++)
-		len += msg->msg_iov[i].iov_len;
-
-	return len;
 }
 
 static ssize_t mnl_nft_socket_sendmsg(struct netlink_ctx *ctx,
@@ -385,7 +377,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	struct iovec iov[iov_len];
 	struct msghdr msg = {};
 	unsigned int rcvbufsiz;
-	size_t batch_size;
 	fd_set readfds;
 	static mnl_cb_t cb_ctl_array[NLMSG_MIN_TYPE] = {
 	        [NLMSG_ERROR] = mnl_batch_extack_cb,
@@ -397,14 +388,12 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
-	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
+	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
 
+	rcvbufsiz = num_cmds * 1024;
 	if (nft_output_echo(&ctx->nft->output)) {
-		rcvbufsiz = num_cmds * 1024;
 		if (rcvbufsiz < NFT_MNL_ECHO_RCVBUFF_DEFAULT)
 			rcvbufsiz = NFT_MNL_ECHO_RCVBUFF_DEFAULT;
-	} else {
-		rcvbufsiz = num_cmds * div_round_up(batch_size, num_cmds) * 4;
 	}
 
 	mnl_set_rcvbuffer(ctx->nft->nf_sock, rcvbufsiz);
-- 
2.20.1

