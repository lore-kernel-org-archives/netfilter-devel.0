Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2567C4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 23:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjKMXZO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 18:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbjKMXZF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 18:25:05 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B3999
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 15:25:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6b44befac59so4509408b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 15:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699917902; x=1700522702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSmsZTw/erGc872d3ztYugpE/QZSHHR9IK/eiRy8Yko=;
        b=LTq7+80PMYi4l9gducx2T07q9iDpRlmMyCm+7u+KL6tKenRY/FF8PIG2OBGGtlDeDp
         arJ8ldg9uclvbQT6ZAj65yoI5Ah8e89uaNtx6LRo3ceSkxNglzONxot9aPRZkz8cCyYk
         p3sajYNWrJxD2qwnJlM6g2kfraLhDXp8URAGnRhrIhGOh44+zvC/bRMjtIa9vyGnlZUJ
         dbllm3OqwW/OFpo8b4MnZ8vj+sDseNAPlivo9DjbXBnF/TuMTyNCYy/aCTJIg0gYdGoK
         px8yVdvUrBABDgDWMwBmTCQeyKWxJXSZpB1LUjSKYu6sOSenPfPHLN14oTjtow58rO3I
         Ip4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699917902; x=1700522702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZSmsZTw/erGc872d3ztYugpE/QZSHHR9IK/eiRy8Yko=;
        b=GnJAB6dLDAwel291f7sJ6YpA/dONg+C2OBTeKGXNshN5bJY3cazv2GK6DrJWu28/qA
         XwNW1dpGH4TUpBiJDS6eRHw0VuvUSGeDmRBeuCjYQsjsvWp3meyUoX04oJ94rFlZeDEq
         MbmWT9HmRoq8dtPNxnWspHfFIA6e0hZYo0/yMcfAgONzk+Kg7QLRu32mYOGK6/6CgaQJ
         9nQpArZJzKOkYc3xcMLGheCvd8h+N7R/RHj5dWGdKRjcpsHNO58yh1I5PxtD+G97a3bS
         QhRGqd5KpjJCmvWDryDOtXE+Q7oHg+npakZ4yo0ugOCSi14ctHmx1Siuo2iaF+APSwVf
         bHcw==
X-Gm-Message-State: AOJu0YzYEa8s5ZbXPmkMPmSTxDJRgZVxAlcx8bGq5v98MDvUvscXmFv+
        +4aZWhPuViUj7qgKn9ssG+o2CBRzsAg=
X-Google-Smtp-Source: AGHT+IFH+gJY4picvcg/HjsL4oMf7F2ef+d+vjJ/Zc2PyIQkfQc6Q/sscFfJhe0COOFUV5VbLBWiZQ==
X-Received: by 2002:a17:90b:1056:b0:280:8e7d:5701 with SMTP id gq22-20020a17090b105600b002808e7d5701mr1458964pjb.2.1699917901682;
        Mon, 13 Nov 2023 15:25:01 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ml10-20020a17090b360a00b002802a080d1dsm4212558pjb.16.2023.11.13.15.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 15:25:01 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] Convert nfq_open(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Date:   Tue, 14 Nov 2023 10:24:55 +1100
Message-Id: <20231113232455.5150-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231113232455.5150-1-duncan_roe@optusnet.com.au>
References: <20231113232455.5150-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/doxygen.cfg.in   |  1 +
 src/libnetfilter_queue.c | 43 ++++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 97174ff..3e06bd8 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -13,6 +13,7 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         nfnl_handle \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..ca44a6c 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -31,6 +31,7 @@
 #include <sys/socket.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
+#include <libmnl/libmnl.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
@@ -134,11 +135,21 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * burst
  */
 
+/* We need a rump nfnl_handle to support nfnl_rcvbufsiz() */
+/* Luckily fd is the 1st item and that's all we need */
+
+struct nfnl_handle {
+	int			fd;
+};
+
 struct nfq_handle
 {
+	unsigned int portid;
 	struct nfnl_handle *nfnlh;
 	struct nfnl_subsys_handle *nfnlssh;
 	struct nfq_q_handle *qh_list;
+	struct mnl_socket *nl;
+	struct nfnl_handle rump_nfnl_handle;
 };
 
 struct nfq_q_handle
@@ -383,20 +394,30 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_handle *nfnlh = nfnl_open();
-	struct nfq_handle *qh;
+	struct nfq_handle *h = malloc(sizeof(*h));
 
-	if (!nfnlh)
+	if (!h)
 		return NULL;
+	memset(h, 0, sizeof(*h));
 
-	/* unset netlink sequence tracking by default */
-	nfnl_unset_sequence_tracking(nfnlh);
+	h->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (!h->nl) {
+		free(h);
+		return NULL;
+	}
 
-	qh = nfq_open_nfnl(nfnlh);
-	if (!qh)
-		nfnl_close(nfnlh);
+	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		mnl_socket_close(h->nl);
+		free(h);
+		return NULL;
+	}
+	h->portid = mnl_socket_get_portid(h->nl);
 
-	return qh;
+	/* fudges for nfnl_rcvbufsiz() */
+	h->nfnlh = &h->rump_nfnl_handle;
+	h->rump_nfnl_handle.fd = mnl_socket_get_fd(h->nl);
+
+	return h;
 }
 
 /**
@@ -502,7 +523,7 @@ int nfq_close(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 {
-	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
+	return 0;
 }
 
 /**
@@ -518,7 +539,7 @@ int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 EXPORT_SYMBOL
 int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 {
-	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
+	return 0;
 }
 
 
-- 
2.35.8

