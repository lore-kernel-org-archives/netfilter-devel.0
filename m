Return-Path: <SRS0=uppk=6Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D78AC54E4B
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 13:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7458220708
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 May 2020 13:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgEJNx1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 May 2020 09:53:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55845 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728238AbgEJNx0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 May 2020 09:53:26 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 3502E3A379F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 May 2020 23:53:18 +1000 (AEST)
Received: (qmail 15572 invoked by uid 501); 10 May 2020 13:53:17 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src: add pktb_alloc2() and pktb_head_size()
Date:   Sun, 10 May 2020 23:53:17 +1000
Message-Id: <20200510135317.15526-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200510135317.15526-1-duncan_roe@optusnet.com.au>
References: <20200510135317.15526-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=sTwFKg_x9MkA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=3TZlPSUlYSEMneeOw-MA:9 a=3bDWAWtAYxgPGslq:21 a=lqDfxbB3LGbY_TwG:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pktb_alloc2() avoids the malloc/free overhead in pktb_alloc() and also
eliminates memcpy() of the payload except when mangling increases the
packet length.

 - pktb_mangle() does the memcpy() if need be.
   Packet metadata is altered in this case
 - All the _mangle functions are altered to account for possible change tp
   packet metadata
 - Documentation is updated

pktb_head_size() returns the size of the pkt_buff opaque object.
This is a suitable value for pktb_alloc2()'s buflen argument, except if
mangling may increase packet size in which case use new NFQ_BUFFER_SIZE macro.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 fixmanpages.sh                       |   6 +-
 include/libnetfilter_queue/pktbuff.h |   4 +
 src/extra/ipv4.c                     |   8 +-
 src/extra/ipv6.c                     |   8 +-
 src/extra/pktbuff.c                  | 213 +++++++++++++++++++++++++++++------
 src/extra/tcp.c                      |  18 +++
 src/extra/udp.c                      |  18 +++
 src/internal.h                       |   2 +
 src/nlmsg.c                          |  14 ++-
 9 files changed, 245 insertions(+), 46 deletions(-)

diff --git a/fixmanpages.sh b/fixmanpages.sh
index dd8b3a4..86f902b 100755
--- a/fixmanpages.sh
+++ b/fixmanpages.sh
@@ -31,11 +31,11 @@ function main
     add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
   setgroup nlmsg nfq_nlmsg_parse
     add2group nfq_nlmsg_put
-  setgroup pktbuff pktb_alloc
-    add2group pktb_data pktb_len pktb_mangle pktb_mangled
-    add2group pktb_free
+  setgroup pktbuff pktb_alloc2
+    add2group pktb_data pktb_len pktb_mangle pktb_mangled pktb_head_size
     setgroup otherfns pktb_tailroom
       add2group pktb_mac_header pktb_network_header pktb_transport_header
+      add2group pktb_alloc pktb_free
       setgroup uselessfns pktb_push
         add2group pktb_pull pktb_put pktb_trim
   setgroup tcp nfq_tcp_get_hdr
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153..fd0a3f3 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,8 +4,11 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
+struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buflen, void *data, size_t len);
 void pktb_free(struct pkt_buff *pktb);
 
+#define NFQ_BUFFER_SIZE	(0xffff + (MNL_SOCKET_BUFFER_SIZE / 2)
+
 uint8_t *pktb_data(struct pkt_buff *pktb);
 uint32_t pktb_len(struct pkt_buff *pktb);
 
