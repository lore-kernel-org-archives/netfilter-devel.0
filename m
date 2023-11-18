Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1612C197A0
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Nov 2023 00:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjKRAHP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 19:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjKRAHN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 19:07:13 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EDED7E
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 16:07:10 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6bee11456baso2348506b3a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 16:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700266030; x=1700870830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPq2huqvXdgjZz31i/XeZZS+midyScO/Glh6QnDYxJA=;
        b=O3QbcxH8Sb6dXuHb27VhY1pz76lGdfgEPOcyvSCZTcwL1liITGH05WX8V8CzdHUD5l
         OUR90i8fQtY9lGPIaszTJA/5IJKudQsbLXMHukMROjbKTzpItYMM1zQN0iJUYlEN+LXC
         Kwemlswxjny3PFrUT61v5pxAFaKgOTIwYJjbL4D8o1pTFRxRL30bvoprehqHPXGS8uSX
         qAi6ORxGWsNEp1rLVqozsBZI6PDOEPX5HGTCn4QO8gxlgVOeANQsmg7jQBwydunzpRmU
         v8qYA82iefDo4mOkf0UY4V4J7SGooLHAncJiL8yQ2E6riPhSa6zZHHp+5rVpP4yExMRX
         xOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700266030; x=1700870830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wPq2huqvXdgjZz31i/XeZZS+midyScO/Glh6QnDYxJA=;
        b=Oo6ZfWlFlo4jMCWO34DDkfgLIC1ZZ5C6VLMv5XsFuA9MunwuqlJflg1WGKSBXR2ByU
         XAV83ukXX7mdZ1z3Z8A0zh4mgrxry2Hbec/ExHGw4sF3xzFIrcdVYM+dBKRs1SW01KgG
         ifCoia5oNMIUJs2qZ9O1YcxMi72DcqteQYQoZuhoGPGA3ewEcxQo3Xo+Rys/pgZzfczV
         vX8QS2bZOjzE6v/AzcaCsO1COhrnbB+xIuZKwTLG8XBRsgTAEFHHc+qTN1fgv2stwp15
         dQbwCRud6eSzLREWIoozfcJMnHwtzUEBZh7Tjo3hv7IL1vbUmUuxF9/KVHtkyeZMDimM
         u37Q==
X-Gm-Message-State: AOJu0YysNSSxIHnlJbB60ZYBPpr7d93ovQfzzkrgk6TXJaw5tRRX4qV/
        xl2X+iV0Azl2VYj63sj3UuT5igmnTRE=
X-Google-Smtp-Source: AGHT+IG+irbdQdoi6cjCxKiXDHRZsomA4yz4ZGfupxUSDm+MBg14ntbe6tbzc8iMknjgkObnY5cM0Q==
X-Received: by 2002:a05:6a00:1d19:b0:693:3e55:59b4 with SMTP id a25-20020a056a001d1900b006933e5559b4mr1120321pfx.8.1700266029867;
        Fri, 17 Nov 2023 16:07:09 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q20-20020a62e114000000b006c003d9897bsm1936979pfh.138.2023.11.17.16.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 16:07:09 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Date:   Sat, 18 Nov 2023 11:07:02 +1100
Message-Id: <20231118000702.9202-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231118000702.9202-1-duncan_roe@optusnet.com.au>
References: <20231118000702.9202-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also remove nfq_errno (incomplete project, never documented).

Main change is to static function __build_send_cfg_msg(). After doing that,
I reinstated nfq_bind_pf() & nfq_unbind_pf() to do what the doc claims
rather than simply returning zero.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  4 +-
 src/libnetfilter_queue.c                      | 37 ++++++++-----------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f254984..9b54489 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -18,6 +18,8 @@
 
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
+#define NFQ_BUFFSIZE 8192
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -26,8 +28,6 @@ struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
 
-extern int nfq_errno;
-
 extern struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h);
 extern int nfq_fd(struct nfq_handle *h);
 
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ca44a6c..73969ce 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -166,8 +166,6 @@ struct nfq_data {
 	struct nfattr **data;
 };
 
-EXPORT_SYMBOL int nfq_errno;
-
 /***********************************************************************
  * low level stuff
  ***********************************************************************/
@@ -210,22 +208,20 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 		uint16_t queuenum, uint16_t pf)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_cmd cmd;
+	char buf[NFQ_BUFFSIZE];
+	struct nlmsghdr *nlh;
+	int ret;
 
-	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queuenum, NLM_F_ACK);
 
-	cmd._pad = 0;
-	cmd.command = command;
-	cmd.pf = htons(pf);
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
+	nfq_nlmsg_cfg_put_cmd(nlh, AF_UNSPEC, command);
 
-	return nfnl_query(h->nfnlh, &u.nmh);
+	ret = mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(h->nl, buf, sizeof(buf));
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, h->portid, NULL, NULL);
+	return ret;
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
@@ -453,15 +449,13 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 
 	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
 				      NFQNL_MSG_MAX, 0);
-	if (!h->nfnlssh) {
-		/* FIXME: nfq_errno */
+	if (!h->nfnlssh)
 		goto out_free;
-	}
+// THIS IS nfq_open_nfnl() - ENTIRE FUNCTION WILL BE REMOVED EVENTUALLY
 
 	pkt_cb.data = h;
 	err = nfnl_callback_register(h->nfnlssh, NFQNL_MSG_PACKET, &pkt_cb);
 	if (err < 0) {
-		nfq_errno = err;
 		goto out_close;
 	}
 
@@ -523,7 +517,7 @@ int nfq_close(struct nfq_handle *h)
 EXPORT_SYMBOL
 int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 {
-	return 0;
+	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_BIND, 0, pf);
 }
 
 /**
@@ -539,7 +533,7 @@ int nfq_bind_pf(struct nfq_handle *h, uint16_t pf)
 EXPORT_SYMBOL
 int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
 {
-	return 0;
+	return __build_send_cfg_msg(h, NFQNL_CFG_CMD_PF_UNBIND, 0, pf);
 }
 
 
@@ -606,7 +600,6 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h, uint16_t num,
 
 	ret = __build_send_cfg_msg(h, NFQNL_CFG_CMD_BIND, num, 0);
 	if (ret < 0) {
-		nfq_errno = ret;
 		free(qh);
 		return NULL;
 	}
-- 
2.35.8

