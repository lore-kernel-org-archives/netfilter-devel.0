Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0A8ECE58C
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEB12054F
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 00:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfJHAuW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:50:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43433 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729285AbfJHAuW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 20:50:22 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id B3A9B43ECF7
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Oct 2019 11:49:49 +1100 (AEDT)
Received: (qmail 25681 invoked by uid 501); 8 Oct 2019 00:49:48 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/5] src: Enable clang build
Date:   Tue,  8 Oct 2019 11:49:45 +1100
Message-Id: <20191008004948.25632-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
References: <20191008004948.25632-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=PO7r1zJSAAAA:8
        a=Mk_cbtOhbz2kleIg72sA:9 a=qYFwiZIHGRt6llLs:21 a=pOwiO6WELnBzxQTf:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Modify the definition and use of EXPORT_SYMBOL as was done for libmnl in
commit 444d6dc9.

Additionally, avoid generating long (>80ch) lines when inserting
EXPORT_SYMBOL by splitting these lines at start of function name (was already
done in a few places).

Finally, re-align multi-line parameter blocks with opening parenthesis.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv4.c         |  24 +++----
 src/extra/ipv6.c         |  14 ++--
 src/extra/pktbuff.c      |  65 +++++++++---------
 src/extra/tcp.c          |  24 +++----
 src/extra/udp.c          |  25 +++----
 src/internal.h           |   3 +-
 src/libnetfilter_queue.c | 173 +++++++++++++++++++++++------------------------
 src/nlmsg.c              |  27 ++++----
 8 files changed, 171 insertions(+), 184 deletions(-)

diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 20f3c12..c79a95f 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -32,7 +32,8 @@
  * This funcion returns NULL if the IPv4 is malformed or the protocol version
  * is not 4. On success, it returns a valid pointer to the IPv4 header.
  */
-struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
+EXPORT_SYMBOL struct iphdr *
+nfq_ip_get_hdr(struct pkt_buff *pktb)
 {
 	struct iphdr *iph;
 	unsigned int pktlen = pktb->tail - pktb->network_header;
@@ -53,7 +54,6 @@ struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
 
 	return iph;
 }
-EXPORT_SYMBOL(nfq_ip_get_hdr);
 
 /**
  * nfq_ip_set_transport_header - set transport header
@@ -64,7 +64,8 @@ EXPORT_SYMBOL(nfq_ip_get_hdr);
  *
  * Level 4 helper functions need this to be set.
  */
-int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
+EXPORT_SYMBOL int
+nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 {
 	int doff = iph->ihl * 4;
 
@@ -75,7 +76,6 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
 	pktb->transport_header = pktb->network_header + doff;
 	return 0;
 }
-EXPORT_SYMBOL(nfq_ip_set_transport_header);
 
 /**
  * nfq_ip_set_checksum - set IPv4 checksum
@@ -84,14 +84,14 @@ EXPORT_SYMBOL(nfq_ip_set_transport_header);
  * \note Call to this function if you modified the IPv4 header to update the
  * checksum.
  */
-void nfq_ip_set_checksum(struct iphdr *iph)
+EXPORT_SYMBOL void
+nfq_ip_set_checksum(struct iphdr *iph)
 {
 	uint32_t iph_len = iph->ihl * 4;
 
 	iph->check = 0;
 	iph->check = nfq_checksum(0, (uint16_t *)iph, iph_len);
 }
-EXPORT_SYMBOL(nfq_ip_set_checksum);
 
 /**
  * nfq_ip_mangle - mangle IPv4 packet buffer
@@ -105,9 +105,10 @@ EXPORT_SYMBOL(nfq_ip_set_checksum);
  * \note This function updates the IPv4 length and recalculates the IPv4
  * checksum (if necessary)
  */
-int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
-		  unsigned int match_offset, unsigned int match_len,
-		  const char *rep_buffer, unsigned int rep_len)
+EXPORT_SYMBOL int
+nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
+	      unsigned int match_offset, unsigned int match_len,
+	      const char *rep_buffer, unsigned int rep_len)
 {
 	struct iphdr *iph = (struct iphdr *) pkt->network_header;
 
@@ -121,7 +122,6 @@ int nfq_ip_mangle(struct pkt_buff *pkt, unsigned int dataoff,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_ip_mangle);
 
 /**
  * nfq_pkt_snprintf_ip - print IPv4 header into buffer in iptables LOG format
@@ -133,7 +133,8 @@ EXPORT_SYMBOL(nfq_ip_mangle);
  * case that there is enough room in the buffer. Read snprintf manpage for more
  * information to know more about this strange behaviour.
  */
-int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
+EXPORT_SYMBOL int
+nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
 {
 	int ret;
 	struct in_addr src = { iph->saddr };
@@ -152,7 +153,6 @@ int nfq_ip_snprintf(char *buf, size_t size, const struct iphdr *iph)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_ip_snprintf);
 
 /**
  * @}
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 7c5dc9b..531e84a 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -33,7 +33,8 @@
  * This funcion returns NULL if an invalid header is found. On sucess, it
  * returns a valid pointer to the header.
  */
-struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
+EXPORT_SYMBOL struct ip6_hdr *
+nfq_ip6_get_hdr(struct pkt_buff *pktb)
 {
 	struct ip6_hdr *ip6h;
 	unsigned int pktlen = pktb->tail - pktb->network_header;
@@ -50,7 +51,6 @@ struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
 
 	return ip6h;
 }
-EXPORT_SYMBOL(nfq_ip6_get_hdr);
 
 /**
  * nfq_ip6_set_transport_header - set transport header pointer for IPv6 packet
@@ -61,8 +61,9 @@ EXPORT_SYMBOL(nfq_ip6_get_hdr);
  * This function returns 1 if the protocol has been found and the transport
  * header has been set. Otherwise, it returns 0.
  */
-int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
-				 uint8_t target)
+EXPORT_SYMBOL int
+nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
+			     uint8_t target)
 {
 	uint8_t nexthdr = ip6h->ip6_nxt;
 	uint8_t *cur = (uint8_t *)ip6h + sizeof(struct ip6_hdr);
@@ -115,7 +116,6 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 	pktb->transport_header = cur;
 	return cur ? 1 : 0;
 }
