Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC1ACA9EC7
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F4F520862
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfKBKaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Nov 2019 06:30:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54962 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfKBKaJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Nov 2019 06:30:09 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 457EC43F11B
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Nov 2019 21:29:53 +1100 (AEDT)
Received: (qmail 17958 invoked by uid 501); 2 Nov 2019 10:29:52 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] src: whitespace: Eliminate useless spaces before tabs
Date:   Sat,  2 Nov 2019 21:29:51 +1100
Message-Id: <20191102102952.17912-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191102102952.17912-1-duncan_roe@optusnet.com.au>
References: <20191102102952.17912-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=PO7r1zJSAAAA:8
        a=fEiTcy3Cmhg5wXj7g8wA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The extra spaces had no effect on how the file looked (except cat -A).

This patch reduces the file size by a few bytes, but the main motivation was
that my editor makes this change automatically.

Updated:

 src/libnetfilter_queue.c: Leading whitespace is canonically tabbed

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 7014878..0ab5030 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -510,7 +510,7 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * The nfq_callback type is defined in libnetfilter_queue.h as:
  * \verbatim
 typedef int nfq_callback(struct nfq_q_handle *qh,
-		    	 struct nfgenmsg *nfmsg,
+			 struct nfgenmsg *nfmsg,
 			 struct nfq_data *nfad, void *data);
 \endverbatim
  *
@@ -831,7 +831,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 	int id;
 	struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(tb);
 	if (ph)
- 		id = ntohl(ph->packet_id);
+		id = ntohl(ph->packet_id);
 \endverbatim
  *
  * Notifies netfilter of the userspace verdict for the given packet.  Every
@@ -1077,15 +1077,15 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
  * during all your program life:
  * \verbatim
 	h = nlif_open();
- 	if (h == NULL) {
- 		perror("nlif_open");
- 		exit(EXIT_FAILURE);
- 	}
+	if (h == NULL) {
+		perror("nlif_open");
+		exit(EXIT_FAILURE);
+	}
 \endverbatim
  * Once the handler is open, you need to fetch the interface table at a
  * whole via a call to nlif_query.
  * \verbatim
-  	nlif_query(h);
+	nlif_query(h);
 \endverbatim
  * libnfnetlink is able to update the interface mapping when a new interface
  * appears. To do so, you need to call nlif_catch() on the handler after each
@@ -1093,11 +1093,11 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
  * a select() or poll() against the nlif file descriptor. To get this file 
  * descriptor, you need to use nlif_fd:
  * \verbatim
- 	if_fd = nlif_fd(h);
+	if_fd = nlif_fd(h);
 \endverbatim
  * Don't forget to close the handler when you don't need the feature anymore:
  * \verbatim
- 	nlif_close(h);
+	nlif_close(h);
 \endverbatim
  *
  */
-- 
2.14.5

