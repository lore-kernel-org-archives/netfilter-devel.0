Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACB7C28CC2
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEB97257A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfE3Kzn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 06:55:43 -0400
Received: from mail.us.es ([193.147.175.20]:35370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbfE3Kzm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 06:55:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8154FC1DEA
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71D8FDA707
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67612DA704; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 606D6DA701;
        Thu, 30 May 2019 12:55:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 12:55:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 38C904265A5B;
        Thu, 30 May 2019 12:55:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 6/7] mnl: mnl_batch_talk() returns -1 on internal netlink errors
Date:   Thu, 30 May 2019 12:55:28 +0200
Message-Id: <20190530105529.12657-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530105529.12657-1-pablo@netfilter.org>
References: <20190530105529.12657-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Display an error in case internal netlink plumbing hits problems.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnftables.c | 8 ++++++++
 src/mnl.c         | 7 ++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index a58b8ca9dcf6..d8de89ca509c 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -58,6 +58,14 @@ static int nft_netlink(struct nft_ctx *nft,
 		goto out;
 
 	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
+	if (ret < 0) {
+		netlink_io_error(&ctx, NULL,
+				 "Could not process rule: %s", strerror(errno));
+		goto out;
+	}
+
+	if (!list_empty(&err_list))
+		ret = -1;
 
 	list_for_each_entry_safe(err, tmp, &err_list, head) {
 		list_for_each_entry(cmd, cmds, list) {
diff --git a/src/mnl.c b/src/mnl.c
index 96984f03e1be..4c15387000e9 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -313,7 +313,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	struct iovec iov[iov_len];
 	struct msghdr msg = {};
 	fd_set readfds;
-	int err = 0;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
 
@@ -343,10 +342,8 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
-		if (ret == -1) {
+		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
-			err = -1;
-		}
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
@@ -355,7 +352,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
 	}
-	return err;
+	return 0;
 }
 
 int mnl_nft_rule_add(struct netlink_ctx *ctx, const struct cmd *cmd,
-- 
2.11.0