-EXPORT_SYMBOL(nfq_ip6_set_transport_header);
 
 /**
  * nfq_ip6_snprintf - print IPv6 header into one buffer in iptables LOG format
@@ -124,7 +124,8 @@ EXPORT_SYMBOL(nfq_ip6_set_transport_header);
  * \param ip6_hdr: pointer to a valid IPv6 header.
  *
  */
-int nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h)
+EXPORT_SYMBOL int
+nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h)
 {
 	int ret;
 	char src[INET6_ADDRSTRLEN];
@@ -143,7 +144,6 @@ int nfq_ip6_snprintf(char *buf, size_t size, const struct ip6_hdr *ip6h)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_ip6_snprintf);
 
 /**
  * @}
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 25b173b..9c2e83a 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -40,7 +40,7 @@
  *
  * \return a pointer to a new queue handle or NULL on failure.
  */
-struct pkt_buff *
+EXPORT_SYMBOL struct pkt_buff *
 pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
@@ -84,120 +84,119 @@ pktb_alloc(int family, void *data, size_t len, size_t extra)
 	}
 	return pktb;
 }
-EXPORT_SYMBOL(pktb_alloc);
 
 /**
  * pktb_data - return pointer to the beginning of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-uint8_t *pktb_data(struct pkt_buff *pktb)
+EXPORT_SYMBOL uint8_t
+*pktb_data(struct pkt_buff *pktb)
 {
 	return pktb->data;
 }
-EXPORT_SYMBOL(pktb_data);
 
 /**
  * pktb_len - return length of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-uint32_t pktb_len(struct pkt_buff *pktb)
+EXPORT_SYMBOL uint32_t
+pktb_len(struct pkt_buff *pktb)
 {
 	return pktb->len;
 }
-EXPORT_SYMBOL(pktb_len);
 
 /**
  * pktb_free - release packet buffer
  * \param pktb Pointer to packet buffer
  */
-void pktb_free(struct pkt_buff *pktb)
+EXPORT_SYMBOL void
+pktb_free(struct pkt_buff *pktb)
 {
 	free(pktb);
 }
-EXPORT_SYMBOL(pktb_free);
 
 /**
  * pktb_push - update pointer to the beginning of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-void pktb_push(struct pkt_buff *pktb, unsigned int len)
+EXPORT_SYMBOL void
+pktb_push(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->data -= len;
 	pktb->len += len;
 }
-EXPORT_SYMBOL(pktb_push);
 
 /**
  * pktb_pull - update pointer to the beginning of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-void pktb_pull(struct pkt_buff *pktb, unsigned int len)
+EXPORT_SYMBOL void
+pktb_pull(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->data += len;
 	pktb->len -= len;
 }
-EXPORT_SYMBOL(pktb_pull);
 
 /**
  * pktb_put - add extra bytes to the tail of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-void pktb_put(struct pkt_buff *pktb, unsigned int len)
+EXPORT_SYMBOL void
+pktb_put(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->tail += len;
 	pktb->len += len;
 }
-EXPORT_SYMBOL(pktb_put);
 
 /**
  * pktb_trim - set new length for this packet buffer
  * \param pktb Pointer to packet buffer
  */
-void pktb_trim(struct pkt_buff *pktb, unsigned int len)
+EXPORT_SYMBOL void
+pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->len = len;
 }
-EXPORT_SYMBOL(pktb_trim);
 
 /**
  * pktb_tailroom - get room in bytes in the tail of the packet buffer
  * \param pktb Pointer to packet buffer
  */
-unsigned int pktb_tailroom(struct pkt_buff *pktb)
+EXPORT_SYMBOL unsigned int
+pktb_tailroom(struct pkt_buff *pktb)
 {
 	return pktb->data_len - pktb->len;
 }
-EXPORT_SYMBOL(pktb_tailroom);
 
 /**
  * pktb_mac_header - return pointer to layer 2 header (if any)
  * \param pktb Pointer to packet buffer
  */
-uint8_t *pktb_mac_header(struct pkt_buff *pktb)
+EXPORT_SYMBOL uint8_t *
+pktb_mac_header(struct pkt_buff *pktb)
 {
 	return pktb->mac_header;
 }
-EXPORT_SYMBOL(pktb_mac_header);
 
 /**
  * pktb_network_header - return pointer to layer 3 header
  * \param pktb Pointer to packet buffer
  */
-uint8_t *pktb_network_header(struct pkt_buff *pktb)
+EXPORT_SYMBOL uint8_t *
+pktb_network_header(struct pkt_buff *pktb)
 {
 	return pktb->network_header;
 }
