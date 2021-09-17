Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B40C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2E64610A4
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 22:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbhIQWJN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 18:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244695AbhIQWJH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 18:09:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C52FC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:07:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k23-20020a17090a591700b001976d2db364so8384609pji.2
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 15:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pDmjGEtZpto/d3ZFh6NOiCfQVGfCSzRkeIV3t34tFY4=;
        b=O5IzrNlB+oA7AMnzIjzBZbwpKaqpuH31r6PSGynbXt1okbO3I9ou64KTRvBaoGhfAN
         nHe2pYbO4oMxkeynMsK/gfzRbMD06Fl+eAX9ag8ry5cvyFEgt564XFcPnzhyKr1EFV5k
         C3kb/G+xB64aLveCocKiYH6ggKg4YZXA5UX6voHT6sPJxz9+iLWhlxsxF9uzhfRMaFWl
         sI6jZ2TIB+XjuQamqYF8m+HYAJHH7ZyboTS/360ZQ5etM0bV8dTRQ6vc9xf5WHpylqpm
         KRkm43iRlW6nqGl0Ax9rBX5Y+lnKOIHrmyMUfm4an7KKzTH7C6iSxrLsJctqLdIjsC98
         8dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=pDmjGEtZpto/d3ZFh6NOiCfQVGfCSzRkeIV3t34tFY4=;
        b=ujHi4PfvWa/kjW6xWq65iwhY67K0qxWGNpRmduH9NtVpMi8QTyz46vALIVg6UHJ3OA
         kqIn4PwatYcMw0zgWpfXpjJia1XIsF52GZ3a8ApFtUEqybJbv8V7gpoDHFBRqDXkSBZj
         g0fKuz6JohRLvt6kQXuFAp4MWA8bphTgV213L2C8AUq62a3IPWpWJD88cnEMhojIM3Vq
         LhtZzsu62RN/eqmo03IgL0gA6KKm5H9KZyXFiYdo4GWsU+eFt4y7PzKLwZKmzO0xCKVU
         QiY0StDRXKg8aoDtONe4SJP6EPhh4GLzErofNfF4bUdiu9t0rvX0Q205TK5NVyyMctnf
         0T6g==
X-Gm-Message-State: AOAM533/hNK5+qWvx44lagcIEsg5/XZlYSs5AP6IJBDLOt8QJbD8qU5B
        u66BD5S6B0136PvRYXYHvcbCv5qoktc=
X-Google-Smtp-Source: ABdhPJz2ANSTLi9wvswRWLsHUsXeQ/+uWyzz5jxPvGamROcatQ5ZQQoilVlamzs5KaPN6NTw5qMK2A==
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr14875687pjf.86.1631916464756;
        Fri, 17 Sep 2021 15:07:44 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id 187sm6051179pfg.59.2021.09.17.15.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:07:44 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [RFC PATCH libnetfilter_log] src: support conntrack XML output
Date:   Sat, 18 Sep 2021 07:02:33 +0900
Message-Id: <20210917220232.36907-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch enables to let conntrack information including XML output.
---
 Hi,

I think there are two issues. First, it deals with obsolete libnfnetlink
internal data. The other is that the family of nfgenmsg is not available, so the
ethernet hw protocol type is used. Are these acceptable?
About ethernet type, should I use IP version from payload?

----

 include/libnetfilter_log/libnetfilter_log.h |  4 +++
 src/Makefile.am                             |  5 +++
 src/libnetfilter_log.c                      | 35 +++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 6192fa3..a98a39e 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -82,6 +82,10 @@ enum {
 	NFLOG_XML_PHYSDEV	= (1 << 4),
 	NFLOG_XML_PAYLOAD	= (1 << 5),
 	NFLOG_XML_TIME		= (1 << 6),
+#ifdef BUILD_NFCT
+        NFLOG_XML_CT		= (1 << 7),
+        NFLOG_XML_CT_TIMESTAMP	= (1 << 8),
+#endif
 	NFLOG_XML_ALL		= ~0U,
 };
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 335c393..bc8da41 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -37,3 +37,8 @@ libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles	\
 libnetfilter_log_libipulog_la_LIBADD = libnetfilter_log.la ${LIBNFNETLINK_LIBS}
 libnetfilter_log_libipulog_la_SOURCES = libipulog_compat.c
 endif
+
+if BUILD_NFCT
+libnetfilter_log_la_LDFLAGS += $(LIBNETFILTER_CONNTRACK_LIBS)
+libnetfilter_log_la_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS} -DBUILD_NFCT
+endif
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 567049c..aa97b51 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -33,6 +33,11 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 
+#ifdef BUILD_NFCT
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#endif
+
 /**
  * \mainpage
  *
@@ -907,6 +912,8 @@ do {								\
  *	- NFLOG_XML_PHYSDEV: include the physical device information
  *	- NFLOG_XML_PAYLOAD: include the payload (in hexadecimal)
  *	- NFLOG_XML_TIME: include the timestamp
+ *	- NFLOG_XML_CT: include conntrack entry
+ *	- NFLOG_XML_CT_TIMESTAMP: include conntrack timestamp
  *	- NFLOG_XML_ALL: include all the logging information (all flags set)
  *
  * You can combine this flags with an binary OR.
@@ -1056,6 +1063,34 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
 		SNPRINTF_FAILURE(size, rem, offset, len);
 	}
 
+#ifdef BUILD_NFCT
+        if (flags & NFLOG_XML_CT) {
+                struct nlattr *ctattr = (struct nlattr *)tb->nfa[NFULA_CT - 1];
+                struct nf_conntrack *ct = nfct_new();
+                unsigned int ct_flags = 0;
+                uint8_t family = 0;
+                uint16_t hw_proto = ntohs(ph->hw_protocol);
+
+                if (!ctattr) goto close_tag;
+                if (hw_proto == 0x0800)
+                        family = AF_INET;
+                else if (hw_proto == 0x86dd)
+                        family = AF_INET6;
+                else
+                        goto close_tag;
+
+                if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
+                                       mnl_attr_get_payload_len(ctattr),
+                                       family, ct) < 0)
+                        goto close_tag;
+                if (flags & NFLOG_XML_CT_TIMESTAMP)
+                        ct_flags |= NFCT_OF_TIMESTAMP;
+                size = nfct_snprintf(buf + offset, rem, ct, 0, NFCT_O_XML,
+                                     ct_flags);
+		SNPRINTF_FAILURE(size, rem, offset, len);
+        }
+close_tag:
+#endif
 	size = snprintf(buf + offset, rem, "</log>");
 	SNPRINTF_FAILURE(size, rem, offset, len);
 
-- 
2.30.2

