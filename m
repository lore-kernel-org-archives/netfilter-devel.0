Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4F3C33CB1
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 14:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD15206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 14:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgAQOKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 09:10:10 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46984 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgAQOKJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 09:10:09 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id C8A363A206B
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Jan 2020 01:09:56 +1100 (AEDT)
Received: (qmail 23867 invoked by uid 501); 17 Jan 2020 14:09:55 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Simplify struct pkt_buff: remove tail
Date:   Sat, 18 Jan 2020 01:09:55 +1100
Message-Id: <20200117140955.23823-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200117113203.17313-1-duncan_roe@optusnet.com.au>
References: <20200117113203.17313-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=l51qDUzY3YqzZGKofNoA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In struct pkt_buff, we only ever needed any 2 of len, data and tail.
This has caused bugs in the past, e.g. commit 8a4316f31.
Delete tail, and where the value of pktb->tail was required,
use new PKTB_TAIL macro.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c    | 4 ++--
 src/extra/ipv6.c    | 8 ++++----
 src/extra/pktbuff.c | 6 +-----
 src/extra/tcp.c     | 6 +++---
 src/extra/udp.c     | 6 +++---
 src/internal.h      | 2 +-
 6 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index caafd37..bd5da22 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL
 struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
 {
 	struct iphdr *iph;
-	unsigned int pktlen = pktb->tail - pktb->network_header;
+	unsigned int pktlen = PKTB_TAIL - pktb->network_header;
 
 	/* Not enough room for IPv4 header. */
 	if (pktlen < sizeof(struct iphdr))
@@ -135,7 +135,7 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 		return 0;
 
 	/* fix IP hdr checksum information */
-	iph->tot_len = htons(pktb->tail - pktb->network_header);
+	iph->tot_len = htons(PKTB_TAIL - pktb->network_header);
 	nfq_ip_set_checksum(iph);
 
 	return 1;
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 6e8820c..b6542f9 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -36,7 +36,7 @@ EXPORT_SYMBOL
 struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 {
 	struct ip6_hdr *ip6h;
-	unsigned int pktlen = pktb->tail - pktb->network_header;
+	unsigned int pktlen = PKTB_TAIL - pktb->network_header;
 
 	/* Not enough room for IPv6 header. */
 	if (pktlen < sizeof(struct ip6_hdr))
@@ -77,7 +77,7 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 			break;
 		}
 		/* No room for extension, bad packet. */
-		if (pktb->tail - cur < sizeof(struct ip6_ext)) {
+		if (PKTB_TAIL - cur < sizeof(struct ip6_ext)) {
 			cur = NULL;
 			break;
 		}
@@ -87,7 +87,7 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 			uint16_t *frag_off;
 
 			/* No room for full fragment header, bad packet. */
-			if (pktb->tail - cur < sizeof(struct ip6_frag)) {
+			if (PKTB_TAIL - cur < sizeof(struct ip6_frag)) {
 				cur = NULL;
 				break;
 			}
@@ -140,7 +140,7 @@ int nfq_ip6_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 
 	/* Fix IPv6 hdr length information */
 	ip6h->ip6_plen =
-		htons(pktb->tail - pktb->network_header - sizeof *ip6h);
+		htons(PKTB_TAIL - pktb->network_header - sizeof *ip6h);
 
 	return 1;
 }
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index c95384f..f97750f 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -67,7 +67,6 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pktb->data_len = len + extra;
 
 	pktb->data = pkt_data;
-	pktb->tail = pktb->data + len;
 
 	switch(family) {
 	case AF_INET:
@@ -190,7 +189,6 @@ void pktb_pull(struct pkt_buff *pktb, unsigned int len)
 EXPORT_SYMBOL
 void pktb_put(struct pkt_buff *pktb, unsigned int len)
 {
-	pktb->tail += len;
 	pktb->len += len;
 }
 
@@ -203,7 +201,6 @@ EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->len = len;
-	pktb->tail = pktb->data + len;
 }
 
 /**
@@ -279,7 +276,6 @@ static int pktb_expand_tail(struct pkt_buff *pktb, int extra)
 		return 0;
 
 	pktb->len += extra;
-	pktb->tail = pktb->tail + extra;
 	return 1;
 }
 
@@ -334,7 +330,7 @@ int pktb_mangle(struct pkt_buff *pktb,
 	/* move post-replacement */
 	memmove(data + match_offset + rep_len,
 		data + match_offset + match_len,
-		pktb->tail - (pktb->network_header + dataoff +
+		PKTB_TAIL - (pktb->network_header + dataoff +
 			     match_offset + match_len));
 
 	/* insert data from buffer */
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index cca20e7..eb43067 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -46,7 +46,7 @@ struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
 		return NULL;
 
 	/* No room for the TCP header. */
-	if (pktb->tail - pktb->transport_header < sizeof(struct tcphdr))
+	if (PKTB_TAIL - pktb->transport_header < sizeof(struct tcphdr))
 		return NULL;
 
 	return (struct tcphdr *)pktb->transport_header;
@@ -68,7 +68,7 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 		return NULL;
 
 	/* malformed TCP data offset. */
-	if (pktb->transport_header + len > pktb->tail)
+	if (pktb->transport_header + len > PKTB_TAIL)
 		return NULL;
 
 	return pktb->transport_header + len;
@@ -83,7 +83,7 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 EXPORT_SYMBOL
 unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
 {
-	return pktb->tail - pktb->transport_header - (tcph->doff * 4);
+	return PKTB_TAIL - pktb->transport_header - (tcph->doff * 4);
 }
 
 /**
diff --git a/src/extra/udp.c b/src/extra/udp.c
index dc476d4..4b7e3cc 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -46,7 +46,7 @@ struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
 		return NULL;
 
 	/* No room for the UDP header. */
-	if (pktb->tail - pktb->transport_header < sizeof(struct udphdr))
+	if (PKTB_TAIL - pktb->transport_header < sizeof(struct udphdr))
 		return NULL;
 
 	return (struct udphdr *)pktb->transport_header;
@@ -68,7 +68,7 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 		return NULL;
 
 	/* malformed UDP packet. */
-	if (pktb->transport_header + len > pktb->tail)
+	if (pktb->transport_header + len > PKTB_TAIL)
 		return NULL;
 
 	return pktb->transport_header + sizeof(struct udphdr);
@@ -83,7 +83,7 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 EXPORT_SYMBOL
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
-	return pktb->tail - pktb->transport_header - sizeof(struct udphdr);
+	return PKTB_TAIL - pktb->transport_header - sizeof(struct udphdr);
 }
 
 /**
diff --git a/src/internal.h b/src/internal.h
index 0cfa425..dafb33a 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -9,6 +9,7 @@
 #else
 #	define EXPORT_SYMBOL
 #endif
+#define PKTB_TAIL (pktb->data + pktb->len)
 
 struct iphdr;
 struct ip6_hdr;
@@ -24,7 +25,6 @@ struct pkt_buff {
 	uint8_t *transport_header;
 
 	uint8_t *data;
-	uint8_t *tail;
 
 	uint32_t len;
 	uint32_t data_len;
-- 
2.14.5

