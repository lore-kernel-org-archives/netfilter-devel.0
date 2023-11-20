Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21371C54E76
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 01:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjKTBI6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Nov 2023 20:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjKTBI5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Nov 2023 20:08:57 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BF1B9
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2023 17:08:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so484207a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2023 17:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700442534; x=1701047334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=v/MLl4H+OMoHyZRb5Wf0RWYir1p/bZZUwarQbkuSfos=;
        b=lsbuAoWSY3UG64vEhTdpvDTDuvYxPln7sORyJyN3GAtTP488580c8tVVXvYhj8lKFD
         rHKR4z9kNFfTpebRbiLr7FNK1Iu3vJnQNQ6qKPkfW+ktsHaF/jBEjlAuUTotubD13UBB
         oOxLu1tBH8plmS5dfC37XUcLPKd19mpbA79o9U2V47qdQGWq2rV1CIFv44kEHqLgrLyO
         ikOtxJ+H4DRsFkvx67PiI8Cul7st09z0rZiH4UD0Cfbr+J8q8BxGnKGc4fucl3v40tB+
         i8XKw7EnDzyxMfRhyIb0rgOef5o4HpEdvB67GEp4lxebQAr3Cz/iHDncLiucJM0qbacR
         T2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700442534; x=1701047334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/MLl4H+OMoHyZRb5Wf0RWYir1p/bZZUwarQbkuSfos=;
        b=qpAkJz0XZXA61+VzEC4okQAO4iGncG1LWe+N/30uMYphSi2IxTBCT9vp3VknF5BeC0
         Xg0m2OoYJ42rHszZyTbsDMzK7GZjcmOn1+aai/i/fkAd57dQbpRPkOltqOT00HbT8366
         N4C0gzEV7h9LLthKC8eXtZr2PQd+KaFmpeVB0Tjs8AAIXlZRYvgmqPTW22oHwtCHsALb
         9QUuEnPSB1LlKsf85Qwr4E2w+6tJclXDXzp1BORweK/taD377Y6Nls9BZGNtPI1gj/mL
         r+f1ENrM0txuN67d5szSlSqgkFRTFYmry9esPnfddRqGtDI6KHmBh8xBi6VBCQ/coksq
         Y4lg==
X-Gm-Message-State: AOJu0Yxpsrpmnei2+Q658SvFITmbK+pNDKEDHbFlrjfwq4im9eiRyhWI
        4HrZWBEkmyH3Ux8SJrR7cbqyvJCBI5Q=
X-Google-Smtp-Source: AGHT+IEGBxjLKZx5VNRHMExtjqFiJFnc/fGPaT+yum1XrRuWGHzBSCffpRyhoYOXwb3NH6f/y8pIlg==
X-Received: by 2002:a05:6a20:8f26:b0:188:c44:5f6 with SMTP id b38-20020a056a208f2600b001880c4405f6mr5125572pzk.32.1700442533584;
        Sun, 19 Nov 2023 17:08:53 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id b5-20020a170903228500b001c9c8d761a3sm4852235plh.131.2023.11.19.17.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 17:08:53 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4] src: Add nfq_nlmsg_put2() - user specifies header flags
Date:   Mon, 20 Nov 2023 12:08:49 +1100
Message-Id: <20231120010849.11276-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable mnl programs to check whether a config request was accepted.
(nfnl programs do this already).

v4: other requested changes

v3: force on NLM_F_REQUEST

v2: take flags as an arg (Pablo request)
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 54 ++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

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
index 5400dd7..0c6229e 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -309,10 +309,62 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  */
 EXPORT_SYMBOL
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
+{
+	return nfq_nlmsg_put2(buf, type, queue_num, 0);
+}
+
+/**
+ * nfq_nlmsg_put2 - Set up a netlink header with user-specified flags
+ *                  in a memory buffer
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \param flags additional flags to put in message header, commonly NLM_F_ACK
+ * \returns Pointer to netlink header
+ *
+ * Use NLM_F_ACK before performing an action that might fail, e.g.
+ * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
+ * \n
+ * The kernel always sends a message in response to a failed command.
+ * NLM_F_ACK instructs the kernel to also send a message in response
+ * to a successful command.
+ * \n
+ * This code snippet demonstrates reading these responses:
+ * \verbatim
+	nlh = nfq_nlmsg_put2(nltxbuf, NFQNL_MSG_CONFIG, queue_num, NLM_F_ACK);
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
+	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
 
 	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = AF_UNSPEC;
-- 
2.35.8

