Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19469C282DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 00:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42DA20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 00:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgAJAy6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 19:54:58 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58353 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730385AbgAJAy6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 19:54:58 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 29891820303
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 11:54:44 +1100 (AEDT)
Received: (qmail 32042 invoked by uid 501); 10 Jan 2020 00:54:43 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: doc: Final polish for current round
Date:   Fri, 10 Jan 2020 11:54:43 +1100
Message-Id: <20200110005443.32000-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=8BuoD0IbghCd1ciezMEA:9 a=u5K6kacvWUVWltMN:21 a=nQ1K9aK_MReaGBk6:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Ensure all functions that return something have a \returns
- Demote more checksum functions to their own groups
  (reduces number of functions on main pages)
- Clarify wording where appropriate
- Add \sa (see also) where appropriate
- Fix documented function name for nfq_tcp_get_hdr
  (no other mismatches noticed, but there may be some)
- Add warnings regarding changing length of tcp packet
- Make group names unique within libnetfilter_queue
  (else man pages would be overwritten)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c | 52 ++++++++++++++++++++++++++++++++++------------------
 src/extra/tcp.c  | 46 +++++++++++++++++++++++++++++++++++++---------
 src/extra/udp.c  | 20 ++++++++++++++------
 src/nlmsg.c      |  4 +---
 4 files changed, 86 insertions(+), 36 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index c03f23f..caafd37 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -26,11 +26,15 @@
  */
 
 /**
- * nfq_ip_get_hdr - get IPv4 header
+ * nfq_ip_get_hdr - get the IPv4 header
  * \param pktb: Pointer to user-space network packet buffer
+ * \returns validated pointer to the IPv4 header or NULL if IP is malformed or
+ * not version 4
  *
- * This funcion returns NULL if the IPv4 is malformed or the protocol version
- * is not 4. On success, it returns a valid pointer to the IPv4 header.
+ * Many programs will not need to call this function. A possible use is to
+ * determine the layer 4 protocol. The validation is that the buffer is big
+ * enough for the declared lengths in the header, i.e. an extra check for packet
+ * truncation.
  */
 EXPORT_SYMBOL
 struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
@@ -56,13 +60,14 @@ struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
 }
 
 /**
- * nfq_ip_set_transport_header - set transport header
+ * nfq_ip_set_transport_header - set the \b transport_header field in \b pktb
  * \param pktb: Pointer to user-space network packet buffer
  * \param iph: Pointer to the IPv4 header
- *
- * Sets the \b transport_header field in \b pktb
- *
- * Level 4 helper functions need this to be set.
+ * \returns 0 on success or -1 if a minimal validation check fails
+ * \note
+ * Most programs should call __nfq_ip_set_transport_header__ as soon as
+ * possible, since most layer 4 helper functions assume the
+ * \b transport_header field is valid.
  */
 EXPORT_SYMBOL
 int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
@@ -77,12 +82,21 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 	return 0;
 }
 
+/**
+ * \defgroup ip_internals Internal IP functions
+ *
+ * Most user-space programs will never need these.
+ *
+ * @{
+ */
+
 /**
  * nfq_ip_set_checksum - set IPv4 checksum
  * \param iph: Pointer to the IPv4 header
- *
- * \note Call to this function if you modified the IPv4 header to update the
- * checksum.
+ * \note
+ * nfq_ip_mangle() invokes this function.
+ * As long as developers always use the appropriate mangler for the layer being
+ * mangled, there is no need to call __nfq_ip_set_checksum__.
  */
 EXPORT_SYMBOL
 void nfq_ip_set_checksum(struct iphdr *iph)
@@ -93,17 +107,21 @@ void nfq_ip_set_checksum(struct iphdr *iph)
 	iph->check = nfq_checksum(0, (uint16_t *)iph, iph_len);
 }
 
+/**
+ * @}
+ */
+
 /**
  * nfq_ip_mangle - mangle IPv4 packet buffer
  * \param pktb: Pointer to user-space network packet buffer
- * \param dataoff: Offset to layer 4 header
+ * \param dataoff: Offset to layer 4 header, or zero to mangle IP header
  * \param match_offset: Offset to content that you want to mangle
  * \param match_len: Length of the existing content you want to mangle
  * \param rep_buffer: Pointer to data you want to use to replace current content
  * \param rep_len: Length of data you want to use to replace current content
  * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
- * \note This function updates the IPv4 length and recalculates the IPv4
- * checksum (if necessary)
+ * \note This function updates the IPv4 length if necessary and recalculates the
+ * IPv4 checksum.
  */
 EXPORT_SYMBOL
 int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
@@ -128,10 +146,8 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
  * \param buf: Pointer to buffer that will be used to print the header
  * \param size: Size of the buffer (or remaining room in it)
  * \param iph: Pointer to a valid IPv4 header
- *
- * This function returns the number of bytes written (excluding the
- * string-terminating NUL) *assuming sufficient room in the buffer*.
- * Read the snprintf manpage for more information about this strange behaviour.
+ * \returns same as snprintf
+ * \sa **snprintf**(3)
  */
 EXPORT_SYMBOL
 int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 236663f..d3a65d3 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -32,14 +32,12 @@
  */
 
 /**
- * nfq_tcp_get - get the TCP header
+ * nfq_tcp_get_hdr - get the TCP header
  * \param pktb: pointer to user-space network packet buffer
- *
- * This function returns NULL if an invalid TCP header is found. On success,
- * it returns the TCP header.
- *
- * \note You have to call nfq_ip_set_transport_header or
- * nfq_ip6_set_transport_header first to access the TCP header.
+ * \returns validated pointer to the TCP header or NULL if the TCP header was
+ * not set or if a minimal length check fails.
+ * \note You have to call nfq_ip_set_transport_header() or
+ * nfq_ip6_set_transport_header() first to set the TCP header.
  */
 EXPORT_SYMBOL
 struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
