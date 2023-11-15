Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E9EC47074
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 11:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjKOLaV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 06:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjKOLaU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 06:30:20 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9187211D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:30:16 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso5225299a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 03:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700047816; x=1700652616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Q+2dcaCoMC54MnLE/Z4S+jeNPL0MNGj3ebV/JvARxA=;
        b=ZE1otEq0Vs69H7X4qd5Tt+M03ZHnR7zUeGIap/YLmmZivZE9f64CI7uQlNAIn6NBb5
         hxdzQnGSsunhya/hcEdJvsOt9xdSVzNHojgyCN/MB/3aDho1jCCQIwEiHXJmPw39FJOx
         O9ya+kvFP2AScRd/+4ehB7q6ooqee7pwQ91UHaM1ef3kl848Xm8+vlRf2ao2i4aEMJeM
         pCtSdVZR+yrfFpfKSUJzSp018id34MlylgABZNJXarvHMXwf3DAm5GxSUBLftMoHuCza
         t/RldN0pi2SmhH0uaTzicljlp2t7Jv48dtDmaf7VYg9qbp8fg3Pdyj2c4lONwC5f/Zk/
         9imA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700047816; x=1700652616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Q+2dcaCoMC54MnLE/Z4S+jeNPL0MNGj3ebV/JvARxA=;
        b=AeveLvx6enVbt3pnZF4mKu/llEZ+fmZVwlJdgDOeiM9Y/Qa67fo7VX3X85yN3M8SRr
         +AsgNgZ2fUHE5x8n/2becU/+Fd+T3vIDxEOkeOHHOhVL6XbBb/4uVKlazNi7/1xC6OVf
         0GbESE71R6xJgLxq5/YJRuW92kFuQgODwL1106bHhxAM+ehYM0MiPVG9qpFrVVnKRo/0
         wC3Xe/DIQ3U79gAlmCRhKDlpQPV56kjCEEtnz2es1VFRfwPQQ8WcAFUzIY3g5EclkmN2
         hHaxuOEYLB5fjZIQSYNWzZMK6PVUMOfp7NAjHz1qZUba1AL+CXZIwKXAq3h/m/UsAXeK
         h6PQ==
X-Gm-Message-State: AOJu0Yy/uFf2es9AL4+bnPvjJcmByzaEjc198EHSsGoFwKIbDUVQWL+5
        cWO/Ns2E22jB9RyR3ScL5cxW9kjBmCE=
X-Google-Smtp-Source: AGHT+IFSjRI1TZ6hOE2Uaf/84bfHHupy79Ou5LuKFWq2oZK7kL86iSCx+YjYp2Deiy84Nq2Mp0q2lA==
X-Received: by 2002:a17:90b:3a8a:b0:280:cc47:b60d with SMTP id om10-20020a17090b3a8a00b00280cc47b60dmr12961545pjb.14.1700047815850;
        Wed, 15 Nov 2023 03:30:15 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id bk17-20020a17090b081100b00278ff752eacsm6546771pjb.50.2023.11.15.03.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 03:30:15 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/1] src: Add nfq_nlmsg_put2() - user specifies header flags
Date:   Wed, 15 Nov 2023 22:30:11 +1100
Message-Id: <20231115113011.6620-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZVSkE1fzi68CN+uo@calendula>
References: <ZVSkE1fzi68CN+uo@calendula>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable mnl programs to check whether a config request was accepted.
(nfnl programs do this already).

v3: force on NLM_F_REQUEST

v2: take flags as an arg (Pablo request)
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  1 +
 src/nlmsg.c                                   | 55 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

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
index 5400dd7..999ccfe 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -309,10 +309,63 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  */
 EXPORT_SYMBOL
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num)
+{
+	return nfq_nlmsg_put2(buf, type, queue_num, 0);
+}
+
+/**
+ * nfq_nlmsg_put2 - Convert memory buffer into a Netlink buffer with
+ * user-specified flags
+ * \param *buf Pointer to memory buffer
+ * \param type Either NFQNL_MSG_CONFIG or NFQNL_MSG_VERDICT
+ * \param queue_num Queue number
+ * \param flags additional (to NLM_F_REQUEST) flags to put in message header,
+ *              commonly NLM_F_ACK
+ * \returns Pointer to netlink message
+ *
+ * Use NLM_F_ACK before performing an action that might fail, e.g.
+ * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
+ * \n
+ * NLM_F_ACK instructs the kernel to send a message in response
+ * to a successful command.
+ * The kernel always sends a message in response to a failed command.
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

