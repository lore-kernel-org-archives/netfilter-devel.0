Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488BDC43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 00:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12580206D5
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 00:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfLIAFT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Dec 2019 19:05:19 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44900 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfLIAFT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Dec 2019 19:05:19 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id C9E5A7EAC52
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 11:05:06 +1100 (AEDT)
Received: (qmail 14900 invoked by uid 501); 9 Dec 2019 00:05:06 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] src: doc: Fully document available verdicts
Date:   Mon,  9 Dec 2019 11:05:06 +1100
Message-Id: <20191209000506.14854-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191209000506.14854-1-duncan_roe@optusnet.com.au>
References: <20191209000506.14854-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=ZqY3rlaF8JmLPznUPqsA:9 a=GiENrgpCSshR8ulV:21
        a=2vPrZYwSsJ7ZPdEQ:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/nlmsg.c - Document NF_DROP, NF_ACCEPT, NF_STOP, NF_REPEAT and
               NF_QUEUE_NR(new_queue).
             - Make line number of examples/nf-queue.c into a hyperlink.
             - Add hint that "cb" in function names is short for "callback".

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/nlmsg.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index c950110..cbf49a6 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -34,11 +34,39 @@
  * nfq_nlmsg_verdict_put - Put a verdict into a Netlink message
  * \param nlh Pointer to netlink message
  * \param id ID assigned to packet by netfilter
- * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
+ * \param verdict verdict to return to netfilter (see \b Verdicts below)
+ * \par Verdicts
+ * __NF_DROP__ Drop the packet. This is final.
+ * \n
+ * __NF_ACCEPT__ Accept the packet. Processing of the current base chain
+ * and any called chains terminates,
+ * but the packet may still be processed by subsequently invoked base chains.
+ * \n
+ * __NF_STOP__ Like __NF_ACCEPT__, but skip any further base chains using the
+ * current hook.
+ * \n
+ * __NF_REPEAT__ Like __NF_ACCEPT__, but re-queue this packet to the
+ * current base chain. One way to prevent a re-queueing loop is to
+ * also set a packet mark using nfq_nlmsg_verdict_put_mark() and have the
+ * program test for this mark in \c attr[NFQA_MARK]; or have the nefilter rules
+ * do this test.
+ * \n
+ * __NF_QUEUE_NR__(*new_queue*) Like __NF_ACCEPT__, but queue this packet to
+ * queue number *new_queue*. As with the command-line \b queue \b num verdict,
+ * if no process is listening to that queue then the packet is discarded; but
+ * again like with the command-line, one may OR in a flag to bypass *new_queue*
+ *  if there is no listener, as in this snippet:
+ * \verbatim
+       nfq_nlmsg_verdict_put(nlh, id, NF_QUEUE_NR(new_queue) |
+	       NF_VERDICT_FLAG_QUEUE_BYPASS);
+\endverbatim
  *
- * See examples/nf-queue.c, line 46 for an example of how to use this function.
+ * See examples/nf-queue.c, line
+ * <a class="el" href="nf-queue_8c_source.html#l00046">46</a>
+ * for an example of how to use this function in context.
  * The calling sequence is \b main --> \b mnl_cb_run --> \b queue_cb -->
  * \b nfq_send_verdict --> \b nfq_nlmsg_verdict_put
+ * (\b cb being short for \b callback).
  */
 EXPORT_SYMBOL
 void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
-- 
2.14.5

