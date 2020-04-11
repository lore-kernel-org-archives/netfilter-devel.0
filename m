Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9E4C2BBC7
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A432078E
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgDKHY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 03:24:56 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60865 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbgDKHY4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 03:24:56 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id AA0B83A3172
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 17:24:51 +1000 (AEST)
Received: (qmail 7405 invoked by uid 501); 11 Apr 2020 07:24:50 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] New faster pktb_alloc2 replaces pktb_alloc & pktb_free
Date:   Sat, 11 Apr 2020 17:24:50 +1000
Message-Id: <20200411072450.7359-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200411072450.7359-1-duncan_roe@optusnet.com.au>
References: <20200411072450.7359-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20200219180410.e56psjovne3y43rc@salvia>
References: <20200219180410.e56psjovne3y43rc@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=MR8HCse9589hoxa4nVEA:9 a=0lWXs1jfUqJdZ7jV:21
        a=XgOFCX_4Vnj2pkgc:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pktb_alloc2() avoids the malloc()/free() overhead in pktb_alloc().
Additionally, if the "extra" argument is zero, pktb_alloc2() leaves the packet
data in place rather than copying it (mangling is still allowed except to
increae the packet size).
New function pktb_head_size() gives size of opaque struct pkt_buff for
allocating space in the stack.
 - Mark old functions DEPRECATED in the documentation.
 - Update sample code snippet in nfq_nlmsg_verdict_put_pkt documentation.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 fixmanpages.sh                       |   6 +-
 include/libnetfilter_queue/pktbuff.h |   2 +
 src/extra/pktbuff.c                  | 204 +++++++++++++++++++++++++++++------
 src/nlmsg.c                          |  14 ++-
 4 files changed, 185 insertions(+), 41 deletions(-)

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
index 42bc153..a71e62b 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,6 +4,7 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
+struct pkt_buff *pktb_alloc2(int family, void *head, size_t headsize, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
 void pktb_free(struct pkt_buff *pktb);
 
 uint8_t *pktb_data(struct pkt_buff *pktb);
@@ -22,5 +23,6 @@ uint8_t *pktb_transport_header(struct pkt_buff *pktb);
 int pktb_mangle(struct pkt_buff *pktb, int dataoff, unsigned int match_offset, unsigned int match_len, const char *rep_buffer, unsigned int rep_len);
 
 bool pktb_mangled(const struct pkt_buff *pktb);
+size_t pktb_head_size(void);
 
 #endif
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca9..df97192 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -29,8 +29,52 @@
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
@@ -46,13 +90,13 @@
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
@@ -63,33 +107,113 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
 
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
+ * \param head Buffer to hold packet metadata
+ * \param headsize Size of _head_. Use pktb_head_size() to get the optimum
+ * value
+ * \param data Pointer to packet data
+ * \param len Packet length
+ * \param extra Extra memory in the tail to be allocated (for mangling).
+ * Specify zero (to avoid a data copy) unless mangling may increase packet size
+ * \param buf Buffer to use for packet data copy.
+ * Specify NULL if _extra_ is zero
+ * \param bufsize Size of _buf_. Specify zero if _buf_ is NULL
+ *
+ * This function builds a userspace packet buffer inside a supplied buffer.
+ * The packet buffer contains the packet data and some extra memory room in the
+ * tail (if requested).
+ *
+ * This function uses less CPU cycles than pktb_alloc() + pktb_free().
+ * Users can expect a decrease in overall CPU time in the order of 5%,
+ * 10% if _extra_ is zero.
+ *
+ * \return Pointer to a userspace packet buffer or NULL on failure.
+ * \par Errors
+ * __ENOMEM__ _bufsize_ is too small to accomodate _len_
+ * or _headsize_ is too small to accomodate __struct pkt_buff__
+ * \n
+ * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
+ * (v4 or v6)
+ * \par Relative performance timings
+ * The table below shows relative timings for pktb_alloc() and pktb_alloc2()
+ * with and without extra bytes.
+ * Tests were done for 50-byte and 1500-byte packets.
+ * \verbatim
+======================================================
+| Bytes | pktb_alloc + | pktb_alloc2, | pktb_alloc2, |
+|       | pktb_free    | extra != 0   | extra == 0   |
+======================================================
+|   50  | 100%         | 51%          | 29%          |
+======================================================
+| 1500  | 100%         | 60%          | 12%          |
+======================================================
+ \endverbatim
+ * \note Be sure not to __malloc__ _buf_ or _head_ inside your callback
+ * function,
+ * otherwise the performance improvement over pktb_alloc() will be lost.
+ * It's suggested to declare the buffers as local (stack) variables in
+ * the callback function.
+ * (Each thread has its own stack of size __uname -s__ (typically 8MB, plenty
+ * of room)).
+ * \n
+ * If debugging a single-threaded program, static buffers may be preferred:
+ * either debug to find __sizeof(struct pkt_buff)__ or allow, say, 64 bytes.
+ * \note If mangling with zero _extra_,
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
+struct pkt_buff *pktb_alloc2(int family, void *head, size_t headsize,
+			     void *data, size_t len, size_t extra,
+			     void *buf, size_t bufsize)
+{
+	struct pkt_buff *pktb;
+	void *pkt_data;
+
+	if (sizeof(struct pkt_buff) > headsize ||
+		(extra && (len + extra > bufsize)))
+	{
+		errno = ENOMEM;
+		return NULL;
 	}
+	pktb = head;
+	memset(pktb, 0, sizeof(struct pkt_buff));
+
+	if (extra)
+	{
+		pkt_data = buf;
+		memcpy(pkt_data, data, len);
+		memset((uint8_t *)pkt_data + len, 0, extra);
+	}
+	else
+		pkt_data = data;
+
+	pktb_setup_metadata(pktb, pkt_data, len, extra);
+	if (pktb_setup_family(pktb, family) < 0)
+		pktb = NULL;
 	return pktb;
 }
 
@@ -122,29 +246,43 @@ uint32_t pktb_len(struct pkt_buff *pktb)
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
@@ -195,7 +333,7 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 /**
  * pktb_trim - set new length for this packet buffer
  * \param pktb Pointer to userspace packet buffer
- * \param len New packet length (tail is adjusted to reflect this)
+ * \param len New packet length
  */
 EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
@@ -306,7 +444,7 @@ static int enlarge_pkt(struct pkt_buff *pktb, unsigned int extra)
  * excess of \b rep_len over \b match_len
  \warning pktb_mangle does not update any checksums. Developers should use the
  appropriate mangler for the protocol level: nfq_ip_mangle(),
- nfq_tcp_mangle_ipv4() or nfq_udp_mangle_ipv4(). IPv6 versions are planned.
+ nfq_tcp_mangle_ipv4(), nfq_udp_mangle_ipv4() or the IPv6 versions of these.
  \n
  It is appropriate to use pktb_mangle to change the MAC header.
  */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e141156..efc8189 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -106,26 +106,30 @@ EXPORT_SYMBOL
  *
  * This code snippet uses nfq_udp_mangle_ipv4. See nf-queue.c for
  * context:
- * \verbatim
-// main calls queue_cb (line 64) to process an enqueued packet:
+ * \code {.c}
+// main calls queue_cb (line 49) to process an enqueued packet:
 	// Extra variables
 	uint8_t *payload, *rep_data;
 	unsigned int match_offset, match_len, rep_len;
+	char head[pktb_head_size()];
 
 	// The next line was commented-out (with payload void*)
 	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
 	// Copy data to a packet buffer (allow 255 bytes for mangling).
-	pktb = pktb_alloc(AF_INET, payload, plen, 255);
+#define EXTRA 255
+	char pktbuf[plen + EXTRA];
+	pktb = pktb_alloc2(AF_INET, head, sizeof head, payload, plen, EXTRA,
+		pktbuf, sizeof pktbuf);
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

