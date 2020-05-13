Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C802C2D0FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36ACD20708
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 06:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgEMGtq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 02:49:46 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41395 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729367AbgEMGtp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 02:49:45 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail109.syd.optusnet.com.au (Postfix) with SMTP id 71B19D786C7
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 16:49:43 +1000 (AEST)
Received: (qmail 28454 invoked by uid 501); 13 May 2020 06:49:41 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src & doc: Rename pktb_alloc2 to pktb_setup
Date:   Wed, 13 May 2020 16:49:41 +1000
Message-Id: <20200513064941.28408-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200513064941.28408-1-duncan_roe@optusnet.com.au>
References: <20200513064941.28408-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20200510151001.GA6216@salvia>
References: <20200510151001.GA6216@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=-C3Z8BRtcUK2uSSGYToA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 fixmanpages.sh                       |  2 +-
 include/libnetfilter_queue/pktbuff.h |  4 +++-
 src/extra/pktbuff.c                  | 37 ++++++++++++++++++------------------
 src/nlmsg.c                          |  2 +-
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fixmanpages.sh b/fixmanpages.sh
index 86f902b..851e334 100755
--- a/fixmanpages.sh
+++ b/fixmanpages.sh
@@ -31,7 +31,7 @@ function main
     add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
   setgroup nlmsg nfq_nlmsg_parse
     add2group nfq_nlmsg_put
-  setgroup pktbuff pktb_alloc2
+  setgroup pktbuff pktb_setup
     add2group pktb_data pktb_len pktb_mangle pktb_mangled pktb_head_size
     setgroup otherfns pktb_tailroom
       add2group pktb_mac_header pktb_network_header pktb_transport_header
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index fd0a3f3..a7a8f8f 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,10 +4,12 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
-struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buflen, void *data, size_t len);
 void pktb_free(struct pkt_buff *pktb);
 
 #define NFQ_BUFFER_SIZE	(0xffff + (MNL_SOCKET_BUFFER_SIZE / 2)
+struct pkt_buff *pktb_setup(int family, void *buf, size_t buflen, void *data, size_t len);
+
+#define pktb_head_alloc()	(struct pkt_buff *)(malloc(pktb_head_size()))
 
 uint8_t *pktb_data(struct pkt_buff *pktb);
 uint32_t pktb_len(struct pkt_buff *pktb);
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index cc8ad13..a0cb3c7 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -31,18 +31,17 @@
  * @{
  */
 
-static int pktb_setup_family(struct pkt_buff *pktb, int family)
+static int __pktb_setup(int family, struct pkt_buff *pktb)
 {
 	struct ethhdr *ethhdr;
 
-	switch(family) {
+	switch (family) {
 	case AF_INET:
 	case AF_INET6:
 		pktb->network_header = pktb->data;
 		break;
 	case AF_BRIDGE:
 		ethhdr = (struct ethhdr *)pktb->data;
-
 		pktb->mac_header = pktb->data;
 
 		switch(ethhdr->h_proto) {
@@ -92,7 +91,7 @@ static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
  * \n
  * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
  * (v4 or v6)
- * \note __pktb_alloc__ is deprecated. Use pktb_alloc2() in new code
+ * \note __pktb_alloc__ is deprecated. Use pktb_setup() in new code
  * \sa __calloc__(3)
  */
 EXPORT_SYMBOL
@@ -112,7 +111,7 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 
 	pktb_setup_metadata(pktb, pkt_data, len, extra);
 
-	if (pktb_setup_family(pktb, family) < 0) {
+	if (__pktb_setup(family, pktb) < 0) {
 		free(pktb);
 		return NULL;
 	}
@@ -125,7 +124,17 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
  */
 
 /**
- * pktb_alloc2 - make a packet buffer from an existing buffer
+ * pktb_head_size - get size of struct pkt_buff
+ * \return Size of (opaque) __struct pkt_buff__
+ */
+EXPORT_SYMBOL
+size_t pktb_head_size(void)
+{
+	return sizeof(struct pkt_buff);
+}
+
+/**
+ * pktb_setup - make a packet buffer from an existing buffer
  * \param family Indicate what family. Currently supported families are
  * AF_BRIDGE, AF_INET & AF_INET6.
  * \param buf Buffer to hold packet metadata, and packet contents _if_
@@ -176,7 +185,7 @@ static char buf[NFQ_BUFFER_SIZE];
  * \sa nfq_nlmsg_verdict_put_pkt() (has sample code using __pktb_alloc2__)
  */
 EXPORT_SYMBOL
-struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buflen,
+struct pkt_buff *pktb_setup(int family, void *buf, size_t buflen,
 			     void *data, size_t len)
 {
 	struct pkt_buff *pktb;
@@ -194,7 +203,7 @@ struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buflen,
 
 	pktb_setup_metadata(pktb, pkt_data, len, 0);
 	pktb->buf_len = buflen;
-	if (pktb_setup_family(pktb, family) < 0)
+	if (__pktb_setup(family, pktb) < 0)
 		pktb = NULL;
 	return pktb;
 }
@@ -231,16 +240,6 @@ uint32_t pktb_len(struct pkt_buff *pktb)
 	return pktb->len;
 }
 
-/**
- * pktb_head_size - get size of struct pkt_buff
- * \return Size of (opaque) __struct pkt_buff__
- */
-EXPORT_SYMBOL
-size_t pktb_head_size(void)
-{
-	return sizeof(struct pkt_buff);
-}
-
 /**
  * \defgroup otherfns Other functions
  *
@@ -261,7 +260,7 @@ size_t pktb_head_size(void)
  * pktb_free - release packet buffer [DEPRECATED]
  * \param pktb Pointer to userspace packet buffer
  * \note __pktb_free__ is deprecated.
- * It is not required and must not be used with pktb_alloc2()
+ * It is not required and must not be used with pktb_setup()
  */
 EXPORT_SYMBOL
 void pktb_free(struct pkt_buff *pktb)
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f3a2c62..a6188cc 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL
 	// The next line was commented-out (with payload void*)
 	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
 	// Set up a packet buffer (the large pktbuf allows for any mangling).
-	pktb = pktb_alloc2(AF_INET, pktbuf, sizeof pktbuf, payload, plen);
+	pktb = pktb_setup(AF_INET, pktbuf, sizeof pktbuf, payload, plen);
 	// (decide that this packet needs mangling)
 	nfq_udp_mangle_ipv4(pktb, match_offset, match_len, rep_data, rep_len);
 	// nfq_udp_mangle_ipv4 updates packet length, no need to track locally
-- 
2.14.5

