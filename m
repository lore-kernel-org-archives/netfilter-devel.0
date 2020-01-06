Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3963C32767
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A65CD21582
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgAFDRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 22:17:31 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34024 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbgAFDRb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 22:17:31 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id EFE423A23F4
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 14:17:15 +1100 (AEDT)
Received: (qmail 12436 invoked by uid 501); 6 Jan 2020 03:17:14 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 1/1] src: Add alternative function to pktb_alloc to avoid malloc / free overhead
Date:   Mon,  6 Jan 2020 14:17:14 +1100
Message-Id: <20200106031714.12390-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200106031714.12390-1-duncan_roe@optusnet.com.au>
References: <20200106031714.12390-1-duncan_roe@optusnet.com.au>
In-Reply-To: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=bFSbER072C4bYWwp3zYA:9 a=RCULdEb0WJsgFQcZ:21
        a=NP3sv3MVDjdLE7ai:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

New function pktb_make() works like pktb_alloc() except it has 2 extra
arguments, being a user-supplied buffer and its length.
Performance testing using a program derived from examples/nf_queue.c shows
6% improvement, so the 5% improvement claimed in the documentation is
conservative.

Updated:

 include/libnetfilter_queue/pktbuff.h: Add pktb_make() prototype

 src/extra/pktbuff.c: Implement pktb_make()

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/pktbuff.h |  1 +
 src/extra/pktbuff.c                  | 60 ++++++++++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153..481ed59 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,6 +4,7 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
+struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra, void *buf, size_t bufsize);
 void pktb_free(struct pkt_buff *pktb);
 
 uint8_t *pktb_data(struct pkt_buff *pktb);
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 37f6bc0..d85121c 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -29,6 +29,8 @@
  * @{
  */
 
+static struct pkt_buff *pktb_alloc_make_common(int family, void *data,
+	size_t len, size_t extra, struct pkt_buff *pktb, bool malloc_used);
 /**
  * pktb_alloc - allocate a new packet buffer
  * \param family Indicate what family. Currently supported families are
@@ -52,11 +54,17 @@ EXPORT_SYMBOL
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
-	void *pkt_data;
 
 	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
 	if (pktb == NULL)
 		return NULL;
+	return pktb_alloc_make_common(family, data, len, extra, pktb, true);
+}
+
+static struct pkt_buff *pktb_alloc_make_common(int family, void *data,
+	size_t len, size_t extra, struct pkt_buff *pktb, bool malloc_used)
+{
+	void *pkt_data;
 
 	/* Better make sure alignment is correct. */
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
@@ -87,7 +95,8 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 		default:
 			/* This protocol is unsupported. */
 			errno = EPROTONOSUPPORT;
-			free(pktb);
+			if (malloc_used)
+				free(pktb);
 			return NULL;
 		}
 		break;
@@ -96,6 +105,53 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	return pktb;
 }
 
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
+ * \warning Do __not__ call pktb_free() on the returned pointer
+ */
+EXPORT_SYMBOL
+struct pkt_buff *pktb_make(int family, void *data, size_t len, size_t extra,
+			     void *buf, size_t bufsize)
+{
+	struct pkt_buff *pktb;
+
+	/* Better make sure alignment is correct. */
+	size_t extra2 =
+		(size_t)buf & 0x7 ? (~((size_t)buf & 0x7) & 0x7) + 1 : 0;
+
+	pktb = buf + extra2;
+	if (extra2 + sizeof(struct pkt_buff) + len + extra > bufsize)
+	{
+		errno = ENOMEM;
+		return NULL;
+	}
+	memset(pktb, 0, sizeof(struct pkt_buff) + len + extra);
+
+	return pktb_alloc_make_common(family, data, len, extra, pktb, false);
+}
+
 /**
  * pktb_data - get pointer to network packet
  * \param pktb Pointer to userspace packet buffer
-- 
2.14.5

