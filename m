Return-Path: <SRS0=SsnH=2M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5872C2D0C1
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 03:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84DA62070A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Dec 2019 03:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLVDgQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Dec 2019 22:36:16 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39410 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbfLVDgQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Dec 2019 22:36:16 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 6B36F3A14D1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Dec 2019 14:36:02 +1100 (AEDT)
Received: (qmail 2005 invoked by uid 501); 22 Dec 2019 03:36:01 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: pktb_mangle has signed offset arg so can mangle MAC header with -ve one
Date:   Sun, 22 Dec 2019 14:36:01 +1100
Message-Id: <20191222033601.1961-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191220002953.gv25rcn7kvv43zk4@salvia>
References: <20191220002953.gv25rcn7kvv43zk4@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=wYwTXCFs3VUMfrEGBRkA:9 a=oHMS247rCS5qQ-Nj:21
        a=Ozg_w4j7DFa6LYUE:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Update prototype
- Update doxygen documentation
- Update declaration

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/pktbuff.h | 2 +-
 src/extra/pktbuff.c                  | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index b15ee1e..5bcc3e5 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -19,7 +19,7 @@ uint8_t *pktb_mac_header(struct pkt_buff *pktb);
 uint8_t *pktb_network_header(struct pkt_buff *pktb);
 uint8_t *pktb_transport_header(struct pkt_buff *pktb);
 
-int pktb_mangle(struct pkt_buff *pkt, unsigned int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int pktb_mangle(struct pkt_buff *pkt, int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 bool pktb_mangled(const struct pkt_buff *pktb);
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index c4f3da3..6250fbf 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -299,8 +299,10 @@ static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
 /**
  * pktb_mangle - adjust contents of a packet
  * \param pktb Pointer to userspace packet buffer
- * \param dataoff Offset to layer 4 header. Specify zero to access layer 3 (IP)
- * header (layer 2 for family \b AF_BRIDGE)
+ * \param dataoff Supplementary offset, usually offset from layer 3 (IP) header
+ * to the layer 4 (TCP or UDP) header. Specify zero to access the layer 3
+ * header. If \b pktb was created in family \b AF_BRIDGE, specify
+ * \b -ETH_HLEN (a negative offset) to access the layer 2 (MAC) header.
  * \param match_offset Further offset to content that you want to mangle
  * \param match_len Length of the existing content you want to mangle
  * \param rep_buffer Pointer to data you want to use to replace current content
@@ -316,7 +318,7 @@ static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
  */
 EXPORT_SYMBOL
 int pktb_mangle(struct pkt_buff *pktb,
-		unsigned int dataoff,
+		int dataoff,
 		unsigned int match_offset,
 		unsigned int match_len,
 		const char *rep_buffer,
-- 
2.14.5

