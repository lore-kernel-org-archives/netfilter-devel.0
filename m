Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B663C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 02:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiC1CuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Mar 2022 22:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiC1CuI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Mar 2022 22:50:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD5A1D0E0
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Mar 2022 19:48:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4so12728905pjh.2
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Mar 2022 19:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/DCb3rpp4ePUznoyUK47L/xmfnrjVJ7eGyirdqtRAsM=;
        b=QH6/Aswxc97QVd2hTxLFqcz32M3irGWuhwOt92VhyNLcqZliWiJMZ5pFoGLEkfO4Zf
         NEVgwvcqLC/mWKzc4vL+9nad8h+YwYYG/Av09B/GLYcMnUm6yvuBuYtUbbJ2Iz8Czgno
         AMa91/wvxv/U1MysbQ8UOHZINq8rszqBwELJXMLOZsnIhgbyYp+3N4nxDW/1+vdxY7aP
         C8tutR4QRI3y7UoRRTqQJfSpQ+sZZbR0t68+D+UMVv5Ucaqveq6remLEtiflYAoW2Asc
         rJJ3GsPOwnlxM/lyTXrZKRF8Jl6nyuxygUDnNqpsxdbaJCP1UORHWkiMvOwoERUZvvpq
         Sv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=/DCb3rpp4ePUznoyUK47L/xmfnrjVJ7eGyirdqtRAsM=;
        b=E8FlySZ46lA+2cx0I0RtxHq+3FVX2CmkBlduPlQYVvLcBStL8KJ1Y27hkfmg1+P1pk
         nbaSEFEK7LlE0U22Rqm3V2Vbd0A94WFtI7GagVSdQYa0UEyNJ+vUGf2HG8SStUPdxYk6
         q3L5LFjbSNHwnM2NptNMvWkfBP/SUfZXIql6CputLP481CtLeDDXMGltQ6poEHSK8UrB
         f6wUUHjQavM11wU2CKb2JjJDF+GsYxlZui+iNQIHy64SPEcORYpANGrdkAHVzwEY2AfC
         L+5mjYvKUXiUVKVFegA0H1qYfaPEGDr0Y6GE6RnHtoGpOMkWKw1rgFIYhEt7aWra2sga
         tiaA==
X-Gm-Message-State: AOAM530qO96fqQc4B7qRYR+6iRsaqJr5BqcxTI3svJBw/pukDeBevWsJ
        SLOEkohPmfgiJRdtSseQk89DxZNwjPQ=
X-Google-Smtp-Source: ABdhPJy9z0FG6W0VoD51m3yZcqHpdX+EBn+MTuWEHQIUXVnYMiGcf/WFQIo+lx1HQjeaYNFHZNRf8w==
X-Received: by 2002:a17:90b:2496:b0:1b9:a6dd:ae7 with SMTP id nt22-20020a17090b249600b001b9a6dd0ae7mr38995173pjb.35.1648435706725;
        Sun, 27 Mar 2022 19:48:26 -0700 (PDT)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm13551639pfu.56.2022.03.27.19.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 19:48:26 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4] src: eliminate packet copy when constructing struct pktbuff
Date:   Mon, 28 Mar 2022 13:48:21 +1100
Message-Id: <20220328024821.9927-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To avoid a copy, the new code takes advantage of the fact that the netfilter
netlink queue never returns multipart messages.
This means that the buffer space following that callback data is available for
packet expansion when mangling.

nfq_cb_run() is a new nfq-specific callback runqueue for netlink messages.
The principal function of nfq_cb_run() is to pass to the called function what is
the length of free space after the packet.

pktb_setup is a new function to initialise a new struct pkt_buff.

pktb_head_size() is a new function to return the amount of memory to reserve
for a new struct pkt_buff.

nfq_cb_t is a new typedef for the function called by nfq_cb_run()
[c.f. mnl_cb_t / mnl_cb_run].

examples/nf-queue.c is updated to demonstrate the new API.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v4:
New functions have man pages / html doc
struct pkt_buff remains opaque
pktb_populate renamed pktb_setup
 doxygen/Makefile.am                    |  1 +
 doxygen/doxygen.cfg.in                 |  1 +
 examples/nf-queue.c                    | 24 ++++++-
 include/libnetfilter_queue/Makefile.am |  1 +
 include/libnetfilter_queue/callback.h  | 11 +++
 include/libnetfilter_queue/pktbuff.h   |  3 +
 src/Makefile.am                        |  1 +
 src/extra/callback.c                   | 93 ++++++++++++++++++++++++++
 src/extra/pktbuff.c                    | 53 +++++++++++++--
 9 files changed, 181 insertions(+), 7 deletions(-)
 create mode 100644 include/libnetfilter_queue/callback.h
 create mode 100644 src/extra/callback.c

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index c6eeed7..6b1186d 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -8,6 +8,7 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/extra/ipv6.c\
            $(top_srcdir)/src/extra/tcp.c\
            $(top_srcdir)/src/extra/udp.c\
