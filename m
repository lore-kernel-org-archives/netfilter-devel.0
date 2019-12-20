Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5127DC43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 05:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A801227BF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 05:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLTFyF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 00:54:05 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45295 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbfLTFyF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 00:54:05 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id CE759820004
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 16:53:48 +1100 (AEDT)
Received: (qmail 24163 invoked by uid 501); 20 Dec 2019 05:53:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] src: add mangle functions for IPv6, IPv6/TCP and IPv6/UDP
Date:   Fri, 20 Dec 2019 16:53:48 +1100
Message-Id: <20191220055348.24113-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191220055348.24113-1-duncan_roe@optusnet.com.au>
References: <20191220055348.24113-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=yqmiQjsSZ5ETotf7rwoA:9 a=yfWvxkdt8hjYQcGF:21
        a=I6fXZnAS6tfgaCu6:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue_ipv6.h   |  1 +
 .../libnetfilter_queue/libnetfilter_queue_tcp.h    |  1 +
 .../libnetfilter_queue/libnetfilter_queue_udp.h    |  1 +
 src/extra/ipv6.c                                   | 29 ++++++++++++++++
 src/extra/tcp.c                                    | 40 ++++++++++++++++++++++
 src/extra/udp.c                                    | 39 +++++++++++++++++++++
 6 files changed, 111 insertions(+)

diff --git a/include/libnetfilter_queue/libnetfilter_queue_ipv6.h b/include/libnetfilter_queue/libnetfilter_queue_ipv6.h
index 93452ce..c0a7d37 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_ipv6.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_ipv6.h
@@ -6,6 +6,7 @@ struct ip6_hdr;
 
 struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb);
 int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *iph, uint8_t target);
+int nfq_ip6_mangle(struct pkt_buff *pktb, unsigned int dataoff,unsigned int match_offset, unsigned int match_len,const char *rep_buffer, unsigned int rep_len);
 int nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h);
 
 #endif
