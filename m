Return-Path: <SRS0=YvWH=YU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9C8CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 08:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C39320679
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Oct 2019 08:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJ0IiX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Oct 2019 04:38:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54387 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbfJ0IiW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Oct 2019 04:38:22 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id E408343F2C9
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Oct 2019 19:38:05 +1100 (AEDT)
Received: (qmail 24195 invoked by uid 501); 27 Oct 2019 08:38:04 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: doc: Document nfq_nlmsg_verdict_put_mark() and nfq_nlmsg_verdict_put_pkt()
Date:   Sun, 27 Oct 2019 19:38:04 +1100
Message-Id: <20191027083804.24152-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=XobE76Q3jBoA:10 a=PO7r1zJSAAAA:8 a=RJQqqpOrBwc2qAwGn6EA:9
        a=VFo9uv_2zmvqHe_y:21 a=y6-qUpeezqAya9Bp:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This completes the "Verdict helpers" module.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/nlmsg.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index d06e6db..c40a9e4 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -31,7 +31,7 @@
  */
 
 /**
- * nfq_nlmsg_verdict_put - Put a verdict into a Netlink header
+ * nfq_nlmsg_verdict_put - Put a verdict into a Netlink message
  * \param nlh Pointer to netlink message
  * \param id ID assigned to packet by netfilter
  * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
@@ -50,6 +50,15 @@ void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
 	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
 }
 
+/**
+ * nfq_nlmsg_verdict_put_mark - Put a packet mark into a netlink message
+ * \param nlh Pointer to netlink message
+ * \param mark Value of mark to put
+ *
+ * The mark becomes part of the packet's metadata, and may be tested by the *nft
+ * primary expression* **meta mark**
+ * \sa __nft__(1)
+ */
 EXPORT_SYMBOL
 void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark)
 {
@@ -57,6 +66,40 @@ void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark)
 }
 
 EXPORT_SYMBOL
+/**
+ * nfq_nlmsg_verdict_put_pkt - Put replacement packet content into a netlink
+ * message
+ * \param nlh Pointer to netlink message
+ * \param pkt Pointer to start of modified IP datagram
+ * \param plen Length of modified IP datagram
+ *
+ * There is only ever a need to return packet content if it has been modified.
+ * Usually one of the nfq_*_mangle_* functions does the modifying.
+ *
+ * This code snippet uses nfq_udp_mangle_ipv4. See nf-queue.c for
+ * context:
+ * \verbatim
+// main calls queue_cb (line 64) to process an enqueued packet:
+	// Extra variables
+	uint8_t *payload, *rep_data;
+	unsigned int match_offset, match_len, rep_len;
+
+	// The next line was commented-out (with payload void*)
+	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
+	// Copy data to a packet buffer (allow 255 bytes for mangling).
+	pktb = pktb_alloc(AF_INET, payload, plen, 255);
+	// (decide that this packet needs mangling)
+	nfq_udp_mangle_ipv4(pktb, match_offset, match_len, rep_data, rep_len);
+	// Update IP Datagram length
+	plen += rep_len - match_len;
+
+	// Eventually nfq_send_verdict (line 39) gets called
+	// The received packet may or may not have been modified.
+	// Add this code before nfq_nlmsg_verdict_put call:
+	if (pktb_mangled(pktb))
+		nfq_nlmsg_verdict_put_pkt(nlh, pktb_data(pktb), plen);
+\endverbatim
+ */
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
 			       uint32_t plen)
 {
-- 
2.14.5