+           $(top_srcdir)/src/extra/callback.c\
            $(top_srcdir)/src/extra/icmp.c
 
 doxyfile.stamp: $(doc_srcs) Makefile
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 14bd0cf..8f05a1d 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -13,6 +13,7 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         data_carrier \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 4466ca8..c69c986 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -13,6 +13,8 @@
 #include <linux/types.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
+#include <libnetfilter_queue/pktbuff.h>
+#include <libnetfilter_queue/callback.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
 /* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
@@ -46,13 +48,17 @@ nfq_send_verdict(int queue_num, uint32_t id)
 	}
 }
 
-static int queue_cb(const struct nlmsghdr *nlh, void *data)
+static int queue_cb(const struct nlmsghdr *nlh, void *data,
+		    size_t supplied_extra)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
+	struct pkt_buff *pktb;
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
+	uint8_t *payload;
 	uint16_t plen;
+	int j;
 
 	if (nfq_nlmsg_parse(nlh, attr) < 0) {
 		perror("problems parsing");
@@ -69,7 +75,9 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
 
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
-	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
+	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
+
+	pktb = pktb_setup(data, AF_INET, payload, plen, supplied_extra);
 
 	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 
@@ -115,6 +123,13 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 		printf(", checksum not ready");
 	puts(")");
 
+	printf("payload (len=%d) [", plen);
+
+	for (j = 0; j < pktb_len(pktb); j++)
+		printf("%02x", payload[j]);
+
+	printf("]\n");
+
 	nfq_send_verdict(ntohs(nfg->res_id), id);
 
 	return MNL_CB_OK;
@@ -129,6 +144,9 @@ int main(int argc, char *argv[])
 	int ret;
 	unsigned int portid, queue_num;
 
+	/* Reserve space to be [re-]used as a struct pktbuff.*/
+	char pkt_b[pktb_head_size()];
+
 	if (argc != 2) {
 		printf("Usage: %s [queue_num]\n", argv[0]);
 		exit(EXIT_FAILURE);
@@ -186,7 +204,7 @@ int main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
-		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
+		ret = nfq_cb_run(buf, ret, sizeof_buf, portid, queue_cb, pkt_b);
 		if (ret < 0){
 			perror("mnl_cb_run");
 			exit(EXIT_FAILURE);
diff --git a/include/libnetfilter_queue/Makefile.am b/include/libnetfilter_queue/Makefile.am
index e436bab..ed6524b 100644
--- a/include/libnetfilter_queue/Makefile.am
+++ b/include/libnetfilter_queue/Makefile.am
@@ -5,4 +5,5 @@ pkginclude_HEADERS = libnetfilter_queue.h	\
 		     libnetfilter_queue_ipv6.h	\
 		     libnetfilter_queue_tcp.h	\
 		     libnetfilter_queue_udp.h	\
+		     callback.h			\
 		     pktbuff.h
diff --git a/include/libnetfilter_queue/callback.h b/include/libnetfilter_queue/callback.h
new file mode 100644
index 0000000..36c8bdb
--- /dev/null
+++ b/include/libnetfilter_queue/callback.h
@@ -0,0 +1,11 @@
+#ifndef _LIBNETFILTER_QUEUE_CALLBACK_H_
+#define _LIBNETFILTER_QUEUE_CALLBACK_H_
+
+struct nlattr;
+struct pkt_buff;
+
+typedef int (*nfq_cb_t)(const struct nlmsghdr *nlh, void *data, size_t extra);
+
+int nfq_cb_run(const void *buf, size_t buflen, size_t bufsiz, unsigned int portid, nfq_cb_t cb_data, void *data);
+
+#endif
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153..6fa9286 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -6,6 +6,9 @@ struct pkt_buff;
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
 void pktb_free(struct pkt_buff *pktb);
 
+struct pkt_buff *pktb_setup(void *pkt_b, int family, void *data, size_t len, size_t extra);
+size_t pktb_head_size(void);
+
 uint8_t *pktb_data(struct pkt_buff *pktb);
 uint32_t pktb_len(struct pkt_buff *pktb);
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 079853e..376bc45 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -31,6 +31,7 @@ libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles \
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				nlmsg.c			\
 				extra/checksum.c	\
+				extra/callback.c	\
 				extra/icmp.c		\
 				extra/ipv6.c		\
 				extra/tcp.c		\
diff --git a/src/extra/callback.c b/src/extra/callback.c
new file mode 100644
index 0000000..c01c100
--- /dev/null
+++ b/src/extra/callback.c
@@ -0,0 +1,93 @@
+/*
+ * (C) 2021 by Duncan Roe <duncan_roe@optusnet.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+#include <libmnl/libmnl.h>
+#include <linux/netlink.h>
+#include <libnetfilter_queue/callback.h>
+#include "internal.h"
+
+/* ---------------------------------------------------------------------- */
+/* It would be less code to have local_cb() declared within nfq_cb_run(). */
+/* gcc is fine with that; unfortunately clang 8.0.1 is not.               */
+/* Lexical scoping would have given access to the 3 outer stack variables */
+/* needed by local_cb(); absent that, pass them down through the data arg */
+/* ---------------------------------------------------------------------- */
+
+struct data_carrier
+{
+	nfq_cb_t cb_func;
+	size_t buflen;
+	size_t bufsiz;
+	void *data;
+};
+
+static int local_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct data_carrier *d = (struct data_carrier *)data;
+
+	return d->cb_func(nlh, d->data, d->bufsiz - d->buflen);
+}
+
+/**
+ * \defgroup callback Callback helper
+ * @{
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/callback.h>
+\endmanonly
+ *
+ * @{
+ */
+
+/**
+ * nfq_cb_run - callback runqueue for netfilter netlink messages
+ * \param buf buffer that contains the netlink messages
+ * \param buflen number of bytes stored in the buffer
+ * \param bufsiz buffer size (max possible buflen)
+ * \param portid Netlink PortID that we expect to receive
+ * \param cb_func callback handler for data messages
+ * \param data pointer to data that will be passed to the data callback handler
+ *
+ * This function is similar to mnl_cb_run() from libmnl but tells the callback
+ * how much extra memory is available after the packet.
+ *
+ * Your callback may return three possible values:
+ *      - MNL_CB_ERROR (<=-1): an error has occurred. Stop callback runqueue.
+ *      - MNL_CB_STOP (=0): stop callback runqueue.
+ *      - MNL_CB_OK (>=1): no problems has occurred.
+ *
+ * \return callback return value
+ */
+EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufsiz,
+			     unsigned int portid, nfq_cb_t cb_func, void *data)
+{
+	const struct nlmsghdr *nlh = buf;
+	struct data_carrier dc;
+
+	dc.cb_func = cb_func;
+	dc.bufsiz = bufsiz;
+	dc.buflen = buflen;
+	dc.data = data;
+
+	/* Verify not multi-part */
+	if (nlh->nlmsg_flags & NLM_F_MULTI) {
+		errno = E2BIG;
+		return MNL_CB_ERROR;
+	}
+
+	return mnl_cb_run(buf, buflen, 0, portid, local_cb, &dc);
+}
+/**
+ * @}
+ * @}
+ */
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 005172c..980bf14 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -19,6 +19,8 @@
 #include <netinet/tcp.h>
 
 #include "internal.h"