-EXPORT_SYMBOL(pktb_network_header);
 
 /**
  * pktb_transport_header - return pointer to layer 4 header (if any)
  * \param pktb Pointer to packet buffer
  */
-uint8_t *pktb_transport_header(struct pkt_buff *pktb)
+EXPORT_SYMBOL uint8_t *
+pktb_transport_header(struct pkt_buff *pktb)
 {
 	return pktb->transport_header;
 }
-EXPORT_SYMBOL(pktb_transport_header);
 
 static int pktb_expand_tail(struct pkt_buff *pkt, int extra)
 {
@@ -237,12 +236,13 @@ static int enlarge_pkt(struct pkt_buff *pkt, unsigned int extra)
  * argument to the pktb_alloc() call that created \b pkt is less than the excess
  * of \b rep_len over \b match_len
  */
-int pktb_mangle(struct pkt_buff *pkt,
-		 unsigned int dataoff,
-		 unsigned int match_offset,
-		 unsigned int match_len,
-		 const char *rep_buffer,
-		 unsigned int rep_len)
+EXPORT_SYMBOL int
+pktb_mangle(struct pkt_buff *pkt,
+	    unsigned int dataoff,
+	    unsigned int match_offset,
+	    unsigned int match_len,
+	    const char *rep_buffer,
+	    unsigned int rep_len)
 {
 	unsigned char *data;
 
@@ -271,17 +271,16 @@ int pktb_mangle(struct pkt_buff *pkt,
 	pkt->mangled = true;
 	return 1;
 }
-EXPORT_SYMBOL(pktb_mangle);
 
 /**
  * pktb_mangled - return true if packet has been mangled
  * \param pktb Pointer to packet buffer
  */
-bool pktb_mangled(const struct pkt_buff *pkt)
+EXPORT_SYMBOL bool
+pktb_mangled(const struct pkt_buff *pkt)
 {
 	return pkt->mangled;
 }
-EXPORT_SYMBOL(pktb_mangled);
 
 /**
  * @}
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index a66f392..f7ab33d 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -40,7 +40,8 @@
  * \note You have to call nfq_ip_set_transport_header or
  * nfq_ip6_set_transport_header first to access the TCP header.
  */
-struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
+EXPORT_SYMBOL struct tcphdr *
+nfq_tcp_get_hdr(struct pkt_buff *pktb)
 {
 	if (pktb->transport_header == NULL)
 		return NULL;
@@ -51,14 +52,14 @@ struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
 
 	return (struct tcphdr *)pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_tcp_get_hdr);
 
 /**
  * nfq_tcp_get_payload - get the TCP packet payload
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
  */
-void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
+EXPORT_SYMBOL void *
+nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 {
 	unsigned int len = tcph->doff * 4;
 
@@ -72,47 +73,43 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
 
 	return pktb->transport_header + len;
 }
-EXPORT_SYMBOL(nfq_tcp_get_payload);
 
 /**
  * nfq_tcp_get_payload_len - get the tcp packet payload
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
  */
-unsigned int
+EXPORT_SYMBOL unsigned int
 nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
 {
 	return pktb->tail - pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_tcp_get_payload_len);
 
 /**
  * nfq_tcp_set_checksum_ipv4 - computes IPv4/TCP packet checksum
  * \param tcph: pointer to the TCP header
  * \param iph: pointer to the IPv4 header
  */
-void
+EXPORT_SYMBOL void
 nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	tcph->check = 0;
 	tcph->check = nfq_checksum_tcpudp_ipv4(iph, IPPROTO_TCP);
 }
-EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv4);
 
 /**
  * nfq_tcp_set_checksum_ipv6 - computes IPv6/TCP packet checksum
  * \param tcph: pointer to the TCP header
  * \param iph: pointer to the IPv6 header
  */
-void
+EXPORT_SYMBOL void
 nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	tcph->check = 0;
 	tcph->check = nfq_checksum_tcpudp_ipv6(ip6h, tcph, IPPROTO_TCP);
 }
-EXPORT_SYMBOL(nfq_tcp_compute_checksum_ipv6);
 
 /*
  *	The union cast uses a gcc extension to avoid aliasing problems
@@ -134,7 +131,8 @@ union tcp_word_hdr {
  * \param tcp: pointer to a valid tcp header.
  *
  */
-int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
+EXPORT_SYMBOL int
+nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
 {
 	int ret, len = 0;
 
@@ -177,7 +175,6 @@ int nfq_tcp_snprintf(char *buf, size_t size, const struct tcphdr *tcph)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_tcp_snprintf);
 
 /**
  * nfq_tcp_mangle_ipv4 - mangle TCP/IPv4 packet buffer
@@ -189,7 +186,7 @@ EXPORT_SYMBOL(nfq_tcp_snprintf);
  *
  * \note This function recalculates the IPv4 and TCP checksums for you.
  */
-int
+EXPORT_SYMBOL int
 nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
 		    unsigned int match_offset, unsigned int match_len,
 		    const char *rep_buffer, unsigned int rep_len)
@@ -208,7 +205,6 @@ nfq_tcp_mangle_ipv4(struct pkt_buff *pkt,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_tcp_mangle_ipv4);
 
 /**
  * @}
diff --git a/src/extra/udp.c b/src/extra/udp.c
index 92165b4..2d29e33 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -36,7 +36,8 @@
  * This function returns NULL if invalid UDP header is found. On success,
  * it returns the UDP header.
  */
-struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
+EXPORT_SYMBOL struct udphdr *
+nfq_udp_get_hdr(struct pkt_buff *pktb)
 {
 	if (pktb->transport_header == NULL)
 		return NULL;
@@ -47,14 +48,14 @@ struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
 
 	return (struct udphdr *)pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_udp_get_hdr);
 
 /**
  * nfq_udp_get_payload - get the UDP packet payload.
  * \param udph: Pointer to UDP header
  * \param pktb: Pointer to network packet buffer
  */
-void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
+EXPORT_SYMBOL void *
+nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 {
 	uint16_t len = ntohs(udph->len);
 
@@ -68,18 +69,17 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
 
 	return pktb->transport_header + sizeof(struct udphdr);
 }
-EXPORT_SYMBOL(nfq_udp_get_payload);
 
 /**
  * nfq_udp_get_payload_len - get the udp packet payload.
  * \param udph: Pointer to UDP header
  * \param pktb: Pointer to network packet buffer
  */
-unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
+EXPORT_SYMBOL unsigned int
+nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
 {
 	return pktb->tail - pktb->transport_header;
 }
-EXPORT_SYMBOL(nfq_udp_get_payload_len);
 
 /**
  * nfq_udp_set_checksum_ipv4 - computes a IPv4/TCP packet's segment
@@ -91,14 +91,13 @@ EXPORT_SYMBOL(nfq_udp_get_payload_len);
  * \see nfq_pkt_compute_ip_checksum
  * \see nfq_pkt_compute_udp_checksum
  */
-void
+EXPORT_SYMBOL void
 nfq_udp_compute_checksum_ipv4(struct udphdr *udph, struct iphdr *iph)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	udph->check = 0;
 	udph->check = nfq_checksum_tcpudp_ipv4(iph, IPPROTO_UDP);
 }
-EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv4);
 
 /**
  * nfq_udp_set_checksum_ipv6 - computes a IPv6/TCP packet's segment
@@ -110,14 +109,13 @@ EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv4);
  * \see nfq_pkt_compute_ip_checksum
  * \see nfq_pkt_compute_udp_checksum
  */
-void
+EXPORT_SYMBOL void
 nfq_udp_compute_checksum_ipv6(struct udphdr *udph, struct ip6_hdr *ip6h)
 {
 	/* checksum field in header needs to be zero for calculation. */
 	udph->check = 0;
 	udph->check = nfq_checksum_tcpudp_ipv6(ip6h, udph, IPPROTO_UDP);
 }
-EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
 
 /**
  * nfq_udp_mangle_ipv4 - Mangle UDP/IPv4 packet buffer
@@ -131,7 +129,7 @@ EXPORT_SYMBOL(nfq_udp_compute_checksum_ipv6);
  * \note This function updates the IPv4 and UDP lengths and recalculates their
  * checksums for you.
  */
-int
+EXPORT_SYMBOL int
 nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
 		    unsigned int match_offset, unsigned int match_len,
 		    const char *rep_buffer, unsigned int rep_len)
@@ -152,7 +150,6 @@ nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
 
 	return 1;
 }
-EXPORT_SYMBOL(nfq_udp_mangle_ipv4);
 
 /**
  * nfq_pkt_snprintf_udp_hdr - print udp header into one buffer in a humnan
@@ -162,12 +159,12 @@ EXPORT_SYMBOL(nfq_udp_mangle_ipv4);
  * \param udp: pointer to a valid udp header.
  *
  */
-int nfq_udp_snprintf(char *buf, size_t size, const struct udphdr *udph)
+EXPORT_SYMBOL int
+nfq_udp_snprintf(char *buf, size_t size, const struct udphdr *udph)
 {
 	return snprintf(buf, size, "SPT=%u DPT=%u ",
 			htons(udph->source), htons(udph->dest));
 }
-EXPORT_SYMBOL(nfq_udp_snprintf);
 
 /**
  * @}
diff --git a/src/internal.h b/src/internal.h
index d648bfe..d968325 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -5,8 +5,7 @@
 #include <stdint.h>
 #include <stdbool.h>
 #ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#	define EXPORT_SYMBOL __attribute__((visibility("default")))
 #else
 #	define EXPORT_SYMBOL
 #endif
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 673e3b0..affbd55 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -133,8 +133,7 @@ struct nfq_data {
 	struct nfattr **data;
 };
 
-int nfq_errno;
-EXPORT_SYMBOL(nfq_errno);
+EXPORT_SYMBOL int nfq_errno;
 
 /***********************************************************************
  * low level stuff 
@@ -218,11 +217,11 @@ static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
 
 /* public interface */
 
-struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
+EXPORT_SYMBOL struct nfnl_handle *
+nfq_nfnlh(struct nfq_handle *h)
 {
 	return h->nfnlh;
 }
-EXPORT_SYMBOL(nfq_nfnlh);
 
 /**
  *
@@ -294,11 +293,11 @@ EXPORT_SYMBOL(nfq_nfnlh);
  * over the netlink connection associated with the given queue connection
  * handle.
  */
-int nfq_fd(struct nfq_handle *h)
+EXPORT_SYMBOL int
+nfq_fd(struct nfq_handle *h)
 {
 	return nfnl_fd(nfq_nfnlh(h));
 }
