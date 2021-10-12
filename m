Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA001C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 04:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B6460C4A
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 04:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhJLEol (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 00:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhJLEol (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 00:44:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76150C061570
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 21:42:40 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 133so12750101pgb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 21:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/XP89vrZGKg16iBURqtEbyTRZFKCCrlUCFYzTTyeb6c=;
        b=E7RxFo2ENjwUw0ccf+y1h1YcFP1d6NIHVNcVhmgGIZAioyyXpjk9eh4K0tfXetwJob
         TbPsMWcbkQ6mRsNXMNKnt1Oz0tosLKMnRiN/2iS6Z3r6vhR0eXtFgEAkraTnbIPgX0zl
         XJt3QM4Jw9htUFZlNI3XVY+Qw7S5h2Cvr0ksmIammGus+dA8ukNtAlXeTXR4Q7MqGosO
         Iim6krvGXvVM6Rty5+Bi+ttELbN7hAr6IWUoyWDmQzEm9aokG4r1dUI/JgNfLBB2Ev2y
         lfQTt/XSnO0a9If255w3+yC/QKDXITMX0HlQtcrGWHNX/gGXgiyQoN8GA+GRd3FQF7M0
         MxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=/XP89vrZGKg16iBURqtEbyTRZFKCCrlUCFYzTTyeb6c=;
        b=6gUnPSFqjJWUJ3pkBXi+Mf2/vCFDDPJwJqcFJCMfvi+hr+9dpzzUfABoSKklCcEDxU
         p7Of4EIDX6hDuyUQRgTRrqTud+RsdYWTt0thM+n+XVS4q+MpXWq3GHL8SAXbz9AthOC2
         66Q2eiLgi3rQyvlUjfdVKO/GgK0oixZljuBFZ8y5KguYIyz7ANyr/XNfhlu0jFMlXd/f
         E9pQjEwkkFon63wtEksuQICkMxN/avGBJN+N4q5WcqIof/NdEahmbwrhlDOCvoPO1VXo
         ZnkSWKzv/vlBkGCIf3G9RdqXseei0ey6RTkv8dR2wBQltsd/aj8MSAQ0R2eZGh4/8XpN
         gKTQ==
X-Gm-Message-State: AOAM530wEaNr+klyPIVuSU7rAfAn5o5px4cDnufcKptBvwejHNoxDWxo
        UpCyxGJ96bhuRvioKb5Qa5vbVsiDW4U=
X-Google-Smtp-Source: ABdhPJyl9aJzKUghxnW57j5zv8PI+fIRo0XcUdL2wOdBDVSc1ixa//yRzhnK1o3/tY/+3WjLMzl0yA==
X-Received: by 2002:a63:3fce:: with SMTP id m197mr3969736pga.296.1634013759893;
        Mon, 11 Oct 2021 21:42:39 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id o2sm1015327pja.7.2021.10.11.21.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 21:42:39 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH libnf-log] src: add conntrack ID to XML output
Date:   Tue, 12 Oct 2021 13:39:14 +0900
Message-Id: <20211012043912.18513-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YWTKdTsedRgM6Lgh@salvia>
References: <YWTKdTsedRgM6Lgh@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch enables to add conntrack ID as `ctid' element to XML output. Users
could identify conntrack entries by this ID from another conntrack output.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/libnetfilter_log/libnetfilter_log.h |  1 +
 src/libnetfilter_log.c                      | 44 ++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 16c4748..3b52f01 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -82,6 +82,7 @@ enum {
 	NFLOG_XML_PHYSDEV	= (1 << 4),
 	NFLOG_XML_PAYLOAD	= (1 << 5),
 	NFLOG_XML_TIME		= (1 << 6),
+        NFLOG_XML_CTID		= (1 << 7),
 	NFLOG_XML_ALL		= ~0U,
 };
 
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 27a6a2d..f2311ae 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -33,6 +33,9 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
+
 /**
  * \mainpage
  *
@@ -652,6 +655,7 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
  *
  *	- NFULNL_CFG_F_SEQ: This enables local nflog sequence numbering.
  *	- NFULNL_CFG_F_SEQ_GLOBAL: This enables global nflog sequence numbering.
+ *	- NFULNL_CFG_F_CONNTRACK: This enables to acquire related conntrack.
  *
  * \return 0 on success, -1 on failure with \b errno set.
  * \par Errors
@@ -974,6 +978,36 @@ int nflog_get_seq_global(struct nflog_data *nfad, uint32_t *seq)
 	return 0;
 }
 
+/**
+ * nflog_get_ct_id - get the conntrack id
+ * \param nfad Netlink packet data handle passed to callback function
+ * \param id conntrack id, if the function returns zero
+ *
+ * You must enable this via nflog_set_flags().
+ *
+ * \return 0 on success or -1 if conntrack itself or its id was unavailable
+ */
+int nflog_get_ctid(struct nflog_data *nfad, uint32_t *id)
+{
+        struct nlattr *cta = (struct nlattr *)nfad->nfa[NFULA_CT - 1];
+        struct nlattr *attr, *ida = NULL;
+
+        if (cta == NULL) return -1;
+
+        mnl_attr_for_each_nested(attr, cta) {
+                if (mnl_attr_get_type(attr) == CTA_ID) {
+                        ida = attr;
+                        break;
+                }
+        }
+
+        if (ida == NULL || mnl_attr_validate(ida, MNL_TYPE_U32) < 0)
+                return -1;
+
+        *id = ntohl(mnl_attr_get_u32(ida));
+        return 0;
+}
+
 /**
  * @}
  */
@@ -1016,6 +1050,7 @@ do {								\
  *	- NFLOG_XML_PHYSDEV: include the physical device information
  *	- NFLOG_XML_PAYLOAD: include the payload (in hexadecimal)
  *	- NFLOG_XML_TIME: include the timestamp
+ *	- NFLOG_XML_CTID: include conntrack id
  *	- NFLOG_XML_ALL: include all the logging information (all flags set)
  *
  * You can combine these flags with a bitwise OR.
@@ -1030,7 +1065,7 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
 {
 	struct nfulnl_msg_packet_hdr *ph;
 	struct nfulnl_msg_packet_hw *hwph;
-	uint32_t mark, ifi;
+	uint32_t mark, ifi, ctid;
 	int size, offset = 0, len = 0, ret;
 	char *data;
 
@@ -1150,6 +1185,13 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
 		SNPRINTF_FAILURE(size, rem, offset, len);
 	}
 
+	ret = nflog_get_ctid(tb, &ctid);
+	if (ret >= 0 && (flags & NFLOG_XML_CTID)) {
+		size = snprintf(buf + offset, rem,
+				"<ctid>%u</ctid>", ctid);
+		SNPRINTF_FAILURE(size, rem, offset, len);
+	}
+
 	ret = nflog_get_payload(tb, &data);
 	if (ret >= 0 && (flags & NFLOG_XML_PAYLOAD)) {
 		int i;
-- 
2.30.2

