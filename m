Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D8CC07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbjKOKKA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjKOKJ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:09:59 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C24A101
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:09:55 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6b44befac59so535030b3a.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700042995; x=1700647795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbkdxjksQF6J0KaFbjm6ga0ollNtAfQ+/qzo7xm3SsA=;
        b=TJT8yL/knRNGwCk78dU4SrXbaa3PMVNgX4XwMS33LY++l9ohgzo6Js0BP1jA8QIIfF
         6oAHRzBZU+VfhtC7bbGVPB/2kzPpUZbpmciRF3/Fu+hUqCiabxyGTQKDftllsb3g2tpd
         l85QIRw3r6hq024ao7j81HaXvzPxtzFrTuI7wSpXpH37PhvTeIi0IrKsc1E5Wm1tNUfI
         sxTHRjIHIC4/plo/NJEFQNbe721q/iXd7L56bHwiCpjuJCdNpUV47vTSe0MWRhlqHyzG
         0utJwsy1WIcaUDOW1JWUaXP1XoefqL2xhC4A+1vALI7VdHjAsfClVvtizM30RVV9bGhs
         4hKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700042995; x=1700647795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HbkdxjksQF6J0KaFbjm6ga0ollNtAfQ+/qzo7xm3SsA=;
        b=pSM4j2D/7zVpOUxvaTUpEs8MYZdKB9oOBj0kDwg36ZTuDlxOUyIeq1HR/AcX2uQRRN
         VW+lW1P2J/gSBAMncrDsSn0dC8gFzMP0TSXWw6LdSpdhtHeP2/EHUM72dWwUFaM+MyLj
         Ff4OLxVYRxrWqQmCcjbqlTxkwsCPWOo7JcUKK7lKkFrSJFv3Qw3DiliyTR948iJN61C7
         Mlb1TYoPzoD8JlX4pwzmDk0ZpJ/hj2dMGNr2Nx/QdEpCrGR6rwQBWGKyB5gVbeRKVk66
         /wejgebinIRC4/762EzRq3OxTIlV8t2KcqVlUTX6263BT28pHFPudxB5RSQta9sm7hcP
         unGQ==
X-Gm-Message-State: AOJu0YwUKLp4J7GiAOcAB0syImhEzaCSUp7zgAHVTPsrgsjgibcGL24d
        +REZxdeiu8k+YCnM3YHRSTkeqspKZw8=
X-Google-Smtp-Source: AGHT+IGJU8s00B+dYK0iBVKveTHImvuZhFBRkmP4EqNsVSmO0Ojt4xxPqFKxMriKqdbGusDrcN1Gcg==
X-Received: by 2002:a17:90b:297:b0:280:2a3f:9938 with SMTP id az23-20020a17090b029700b002802a3f9938mr7520644pjb.12.1700042994829;
        Wed, 15 Nov 2023 02:09:54 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id 24-20020a17090a191800b00274b9dd8519sm7332229pjg.35.2023.11.15.02.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 02:09:54 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 1/1] src: Add nfq_nlmsg_put2() - user specifies header flags
Date:   Wed, 15 Nov 2023 21:09:50 +1100
Message-Id: <20231115100950.6553-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZVORoqFJonvQaABS@calendula>
References: <ZVORoqFJonvQaABS@calendula>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable mnl programs to check whether a config request was accepted.
(nfnl programs do this already).

v2: take flags as an arg (Pablo request)
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 57 ++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 3d8e444..f254984 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -151,6 +151,7 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt, uint32_t p
 
 int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 5400dd7..865e508 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -309,10 +309,65 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  */
 EXPORT_SYMBOL
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
+{
+	return nfq_nlmsg_put2(buf, type, queue_num, NLM_F_REQUEST);
+}
+
+/**
+ * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with
+ * user-specified flags
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \param flags flags to put in message header,
+ *              commonly NLM_F_REQUEST|NLM_F_ACK.
+ *              NLM_F_REQUEST by itself is the same as calling nfq_nlmsg_put()
+ * \returns Pointer to netlink message
+ *
+ * Use NLM_F_REQUEST|NLM_F_ACK before performing an action that might fail, e.g.
+ * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
+ * \n
+ * NLM_F_ACK instructs the kernel to send a message in response
+ * to a successful command.
+ * The kernel always sends a message in response to a failed command.
+ * \n
+ * This code snippet demonstrates reading these responses:
+ * \verbatim
+	nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num,
+			     NLM_F_REQUEST|NLM_F_ACK);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, NFQA_CFG_F_SECCTX);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, NFQA_CFG_F_SECCTX);
+
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
+struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
+				uint16_t flags)
 {
 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
+	nlh->nlmsg_flags = flags;
 
 	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = AF_UNSPEC;
-- 
2.35.8