+#include <libnetfilter_queue/pktbuff.h> /* I.e. local copy */
+					/* (to verify prototypes) */
 
 /**
  * \defgroup pktbuff User-space network packet buffer
@@ -67,6 +69,14 @@ static int __pktb_setup(int family, struct pkt_buff *pktb)
 	return 0;
 }
 
+static void pktb_setup_metadata(struct pkt_buff *pktb, void *pkt_data,
+				size_t len, size_t extra)
+{
+	pktb->len = len;
+	pktb->data_len = len + extra;
+	pktb->data = pkt_data;
+}
+
 /**
  * pktb_alloc - allocate a new packet buffer
  * \param family Indicate what family. Currently supported families are
@@ -100,10 +110,7 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
 
-	pktb->len = len;
-	pktb->data_len = len + extra;
-
-	pktb->data = pkt_data;
+	pktb_setup_metadata(pktb, pkt_data, len, extra);
 
 	if (__pktb_setup(family, pktb) < 0) {
 		free(pktb);
@@ -113,6 +120,32 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	return pktb;
 }
 
+/**
+ * pktb_setup - set up a packet buffer
+ * \param pkt_b Pointer to memory of length pktb_head_size() bytes
+ * \param family Indicate what family. Currently supported families are
+ * AF_BRIDGE, AF_INET & AF_INET6.
+ * \param data Pointer to packet data
+ * \param len Packet length
+ * \param extra Extra memory available after packet data (for mangling).
+ * nfq_cb_run() supplies this datum
+ * \return Pointer to a new userspace packet buffer or NULL on failure.
+ * \par Errors
+ * __EPROTONOSUPPORT__ _family_ was __AF_BRIDGE__ and this is not an IP packet
+ * (v4 or v6)
+ */
+EXPORT_SYMBOL
+struct pkt_buff *pktb_setup(void *pkt_b, int family, void *data,
+			    size_t len, size_t extra)
+{
+	memset(pkt_b, 0, sizeof (struct pkt_buff));
+	pktb_setup_metadata(pkt_b, data, len, extra);
+	if (__pktb_setup(family, pkt_b) < 0)
+		pkt_b = NULL;
+	return pkt_b;
+}
+
+
 /**
  * pktb_data - get pointer to network packet
  * \param pktb Pointer to userspace packet buffer
@@ -397,6 +430,18 @@ bool pktb_mangled(const struct pkt_buff *pktb)
 	return pktb->mangled;
 }
 
+/**
+ * pktb_head_size - get number of bytes needed for a packet buffer
+ *                  (control part only)
+ * \return size of struct pkt_buff
+ */
+
+EXPORT_SYMBOL
+size_t pktb_head_size(void)
+{
+	return sizeof(struct pkt_buff);
+}
+
 /**
  * @}
  */
-- 
2.17.5

