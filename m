Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A916BC28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 886F2205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfE2NNz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 09:13:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40258 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2NNz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 09:13:55 -0400
Received: from localhost ([::1]:53346 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVyOv-0006w2-9n; Wed, 29 May 2019 15:13:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH 2/4] mnl: Increase receive buffer in mnl_batch_talk()
Date:   Wed, 29 May 2019 15:13:44 +0200
Message-Id: <20190529131346.23659-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529131346.23659-1-phil@nwl.cc>
References: <20190529131346.23659-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Be prepared to receive larger messages for the same reason as in
nft_mnl_recv() and mnl_nft_event_listener().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 2c5a26a5e3465..06280aa2cb50a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -287,7 +287,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 {
 	struct mnl_socket *nl = ctx->nft->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
-	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
+	char rcv_buf[NFT_NLMSG_MAXSIZE];
 	fd_set readfds;
 	struct timeval tv = {
 		.tv_sec		= 0,
-- 
2.21.0