-EXPORT_SYMBOL(nfq_fd);
 /**
  * @}
  */
@@ -349,7 +348,8 @@ EXPORT_SYMBOL(nfq_fd);
  *
  * \return a pointer to a new queue handle or NULL on failure.
  */
-struct nfq_handle *nfq_open(void)
+EXPORT_SYMBOL struct nfq_handle *
+nfq_open(void)
 {
 	struct nfnl_handle *nfnlh = nfnl_open();
 	struct nfq_handle *qh;
@@ -366,7 +366,6 @@ struct nfq_handle *nfq_open(void)
 
 	return qh;
 }
-EXPORT_SYMBOL(nfq_open);
 
 /**
  * @}
@@ -382,7 +381,8 @@ EXPORT_SYMBOL(nfq_open);
  *
  * \return a pointer to a new queue handle or NULL on failure.
  */
-struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
+EXPORT_SYMBOL struct nfq_handle *
+nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
 	struct nfnl_callback pkt_cb = {
 		.call		= __nfq_rcv_pkt,
@@ -419,7 +419,6 @@ out_free:
 	free(h);
 	return NULL;
 }
-EXPORT_SYMBOL(nfq_open_nfnl);
 
 /**
  * \addtogroup LibrarySetup
@@ -438,7 +437,8 @@ EXPORT_SYMBOL(nfq_open_nfnl);
  *
  * \return 0 on success, non-zero on failure. 
  */
-int nfq_close(struct nfq_handle *h)
+EXPORT_SYMBOL int
+nfq_close(struct nfq_handle *h)
 {
 	int ret;
 	
@@ -447,7 +447,6 @@ int nfq_close(struct nfq_handle *h)
 		free(h);
 	return ret;
 }
-EXPORT_SYMBOL(nfq_close);
 
 /**
  * nfq_bind_pf - bind a nfqueue handler to a given protocol family
@@ -460,11 +459,11 @@ EXPORT_SYMBOL(nfq_close);
  *
  * \return integer inferior to 0 in case of failure
  */
-int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
+EXPORT_SYMBOL int
+nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
-EXPORT_SYMBOL(nfq_bind_pf);
 
 /**
  * nfq_unbind_pf - unbind nfqueue handler from a protocol family
@@ -476,11 +475,11 @@ EXPORT_SYMBOL(nfq_bind_pf);
  *
  * This call is obsolete, Linux kernels from 3.8 onwards ignore it.
  */
-int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
+EXPORT_SYMBOL int
+nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 {
 	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
-EXPORT_SYMBOL(nfq_unbind_pf);
 
 
 /**
@@ -524,10 +523,11 @@ typedef int nfq_callback(struct nfq_q_handle *qh,
  * The callback should return < 0 to stop processing.
  */
 
-struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, 
-		uint16_t num,
-		nfq_callback *cb,
-		void *data)
+EXPORT_SYMBOL struct nfq_q_handle *
+nfq_create_queue(struct nfq_handle *h,
+		 uint16_t num,
+		 nfq_callback *cb,
+		 void *data)
 {
 	int ret;
 	struct nfq_q_handle *qh;
@@ -555,7 +555,6 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 	add_qh(qh);
 	return qh;
 }
-EXPORT_SYMBOL(nfq_create_queue);
 
 /**
  * @}
@@ -573,7 +572,8 @@ EXPORT_SYMBOL(nfq_create_queue);
  * Removes the binding for the specified queue handle. This call also unbind
  * from the nfqueue handler, so you don't have to call nfq_unbind_pf.
  */
-int nfq_destroy_queue(struct nfq_q_handle *qh)
+EXPORT_SYMBOL int
+nfq_destroy_queue(struct nfq_q_handle *qh)
 {
 	int ret = __build_send_cfg_msg(qh->h, NFQNL_CFG_CMD_UNBIND, qh->id, 0);
 	if (ret == 0) {
@@ -583,7 +583,6 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 
 	return ret;
 }
-EXPORT_SYMBOL(nfq_destroy_queue);
 
 /**
  * nfq_handle_packet - handle a packet received from the nfqueue subsystem
@@ -597,11 +596,11 @@ EXPORT_SYMBOL(nfq_destroy_queue);
  *
  * \return 0 on success, non-zero on failure.
  */
-int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
+EXPORT_SYMBOL int
+nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
 	return nfnl_handle_packet(h->nfnlh, buf, len);
 }
-EXPORT_SYMBOL(nfq_handle_packet);
 
 /**
  * nfq_set_mode - set the amount of packet data that nfqueue copies to userspace
@@ -618,8 +617,9 @@ EXPORT_SYMBOL(nfq_handle_packet);
  *
  * \return -1 on error; >=0 otherwise.
  */
-int nfq_set_mode(struct nfq_q_handle *qh,
-		uint8_t mode, uint32_t range)
+EXPORT_SYMBOL int
+nfq_set_mode(struct nfq_q_handle *qh,
+	     uint8_t mode, uint32_t range)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -638,7 +638,6 @@ int nfq_set_mode(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_mode);
 
 /**
  * nfq_set_queue_flags - set flags (options) for the kernel queue
@@ -708,8 +707,9 @@ EXPORT_SYMBOL(nfq_set_mode);
  *
  * \return -1 on error with errno set appropriately; =0 otherwise.
  */