@@ -22,5 +25,6 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb);
 int pktb_mangle(struct pkt_buff *pktb, int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 bool pktb_mangled(const struct pkt_buff *pktb);
+size_t pktb_head_size(void);
 
 #endif
diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 797bab1..50ca90f 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -35,6 +35,10 @@
  * determine the layer 4 protocol. The validation is that the buffer is big
  * enough for the declared lengths in the header, i.e. an extra check for packet
  * truncation.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 struct iphdr *nfq_ip_get_hdr(struct pkt_buff *pktb)
@@ -128,13 +132,13 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 		  unsigned int match_offset, unsigned int match_len,
 		  const char *rep_buffer, unsigned int rep_len)
 {
-	struct iphdr *iph = (struct iphdr *) pktb->network_header;
-
 	if (!pktb_mangle(pktb, dataoff, match_offset, match_len, rep_buffer,
 			 rep_len))
 		return 0;
 
 	/* fix IP hdr checksum information */
+	/* N.B. set iph *after* pktb_mangle which can change network_header */
+	struct iphdr *iph = (struct iphdr *) pktb->network_header;
 	iph->tot_len = htons(pktb_tail(pktb) - pktb->network_header);
 	nfq_ip_set_checksum(iph);
 
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 42c5e25..ff16818 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -31,6 +31,10 @@
  * \param pktb: Pointer to user-space network packet buffer
  *
  * \returns pointer to IPv6 header if a valid header found, else NULL.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 struct ip6_hdr *nfq_ip6_get_hdr(struct pkt_buff *pktb)
@@ -132,13 +136,13 @@ int nfq_ip6_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 		   unsigned int match_offset, unsigned int match_len,
 		   const char *rep_buffer, unsigned int rep_len)
 {
-	struct ip6_hdr *ip6h = (struct ip6_hdr *)pktb->network_header;
-
 	if (!pktb_mangle(pktb, dataoff, match_offset, match_len, rep_buffer,
 			 rep_len))
 		return 0;
 
 	/* Fix IPv6 hdr length information */
+	/* N.B. set ip6h *after* pktb_mangle which can change network_header */
+	struct ip6_hdr *ip6h = (struct ip6_hdr *)pktb->network_header;
 	ip6h->ip6_plen =
 		htons(pktb_tail(pktb) - pktb->network_header - sizeof *ip6h);
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca9..cc8ad13 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -19,6 +19,8 @@
 #include <netinet/tcp.h>
 
 #include "internal.h"
+#include <libnetfilter_queue/pktbuff.h> /* I.e. local copy */
+					/* (to verify prototypes) */
 
 /**
  * \defgroup pktbuff User-space network packet buffer
@@ -29,8 +31,52 @@
  * @{
  */
 
+static int pktb_setup_family(struct pkt_buff *pktb, int family)
+{
+	struct ethhdr *ethhdr;
+
+	switch(family) {
+	case AF_INET:
+	case AF_INET6:
+		pktb->network_header = pktb->data;
+		break;
+	case AF_BRIDGE:
+		ethhdr = (struct ethhdr *)pktb->data;
+
+		pktb->mac_header = pktb->data;
+
+		switch(ethhdr->h_proto) {
+		case ETH_P_IP:
+		case ETH_P_IPV6:
+			pktb->network_header = pktb->data + ETH_HLEN;
+			break;
+		default:
+			/* This protocol is unsupported. */
+			errno = EPROTONOSUPPORT;
+			return -1;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
+				size_t len, size_t extra)
+{
+	pktb->len = len;
+	pktb->data_len = len + extra;
+
+	pktb->data = pkt_data;
+}
+
+/**
+ * \addtogroup otherfns
+ * @{
+ */
+
 /**
- * pktb_alloc - allocate a new packet buffer
+ * pktb_alloc - allocate a new packet buffer [DEPRECATED]
  * \param family Indicate what family. Currently supported families are
  * AF_BRIDGE, AF_INET & AF_INET6.
  * \param data Pointer to packet data
@@ -46,13 +92,13 @@
  * \n
  * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
  * (v4 or v6)
+ * \note __pktb_alloc__ is deprecated. Use pktb_alloc2() in new code
  * \sa __calloc__(3)
  */
 EXPORT_SYMBOL
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
-	struct ethhdr *ethhdr;
 	void *pkt_data;
 
 	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
@@ -62,34 +108,94 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	/* Better make sure alignment is correct. */
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
+	pktb->copied = true;
 
-	pktb->len = len;
-	pktb->data_len = len + extra;
+	pktb_setup_metadata(pktb, pkt_data, len, extra);
 
-	pktb->data = pkt_data;
+	if (pktb_setup_family(pktb, family) < 0) {
+		free(pktb);
+		return NULL;
+	}
 
-	switch(family) {
-	case AF_INET:
-	case AF_INET6:
-		pktb->network_header = pktb->data;
-		break;
-	case AF_BRIDGE:
-		ethhdr = (struct ethhdr *)pktb->data;
-		pktb->mac_header = pktb->data;
+	return pktb;
+}
 
-		switch(ethhdr->h_proto) {
-		case ETH_P_IP:
-		case ETH_P_IPV6:
-			pktb->network_header = pktb->data + ETH_HLEN;
-			break;
-		default:
-			/* This protocol is unsupported. */
-			errno = EPROTONOSUPPORT;
-			free(pktb);
-			return NULL;
-		}
-		break;
+/**
+ * @}
+ */
+
+/**
+ * pktb_alloc2 - make a packet buffer from an existing buffer
+ * \param family Indicate what family. Currently supported families are
+ * AF_BRIDGE, AF_INET & AF_INET6.
+ * \param buf Buffer to hold packet metadata, and packet contents _if_
+ * mangling results in an increase in packet size
+ * \param buflen Size of _buf_.
+ * If your app may mangle a packet to be larger than it was,
+ * __NFQ_BUFFER_SIZE__ is a safe choice.
+ * Otherwise use pktb_head_size() to get the optimum value
+ * \param data Pointer to packet data
+ * \param len Packet length
+ *
+ * This function builds a userspace packet buffer inside a supplied buffer.
+ * The packet buffer contains packet metadata and optionally room for a copy of
+ * (enlarged) packet data.
+ *
+ * This function uses less CPU cycles than pktb_alloc() + pktb_free().
+ * Users can expect a decrease in overall CPU time in the order of 10%.
+ *
+ * \return Pointer to a userspace packet buffer or NULL on failure.
+ * \par Errors
+ * __ENOMEM__ _bufsize_ is less than pktb_head_size()
+ * \n
+ * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
+ * (v4 or v6)
+ * \note Be sure not to __malloc__ _buf_ inside your callback function,
+ * otherwise the performance improvement over pktb_alloc() will be lost.
+ * It's suggested to declare the _buf_ as a local (stack) variable in
+ * the callback function.
+ * To avoid repeated calls to pktb_head_size(), declare a __static__ or
+ * __extern__ __size_t__ variable
+ * and initialise its value by a single call from __main()__
+ * (Each thread has its own stack of size __uname -s__ (typically 8MB, plenty
+ * of room)).
+ * \n
+ * If debugging a single-threaded program, a static _buf_ may be preferred:
+ * \code {.c}
+static char buf[NFQ_BUFFER_SIZE];
+\endcode
+ * is always safe.
+ * \note If mangling,
+ * one must use different buffers for netlink receive and
+ * send from and to the kernel.
+ * Otherwise, there may be overlapping moves or worse.
+ * examples/nf-queue.c does this anyway.
+ * \warning Do __not__ call pktb_free() on the returned pointer.
+ * If upgrading existing software to use __pktb_alloc2__,
+ * be sure to remove the __pktb_free__ call.
+ * \sa nfq_nlmsg_verdict_put_pkt() (has sample code using __pktb_alloc2__)
+ */
+EXPORT_SYMBOL
+struct pkt_buff *pktb_alloc2(int family, void *buf, size_t buflen,
+			     void *data, size_t len)
+{
+	struct pkt_buff *pktb;
+	void *pkt_data;
+
+	if (sizeof(struct pkt_buff) > buflen)
+	{
+		errno = ENOMEM;
+		return NULL;
 	}
+	pktb = buf;
+	memset(pktb, 0, sizeof(struct pkt_buff));
+
+	pkt_data = data;
+
+	pktb_setup_metadata(pktb, pkt_data, len, 0);
+	pktb->buf_len = buflen;
+	if (pktb_setup_family(pktb, family) < 0)
+		pktb = NULL;
 	return pktb;
 }
 
@@ -100,6 +206,10 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
  * \par
  * It is appropriate to use _pktb_data_ as the second argument of
  * nfq_nlmsg_verdict_put_pkt()
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 uint8_t *pktb_data(struct pkt_buff *pktb)
@@ -122,29 +232,43 @@ uint32_t pktb_len(struct pkt_buff *pktb)
 }
 
 /**
- * pktb_free - release packet buffer
- * \param pktb Pointer to userspace packet buffer
+ * pktb_head_size - get size of struct pkt_buff
+ * \return Size of (opaque) __struct pkt_buff__
  */
 EXPORT_SYMBOL
-void pktb_free(struct pkt_buff *pktb)
+size_t pktb_head_size(void)
 {
-	free(pktb);
+	return sizeof(struct pkt_buff);
 }
 
 /**
  * \defgroup otherfns Other functions
  *
  * The library provides a number of other functions which many user-space
- * programs will never need. These divide into 2 groups:
+ * programs will never need. These divide into 3 groups:
  * \n
  * 1. Functions to get values of members of opaque __struct pktbuff__, described
  * below
  * \n
- * 2. Internal functions, described in Module __Internal functions__
+ * 2. Slower functions that __malloc__ and __free__ the memory to make a buffer
+ * \n
+ * 3. Internal functions, described in Module __Internal functions__
  *
  * @{
  */
 
+/**
+ * pktb_free - release packet buffer [DEPRECATED]
+ * \param pktb Pointer to userspace packet buffer
+ * \note __pktb_free__ is deprecated.
+ * It is not required and must not be used with pktb_alloc2()
+ */
+EXPORT_SYMBOL
+void pktb_free(struct pkt_buff *pktb)
+{
+	free(pktb);
+}
+
 /**
  * \defgroup uselessfns Internal functions
  *
@@ -195,7 +319,7 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 /**
  * pktb_trim - set new length for this packet buffer
  * \param pktb Pointer to userspace packet buffer
- * \param len New packet length (tail is adjusted to reflect this)
+ * \param len New packet length
  */
 EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
@@ -306,7 +430,7 @@ static int enlarge_pkt(struct pkt_buff *pktb, unsigned int extra)
  * excess of \b rep_len over \b match_len
  \warning pktb_mangle does not update any checksums. Developers should use the
  appropriate mangler for the protocol level: nfq_ip_mangle(),
- nfq_tcp_mangle_ipv4() or nfq_udp_mangle_ipv4(). IPv6 versions are planned.
+ nfq_tcp_mangle_ipv4(), nfq_udp_mangle_ipv4() or the IPv6 versions of these.
  \n
  It is appropriate to use pktb_mangle to change the MAC header.
  */
@@ -319,6 +443,29 @@ int pktb_mangle(struct pkt_buff *pktb,
 		unsigned int rep_len)
 {
 	unsigned char *data;
+	uint32_t extra, xs;
+
+	/* Check whether we need to do the delayed data copy,
+	 * and whether there is room to do it */
+	if ((xs = rep_len - match_len) > 0 && !pktb->copied &&
+	    pktb->len + xs > pktb->data_len &&
+	    (extra = pktb->buf_len - pktb->data_len - sizeof *pktb) >= xs)
+	{
+		void *pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
+		size_t pkt_diff = (size_t)pkt_data - (size_t)pktb->data;
+
+		memcpy(pkt_data, pktb->data, pktb->len);
+		pktb->copied = true;
+		pktb->data_len += extra;
+
+		/* Adjust pointers */
+		pktb->data += pkt_diff;
+		pktb->network_header += pkt_diff;
+		if (pktb->mac_header)
+			pktb->mac_header += pkt_diff;
+		if (pktb->transport_header)
+			pktb->transport_header += pkt_diff;
+	}
 
 	if (rep_len > match_len &&
 	    rep_len - match_len > pktb_tailroom(pktb) &&
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 933c6ee..7f62f2b 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -38,6 +38,10 @@
  * not set or if a minimal length check fails.
  * \note You have to call nfq_ip_set_transport_header() or
  * nfq_ip6_set_transport_header() first to set the TCP header.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
@@ -57,6 +61,10 @@ struct tcphdr *nfq_tcp_get_hdr(struct pkt_buff *pktb)
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
  * \returns Pointer to the TCP payload, or NULL if malformed TCP packet.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
@@ -79,6 +87,8 @@ void *nfq_tcp_get_payload(struct tcphdr *tcph, struct pkt_buff *pktb)
  * \param tcph: pointer to the TCP header
  * \param pktb: pointer to user-space network packet buffer
  * \returns Length of TCP payload (user data)
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling.
  */
 EXPORT_SYMBOL
 unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
@@ -230,6 +240,10 @@ int nfq_tcp_mangle_ipv4(struct pkt_buff *pktb,
 				match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
+	/* Re-fetch iph & tcph in case pktb_mangle changed network_header */
+	iph = (struct iphdr *)pktb->network_header;
+	tcph = (struct tcphdr *)(pktb->network_header + iph->ihl*4);
+
 	nfq_tcp_compute_checksum_ipv4(tcph, iph);
 
 	return 1;
@@ -269,6 +283,10 @@ int nfq_tcp_mangle_ipv6(struct pkt_buff *pktb,
 			   match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
+	/* Re-fetch ip6h & tcph in case pktb_mangle changed network_header */
+	ip6h = (struct ip6_hdr *)pktb->network_header;
+	tcph = (struct tcphdr *)(pktb->transport_header);
+
 	nfq_tcp_compute_checksum_ipv6(tcph, ip6h);
 
 	return 1;
diff --git a/src/extra/udp.c b/src/extra/udp.c
index f232127..f94b9f4 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -38,6 +38,10 @@
  * not set or if a minimal length check fails.
  * \note You have to call nfq_ip_set_transport_header() or
  * nfq_ip6_set_transport_header() first to set the UDP header.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
@@ -57,6 +61,10 @@ struct udphdr *nfq_udp_get_hdr(struct pkt_buff *pktb)
  * \param udph: Pointer to UDP header
  * \param pktb: Pointer to userspace network packet buffer
  * \returns Pointer to the UDP payload, or NULL if malformed UDP packet.
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling. (Specifically,
+ * invalidation occurs if the packet is being mangled to be longer than it was
+ * originally (only happens once per packet)).
  */
 EXPORT_SYMBOL
 void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
@@ -79,6 +87,8 @@ void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pktb)
  * \param udph: Pointer to UDP header
  * \param pktb: Pointer to userspace network packet buffer
  * \returns Length of UDP payload (user data)
+ * \note Calling any of the **mangle** functions may invalidate the result,
+ * so one should call the function again after mangling.
  */
 EXPORT_SYMBOL
 unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
@@ -163,6 +173,10 @@ int nfq_udp_mangle_ipv4(struct pkt_buff *pktb,
 				match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
+	/* Re-fetch iph & udph in case pktb_mangle changed network_header */
+	iph = (struct iphdr *)pktb->network_header;
+	udph = (struct udphdr *)(pktb->network_header + iph->ihl*4);
+
 	nfq_udp_compute_checksum_ipv4(udph, iph);
 
 	return 1;
@@ -201,6 +215,10 @@ int nfq_udp_mangle_ipv6(struct pkt_buff *pktb,
 			    match_offset, match_len, rep_buffer, rep_len))
 		return 0;
 
+	/* Re-fetch ip6h & udph in case pktb_mangle changed network_header */
+	ip6h = (struct ip6_hdr *)pktb->network_header;
+	udph = (struct udphdr *)(pktb->transport_header);
+
 	nfq_udp_compute_checksum_ipv6(udph, ip6h);
 
 	return 1;
diff --git a/src/internal.h b/src/internal.h
index ae849d6..31d23db 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -27,8 +27,10 @@ struct pkt_buff {
 
 	uint32_t len;
 	uint32_t data_len;
+	uint32_t buf_len;
 
 	bool	mangled;
+	bool	copied;
 };
 
 static inline uint8_t *pktb_tail(struct pkt_buff *pktb)
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e141156..f3a2c62 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -106,26 +106,28 @@ EXPORT_SYMBOL
  *
  * This code snippet uses nfq_udp_mangle_ipv4. See nf-queue.c for
  * context:
- * \verbatim
-// main calls queue_cb (line 64) to process an enqueued packet:
+ * \code {.c}
+// main calls queue_cb (line 49) to process an enqueued packet:
 	// Extra variables
+	struct pkt_buff *pktb;
 	uint8_t *payload, *rep_data;
 	unsigned int match_offset, match_len, rep_len;
+	char pktbuf[NFQ_BUFFER_SIZE];
 
 	// The next line was commented-out (with payload void*)
 	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
-	// Copy data to a packet buffer (allow 255 bytes for mangling).
-	pktb = pktb_alloc(AF_INET, payload, plen, 255);
+	// Set up a packet buffer (the large pktbuf allows for any mangling).
+	pktb = pktb_alloc2(AF_INET, pktbuf, sizeof pktbuf, payload, plen);
 	// (decide that this packet needs mangling)
 	nfq_udp_mangle_ipv4(pktb, match_offset, match_len, rep_data, rep_len);
 	// nfq_udp_mangle_ipv4 updates packet length, no need to track locally
 
-	// Eventually nfq_send_verdict (line 39) gets called
+	// Eventually nfq_send_verdict (line 24) gets called
 	// The received packet may or may not have been modified.
 	// Add this code before nfq_nlmsg_verdict_put call:
 	if (pktb_mangled(pktb))
 		nfq_nlmsg_verdict_put_pkt(nlh, pktb_data(pktb), pktb_len(pktb));
-\endverbatim
+\endcode
  */
 void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
 			       uint32_t plen)
-- 
2.14.5

