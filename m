Return-Path: <SRS0=1PIt=XE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD82EC4740A
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 22:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5C62171F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Sep 2019 22:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfIIWUs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Sep 2019 18:20:48 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40672 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbfIIWUs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Sep 2019 18:20:48 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i7S1c-0002Jy-5m; Tue, 10 Sep 2019 00:20:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <eric@garver.life>
Subject: [PATCH nft] src: mnl: fix --echo buffer size -- again
Date:   Tue, 10 Sep 2019 00:19:18 +0200
Message-Id: <20190909221918.28473-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Garver reports:
   If this restart is triggered it causes rules to be duplicated. We send
   the same batch again.

... and indeed, if the batch isn't doing a full replace, we cannot resend.

Therefore, remove the restart logic again.

1. If user passed --echo, use a 4mb buffer.
2. assume each element in the batch will result in a 1k
notification and further increase limits if thats not enough.

This still passes on s390x (the platform that did not work with
the former, more conservative estimate).

Next option (aside from increasing the guess again ...) is to add a
commandline switch to nftables to allow userspace to override the
buffer size.

Fixes: 877baf9538f66f8f238 ("src: mnl: retry when we hit -ENOBUFS")
Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 9c1f5356c9b9..d664564e16af 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -311,8 +311,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	uint32_t iov_len = nftnl_batch_iovec_len(ctx->batch);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
-	unsigned int enobuf_restarts = 0;
-	size_t avg_msg_size, batch_size;
 	const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
 	};
@@ -321,17 +319,22 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		.tv_usec	= 0
 	};
 	struct iovec iov[iov_len];
-	unsigned int scale = 4;
 	struct msghdr msg = {};
 	fd_set readfds;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
-	batch_size = mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
-	avg_msg_size = div_round_up(batch_size, num_cmds);
+	mnl_nft_batch_to_msg(ctx, &msg, &snl, iov, iov_len);
 
-restart:
-	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * avg_msg_size * scale);
+	if (nft_output_echo(&ctx->nft->output)) {
+		size_t buffer_size = MNL_SOCKET_BUFFER_SIZE * 1024;
+		size_t new_buffer_size = num_cmds * 1024;
+
+		if (new_buffer_size > buffer_size)
+			buffer_size = new_buffer_size;
+
+		mnl_set_rcvbuffer(ctx->nft->nf_sock, buffer_size);
+	}
 
 	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
@@ -351,10 +354,6 @@ restart:
 
 		ret = mnl_socket_recvfrom(nl, rcv_buf, sizeof(rcv_buf));
 		if (ret == -1) {
-			if (errno == ENOBUFS && enobuf_restarts++ < 3) {
-				scale *= 2;
-				goto restart;
-			}
 			return -1;
 		}
 
-- 
2.21.0

