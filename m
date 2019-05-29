Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FF9C28CC1
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 18:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC2423F61
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 18:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfE2Sos (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 14:44:48 -0400
Received: from mail.us.es ([193.147.175.20]:50668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2Sos (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 14:44:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 323CCBAEEA
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 20:44:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FDB7DA708
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 20:44:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 158E9DA707; Wed, 29 May 2019 20:44:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2061DA702;
        Wed, 29 May 2019 20:44:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 20:44:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CE0354265A32;
        Wed, 29 May 2019 20:44:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 3/3] mnl: estimate receiver buffer size based on the number of commands
Date:   Wed, 29 May 2019 20:44:36 +0200
Message-Id: <20190529184436.7553-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190529184436.7553-1-pablo@netfilter.org>
References: <20190529184436.7553-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set a receiver buffer size based on the number of commands, this is
useful for the --echo option in order to avoid ENOBUFS errors, assume
MNL_SOCKET_BUFFER_SIZE per echo message worst case.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h     | 3 ++-
 src/libnftables.c | 5 +++--
 src/mnl.c         | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

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
index e623a1adccfc..e9419ce6cd76 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -278,19 +278,21 @@ static ssize_t mnl_nft_socket_sendmsg(const struct netlink_ctx *ctx)
 	return sendmsg(mnl_socket_get_fd(ctx->nft->nf_sock), &msg, 0);
 }
 
-int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
+int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
+		   uint32_t num_cmds)
 {
 	struct mnl_socket *nl = ctx->nft->nf_sock;
 	int ret, fd = mnl_socket_get_fd(nl), portid = mnl_socket_get_portid(nl);
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
-	fd_set readfds;
 	struct timeval tv = {
 		.tv_sec		= 0,
 		.tv_usec	= 0
 	};
+	fd_set readfds;
 	int err = 0;
 
 	mnl_set_sndbuffer(ctx->nft->nf_sock, ctx->batch);
+	mnl_set_rcvbuffer(ctx->nft->nf_sock, num_cmds * MNL_SOCKET_BUFFER_SIZE);
 
 	ret = mnl_nft_socket_sendmsg(ctx);
 	if (ret == -1)
-- 
2.11.0

