Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDE4C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 03:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96798611CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 03:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhERDKw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 May 2021 23:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241125AbhERDKv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 May 2021 23:10:51 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BA3C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 17 May 2021 20:09:34 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d78so5502355pfd.10
        for <netfilter-devel@vger.kernel.org>; Mon, 17 May 2021 20:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CHoRA0N1b80YhXIxreXTduBIL7slkUolkEzXpbjN6Bg=;
        b=VPLU8wVmPNpla+yvWXibQrHLv6dA4khuCsaE81D987d/QQSWRDw/fM1AnWoreVucb2
         Yviw8AyOaxqPhwI23O397HJM3wn04mqxdhh0xnkFtgEw4yhQz0M99DwqxQkne3475B9b
         EKINxVNRso1QOCY0y3GZOs+W1MNgscnAwov3Y3vfK3D26kx+7JeKtXPS5utfh3+72NKy
         LTclQjF1z1bOlrzexz35DH4uvR+vSIz0LwZQieGyJey3m6w9WZIMHEuiKaTZZ/R+hezp
         lrSsTz3ovPyXjszn6LT7Ku5X/TvGH1T7969UjY7cQpg/oaFzMDwgYfaznWxUiFa30XlJ
         11MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CHoRA0N1b80YhXIxreXTduBIL7slkUolkEzXpbjN6Bg=;
        b=tUDXfGb2f4sP+++jNFUYD1nSY+FDEBauGwAZ7v4D5FxxayRpyCQI7Ch2idCpsYBvi+
         YIqY1LUcSP9ozB0aPTsk22KlY+T/mA9I6HiqyH7M9wwk++7uEEolFq74nBR++UXCFC43
         sVx4gQZBoMIy+ktBrcub2QmUBpMggE8JgPZLKWW9Nb33fIQc3V3i54LZgxwRjM929ZAN
         1blHxdhASXfPPXRzevxHVKCmW3iUDLIYxJLaPk8NEhifZw0oSuSTVyxLlZWWG47o9Cqz
         zllDXkS5UIIZ/dQM3ZWMfy4TRUEe2e26N9ZnoR3WFsDVOoJcJsC3BRikVu/RgWIkGPr3
         w4IQ==
X-Gm-Message-State: AOAM530ivi7n2tVL7EqM8iqS/2OfGJX0r0ckNvpmguCE947clKhUEiz6
        eoPnwDhy3dG2+L8sUfziX37IJ7X+vbCWEA==
X-Google-Smtp-Source: ABdhPJzJ0khs/kqqfxJc+ZwWQaRa1GJah9syE4JnKWPsxW8IwT1s9Jq3EDLShSNCf/Hz2U6yaS5sFQ==
X-Received: by 2002:aa7:81d8:0:b029:28e:6e31:7c9a with SMTP id c24-20020aa781d80000b029028e6e317c9amr2879367pfn.56.1621307373806;
        Mon, 17 May 2021 20:09:33 -0700 (PDT)
Received: from slk1.local.net (n49-192-89-29.sun3.vic.optusnet.com.au. [49.192.89.29])
        by smtp.gmail.com with ESMTPSA id i2sm611197pjj.25.2021.05.17.20.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 20:09:33 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libnetfilter_queue v2 1/1] Eliminate packet copy when constructing struct pkt_buff
Date:   Tue, 18 May 2021 13:08:48 +1000
Message-Id: <20210518030848.17694-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
References: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
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
As a side benefit, nfq_cb_run() also gives the called functio a pointer to a
zeroised struct pkt_buff, avoiding the malloc / free that was previously needed.

nfq_cb_t is a new typedef for the function called by nfq_cb_run()
[c.f. mnl_cb_t / mnl_cb_run].

No doxygen documentation update yet -
will do once function prototypes are agreed.
In the meantime, examples/nf-queue.c is updated to demonstrate the new API.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c                    | 22 ++++++-
 include/libnetfilter_queue/Makefile.am |  1 +
 include/libnetfilter_queue/callback.h  | 11 ++++
 include/libnetfilter_queue/pktbuff.h   |  2 +
 src/Makefile.am                        |  1 +
 src/extra/callback.c                   | 60 +++++++++++++++++++
 src/extra/pktbuff.c                    | 80 ++++++++++++++++++--------
 7 files changed, 149 insertions(+), 28 deletions(-)
 create mode 100644 include/libnetfilter_queue/callback.h
 create mode 100644 src/extra/callback.c

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..15c0d77 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -13,6 +13,8 @@
 #include <linux/types.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
+#include <libnetfilter_queue/pktbuff.h>
+#include <libnetfilter_queue/callback.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
 /* only for NFQA_CT, not needed otherwise: */
@@ -46,13 +48,17 @@ nfq_send_verdict(int queue_num, uint32_t id)
 	}
 }
 
-static int queue_cb(const struct nlmsghdr *nlh, void *data)
+static int queue_cb(const struct nlmsghdr *nlh, void *data,
+		    struct pkt_buff *supplied_pktb, size_t supplied_extra)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
+	struct pkt_buff *pktb;
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
+	uint8_t *payload;
 	uint16_t plen;