-int nfq_set_queue_flags(struct nfq_q_handle *qh,
-			uint32_t mask, uint32_t flags)
+EXPORT_SYMBOL int
+nfq_set_queue_flags(struct nfq_q_handle *qh,
+		    uint32_t mask, uint32_t flags)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -729,7 +729,6 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_queue_flags);
 
 /**
  * nfq_set_queue_maxlen - Set kernel queue maximum length parameter
@@ -742,8 +741,8 @@ EXPORT_SYMBOL(nfq_set_queue_flags);
  *
  * \return -1 on error; >=0 otherwise.
  */
-int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
-				uint32_t queuelen)
+EXPORT_SYMBOL int
+nfq_set_queue_maxlen(struct nfq_q_handle *qh, uint32_t queuelen)
 {
 	union {
 		char buf[NFNL_HEADER_LEN
@@ -760,7 +759,6 @@ int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
 
 	return nfnl_query(qh->h->nfnlh, &u.nmh);
 }
-EXPORT_SYMBOL(nfq_set_queue_maxlen);
 
 /**
  * @}
@@ -847,14 +845,14 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
  *
  * \return -1 on error; >= 0 otherwise.
  */
-int nfq_set_verdict(struct nfq_q_handle *qh, uint32_t id,
+EXPORT_SYMBOL int
+nfq_set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		uint32_t verdict, uint32_t data_len,
 		const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict);
 
 /**
  * nfq_set_verdict2 - like nfq_set_verdict, but you can set the mark.
@@ -865,14 +863,14 @@ EXPORT_SYMBOL(nfq_set_verdict);
  * \param data_len number of bytes of data pointed to by #buf
  * \param buf the buffer that contains the packet data
  */
-int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
-		     uint32_t verdict, uint32_t mark,
-		     uint32_t data_len, const unsigned char *buf)
+EXPORT_SYMBOL int
+nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
+		 uint32_t verdict, uint32_t mark,
+		 uint32_t data_len, const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict2);
 
 /**
  * nfq_set_verdict_batch - issue verdicts on several packets at once
@@ -886,13 +884,12 @@ EXPORT_SYMBOL(nfq_set_verdict2);
  * batch support was added in Linux 3.1.
  * These functions will fail silently on older kernels.
  */
-int nfq_set_verdict_batch(struct nfq_q_handle *qh, uint32_t id,
-					  uint32_t verdict)
+EXPORT_SYMBOL int
+nfq_set_verdict_batch(struct nfq_q_handle *qh, uint32_t id, uint32_t verdict)
 {
 	return __set_verdict(qh, id, verdict, 0, 0, 0, NULL,
 					NFQNL_MSG_VERDICT_BATCH);
 }
-EXPORT_SYMBOL(nfq_set_verdict_batch);
 
 /**
  * nfq_set_verdict_batch2 - like nfq_set_verdict_batch, but you can set a mark.
@@ -901,13 +898,13 @@ EXPORT_SYMBOL(nfq_set_verdict_batch);
  * \param verdict verdict to return to netfilter (NF_ACCEPT, NF_DROP)
  * \param mark mark to put on packet
  */
-int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
-		     uint32_t verdict, uint32_t mark)
+EXPORT_SYMBOL int
+nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
+		       uint32_t verdict, uint32_t mark)
 {
 	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
-EXPORT_SYMBOL(nfq_set_verdict_batch2);
 
 /**
  * nfq_set_verdict_mark - like nfq_set_verdict, but you can set the mark.
@@ -923,14 +920,14 @@ EXPORT_SYMBOL(nfq_set_verdict_batch2);
  * This function is deprecated since it is broken, its use is highly
  * discouraged. Please, use nfq_set_verdict2 instead.
  */
-int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
-		uint32_t verdict, uint32_t mark,
-		uint32_t data_len, const unsigned char *buf)
+EXPORT_SYMBOL int
+nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
+		     uint32_t verdict, uint32_t mark,
+		     uint32_t data_len, const unsigned char *buf)
 {
 	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
-EXPORT_SYMBOL(nfq_set_verdict_mark);
 
 /**
  * @}
@@ -965,12 +962,12 @@ EXPORT_SYMBOL(nfq_set_verdict_mark);
 	} __attribute__ ((packed));
 \endverbatim
  */
-struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
+EXPORT_SYMBOL struct nfqnl_msg_packet_hdr *
+nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
 					struct nfqnl_msg_packet_hdr);
 }
-EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
 
 /**
  * nfq_get_nfmark - get the packet mark
@@ -978,11 +975,11 @@ EXPORT_SYMBOL(nfq_get_msg_packet_hdr);
  *
  * \return the netfilter mark currently assigned to the given queued packet.
  */
-uint32_t nfq_get_nfmark(struct nfq_data *nfad)
+EXPORT_SYMBOL uint32_t
+nfq_get_nfmark(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_nfmark);
 
 /**
  * nfq_get_timestamp - get the packet timestamp
@@ -993,7 +990,8 @@ EXPORT_SYMBOL(nfq_get_nfmark);
  *
  * \return 0 on success, non-zero on failure.
  */
-int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
+EXPORT_SYMBOL int
+nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;
 	qpt = nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
@@ -1006,7 +1004,6 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 
 	return 0;
 }
