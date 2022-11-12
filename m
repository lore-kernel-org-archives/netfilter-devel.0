Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15980C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiKLAVU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiKLAVT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945C31F620
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GM1egIFVtEJ3lByNK01gDn13O0XsDv0n/Jl5ZKaEDJA=; b=N8OsDmkWoksU2O5T4DAjk46Xui
        xvvPuETyHvAoTcJfixNtm6vrVx/wXJ5Y8m8TbfcVDXRwpWCnCLeWDqhhYxxvEkovBaUBAKlNR3qfr
        lN3CGqXs+BPCF32ii5s3yLMlHGg05KsWExHrnqNo3vXZB+l09cEDu9wJl0DsgeuJcjRvujm2Z8G0K
        lbdhWVLdjMGWyD/DUa7fVN3596L2adzv5ZyWzgp1tab+J6Kx8L7/xhBnbbCx3mzTwc1hcOMbESNvR
        yhUGUwBpb0uiXQaPpbLFH4+McgrgDjyApDz+SvXmVfl+MhERmv0p0w7kdplO67T7j8FSFTos0lnsN
        /5kN53Qw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteGp-00022e-UA
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:16 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/7] extensions: libebt_ip: Include kernel header
Date:   Sat, 12 Nov 2022 01:20:53 +0100
Message-Id: <20221112002056.31917-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update the local copy of linux/netfilter_bridge/ebt_ip.h and include it
instead of keeping the local copy of struct ebt_ip_info et al.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c                  | 32 +------------------------
 include/linux/netfilter_bridge/ebt_ip.h | 15 +++++++++---
 2 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 51649ffb3c305..8413a5aa8dd57 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -20,40 +20,10 @@
 #include <netdb.h>
 #include <inttypes.h>
 #include <xtables.h>
+#include <linux/netfilter_bridge/ebt_ip.h>
 
 #include "libxt_icmp.h"
 
-#define EBT_IP_SOURCE 0x01
-#define EBT_IP_DEST 0x02
-#define EBT_IP_TOS 0x04
-#define EBT_IP_PROTO 0x08
-#define EBT_IP_SPORT 0x10
-#define EBT_IP_DPORT 0x20
-#define EBT_IP_ICMP 0x40
-#define EBT_IP_IGMP 0x80
-#define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
-		     EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP | EBT_IP_IGMP)
-
-struct ebt_ip_info {
-	__be32 saddr;
-	__be32 daddr;
-	__be32 smsk;
-	__be32 dmsk;
-	__u8  tos;
-	__u8  protocol;
-	__u8  bitmask;
-	__u8  invflags;
-	union {
-		__u16 sport[2];
-		__u8 icmp_type[2];
-		__u8 igmp_type[2];
-	};
-	union {
-		__u16 dport[2];
-		__u8 icmp_code[2];
-	};
-};
-
 #define IP_SOURCE	'1'
 #define IP_DEST		'2'
 #define IP_EBT_TOS	'3' /* include/bits/in.h seems to already define IP_TOS */
diff --git a/include/linux/netfilter_bridge/ebt_ip.h b/include/linux/netfilter_bridge/ebt_ip.h
index c4bbc41b0ea47..ae5d4d1084188 100644
--- a/include/linux/netfilter_bridge/ebt_ip.h
+++ b/include/linux/netfilter_bridge/ebt_ip.h
@@ -23,8 +23,10 @@
 #define EBT_IP_PROTO 0x08
 #define EBT_IP_SPORT 0x10
 #define EBT_IP_DPORT 0x20
+#define EBT_IP_ICMP 0x40
+#define EBT_IP_IGMP 0x80
 #define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
- EBT_IP_SPORT | EBT_IP_DPORT )
+		     EBT_IP_SPORT | EBT_IP_DPORT | EBT_IP_ICMP | EBT_IP_IGMP)
 #define EBT_IP_MATCH "ip"
 
 /* the same values are used for the invflags */
@@ -37,8 +39,15 @@ struct ebt_ip_info {
 	__u8  protocol;
 	__u8  bitmask;
 	__u8  invflags;
-	__u16 sport[2];
-	__u16 dport[2];
+	union {
+		__u16 sport[2];
+		__u8 icmp_type[2];
+		__u8 igmp_type[2];
+	};
+	union {
+		__u16 dport[2];
+		__u8 icmp_code[2];
+	};
 };
 
 #endif
-- 
2.38.0