diff --git a/include/libnetfilter_queue/libnetfilter_queue_tcp.h b/include/libnetfilter_queue/libnetfilter_queue_tcp.h
index c66dfb6..997d997 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_tcp.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_tcp.h
@@ -14,6 +14,7 @@ void nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph);
 void nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h);
 
 int nfq_tcp_mangle_ipv4(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_tcp_mangle_ipv6(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcp);
 
diff --git a/include/libnetfilter_queue/libnetfilter_queue_udp.h b/include/libnetfilter_queue/libnetfilter_queue_udp.h
index f4b6c49..f9fd609 100644
--- a/include/libnetfilter_queue/libnetfilter_queue_udp.h
+++ b/include/libnetfilter_queue/libnetfilter_queue_udp.h
@@ -11,6 +11,7 @@ void nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph);
 void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h);
 
 int nfq_udp_mangle_ipv4(struct pkt_buff *pkt, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
+int nfq_udp_mangle_ipv6(struct pkt_buff *pktb, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 int nfq_udp_snprintf(char *buf, size_t size, const struct udphdr *udp);
 
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index f685b3b..6e8820c 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -116,6 +116,35 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 	return cur ? 1 : 0;
 }
 
+/**
+ * nfq_ip6_mangle - mangle IPv6 packet buffer
+ * \param pktb: Pointer to user-space network packet buffer
+ * \param dataoff: Offset to layer 4 header
+ * \param match_offset: Offset to content that you want to mangle
+ * \param match_len: Length of the existing content you want to mangle
+ * \param rep_buffer: Pointer to data you want to use to replace current content
+ * \param rep_len: Length of data you want to use to replace current content
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv6 length (if necessary)
+ */
+EXPORT_SYMBOL
+int nfq_ip6_mangle(struct pkt_buff *pktb, unsigned int dataoff,
+		   unsigned int match_offset, unsigned int match_len,
+		   const char *rep_buffer, unsigned int rep_len)
+{
+	struct ip6_hdr *ip6h = (struct ip6_hdr *)pktb->network_header;
+
+	if (!pktb_mangle(pktb, dataoff, match_offset, match_len, rep_buffer,
+			 rep_len))
+		return 0;
+
+	/* Fix IPv6 hdr length information */
+	ip6h->ip6_plen =
+		htons(pktb->tail - pktb->network_header - sizeof *ip6h);
+
+	return 1;
+}
+
 /**
  * nfq_ip6_snprintf - print IPv6 header into one buffer in iptables LOG format
  * \param buf: Pointer to buffer that is used to print the object
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 136d7ea..8119843 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -21,6 +21,7 @@
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include <libnetfilter_queue/libnetfilter_queue_tcp.h>
 #include <libnetfilter_queue/libnetfilter_queue_ipv4.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv6.h>
 #include <libnetfilter_queue/pktbuff.h>
 
 #include "internal.h"
@@ -206,6 +207,45 @@ int nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
 	return 1;
 }
 
+/**
+ * nfq_tcp_mangle_ipv6 - Mangle TCP/IPv6 packet buffer
+ * \param pktb: Pointer to network packet buffer
+ * \param match_offset: Offset from start of TCP data of content that you want
+ * to mangle
+ * \param match_len: Length of the existing content you want to mangle
+ * \param rep_buffer: Pointer to data you want to use to replace current content
+ * \param rep_len: Length of data you want to use to replace current content
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv6 length and recalculates the TCP
+ * checksum for you.
+ * \warning After changing the length of a TCP message, the application will
+ * need to mangle sequence numbers in both directions until another change
+ * puts them in sync again
+ */
+EXPORT_SYMBOL
+int nfq_tcp_mangle_ipv6(struct pkt_buff *pktb,
+			unsigned int match_offset, unsigned int match_len,
+			const char *rep_buffer, unsigned int rep_len)
+{
+	struct ip6_hdr *ip6h;
+	struct tcphdr *tcph;
+
+	ip6h = (struct ip6_hdr *)pktb->network_header;
+	tcph = (struct tcphdr *)(pktb->transport_header);
+	if (!tcph)
+		return 0;
+
+	if (!nfq_ip6_mangle(pktb,
+			   pktb->transport_header - pktb->network_header +
+			   tcph->doff * 4,
+			   match_offset, match_len, rep_buffer, rep_len))
+		return 0;
+
+	nfq_tcp_compute_checksum_ipv6(tcph, ip6h);
+
+	return 1;
+}
+
 /**
  * @}
  */
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 34dbf2a..9eee1c7 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -20,6 +20,7 @@
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include <libnetfilter_queue/libnetfilter_queue_udp.h>
 #include <libnetfilter_queue/libnetfilter_queue_ipv4.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv6.h>
 #include <libnetfilter_queue/pktbuff.h>
 
 #include "internal.h"
@@ -159,6 +160,44 @@ int nfq_udp_mangle_ipv4(struct pkt_buff *pktb,
 	return 1;
 }
 
+/**
+ * nfq_udp_mangle_ipv6 - Mangle UDP/IPv6 packet buffer
+ * \param pktb: Pointer to network packet buffer
+ * \param match_offset: Offset from start of UDP data of content that you want
+ * to mangle
+ * \param match_len: Length of the existing content you want to mangle
+ * \param rep_buffer: Pointer to data you want to use to replace current content
+ * \param rep_len: Length of data you want to use to replace current content
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv6 and UDP lengths and recalculates the UDP
+ * checksum for you.
+ */
+EXPORT_SYMBOL
+int nfq_udp_mangle_ipv6(struct pkt_buff *pktb,
+			unsigned int match_offset, unsigned int match_len,
+			const char *rep_buffer, unsigned int rep_len)
+{
+	struct ip6_hdr *ip6h;
+	struct udphdr *udph;
+
+	ip6h = (struct ip6_hdr *)pktb->network_header;
+	udph = (struct udphdr *)(pktb->transport_header);
+	if (!udph)
+		return 0;
+
+	udph->len = htons(ntohs(udph->len) + rep_len - match_len);
+
+	if (!nfq_ip6_mangle(pktb,
+			    pktb->transport_header - pktb->network_header +
+			    sizeof(struct udphdr),
+			    match_offset, match_len, rep_buffer, rep_len))
+		return 0;
+
+	nfq_udp_compute_checksum_ipv6(udph, ip6h);
+
+	return 1;
+}
+
 /**
  * nfq_pkt_snprintf_udp_hdr - print udp header into one buffer in a humnan
  * readable way
-- 
2.14.5