-EXPORT_SYMBOL(nfq_get_timestamp);
 
 /**
  * nfq_get_indev - get the interface that the packet was received through
@@ -1019,11 +1016,11 @@ EXPORT_SYMBOL(nfq_get_timestamp);
  * \warning all nfq_get_dev() functions return 0 if not set, since linux
  * only allows ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1)
  */
-uint32_t nfq_get_indev(struct nfq_data *nfad)
+EXPORT_SYMBOL uint32_t
+nfq_get_indev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_indev);
 
 /**
  * nfq_get_physindev - get the physical interface that the packet was received
@@ -1033,11 +1030,11 @@ EXPORT_SYMBOL(nfq_get_indev);
  * If the returned index is 0, the packet was locally generated or the
  * physical input interface is no longer known (ie. POSTROUTING?).
  */
-uint32_t nfq_get_physindev(struct nfq_data *nfad)
+EXPORT_SYMBOL uint32_t
+nfq_get_physindev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_physindev);
 
 /**
  * nfq_get_outdev - gets the interface that the packet will be routed out
@@ -1047,11 +1044,11 @@ EXPORT_SYMBOL(nfq_get_physindev);
  * returned index is 0, the packet is destined for localhost or the output
  * interface is not yet known (ie. PREROUTING?).
  */
-uint32_t nfq_get_outdev(struct nfq_data *nfad)
+EXPORT_SYMBOL uint32_t
+nfq_get_outdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_outdev);
 
 /**
  * nfq_get_physoutdev - get the physical interface that the packet output
@@ -1063,11 +1060,11 @@ EXPORT_SYMBOL(nfq_get_outdev);
  * 
  * \return The index of physical interface that the packet output will be routed out.
  */
-uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
+EXPORT_SYMBOL uint32_t
+nfq_get_physoutdev(struct nfq_data *nfad)
 {
 	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
 }
-EXPORT_SYMBOL(nfq_get_physoutdev);
 
 /**
  * nfq_get_indev_name - get the name of the interface the packet
@@ -1107,13 +1104,13 @@ EXPORT_SYMBOL(nfq_get_physoutdev);
 \endverbatim
  *
  */
-int nfq_get_indev_name(struct nlif_handle *nlif_handle,
-			struct nfq_data *nfad, char *name)
+EXPORT_SYMBOL int
+nfq_get_indev_name(struct nlif_handle *nlif_handle,
+		   struct nfq_data *nfad, char *name)
 {
 	uint32_t ifindex = nfq_get_indev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_indev_name);
 
 /**
  * nfq_get_physindev_name - get the name of the physical interface the
@@ -1127,13 +1124,13 @@ EXPORT_SYMBOL(nfq_get_indev_name);
  *
  * \return  -1 in case of error, > 0 if it succeed. 
  */
-int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
-			   struct nfq_data *nfad, char *name)
+EXPORT_SYMBOL int
+nfq_get_physindev_name(struct nlif_handle *nlif_handle,
+		       struct nfq_data *nfad, char *name)
 {
 	uint32_t ifindex = nfq_get_physindev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_physindev_name);
 
 /**
  * nfq_get_outdev_name - get the name of the physical interface the
@@ -1147,13 +1144,13 @@ EXPORT_SYMBOL(nfq_get_physindev_name);
  *
  * \return  -1 in case of error, > 0 if it succeed. 
  */
-int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
-			struct nfq_data *nfad, char *name)
+EXPORT_SYMBOL int
+nfq_get_outdev_name(struct nlif_handle *nlif_handle,
+		    struct nfq_data *nfad, char *name)
 {
 	uint32_t ifindex = nfq_get_outdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_outdev_name);
 
 /**
  * nfq_get_physoutdev_name - get the name of the interface the
@@ -1168,13 +1165,13 @@ EXPORT_SYMBOL(nfq_get_outdev_name);
  * \return  -1 in case of error, > 0 if it succeed. 
  */
 
-int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
-			    struct nfq_data *nfad, char *name)
+EXPORT_SYMBOL int
+nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
+			struct nfq_data *nfad, char *name)
 {
 	uint32_t ifindex = nfq_get_physoutdev(nfad);
 	return nlif_index2name(nlif_handle, ifindex, name);
 }
-EXPORT_SYMBOL(nfq_get_physoutdev_name);
 
 /**
  * nfq_get_packet_hw
@@ -1198,12 +1195,12 @@ EXPORT_SYMBOL(nfq_get_physoutdev_name);
 	} __attribute__ ((packed));
 \endverbatim
  */
-struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
+EXPORT_SYMBOL struct nfqnl_msg_packet_hw *
+nfq_get_packet_hw(struct nfq_data *nfad)
 {
 	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
 					struct nfqnl_msg_packet_hw);
 }
-EXPORT_SYMBOL(nfq_get_packet_hw);
 
 /**
  * nfq_get_uid - get the UID of the user the packet belongs to
@@ -1215,7 +1212,8 @@ EXPORT_SYMBOL(nfq_get_packet_hw);
  *
  * \return 1 if there is a UID available, 0 otherwise.
  */
-int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
+EXPORT_SYMBOL int
+nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 {
 	if (!nfnl_attr_present(nfad->data, NFQA_UID))
 		return 0;
@@ -1223,7 +1221,6 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
 	return 1;
 }
