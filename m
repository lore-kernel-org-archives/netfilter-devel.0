Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71590C43460
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F48611CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhEDCf4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 22:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDCfz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 22:35:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B94BC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2021 19:35:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t21so4015164plo.2
        for <netfilter-devel@vger.kernel.org>; Mon, 03 May 2021 19:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s6fsRVQQZ9uOu+IZsX8tW383oGPQ26W+NG+hvywlL20=;
        b=ii/WOj0GM+rY7Hnug0VREn/8ABHg/cLLLUl6fs0Hg6KkgZgYy2Y9otH1ve9+n62prB
         jDKGQs6F/ZlK/LBVg1gPSolBscywngGnCLalpA+PG36nYGjSzTkyJxC4mP/+2EIlfwZr
         Gl5g4kRoHmtIwvLlxYlzpR/r0OmUx8oBQg++GCa6iYS8D9MUGsthnWJQz5+6bwRbyxAE
         G9ygaEnlMHA4YUO0c1NaxK30mwTRT6YSylBHMnROQQlNuuHT+Suj/EHesjLaT8/P0iS/
         N4S9GYMJY/OeZyOE+eule0eImImO27PWC4jhcEM2lc1GfAcl83GoR2fGC+no4zLcg1zE
         yztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=s6fsRVQQZ9uOu+IZsX8tW383oGPQ26W+NG+hvywlL20=;
        b=ATUzfftjiYVVJFoJu6I0voe6t/sE/Us7G0Z7iJ/VCdRUUsli1DynXGeptlYNUw7/4C
         YdjhDYujSMZQrvp4iOs8qQsOzIi33YIej/Oc3zxaIh0gkVd1FCFPEPsGx+DQoZgGp8QK
         32+HcazcA0Py2995ZuSSRrRmfNFzeyZpOtBYa1poCz+CrIizk6aw4WRwpityenwXREji
         u1RaBc29iDQMqfWRxqdP22lYST2Y9rZVTgQUW44e8DmacSgNSX4cOLnDbga6mAZOTZuv
         SXQ071xbwwhoket4jan4bh6nyrNHPFNh/uHVyRHuUQpHIFOUlBH3Q1P1AiFLm+TYKWgY
         pvOg==
X-Gm-Message-State: AOAM53375HyoR2i/+MLXXxrRAjTRfCO4ryoOjVCiEGnop919YnmZUfET
        Ty5Qrynl2tQXlP3A74YBN0f2xVbqR6jIZw==
X-Google-Smtp-Source: ABdhPJxCElsRjDHVhGCAyP7Ew14dsL0DVU9RpvzzICacgoOzQH2xfY4kdpLfGNS2aFtAtTmBXMYpYg==
X-Received: by 2002:a17:902:dacf:b029:ee:ac0e:d0fe with SMTP id q15-20020a170902dacfb02900eeac0ed0femr19133142plx.30.1620095701648;
        Mon, 03 May 2021 19:35:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-228-163.sun4.vic.optusnet.com.au. [49.192.228.163])
        by smtp.gmail.com with ESMTPSA id 205sm10386366pfc.201.2021.05.03.19.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 19:35:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 1/1] Eliminate packet copy when constructing struct pkt_buff
Date:   Tue,  4 May 2021 12:34:31 +1000
Message-Id: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
References: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
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
 examples/nf-queue.c                    | 22 ++++++-
 include/libnetfilter_queue/Makefile.am |  1 +
 include/libnetfilter_queue/callback.h  | 11 ++++
 include/libnetfilter_queue/pktbuff.h   |  2 +
 src/Makefile.am                        |  1 +
 src/extra/callback.c                   | 52 +++++++++++++++++
 src/extra/pktbuff.c                    | 80 ++++++++++++++++++--------
 7 files changed, 141 insertions(+), 28 deletions(-)
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
index 0000000..50b15ce
--- /dev/null
+++ b/src/extra/callback.c
@@ -0,0 +1,52 @@
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
+/* Use thread local dumps for the stack variables that lexical scoping    */
+/* would have allowed local_cb() to access therefore.                     */
+/* ---------------------------------------------------------------------- */
+
+static __thread nfq_cb_t cb_func_sv;
+static __thread size_t bufcap_sv, buflen_sv;
+
+static int local_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct pkt_buff pktb_instance = { };
+
+	return cb_func_sv(nlh, data, &pktb_instance, bufcap_sv - buflen_sv);
+}
+
+EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
+			     unsigned int portid, nfq_cb_t cb_func, void *data)
+{
+	const struct nlmsghdr *nlh = buf;
+
+	cb_func_sv = cb_func;
+	bufcap_sv = bufcap;
+	buflen_sv = buflen;
+
+	/* Verify not multi-part */
+	if (nlh->nlmsg_flags & NLM_F_MULTI) {
+		errno = E2BIG;
+		return MNL_CB_ERROR;
+	}
+
+
+	return mnl_cb_run(buf, buflen, 0, portid, local_cb, data);
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

