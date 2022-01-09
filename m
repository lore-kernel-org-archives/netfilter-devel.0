Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D9DC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiAIDRC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiAIDRB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:17:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26733C06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:17:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id n16so9240319plc.2
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EoKNTdw91UMP1vmmYOvRo+LT7n2EfgpJkSOCw0EHwYg=;
        b=a+n7b0yIne8JFLEzGTNslP6HGSgjY9RuvxHlvnQCxz6H5X1ZmjFEMhK6TpMxFFik1F
         PR88IoFf3OUt198Y9qb22OI1GBdkz4x7fJvoA1i4Mv1/ZKIbXHr4WmK7JQ2pmeU1CyLz
         E49BHTRbKY+fnXSlSQJftISz3qZwo3RvBwS6mG+CqM/aEh8c6XsIzwJbCKg5HB60wNNp
         RHWTO31xZ5cMCAQNFNKGb08BULgwD1GS4e6mGYR9ZdaBfzZQLVqCOK/yEKZSrm2xj/Gy
         EUywwOvIeu8zpEgi0bO8gaYNT8LZIEJsIPSHYFR5YAqsB4V2+Y4AzonA4cUxkKRVMyWB
         71Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EoKNTdw91UMP1vmmYOvRo+LT7n2EfgpJkSOCw0EHwYg=;
        b=JeRC/rsDsNGJr1zNAiBVhnMRIJXOKcFweIHUCTqFHUGAZabxFGWxy3jA73cp7xGpmJ
         w6QIthcB+vtQPuMjt7VeLhBdtYVudNngGa94JwuOY5BosOMzN8v/psCkYbnvmAKhyCe7
         VfrVBDFh8n/Qtz4JpT5xv09tL4A2xLQNIOi5jH9U/4KDrYxBbCUkK3Hy/zcTQmZhHOmT
         AUaTXnnE6Qj5/+kWzXWpalio85Dj6fLQSIgRF/q+CA4wB4rPzKse9s26BWx0z0BaGBI7
         Ntj2c3TZp6WSPLvZ2y1dz09UmqDOPttaHJNkZtlOn9jfA92RPnAdlqV7z9TVZj6cBDaD
         GGGg==
X-Gm-Message-State: AOAM532CO0GujAJjmhphLbl2ReHlzTWmUXPQlwrsOoPm2O7XALhEIzK7
        vkcSWA9Oc60Uf1k3ZDDwIWa0VtvJ0XA=
X-Google-Smtp-Source: ABdhPJwB8jRFFMOJOJ0rwDjAzLwHynPmB+USOUw27/gULLMeO6N6zEczvbPD9gw/gYMPOsl9qUGkFw==
X-Received: by 2002:a17:90b:3a85:: with SMTP id om5mr23467017pjb.145.1641698220590;
        Sat, 08 Jan 2022 19:17:00 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:17:00 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/5] src: eliminate packet copy when constructing struct pkt_buff
Date:   Sun,  9 Jan 2022 14:16:49 +1100
Message-Id: <20220109031653.23835-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
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
As a side benefit, nfq_cb_run() also gives the called function a pointer to a
zeroised struct pkt_buff, avoiding the malloc / free that was previously needed.

nfq_cb_t is a new typedef for the function called by nfq_cb_run()
[c.f. mnl_cb_t / mnl_cb_run].

No doxygen documentation update yet -
will do once function prototypes are agreed.
In the meantime, examples/nf-queue.c is updated to demonstrate the new API.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Pass saved vars in a struct rather than use (slower) thread-local
v3: Rebase to master commit c3bada27
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
 
 /* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
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
 
@@ -115,6 +124,13 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
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
@@ -186,7 +202,7 @@ int main(int argc, char *argv[])
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
index 005172c..df23335 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -19,6 +19,8 @@
 #include <netinet/tcp.h>
 
 #include "internal.h"
+#include <libnetfilter_queue/pktbuff.h> /* I.e. local copy */
+					/* (to verify prototypes) */
 
 /**
  * \defgroup pktbuff User-space network packet buffer
@@ -67,6 +60,15 @@ static int __pktb_setup(int family, struct pkt_buff *pktb)
 	return 0;
 }
 
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
@@ -100,10 +102,7 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pkt_data = (uint8_t *)pktb + sizeof(struct pkt_buff);
 	memcpy(pkt_data, data, len);
 
-	pktb->len = len;
-	pktb->data_len = len + extra;
-
-	pktb->data = pkt_data;
+	pktb_setup_metadata(pktb, pkt_data, len, extra);
 
 	if (__pktb_setup(family, pktb) < 0) {
 		free(pktb);
@@ -113,6 +112,17 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	return pktb;
 }
 
+EXPORT_SYMBOL
+struct pkt_buff *pktb_populate(struct pkt_buff *pktb, int family, void *data,
+			       size_t len, size_t extra)
+{
+	pktb_setup_metadata(pktb, data, len, extra);
+	if (__pktb_setup(family, pktb) < 0)
+		pktb = NULL;
+	return pktb;
+}
+
+
 /**
  * pktb_data - get pointer to network packet
  * \param pktb Pointer to userspace packet buffer