-EXPORT_SYMBOL(nfq_get_uid);
 
 /**
  * nfq_get_gid - get the GID of the user the packet belongs to
@@ -1235,7 +1232,8 @@ EXPORT_SYMBOL(nfq_get_uid);
  *
  * \return 1 if there is a GID available, 0 otherwise.
  */
-int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
+EXPORT_SYMBOL int
+nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 {
 	if (!nfnl_attr_present(nfad->data, NFQA_GID))
 		return 0;
@@ -1243,7 +1241,6 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
 	return 1;
 }
-EXPORT_SYMBOL(nfq_get_gid);
 
 /**
  * nfq_get_secctx - get the security context for this packet
@@ -1256,7 +1253,8 @@ EXPORT_SYMBOL(nfq_get_gid);
  *
  * \return -1 on error, otherwise > 0
  */
-int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
+EXPORT_SYMBOL int
+nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 {
 	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
 		return -1;
@@ -1269,7 +1267,6 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 
 	return 0;
 }
-EXPORT_SYMBOL(nfq_get_secctx);
 
 /**
  * nfq_get_payload - get payload 
@@ -1282,7 +1279,8 @@ EXPORT_SYMBOL(nfq_get_secctx);
  *
  * \return -1 on error, otherwise > 0.
  */
-int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
+EXPORT_SYMBOL int
+nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 {
 	*data = (unsigned char *)
 		nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char);
@@ -1291,7 +1289,6 @@ int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 
 	return -1;
 }
-EXPORT_SYMBOL(nfq_get_payload);
 
 /**
  * @}
@@ -1336,7 +1333,8 @@ do {								\
  * would have been printed into the buffer (in case that there is enough
  * room in it). See snprintf() return value for more information.
  */
-int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
+EXPORT_SYMBOL int
+nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 {
 	struct nfqnl_msg_packet_hdr *ph;
 	struct nfqnl_msg_packet_hw *hwph;
@@ -1489,7 +1487,6 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 
 	return len;
 }
-EXPORT_SYMBOL(nfq_snprintf_xml);
 
 /**
  * @}
diff --git a/src/nlmsg.c b/src/nlmsg.c
index ac0adab..95b6f73 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -40,7 +40,8 @@
  * The calling sequence is \b main --> \b mnl_cb_run --> \b queue_cb -->
  * \b nfq_send_verdict --> \b nfq_nlmsg_verdict_put
  */
-void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
+EXPORT_SYMBOL void
+nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
 {
 	struct nfqnl_msg_verdict_hdr vh = {
 		.verdict	= htonl(verdict),
@@ -48,20 +49,18 @@ void nfq_nlmsg_verdict_put(struct nlmsghdr *nlh, int id, int verdict)
 	};
 	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put);
 
-void nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark)
+EXPORT_SYMBOL void
+nfq_nlmsg_verdict_put_mark(struct nlmsghdr *nlh, uint32_t mark)
 {
 	mnl_attr_put_u32(nlh, NFQA_MARK, htonl(mark));
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put_mark);
 
-void
+EXPORT_SYMBOL void
 nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t plen)
 {
 	mnl_attr_put(nlh, NFQA_PAYLOAD, plen, pkt);
 }
-EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
 
 /**
  * @}
@@ -92,7 +91,8 @@ EXPORT_SYMBOL(nfq_nlmsg_verdict_put_pkt);
  *   given protocol family.  Both commands are ignored by Linux kernel 3.8 and
  *   later versions.
  */
-void nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
+EXPORT_SYMBOL void
+nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
 {
 	struct nfqnl_msg_config_cmd command = {
 		.command = cmd,
@@ -100,7 +100,6 @@ void nfq_nlmsg_cfg_put_cmd(struct nlmsghdr *nlh, uint16_t pf, uint8_t cmd)
 	};
 	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(command), &command);
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_cmd);
 
 /**
  * nfq_nlmsg_cfg_put_params Add parameter to netlink message
@@ -108,7 +107,8 @@ EXPORT_SYMBOL(nfq_nlmsg_cfg_put_cmd);
  * \param mode one of NFQNL_COPY_NONE, NFQNL_COPY_META or NFQNL_COPY_PACKET
  * \param range value of parameter
  */
-void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
+EXPORT_SYMBOL void
+nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 {
 	struct nfqnl_msg_config_params params = {
 		.copy_range = htonl(range),
@@ -116,18 +116,17 @@ void nfq_nlmsg_cfg_put_params(struct nlmsghdr *nlh, uint8_t mode, int range)
 	};
 	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_params);
 
 /**
  * nfq_nlmsg_cfg_put_qmaxlen Add queue maximum length to netlink message
  * \param nlh Pointer to netlink message
  * \param queue_maxlen Maximum queue length
  */
-void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
+EXPORT_SYMBOL void
+nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
 {
 	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queue_maxlen));
 }
-EXPORT_SYMBOL(nfq_nlmsg_cfg_put_qmaxlen);
 
 /**
  * @}
@@ -197,12 +196,12 @@ static int nfq_pkt_parse_attr_cb(const struct nlattr *attr, void *data)
  * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
  * success.
  */
-int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
+EXPORT_SYMBOL int
+nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 {
 	return mnl_attr_parse(nlh, sizeof(struct nfgenmsg),
 			      nfq_pkt_parse_attr_cb, attr);
 }
-EXPORT_SYMBOL(nfq_nlmsg_parse);
 
 /**
  * @}
-- 
2.14.5

