Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CCDC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbhKXWst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhKXWst (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:49 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LIB1Y5NShiZoXG+gz4+Wf1m9shwTYx851IbuJyvlwXU=; b=PcBO3aMgvgcGQbSLmRoJpf/jEV
        515RPFqxOS3+WG63z+KcK9GCCtq/lRYcr5/S8UdM8wHcoxdwp4VAr9ceIt74hcxMhko3IZAeBFPb8
        BfxdIBO9NlGS3NisUGbeorx4WxV9+tVTt2Kxvc0dXAQ1XA8wusPMIH6+ILjNOcYUgLdErigXF/OWD
        YsA+kSp3j+kCnbsXJ93ZdB4a3pjt6fyCPIjG0kTezzjNfMgyZ03bEIHXNN+zmCQ3C3KaDHSDJ5gn2
        LnxMTtHvIrcLi+l44Yb7cHn2CoDRG7chZKAqX3Qv2a7cmrgfhxdVxW2VYENaIG1wayUlphHGS62C7
        /qozryHg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hB-00563U-FY
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 32/32] output: IPFIX: remove compiler attribute macros
Date:   Wed, 24 Nov 2021 22:24:44 +0000
Message-Id: <20211124222444.2597311-50-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ipfix.h header includes three macros which expand to compiler attributes.
Presumably, at some point the definitions were one branch of an if-else
preprocessor conditional where the definitions in the other branch expanded to
nothing.  This is no longer the case.  Only one of the macros (`__packed`) is
used and the raw attribute is used elsewhere in the code-base.  Remove the
macros.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/ulogd.h | 5 -----
 output/ipfix/ipfix.c  | 2 --
 output/ipfix/ipfix.h  | 8 ++++----
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index a487c8e70e37..092d9f521a70 100644
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

