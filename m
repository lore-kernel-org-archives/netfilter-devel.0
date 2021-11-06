Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC250C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C8D61360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhKFRRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbhKFRRj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:39 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF7FC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fza79Yb0eHuEH4QbRSYeYTaAWoRq/EIY7MYjHgW10UE=; b=WHxK2xSf9gIfgZdb8WchMtUXLZ
        NSufCtZJICuGtdbWACGrzU4F2n/+VNQidKs5MSk+gdLQsU3wZg7Py38qUiXE+RJ6QoNGmnH3xFt+y
        GJ0LF6rdAMz1Zycsgkxaipx0GFkLPMrl5JPOAR3z/8sIkgIW/DVR9Vg9HY+ToJNFPhPmdCl65QrkY
        mmivfE9tceLaO/V6NpAXj7WIFJ6obz0ppP8Ecb1AzuShcANf3GjcFzFdXD7KhpAKs5Wf2tJWNlfKN
        LQ7huXwLAAAqEzYkhTGXTq49zVQmQUmZnqW93JSp13+JxifRGrZ4c8cYeUaftyViLv3QlNxzHOwr/
        jbVd3WwA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtL-004m1E-QA
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 27/27] output: IPFIX: remove attribute macros
Date:   Sat,  6 Nov 2021 16:49:53 +0000
Message-Id: <20211106164953.130024-28-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only one of the macros (`__packed`) is used and the raw attribute is used
elsewhere in the code-base.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/ulogd.h | 5 -----
 output/ipfix/ipfix.c  | 2 --
 output/ipfix/ipfix.h  | 8 ++++----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 09f4a09cc56e..3956f5f656ec 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -28,11 +28,6 @@
 
 /* types without length */
 #define ULOGD_RET_NONE		0x0000
-#define __packed		__attribute__((packed))
-#define __noreturn		__attribute__((noreturn))
-#define __cold			__attribute__((cold))
-
-#define __packed		__attribute__((packed))
 
 #define ULOGD_RET_INT8		0x0001
 #define ULOGD_RET_INT16		0x0002
diff --git a/output/ipfix/ipfix.c b/output/ipfix/ipfix.c
index b2719fd1d8a3..e0b3440e1d1a 100644
--- a/output/ipfix/ipfix.c
+++ b/output/ipfix/ipfix.c
@@ -8,8 +8,6 @@
 /* These forward declarations are needed since ulogd.h doesn't like to be the first */
 #include <ulogd/linuxlist.h>
 
-#define __packed		__attribute__((packed))
-
 #include "ipfix.h"
 
 #include <ulogd/ulogd.h>
diff --git a/output/ipfix/ipfix.h b/output/ipfix/ipfix.h
index 93945fbd562b..b0f3ae64740f 100644
--- a/output/ipfix/ipfix.h
+++ b/output/ipfix/ipfix.h
@@ -19,7 +19,7 @@ struct ipfix_hdr {
 	uint32_t seqno;
 	uint32_t oid;				/* Observation Domain ID */
 	uint8_t data[];
-} __packed;
+} __attribute__((packed));
 
 #define IPFIX_HDRLEN		sizeof(struct ipfix_hdr)
 
@@ -32,7 +32,7 @@ struct ipfix_templ_hdr {
 	uint16_t tid;
 	uint16_t cnt;
 	uint8_t data[];
-} __packed;
+} __attribute__((packed));
 
 #define IPFIX_TEMPL_HDRLEN(nfields)	sizeof(struct ipfix_templ_hdr) + (sizeof(uint16_t) * 2 * nfields)
 
@@ -42,7 +42,7 @@ struct ipfix_set_hdr {
 	uint16_t id;
 	uint16_t len;
 	uint8_t data[];
-} __packed;
+} __attribute__((packed));
 
 #define IPFIX_SET_HDRLEN		sizeof(struct ipfix_set_hdr)
 
@@ -67,7 +67,7 @@ struct vy_ipfix_data {
 	uint16_t dport;
 	uint8_t l4_proto;
 	uint32_t aid;				/* Application ID */
-} __packed;
+} __attribute__((packed));
 
 #define VY_IPFIX_SID		256
 
-- 
2.33.0

