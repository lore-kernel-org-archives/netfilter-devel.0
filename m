Return-Path: <SRS0=L7DL=Y3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73FCCA9EB0
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 11:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC1E2080F
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 11:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfKCL1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Nov 2019 06:27:54 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38823 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727379AbfKCL1y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Nov 2019 06:27:54 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id DFC503A0919
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Nov 2019 22:27:35 +1100 (AEDT)
Received: (qmail 30292 invoked by uid 501); 3 Nov 2019 11:27:35 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: doc: Eliminate doxygen warnings from ipv{4,6}.c
Date:   Sun,  3 Nov 2019 22:27:35 +1100
Message-Id: <20191103112735.30250-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=PO7r1zJSAAAA:8 a=ttg1TQaozeBJuh-qELsA:9
        a=cl3SHbEZzvOpcvJI:21 a=G2LTJ8BrdcxbVB18:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/extra/ipv4.c: - Rename pkt formal arg of nfq_ip_mangle to pktb
                     (to match all other struct pkt_buff args)
                   - Make it clear that packet buffer is the user-space one
                   - Sentence-case all parameter descriptions
                   - Fix \param 3 of nfq_pkt_snprintf_ip to match prototype
                   - Revised description of nfq_pkt_snprintf_ip for English
                     usage, but left the "strange behaviour" bit at the end.
                     (I know kernel developers hate snprintf: the purpose of the
                      return code was not a blanket buffer overrun check but
                      rather an amount to subtract from the size argument to the
                      next snprintf call.
                      It was therefore a bit of a screw-up to have snprintf take
                      an unsigned size_t argument so the -ve size looks like a
                      huge +ve one and snprintf keeps writing :(
                      The programmer needs to use a signed type for size and
                      explicitly test it for still being +ve before every
                      snprintf call; with ssize_t, snprintf could have done
                      nothing and returned zero with a -ve size so the
                      programmer only needs to check right at the end.
                      Ah well...)
 src/extra/ipv6.c: - Use \returns for all return values
                   - Fix \param 3 of nfq_ip6_snprintf to match prototype
                   - Sentence-case all parameter descriptions
                   - Change IPv4 to IPv6 in a comment

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c | 40 ++++++++++++++++++++--------------------
 src/extra/ipv6.c | 25 +++++++++++++------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 3eb1054..c256eee 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -27,7 +27,7 @@
 
 /**
  * nfq_ip_get_hdr - get IPv4 header
- * \param pktb: pointer to network packet buffer
+ * \param pktb: Pointer to user-space network packet buffer
  *
  * This funcion returns NULL if the IPv4 is malformed or the protocol version
  * is not 4. On success, it returns a valid pointer to the IPv4 header.
@@ -57,8 +57,8 @@ struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
 
 /**
  * nfq_ip_set_transport_header - set transport header
- * \param pktb: pointer to network packet buffer
- * \param iph: pointer to the IPv4 header
+ * \param pktb: Pointer to user-space network packet buffer
+ * \param iph: Pointer to the IPv4 header
  *
  * Sets the \b transport_header field in \b pktb
  *
@@ -79,7 +79,7 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 
 /**
  * nfq_ip_set_checksum - set IPv4 checksum
- * \param iph: pointer to the IPv4 header
+ * \param iph: Pointer to the IPv4 header
  *
  * \note Call to this function if you modified the IPv4 header to update the
  * checksum.
@@ -95,29 +95,29 @@ void nfq_ip_set_checksum(struct iphdr *iph)
 
 /**
  * nfq_ip_mangle - mangle IPv4 packet buffer
- * \param pktb: pointer to network packet buffer
- * \param dataoff: offset to layer 4 header
- * \param match_offset: offset to content that you want to mangle
- * \param match_len: length of the existing content you want to mangle
- * \param rep_buffer: pointer to data you want to use to replace current content
- * \param rep_len: length of data you want to use to replace current content
+ * \param pktb: Pointer to user-space network packet buffer
+ * \param dataoff: Offset to layer 4 header
+ * \param match_offset: Offset to content that you want to mangle
+ * \param match_len: Length of the existing content you want to mangle
+ * \param rep_buffer: Pointer to data you want to use to replace current content
+ * \param rep_len: Length of data you want to use to replace current content
  * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
  * \note This function updates the IPv4 length and recalculates the IPv4
  * checksum (if necessary)
  */
 EXPORT_SYMBOL
-int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
+int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 		  unsigned int match_offset, unsigned int match_len,
 		  const char *rep_buffer, unsigned int rep_len)
 {
-	struct iphdr *iph = (struct iphdr *) pkt->network_header;
+	struct iphdr *iph = (struct iphdr *) pktb->network_header;
 
-	if (!pktb_mangle(pkt, dataoff, match_offset, match_len,
+	if (!pktb_mangle(pktb, dataoff, match_offset, match_len,
 						rep_buffer, rep_len))
 		return 0;
 
 	/* fix IP hdr checksum information */
-	iph->tot_len = htons(pkt->len);
+	iph->tot_len = htons(pktb->len);
 	nfq_ip_set_checksum(iph);
 
 	return 1;
@@ -125,13 +125,13 @@ int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
 
 /**
  * nfq_pkt_snprintf_ip - print IPv4 header into buffer in iptables LOG format
- * \param buf: pointer to buffer that will be used to print the header
- * \param size: size of the buffer (or remaining room in it)
- * \param ip: pointer to a valid IPv4 header
+ * \param buf: Pointer to buffer that will be used to print the header
+ * \param size: Size of the buffer (or remaining room in it)
+ * \param iph: Pointer to a valid IPv4 header
  *
- * This function returns the number of bytes that would have been written in
- * case that there is enough room in the buffer. Read snprintf manpage for more
- * information to know more about this strange behaviour.
+ * This function returns the number of bytes written (excluding the
+ * string-terminating NUL) *assuming sufficient room in the buffer*.
+ * Read the snprintf manpage for more information about this strange behaviour.
  */
 EXPORT_SYMBOL
 int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index b599e91..af307d6 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -28,10 +28,9 @@
 
 /**
  * nfq_ip6_get_hdr - get IPv6 header
- * \param pktb: pointer to user-space network packet buffer
+ * \param pktb: Pointer to user-space network packet buffer
  *
- * This funcion returns NULL if an invalid header is found. On sucess, it
- * returns a valid pointer to the header.
+ * \returns pointer to IPv6 header if a valid header found, else NULL.
  */
 EXPORT_SYMBOL
 struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
@@ -39,7 +38,7 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 	struct ip6_hdr *ip6h;
 	unsigned int pktlen = pktb->tail - pktb->network_header;
 
-	/* Not enough room for IPv4 header. */
+	/* Not enough room for IPv6 header. */
 	if (pktlen < sizeof(struct ip6_hdr))
 		return NULL;
 
@@ -54,12 +53,12 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 
 /**
  * nfq_ip6_set_transport_header - set transport header pointer for IPv6 packet
- * \param pktb: pointer to user-space network packet buffer
- * \param ip6h: pointer to IPv6 header
- * \param target: protocol number to find transport header (ie. IPPROTO_*)
+ * \param pktb: Pointer to user-space network packet buffer
+ * \param ip6h: Pointer to IPv6 header
+ * \param target: Protocol number to find transport header (ie. IPPROTO_*)
  *
- * This function returns 1 if the protocol has been found and the transport
- * header has been set. Otherwise, it returns 0.
+ * \returns 1 if the protocol has been found and the transport
+ * header has been set, else 0.
  */
 EXPORT_SYMBOL
 int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
@@ -119,9 +118,11 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 
 /**
  * nfq_ip6_snprintf - print IPv6 header into one buffer in iptables LOG format
- * \param buf: pointer to buffer that is used to print the object
- * \param size: size of the buffer (or remaining room in it).
- * \param ip6_hdr: pointer to a valid IPv6 header.
+ * \param buf: Pointer to buffer that is used to print the object
+ * \param size: Size of the buffer (or remaining room in it).
+ * \param ip6h: Pointer to a valid IPv6 header.
+ * \returns same as snprintf
+ * \sa **snprintf**(3)
  *
  */
 EXPORT_SYMBOL
-- 
2.14.5

