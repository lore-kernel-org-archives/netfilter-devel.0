Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD9BC33CA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 04:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ADD52072E
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 04:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgAJEJm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 23:09:42 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48986 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731298AbgAJEJm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 23:09:42 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 601EC3A310C
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 15:09:26 +1100 (AEDT)
Received: (qmail 16168 invoked by uid 501); 10 Jan 2020 04:09:25 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue] src: Simplify struct pkt_buff
Date:   Fri, 10 Jan 2020 15:09:25 +1100
Message-Id: <20200110040925.16124-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=Jl-TZFZsi0qgZRGVfQoA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In struct pkt_buff:
- We only ever needed any 2 of len, data and tail.
  This has caused bugs in the past, e.g. commit 8a4316f31.
  Delete len, and where the value of pktb->len was required,
  use new PKTB_LEN macro.
- head and data always had the same value.
  head was in the minority, so replace with data where it was used.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c    |  2 +-
 src/extra/pktbuff.c | 21 +++++++--------------
 src/internal.h      |  3 +--
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index c03f23f..8e36861 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -70,7 +70,7 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 	int doff = iph->ihl * 4;
 
 	/* Wrong offset to IPv4 payload. */
-	if ((int)pktb->len - doff <= 0)
+	if ((int)PKTB_LEN - doff <= 0)
 		return -1;
 
 	pktb->transport_header = pktb->network_header + doff;
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 37f6bc0..0b67029 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -62,12 +62,10 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
 
-	pktb->len = len;
 	pktb->data_len = len + extra;
 
-	pktb->head = pkt_data;
 	pktb->data = pkt_data;
-	pktb->tail = pktb->head + len;
+	pktb->tail = pktb->data + len;
 
 	switch(family) {
 	case AF_INET:
@@ -121,7 +119,7 @@ uint8_t *pktb_data(struct pkt_buff *pktb)
 EXPORT_SYMBOL
 uint32_t pktb_len(struct pkt_buff *pktb)
 {
-	return pktb->len;
+	return PKTB_LEN;
 }
 
 /**
@@ -169,7 +167,6 @@ EXPORT_SYMBOL
 void pktb_push(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->data -= len;
-	pktb->len += len;
 }
 
 /**
@@ -181,7 +178,6 @@ EXPORT_SYMBOL
 void pktb_pull(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->data += len;
-	pktb->len -= len;
 }
 
 /**
@@ -193,7 +189,6 @@ EXPORT_SYMBOL
 void pktb_put(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->tail += len;
-	pktb->len += len;
 }
 
 /**
@@ -204,8 +199,7 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
-	pktb->len = len;
-	pktb->tail = pktb->head + len;
+	pktb->tail = pktb->data + len;
 }
 
 /**
@@ -224,7 +218,7 @@ void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 EXPORT_SYMBOL
 unsigned int pktb_tailroom(struct pkt_buff *pktb)
 {
-	return pktb->data_len - pktb->len;
+	return pktb->data_len - PKTB_LEN;
 }
 
 /**
@@ -277,17 +271,16 @@ static int pktb_expand_tail(struct pkt_buff *pktb, int extra)
 	 * reallocation. Instead, increase the size of the extra room in
 	 * the tail in pktb_alloc.
 	 */
-	if (pktb->len + extra > pktb->data_len)
+	if (PKTB_LEN + extra > pktb->data_len)
 		return 0;
 
-	pktb->len += extra;
 	pktb->tail = pktb->tail + extra;
 	return 1;
 }
 
 static int enlarge_pkt(struct pkt_buff *pktb, unsigned int extra)
 {
-	if (pktb->len + extra > 65535)
+	if (PKTB_LEN + extra > 65535)
 		return 0;
 
 	if (!pktb_expand_tail(pktb, extra - pktb_tailroom(pktb)))
@@ -346,7 +339,7 @@ int pktb_mangle(struct pkt_buff *pktb,
 	if (rep_len > match_len)
 		pktb_put(pktb, rep_len - match_len);
 	else
-		pktb_trim(pktb, pktb->len + rep_len - match_len);
+		pktb_trim(pktb, PKTB_LEN + rep_len - match_len);
 
 	pktb->mangled = true;
 	return 1;
diff --git a/src/internal.h b/src/internal.h
index d968325..95ac03e 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -9,6 +9,7 @@
 #else
 #	define EXPORT_SYMBOL
 #endif
+#define PKTB_LEN (pktb->tail - pktb->data)
 
 struct iphdr;
 struct ip6_hdr;
@@ -23,11 +24,9 @@ struct pkt_buff {
 	uint8_t *network_header;
 	uint8_t *transport_header;
 
-	uint8_t *head;
 	uint8_t *data;
 	uint8_t *tail;
 
-	uint32_t len;
 	uint32_t data_len;
 
 	bool	mangled;
-- 
2.14.5

