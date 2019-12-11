Return-Path: <SRS0=EbRH=2B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF52C2D0C6
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 22:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA532077B
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 22:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLKWhi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 17:37:38 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:32910 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfLKWhi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 17:37:38 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 714C13A3024
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 09:37:20 +1100 (AEDT)
Received: (qmail 30116 invoked by uid 501); 11 Dec 2019 22:37:19 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] src: doc: Eliminate doxygen warnings from udp.c
Date:   Thu, 12 Dec 2019 09:37:19 +1100
Message-Id: <20191211223719.30070-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191211223719.30070-1-duncan_roe@optusnet.com.au>
References: <20191211223719.30070-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=QQoG7Y54ag0NdHCkiRkA:9 a=tucDlVSJ5OocSiML:21
        a=xQZlZJP5yxJM1niR:21 a=XStyNKNTBhcjMNURsHPe:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/udp.c: - Make it clear that packet buffer is the user-space one
                  - Use \returns for all return values
                  - Make function names in doc agree with prototypes
                  - Make number and names of params in doc agree with prototypes
                  - Divide functions into a hierarchy:
                     top-level: Functions all programs that modify data will use
                                (nfq_udp_snprintf is optional)
                     2nd-level: Rarely-used (except internally) functions
                  - Add see-also snprintf

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/udp.c | 50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/src/extra/udp.c b/src/extra/udp.c
index eb301f2..da03be8 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -31,10 +31,9 @@
 
 /**
  * nfq_udp_get_hdr - get the UDP header.
- * \param pktb: Pointer to network packet buffer
+ * \param pktb: Pointer to userspace network packet buffer
  *
- * This function returns NULL if invalid UDP header is found. On success,
- * it returns the UDP header.
+ * \returns Pointer to the UDP header, or NULL if no valid UDP header is found.
  */
 EXPORT_SYMBOL
 struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
@@ -52,7 +51,8 @@ struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
 /**
  * nfq_udp_get_payload - get the UDP packet payload.
  * \param udph: Pointer to UDP header
- * \param pktb: Pointer to network packet buffer
+ * \param pktb: Pointer to userspace network packet buffer
+ * \returns Pointer to the UDP payload, or NULL if malformed UDP packet.
  */
 EXPORT_SYMBOL
 void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
@@ -73,7 +73,8 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 /**
  * nfq_udp_get_payload_len - get the udp packet payload.
  * \param udph: Pointer to UDP header
- * \param pktb: Pointer to network packet buffer
+ * \param pktb: Pointer to userspace network packet buffer
+ * \returns Length of UDP payload (user data)
  */
 EXPORT_SYMBOL
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
@@ -82,14 +83,22 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 }
 
 /**
- * nfq_udp_set_checksum_ipv4 - computes a IPv4/TCP packet's segment
- * \param iphdrp: pointer to the ip header
- * \param ippayload: payload of the ip packet
+ * \defgroup internals Internal functions
  *
- * \returns the checksum of the udp segment.
+ * Most user-space programs will never need these.
  *
- * \see nfq_pkt_compute_ip_checksum
- * \see nfq_pkt_compute_udp_checksum
+ * @{
+ */
+
+/**
+ * nfq_udp_compute_checksum_ipv4 - sets up the UDP checksum in a UDP/IPv4 packet
+ * \param udph: pointer to the UDP header
+ * \param iph: pointer to the IPv4 header
+ * \note
+ * nfq_udp_mangle_ipv4() invokes this function.
+ * As long as developers always use __nfq_udp_mangle_ipv4__ when changing the
+ * content of a UDP message, there is no need to call
+ * __nfq_udp_compute_checksum_ipv4__.
  */
 EXPORT_SYMBOL
 void nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
@@ -100,14 +109,13 @@ void nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
 }
 
 /**
- * nfq_udp_set_checksum_ipv6 - computes a IPv6/TCP packet's segment
- * \param iphdrp: pointer to the ip header
- * \param ippayload: payload of the ip packet
- *
- * \returns the checksum of the udp segment.
- *
- * \see nfq_pkt_compute_ip_checksum
- * \see nfq_pkt_compute_udp_checksum
+ * @}
+ */
+
+/**
+ * nfq_udp_compute_checksum_ipv6 - sets up the UDP checksum in a UDP/IPv6 packet
+ * \param udph: pointer to the UDP header
+ * \param ip6h: pointer to the IPv6 header
  */
 EXPORT_SYMBOL
 void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
@@ -156,7 +164,9 @@ int nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
  * readable way
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
- * \param udp: pointer to a valid udp header.
+ * \param udph: pointer to a valid udp header.
+ * \returns The number of characters notionally written (excluding trailing NUL)
+ * \sa __snprintf__(3)
  *
  */
 EXPORT_SYMBOL
-- 
2.14.5

