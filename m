Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33530C432C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 05:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FC220672
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 05:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfKWFRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 00:17:13 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54519 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbfKWFRN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 00:17:13 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 7CDF73A0D7E
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 16:16:58 +1100 (AEDT)
Received: (qmail 18354 invoked by uid 501); 23 Nov 2019 05:16:57 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src: Comment-out code not needed since Linux 3.8 in examples/nf-queue.c
Date:   Sat, 23 Nov 2019 16:16:57 +1100
Message-Id: <20191123051657.18308-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
References: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=vifiqeo6ZM97exj4QrcA:9 a=q-lN_5IBCXnZdEYi:21
        a=-wrLoK8nc3GZTz2h:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes it clear which lines are no longer required.
It also obviates the need to document NFQNL_CFG_CMD_PF_(UN)BIND.

Add comment with sed command to re-enable commented-out code.

Use // comments because my sed-fu is not up to reversing a /* comment block

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index f6d254a..ee9e4f4 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -151,29 +151,31 @@ int main(int argc, char *argv[])
 	}
 
 	/* PF_(UN)BIND is not needed with kernels 3.8 and later */
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
-	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
-	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_BIND);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
-	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_BIND);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
+	/* Uncomment this code block if you need to cater for an older kernel */
+	/* E.g. sed -i '156,178s+//++' examples/nf-queue.c */
+	//nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
+	//nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
+	//
+	//if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	//	perror("mnl_socket_send");
+	//	exit(EXIT_FAILURE);
+	//}
+	//
+	//nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
+	//nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_BIND);
+	//
+	//if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	//	perror("mnl_socket_send");
+	//	exit(EXIT_FAILURE);
+	//}
+	//
+	//nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
+	//nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_BIND);
+	//
+	//if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+	//	perror("mnl_socket_send");
+	//	exit(EXIT_FAILURE);
+	//}
 
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_params(nlh, NFQNL_COPY_PACKET, 0xffff);
-- 
2.14.5

