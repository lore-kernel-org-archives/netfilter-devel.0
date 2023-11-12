Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC6DC4167D
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 22:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjKLWMr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 17:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjKLWMq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 17:12:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4F41BEC
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:12:43 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1cc58219376so34119285ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Nov 2023 14:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699827163; x=1700431963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSZthvlT1U7tTHRlI0ETa6A+O792WXjUtJhqHygOCTU=;
        b=g65m767gnCdKHcqR6M3eyBGSWhGIoxjM4c1STCDK1cKp/gXlAKIOo+5+K8INTyRVDh
         TIBDXkUweZGThNV/xPEBacCOQz3ZWD6gJ7/AqlLj0lpF5jQitvgvgjyGg0PgjlBqOLJM
         LbJtAx3NjtOLyAsRRxKTy4gy0KNg7Xz6IWqMb+j7EWQAXloGrlnWSkQ2DXQDz6iWG2Ey
         TD5PcYpoPUaPnVE3tgMAyot9o+xCZVz5gjddcXBah48v4qo0fRek395T8U5UOWSomxTB
         1XFuWQp02S48Nn8H8AEYDQ4jfbjM7Cpg3wrVkYZrZSV2MzsYLTZfT8oVkyPrhJtp8fOz
         mSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699827163; x=1700431963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZSZthvlT1U7tTHRlI0ETa6A+O792WXjUtJhqHygOCTU=;
        b=fy31V43Xf04YjR5q8DvpEFW3Lulu3n9kP3T/bwp+QO4enl7ZZCls2GnpAACXCBwRnb
         1Ku7e0P7CPXg37SGz4MYNK9qY6LgbX202DzqVkZf0QH9sEsACWFVtVOUvOcDvx9/vvtC
         fC3evkWeQRNyXML6jJwFasvGKzUJgaxHHc0O1JsZ/JIvP1MZ6TZITMck4AFNTEk9BpUx
         D9E4TxdpvWGj+iTF5thJaX1DJmFy4JexUeMjtfjf4346BGO4n985P0mYluUUDefVz3tv
         b/1yFwXrep1VtIslgyDU/8L1I0rozjeO7l720lWn9uJULY2c72qF86VM0alYB/4aihnt
         lR4w==
X-Gm-Message-State: AOJu0YxTV37pzasb1vd07yLnZOh6bWK2/5lX4NieXLek8QYCGzQChngv
        U90l5sux/9niojk5ii8vjgzKvhfJbtM=
X-Google-Smtp-Source: AGHT+IEv9DDkLp6B15Tetdc5EXRrnZhPpGYb7Q32l5bfNFYRmsXAvz3BTPMjF89KCjVfwGqQPAt9hQ==
X-Received: by 2002:a17:902:d503:b0:1cc:339b:62af with SMTP id b3-20020a170902d50300b001cc339b62afmr7186226plg.16.1699827162804;
        Sun, 12 Nov 2023 14:12:42 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902dad200b001cc530c495asm2943128plx.113.2023.11.12.14.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Nov 2023 14:12:42 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] src: Add nfq_nlmsg_put2() - header flags include NLM_F_ACK
Date:   Mon, 13 Nov 2023 09:12:35 +1100
Message-Id: <20231112221235.4086-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231112221235.4086-1-duncan_roe@optusnet.com.au>
References: <20231112221235.4086-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable mnl programs to check whether a config request was accepted.
(nfnl programs do this already).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 72 ++++++++++++++++---
 2 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 3d8e444..084a2ea 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 5400dd7..ba53df2 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -300,6 +300,21 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 			      nfq_pkt_parse_attr_cb, attr);
 }
 
+static struct nlmsghdr *__nfq_nlmsg_put(char *buf, int type, uint32_t queue_num,
+					uint16_t flags)
+{
+	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
+	nlh->nlmsg_flags = flags;
+
+	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
+	nfg->nfgen_family = AF_UNSPEC;
+	nfg->version = NFNETLINK_V0;
+	nfg->res_id = htons(queue_num);
+
+	return nlh;
+}
+
 /**
  * nfq_nlmsg_put - Convert memory buffer into a Netlink buffer
  * \param *buf Pointer to memory buffer
@@ -310,16 +325,57 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 EXPORT_SYMBOL
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
 {
-	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
+	return __nfq_nlmsg_put(buf, type, queue_num, NLM_F_REQUEST);
+}
 
-	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_UNSPEC;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = htons(queue_num);
+/**
+ * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with NLM_F_ACK
+ * flag present
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \returns Pointer to netlink message
+ *
+ * Use this function before performing an action that might fail, e.g.
+ * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
+ * \n
+ * NLM_F_ACK instructs the kernel to send a message in response
+ * to a successful command.
+ * The kernel always sends a message in response to a failed command.
+ * \n
+ * This code snippet demonstrates reading these responses:
+ * \verbatim
+	nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
 
-	return nlh;
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, nlrxbuf, sizeof nlrxbuf);
+	if (ret == -1) {
+		perror("mnl_socket_recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_cb_run(nlrxbuf, ret, 0, portid, NULL, NULL);
+	if (ret == -1)
+		perror("configure NFQA_CFG_F_SECCTX");
+\endverbatim
+ *
+ * \note
+ * The program above can continue after the error because NFQA_CFG_F_SECCTX
+ * was the only item in the preceding **mnl_socket_sendto**.
+ * If there had been other items, they would not have been actioned and it would
+ * not now be safe to proceed.
+ */
+
+EXPORT_SYMBOL
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num)
+{
+	return __nfq_nlmsg_put(buf, type, queue_num, NLM_F_REQUEST|NLM_F_ACK);
 }
 
 /**
-- 
2.35.8

