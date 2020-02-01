Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0289AC33C9E
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 06:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E52920679
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 06:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgBAGVs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 01:21:48 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43839 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726038AbgBAGVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 01:21:47 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 7C2368206E4
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Feb 2020 17:21:28 +1100 (AEDT)
Received: (qmail 4771 invoked by uid 501); 1 Feb 2020 06:21:27 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: Add faster alternatives to pktb_alloc()
Date:   Sat,  1 Feb 2020 17:21:27 +1100
Message-Id: <20200201062127.4729-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200108225323.io724vuxuzsydjzs@salvia>
References: <20200108225323.io724vuxuzsydjzs@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=l697ptgUJYAA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=jRMuBokcdIEVFm9YM2oA:9 a=fnMAPFMWG2l5Uacm:21
        a=jADEQo8V3bVSEJme:21 a=qgObOmUcw677F6Me:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Functions pktb_alloc_data, pktb_make and pktb_make_data are defined.
The pktb_make pair are syggested as replacements for the pktb_alloc (now) pair
because they are always faster.

- Add prototypes to include/libnetfilter_queue/pktbuff.h
- Add pktb_alloc_data much as per Pablo's email of Wed, 8 Jan 2020
  speedup: point to packet data in netlink receive buffer rather than copy to
           area immediately following pktb struct
- Add pktb_make much like pktb_usebuf proposed on 10 Dec 2019
  2 sppedups: 1. Use an existing buffer rather than calloc and (later) free one.
              2. Only zero struct and extra parts of pktb - the rest is
                 overwritten by copy (calloc has to zero the lot).
- Add pktb_make_data
  3 speedups: All of the above
- Document the new functions
- Move pktb_alloc and pktb_alloc_data into the "other functions" group since
  they are slower than the "make" equivalent functions

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/pktbuff.h |   3 +
 src/extra/pktbuff.c                  | 296 ++++++++++++++++++++++++++++++-----
 2 files changed, 261 insertions(+), 38 deletions(-)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153..fc6bf01 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,6 +4,9 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
+struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len);
+struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
+struct pkt_buff *pktb_make_data(int family, void *data, size_t len, void *buf, size_t bufsize);
 void pktb_free(struct pkt_buff *pktb);
 
 uint8_t *pktb_data(struct pkt_buff *pktb);
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca9..cfd9f15 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -29,6 +29,59 @@
  * @{
  */
 
+static struct pkt_buff *__pktb_alloc(size_t len, size_t extra)
+{
+	struct pkt_buff *pktb;
+
+	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
+
+	return pktb;
+}
+
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
  * pktb_alloc - allocate a new packet buffer
  * \param family Indicate what family. Currently supported families are
@@ -52,10 +105,9 @@ EXPORT_SYMBOL
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
-	struct ethhdr *ethhdr;
 	void *pkt_data;
 
-	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
+	pktb = __pktb_alloc(len, extra);
 	if (pktb == NULL)
 		return NULL;
 
@@ -63,32 +115,198 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
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
+ * pktb_alloc_data - fast version of pktb_alloc with some restrictions
+ * \param family Indicate what family. Currently supported families are
+ * AF_BRIDGE, AF_INET & AF_INET6.
+ * \param data Pointer to packet data
+ * \param len Packet length
+ *
+ * This function returns a packet buffer that points to the packet data which
+ * remains in its original netlink receive buffer.
+ * This saves the time to copy the data but restricts mangling to leaving the
+ * packet the same size or making it shorter.
+ *
+ * \sa pktb_make_data(), expecially Notes and Warnings
+ */
+EXPORT_SYMBOL
+struct pkt_buff *pktb_alloc_data(int family, void *data, size_t len)
+{
+	struct pkt_buff *pktb;
+
+	pktb = __pktb_alloc(0, 0);
+	if (!pktb)
+		return NULL;
+
+	pktb->data = data;
+	pktb_setup_metadata(pktb, data, len, 0);
+
+	if (pktb_setup_family(pktb, family) < 0) {
+		free(pktb);
+		return NULL;
+	}
+
+	return pktb;
+}
+
+/**
+ * @}
+ */
+
+static struct pkt_buff *__pktb_make(size_t len, size_t extra, void *buf,
+				    size_t bufsize)
+{
+	struct pkt_buff *pktb;
+
+	/* Better make sure alignment is correct. */
+	size_t extra2 =
+		(size_t)buf & 0x3 ? (~((size_t)buf & 0x3) & 0x3) + 1 : 0;
+
+	pktb = buf + extra2;
+	if (extra2 + sizeof(struct pkt_buff) + len + extra > bufsize)
+	{
+		errno = ENOMEM;
+		return NULL;
+	}
+	/* Zero the front bit. memcpy looks after next part */
+	memset(pktb, 0, sizeof(struct pkt_buff) + extra2);
+
+	return pktb;
+}
+
+/**
+ * pktb_make - make a packet buffer from an existing buffer
+ * \param family Indicate what family. Currently supported families are
+ * AF_BRIDGE, AF_INET & AF_INET6.
+ * \param data Pointer to packet data
+ * \param len Packet length
+ * \param extra Extra memory in the tail to be allocated (for mangling)
+ * \param buf Existing buffer to use
+ * \param bufsize Size of _buf_
+ *
+ * This function builds a userspace packet buffer inside a supplied buffer.
+ * The packet buffer contains the packet data and some extra memory room in the
+ * tail (if requested).
+ *
+ * This function uses less CPU cycles than pktb_alloc() + pktb_free().
+ * Users can expect a decrease in overall CPU time in the order of 5%.
+ *
+ * \return Pointer to a userspace packet buffer aligned within _buf_ or NULL on
+ * failure.
+ * \par Errors
+ * __ENOMEM__ _bufsize_ is too small to accomodate _len_
+ * \n
+ * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
+ * (v4 or v6)
+ * \note Be sure not to __malloc__ _buf_ inside your callback function,
+ * otherwise the performance improvement over pktb_alloc() will be lost.
+ * A static buffer works well in single-threaded programs, especially if
+ * debugging.
+ * Or, declare the buffer as a local (stack) variable in
+ * the callback function.
+ * (Each thread has its own stack of size __uname -s__ (typically 8MB, plenty
+ * of room)).
+ * \warning Do __not__ call pktb_free() on the returned pointer
+ */
+EXPORT_SYMBOL
+struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra,
+			     void *buf, size_t bufsize)
+{
+	struct pkt_buff *pktb;
+	void *pkt_data;
+
+	pktb = __pktb_make(len, extra, buf, bufsize);
+
+	if (pktb)
+	{
+		pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
+		memcpy(pkt_data, data, len);
+
+		pktb_setup_metadata(pktb, pkt_data, len, extra);
+		if (pktb_setup_family(pktb, family) < 0)
+			pktb = NULL;
+		if (pktb && extra)
+			memset(pktb_tail(pktb), 0, extra);
+	}
+	return pktb;
+}
+/**
+ * pktb_make_data - fast version of pktb_make with some restrictions
+ * \param family Indicate what family. Currently supported families are
+ * AF_BRIDGE, AF_INET & AF_INET6.
+ * \param data Pointer to packet data
+ * \param len Packet length
+ * \param buf Existing buffer to use
+ * \param bufsize Size of _buf_
+ *
+ * This function builds a userspace packet buffer where the packet data is left
+ * in the original receive buffer and pointed to.
+ * This saves the time to copy the data but restricts mangling to leaving the
+ * packet the same size or making it shorter.
+ *
+ * \par Relative performance timings
+ * The table below shows relative timings for pktb_alloc(), pktb_make(),
+ * pktb_alloc_data() and pktb_make_data().
+ * Timings for the functions with __alloc__ in their name include a call to
+ * __pktb_free__. Tests were done for 50-byte and 1500-byte packets.
+ * <TABLE>
+ * <TR>
+ * <TD><B>Bytes</B></TD>
+ * <TD><B>pktb_alloc</B></TD>
+ * <TD><B>pktb_make</B></TD>
+ * <TD><B>pktb_alloc_data</B></TD>
+ * <TD><B>pktb_make_data</B></TD>
+ * </TR>
+ * <TR>
+ * <TD>50</TD>
+ * <TD>100%</TD>
+ * <TD>51%</TD>
+ * <TD>56%</TD>
+ * <TD>29%</TD>
+ * </TR>
+ * <TR>
+ * <TD>1500</TD>
+ * <TD>100%</TD>
+ * <TD>60%</TD>
+ * <TD>23%</TD>
+ * <TD>12%</TD>
+ * </TR>
+ * </TABLE>
+ *
+ * \note If mangling, one must use different buffers for netlink receive and
+ * send from and to the kernel.
+ * Otherwise, there may be overlapping moves or worse.
+ * examples/nf-queue.c does this anyway.
+ * \note _bufsize_ only needs to be __sizeof(struct pkt_buff)__, since no data
+ * is copied.
+ * \warning The function prototype may change before the next library release,
+ * to accomodate other _data fast function variants
+ * \sa pktb_make(), expecially Notes and Warnings
+ */
+
+EXPORT_SYMBOL
+struct pkt_buff *pktb_make_data(int family, void *data, size_t len, void *buf,
+				size_t bufsize)
+{
+	struct pkt_buff *pktb;
+
+	pktb = __pktb_make(0, 0, buf, bufsize);
+
+	if (pktb)
+	{
+		pktb_setup_metadata(pktb, data, len, 0);
+		if (pktb_setup_family(pktb, family) < 0)
+			pktb = NULL;
 	}
 	return pktb;
 }
@@ -121,30 +339,32 @@ uint32_t pktb_len(struct pkt_buff *pktb)
 	return pktb->len;
 }
 
-/**
- * pktb_free - release packet buffer
- * \param pktb Pointer to userspace packet buffer
- */
-EXPORT_SYMBOL
-void pktb_free(struct pkt_buff *pktb)
-{
-	free(pktb);
-}
-
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
+ * pktb_free - release packet buffer
+ * \param pktb Pointer to userspace packet buffer
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
@@ -195,7 +415,7 @@ void pktb_put(struct pkt_buff *pktb, unsigned int len)
 /**
  * pktb_trim - set new length for this packet buffer
  * \param pktb Pointer to userspace packet buffer
- * \param len New packet length (tail is adjusted to reflect this)
+ * \param len New packet length
  */
 EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
-- 
2.14.5