@@ -58,6 +56,7 @@ struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
  * nfq_tcp_get_payload - get the TCP packet payload
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
+ * \returns Pointer to the TCP payload, or NULL if malformed TCP packet.
  */
 EXPORT_SYMBOL
 void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
@@ -79,6 +78,7 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
  * nfq_tcp_get_payload_len - get the tcp packet payload
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
+ * \returns Length of TCP payload (user data)
  */
 EXPORT_SYMBOL
 unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
@@ -86,10 +86,23 @@ unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
 	return pktb->tail - pktb->transport_header -tcph->doff * 4;
 }
 
+/**
+ * \defgroup tcp_internals Internal TCP functions
+ *
+ * Most user-space programs will never need these.
+ *
+ * @{
+ */
+
 /**
  * nfq_tcp_compute_checksum_ipv4 - computes IPv4/TCP packet checksum
  * \param tcph: pointer to the TCP header
  * \param iph: pointer to the IPv4 header
+ * \note
+ * nfq_tcp_mangle_ipv4() invokes this function.
+ * As long as developers always use __nfq_tcp_mangle_ipv4__ when changing the
+ * content of a TCP message, there is no need to call
+ * __nfq_tcp_compute_checksum_ipv4__.
  */
 EXPORT_SYMBOL
 void nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
@@ -103,6 +116,11 @@ void nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
  * nfq_tcp_compute_checksum_ipv6 - computes IPv6/TCP packet checksum
  * \param tcph: pointer to the TCP header
  * \param ip6h: pointer to the IPv6 header
+ * \note
+ * nfq_tcp_mangle_ipv6() invokes this function.
+ * As long as developers always use __nfq_tcp_mangle_ipv6__ when changing the
+ * content of a TCP message, there is no need to call
+ * __nfq_tcp_compute_checksum_ipv6__.
  */
 EXPORT_SYMBOL
 void nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
@@ -112,6 +130,10 @@ void nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
 	tcph->check = nfq_checksum_tcpudp_ipv6(ip6h, tcph, IPPROTO_TCP);
 }
 
+/**
+ * @}
+ */
+
 /*
  *	The union cast uses a gcc extension to avoid aliasing problems
  *  (union is compatible to any of its members)
@@ -130,6 +152,8 @@ union tcp_word_hdr {
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
  * \param tcph: pointer to a valid tcp header.
+ * \returns Same as \b snprintf
+ * \sa __snprintf__(3)
  *
  */
 EXPORT_SYMBOL
@@ -184,8 +208,12 @@ int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
  * \param match_len: length of the existing content you want to mangle
  * \param rep_buffer: pointer to data you want to use to replace current content
  * \param rep_len: length of data you want to use to replace current content
- *
- * \note This function recalculates the IPv4 and TCP checksums for you.
+ * \returns 1 for success and 0 for failure. See pktb_mangle() for failure case
+ * \note This function updates the IPv4 length and recalculates the IPv4 & TCP
+ * checksums for you.
+ * \warning After changing the length of a TCP message, the application will
+ * need to mangle sequence numbers in both directions until another change
+ * puts them in sync again
  */
 EXPORT_SYMBOL
 int nfq_tcp_mangle_ipv4(struct pkt_buff *pktb,
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 9eee1c7..dc476d4 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -34,7 +34,10 @@
  * nfq_udp_get_hdr - get the UDP header.
  * \param pktb: Pointer to userspace network packet buffer
  *
- * \returns Pointer to the UDP header, or NULL if no valid UDP header is found.
+ * \returns validated pointer to the UDP header or NULL if the UDP header was
+ * not set or if a minimal length check fails.
+ * \note You have to call nfq_ip_set_transport_header() or
+ * nfq_ip6_set_transport_header() first to set the UDP header.
  */
 EXPORT_SYMBOL
 struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
@@ -84,7 +87,7 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 }
 
 /**
- * \defgroup internals Internal functions
+ * \defgroup udp_internals Internal UDP functions
  *
  * Most user-space programs will never need these.
  *
@@ -109,14 +112,15 @@ void nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
 	udph->check = nfq_checksum_tcpudp_ipv4(iph, IPPROTO_UDP);
 }
 
-/**
- * @}
- */
-
 /**
  * nfq_udp_compute_checksum_ipv6 - sets up the UDP checksum in a UDP/IPv6 packet
  * \param udph: pointer to the UDP header
  * \param ip6h: pointer to the IPv6 header
+ * \note
+ * nfq_udp_mangle_ipv6() invokes this function.
+ * As long as developers always use __nfq_udp_mangle_ipv6__ when changing the
+ * content of a UDP message, there is no need to call
+ * __nfq_udp_compute_checksum_ipv6__.
  */
 EXPORT_SYMBOL
 void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
@@ -126,6 +130,10 @@ void nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
 	udph->check = nfq_checksum_tcpudp_ipv6(ip6h, udph, IPPROTO_UDP);
 }
 
+/**
+ * @}
+ */
+
 /**
  * nfq_udp_mangle_ipv4 - Mangle UDP/IPv4 packet buffer
  * \param pktb: Pointer to network packet buffer
diff --git a/src/nlmsg.c b/src/nlmsg.c
index cbf49a6..4f09bf6 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -263,9 +263,7 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
  * nfq_nlmsg_parse - set packet attributes from netlink message
  * \param nlh netlink message that you want to read.
  * \param attr pointer to array of attributes to set.
- *
- * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
- * success.
+ * \returns MNL_CB_OK on success or MNL_CB_ERROR if any error occurs.
  */
 EXPORT_SYMBOL
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
-- 
2.14.5

