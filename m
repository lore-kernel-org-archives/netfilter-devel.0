Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AD1C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 911D62067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfHMUMe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:12:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57626 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfHMUMe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 16:12:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxd9k-0004Ba-Ic; Tue, 13 Aug 2019 22:12:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 3/3] src: mnl: retry when we hit -ENOBUFS
Date:   Tue, 13 Aug 2019 22:12:46 +0200
Message-Id: <20190813201246.5543-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813201246.5543-1-fw@strlen.de>
References: <20190813201246.5543-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tests/shell/testcases/transactions/0049huge_0

still fails with ENOBUFS error after endian fix done in
previous patch.  Its enough to increase the scale factor (4)
on s390x, but rather than continue with these "guess the proper
size" game, just increase the buffer size and retry up to 3 times.

This makes above test work on s390x.

So, implement what Pablo suggested in the earlier commit:
    We could also explore increasing the buffer and retry if
    mnl_nft_socket_sendmsg() hits ENOBUFS if we ever hit this problem again.

v2: call setsockopt unconditionally, then increase on error.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 97a2e0765189..9c1f5356c9b9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -311,6 +311,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	unsigned int enobuf_restarts = 0;
 	size_t avg_msg_size, batch_size;
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -320,6 +321,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		.tv_usec	= 0
 	};
 	struct iovec iov[iov_len];
+	unsigned int scale = 4;
 	struct msghdr msg = {};
 	fd_set readfds;
 
@@ -328,7 +330,8 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
 	avg_msg_size = div_round_up(batch_size, num_cmds);
 
-	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * 4);
+restart:
+	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
 
 	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
@@ -347,8 +350,13 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 			break;
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
-		if (ret == -1)
+		if (ret == -1) {
+			if (errno == ENOBUFS && enobuf_restarts++ < 3) {
+				scale *= 2;
+				goto restart;
+			}
 			return -1;
+		}
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
-- 
2.21.0

