Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08626C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D532073F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfKZK0A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 05:26:00 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45265 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727831AbfKZK0A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 05:26:00 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 610495EA4FA
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 21:25:47 +1100 (AEDT)
Received: (qmail 6862 invoked by uid 501); 26 Nov 2019 10:25:46 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: Delete code not needed since Linux 3.8 in examples/nf-queue.c
Date:   Tue, 26 Nov 2019 21:25:46 +1100
Message-Id: <20191126102546.6751-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191125211059.b2k7e52cgllyk53x@salvia>
References: <20191125211059.b2k7e52cgllyk53x@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=vNVEUF_xQQuxJVIZdzwA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The removed code sent configuration commands NFQNL_CFG_CMD_PF_UNBIND &
NFQNL_CFG_CMD_PF_BIND which the kernel required prior to 3.8.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index f6d254a..960e244 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -150,23 +150,6 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	/* PF_(UN)BIND is not needed with kernels 3.8 and later */
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
 	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, queue_num);
 	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_BIND);
 
-- 
2.14.5

