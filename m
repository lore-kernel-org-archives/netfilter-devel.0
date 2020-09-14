Return-Path: <SRS0=xYKs=CX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3CCC43461
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC682078D
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Sep 2020 10:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgINKJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 06:09:58 -0400
Received: from correo.us.es ([193.147.175.20]:42974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgINKJ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 06:09:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C9F7D2AE7
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24A37DA791
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 203BDDA72F; Mon, 14 Sep 2020 12:09:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF99FDA7E1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Sep 2020 12:09:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B8F9542EF9E1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 12:09:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] libnftables: avoid repeated command list traversal on errors
Date:   Mon, 14 Sep 2020 12:09:47 +0200
Message-Id: <20200914100947.880-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914100947.880-1-pablo@netfilter.org>
References: <20200914100947.880-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jindrich Makovicka <makovick@gmail.com>

Because the command seqnums are monotonic, repeated traversals
of the cmds list from the beginning are not necessary as long as
the error seqnums are also monotonic.

Signed-off-by: Jindrich Makovicka <makovick@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
via netfilter's bugzilla.

 src/libnftables.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index fce52ad4003b..a180a9a30b3d 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -21,7 +21,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs,
 		       struct mnl_socket *nf_sock)
 {
-	uint32_t batch_seqnum, seqnum = 0, num_cmds = 0;
+	uint32_t batch_seqnum, seqnum = 0, last_seqnum = UINT32_MAX, num_cmds = 0;
 	struct netlink_ctx ctx = {
 		.nft  = nft,
 		.msgs = msgs,
@@ -65,7 +65,14 @@ static int nft_netlink(struct nft_ctx *nft,
 		ret = -1;
 
 	list_for_each_entry_safe(err, tmp, &err_list, head) {
-		list_for_each_entry(cmd, cmds, list) {
+		/* cmd seqnums are monotonic: only reset the starting position
+		 * if the error seqnum is lower than the previous one.
+		 */
+		if (err->seqnum < last_seqnum)
+			cmd = list_first_entry(cmds, struct cmd, list);
+
+		list_for_each_entry_from(cmd, cmds, list) {
+			last_seqnum = cmd->seqnum;
 			if (err->seqnum == cmd->seqnum ||
 			    err->seqnum == batch_seqnum) {
 				nft_cmd_error(&ctx, cmd, err);
@@ -76,6 +83,11 @@ static int nft_netlink(struct nft_ctx *nft,
 				}
 			}
 		}
+
+		if (&cmd->list == cmds) {
+			/* not found, rewind */
+			last_seqnum = UINT32_MAX;
+		}
 	}
 out:
 	mnl_batch_reset(ctx.batch);
-- 
2.20.1

