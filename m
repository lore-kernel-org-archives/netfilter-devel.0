Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AD9C28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 11:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8CF2586C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 11:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfE3Ljx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 07:39:53 -0400
Received: from mail.us.es ([193.147.175.20]:39540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfE3Ljx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 07:39:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 114D5BAEAB
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 13:39:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E39AEDA79D
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 13:39:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0515DDA71A; Thu, 30 May 2019 13:39:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E3D4DA71A;
        Thu, 30 May 2019 13:39:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 13:39:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0B0794265A32;
        Thu, 30 May 2019 13:39:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v4 5/7] mnl: estimate receiver buffer size
Date:   Thu, 30 May 2019 13:39:34 +0200
Message-Id: <20190530113934.7810-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set a receiver buffer size based on the number of commands and the
average message size, this is useful for the --echo option in order to
avoid ENOBUFS errors.

On the kernel side, each skbuff consumes truesize from the socket queue,
which is approximately four times the estimated size per message that we
get in turn for each echo message to ensure enough receiver buffer space.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: makes happy the new testcase from Phil.

 include/mnl.h     |  3 ++-
 src/libnftables.c |  5 +++--
 src/mnl.c         | 11 ++++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index c63a7e7fd73a..9f50c3da0f3a 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -25,7 +25,8 @@ bool mnl_batch_ready(struct nftnl_batch *batch);
 void mnl_batch_reset(struct nftnl_batch *batch);
 uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t seqnum);
 void mnl_batch_end(struct nftnl_batch *batch, uint32_t seqnum);
-int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list);
+int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
+		   uint32_t num_cmds);
 
 int mnl_nft_rule_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		     unsigned int flags);
diff --git a/src/libnftables.c b/src/libnftables.c
index 199dbc97b801..a58b8ca9dcf6 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -21,7 +21,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
 {
-	uint32_t batch_seqnum, seqnum = 0;
+	uint32_t batch_seqnum, seqnum = 0, num_cmds = 0;
 	struct nftnl_batch *batch;
 	struct netlink_ctx ctx;
 	struct cmd *cmd;
@@ -49,6 +49,7 @@ static int nft_netlink(struct nft_ctx *nft,
 					 strerror(errno));
 			goto out;
 		}
+		num_cmds++;
 	}
 	if (!nft->check)
 		mnl_batch_end(batch, mnl_seqnum_alloc(&seqnum));
@@ -56,7 +57,7 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (!mnl_batch_ready(batch))
 		goto out;
 
-	ret = mnl_batch_talk(&ctx, &err_list);
+	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
 
 	list_for_each_entry_safe(err, tmp, &err_list, head) {
 		list_for_each_entry(cmd, cmds, list) {
diff --git a/src/mnl.c b/src/mnl.c
index cea3c11d22a9..c9da6bbcd17a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -295,12 +295,14 @@ static ssize_t mnl_nft_socket_sendmsg(struct netlink_ctx *ctx,
 	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), msg, 0);
 }
 
-int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
+int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
+		   uint32_t num_cmds)
 {
 	struct mnl_socket *nl = ctx->nft->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	size_t avg_msg_size, batch_size;
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
@@ -308,14 +310,17 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		.tv_sec		= 0,
 		.tv_usec	= 0
 	};
-	fd_set readfds;
 	struct iovec iov[iov_len];
 	struct msghdr msg = {};
+	fd_set readfds;
 	int err = 0;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
-	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
+	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
+	avg_msg_size = div_round_up(batch_size, num_cmds);
+
+	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 4);
 
 	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
-- 
2.11.0

