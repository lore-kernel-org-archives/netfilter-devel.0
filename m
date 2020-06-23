Return-Path: <SRS0=AczV=AE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA46AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DBA20716
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jun 2020 12:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgFWMey (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jun 2020 08:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732557AbgFWMet (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 08:34:49 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E268C061795
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2020 05:34:46 -0700 (PDT)
Received: janet.servers.dxld.at; Tue, 23 Jun 2020 14:34:45 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
Subject: [libnf_ct resend PATCH 7/8] Fix buffer overflow in protocol related snprintf functions
Date:   Tue, 23 Jun 2020 14:34:02 +0200
Message-Id: <20200623123403.31676-8-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623123403.31676-1-dxld@darkboxed.org>
References: <20200623123403.31676-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/conntrack/snprintf_default.c | 12 ++++--------
 src/conntrack/snprintf_xml.c     | 20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index d00c5cb..8e3d41c 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -13,20 +13,16 @@ static int __snprintf_l3protocol(char *buf,
 				 unsigned int len,
 				 const struct nf_conntrack *ct)
 {
-	return (snprintf(buf, len, "%-8s %u ", 
-		l3proto2str[ct->head.orig.l3protonum] == NULL ?
-		"unknown" : l3proto2str[ct->head.orig.l3protonum], 
-		 ct->head.orig.l3protonum));
+        uint8_t num = ct->head.orig.l3protonum;
+	return snprintf(buf, len, "%-8s %u ", __l3proto2str(num), num);
 }
 
 int __snprintf_protocol(char *buf,
 			unsigned int len,
 			const struct nf_conntrack *ct)
 {
-	return (snprintf(buf, len, "%-8s %u ", 
-		proto2str[ct->head.orig.protonum] == NULL ?
-		"unknown" : proto2str[ct->head.orig.protonum], 
-		 ct->head.orig.protonum));
+        uint8_t num = ct->head.orig.protonum;
+	return snprintf(buf, len, "%-8s %u ", __proto2str(num), num);
 }
 
 static int __snprintf_timeout(char *buf,
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index c3a836a..6a9dfb4 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -55,12 +55,28 @@
 
 const char *__proto2str(uint8_t protonum)
 {
-	return proto2str[protonum] ? proto2str[protonum] : "unknown";
+        const char *str = NULL;
+
+        if(protonum < asizeof(proto2str))
+                str = proto2str[protonum];
+
+        if(str == NULL)
+                str = "unknown";
+
+	return str;
 }
 
 const char *__l3proto2str(uint8_t protonum)
 {
-	return l3proto2str[protonum] ? l3proto2str[protonum] : "unknown";
+        const char *str = NULL;
+
+        if(protonum < asizeof(l3proto2str))
+                str = l3proto2str[protonum];
+
+        if(str == NULL)
+                str = "unknown";
+
+	return str;
 }
 
 static int __snprintf_ipv4_xml(char *buf,
-- 
2.20.1