+	int i;
 
 	if (nfq_nlmsg_parse(nlh, attr) < 0) {
 		perror("problems parsing");
@@ -69,7 +75,10 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	ph = mnl_attr_get_payload(attr[NFQA_PACKET_HDR]);
 
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
-	/* void *payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]); */
+	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
+
+	pktb = pktb_populate(supplied_pktb, AF_INET, payload, plen,
+			     supplied_extra);
 
 	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 
@@ -97,6 +106,13 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 		printf(", checksum not ready");
 	puts(")");
 
+	printf("payload (len=%d) [", plen);
+
+	for (i = 0; i < pktb_len(pktb); i++)
+		printf("%02x", payload[i]);
+
+	printf("]\n");
+
 	nfq_send_verdict(ntohs(nfg->res_id), id);
 
 	return MNL_CB_OK;
@@ -168,7 +184,7 @@ int main(int argc, char *argv[])
 			exit(EXIT_FAILURE);
 		}
 
-		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
+		ret = nfq_cb_run(buf, ret, sizeof_buf, portid, queue_cb, NULL);
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
index 0000000..27bfe31
--- /dev/null
+++ b/include/libnetfilter_queue/callback.h
@@ -0,0 +1,11 @@
+#ifndef _LIBNETFILTER_QUEUE_CALLBACK_H_
+#define _LIBNETFILTER_QUEUE_CALLBACK_H_
+
+struct nlattr;
+struct pkt_buff;
+
+typedef int (*nfq_cb_t)(const struct nlmsghdr *nlh, void *data, struct pkt_buff *pktb, size_t extra);
+
+int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap, unsigned int portid, nfq_cb_t cb_data, void *data);
+
+#endif
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153..33829cc 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -6,6 +6,8 @@ struct pkt_buff;
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
 void pktb_free(struct pkt_buff *pktb);
 
+struct pkt_buff *pktb_populate(struct pkt_buff *pktb, int family, void *data, size_t len, size_t extra);
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
index 0000000..2d67848
--- /dev/null
+++ b/src/extra/callback.c
@@ -0,0 +1,60 @@
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
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include "internal.h"
+
+/* ---------------------------------------------------------------------- */
+/* It would be less code to have local_cb() declared within nfq_cb_run(). */
+/* gcc is fine with that; unfortunately clang 8.0.1 is not.               */
+/* Lexical scoping would have given access to the 3 outer stack variables */
+/* needed by local_cb(); absent that, pass them down through the data arg */
+/* ---------------------------------------------------------------------- */
+
+typedef struct qwerty
+{
+	nfq_cb_t cb_func;
+	size_t buflen;
+	size_t bufcap;
+	void *data;
+} werty;
+
+static int local_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct pkt_buff pktb_instance = { };
+	werty *w = (werty *)data;
+
+	return w->cb_func(nlh, w->data, &pktb_instance, w->bufcap - w->buflen);
+}
+
+EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
+			     unsigned int portid, nfq_cb_t cb_func, void *data)
+{
+	const struct nlmsghdr *nlh = buf;
+	werty wert;
+
+	wert.cb_func = cb_func;
+	wert.bufcap = bufcap;
+	wert.buflen = buflen;
+	wert.data = data;
+
+	/* Verify not multi-part */
+	if (nlh->nlmsg_flags & NLM_F_MULTI) {
+		errno = E2BIG;
+		return MNL_CB_ERROR;
+	}
+
+
+	return mnl_cb_run(buf, buflen, 0, portid, local_cb, &wert);
+}
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca9..df23335 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -19,6 +19,8 @@
 #include <netinet/tcp.h>
 
 #include "internal.h"
+#include <libnetfilter_queue/pktbuff.h> /* I.e. local copy */
+					/* (to verify prototypes) */
 
 /**
  * \defgroup pktbuff User-space network packet buffer
@@ -29,6 +31,44 @@
  * @{
  */
 
+static int __pktb_setup(int family, struct pkt_buff *pktb)
+{
+	struct ethhdr *ethhdr;
+
+	switch (family) {
+	case AF_INET:
+	case AF_INET6:
+		pktb->network_header = pktb->data;
+		break;
+	case AF_BRIDGE:
+		ethhdr = (struct ethhdr *)pktb->data;
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
 /**
  * pktb_alloc - allocate a new packet buffer
  * \param family Indicate what family. Currently supported families are
@@ -52,7 +92,6 @@ EXPORT_SYMBOL
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
-	struct ethhdr *ethhdr;
 	void *pkt_data;
 
 	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
@@ -63,36 +102,27 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
 
-	pktb->len = len;
-	pktb->data_len = len + extra;
+	pktb_setup_metadata(pktb, pkt_data, len, extra);
 
-	pktb->data = pkt_data;
+	if (__pktb_setup(family, pktb) < 0) {
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
-	}
+EXPORT_SYMBOL
+struct pkt_buff *pktb_populate(struct pkt_buff *pktb, int family, void *data,
+			       size_t len, size_t extra)
+{
+	pktb_setup_metadata(pktb, data, len, extra);
+	if (__pktb_setup(family, pktb) < 0)
+		pktb = NULL;
 	return pktb;
 }
 
+
 /**
  * pktb_data - get pointer to network packet
  * \param pktb Pointer to userspace packet buffer
-- 
2.17.5

