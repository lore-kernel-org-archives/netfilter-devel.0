Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4239FC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Dec 2022 12:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLWMi2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 07:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiLWMi0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 07:38:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650F817E23
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2022 04:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FnLX1/NeijDBI+lcJUs8uhMCL8NdQ0P8Lu11UYb/EiA=; b=PbhDc+JA4wgOz8OPvczNrq8FuH
        doZWuBgh6sbHjIvo5V+Z3VFPduhDvzZX5RFFT6Hc2LrjGoL/D74996WUotj6U7WrT1u5DNjm8n4D3
        deJfO8gpfsKrMg/w55P78UB0CkrI0ybwhMiKq+ACTUOOtBtFP0+MiJ8erOQACroaefVk+wNxYKV5E
        faTcD1teGv96P6lbapiV0PhosLiaO3a+OBd2w/qLBkrox0xns2QhFHLLWxJN9w3T44vKoaLNzvE4X
        zHFk0e1jWnkWcN6rml0lM0AobVAkKOpAN4mmyx3Nvba1p6vy/7RkUmnmqtr2+qikSX0QiKVv5xCiY
        uxCyDuDQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p8hJe-005VgK-TF
        for netfilter-devel@vger.kernel.org; Fri, 23 Dec 2022 12:38:22 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_conntrack PATCH] conntrack: increase the length of `l4proto_map`
Date:   Fri, 23 Dec 2022 12:38:06 +0000
Message-Id: <20221223123806.2685611-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With addition of MPTCP `IPPROTO_MAX` is greater than 256, so extend the
array to account for the new upper bound.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/internal/object.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 75ffdbe97229..b919f5784df3 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -6,6 +6,7 @@
 #ifndef _NFCT_OBJECT_H_
 #define _NFCT_OBJECT_H_
 
+#include <internal/bitops.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 /*
@@ -223,12 +224,13 @@ struct nfct_filter {
 	enum nfct_filter_logic 	logic[NFCT_FILTER_MAX];
 
 	/*
-	 * This the layer 4 protocol map for filtering. Not more than 
-	 * 255 protocols (maximum is IPPROTO_MAX which is 256). Actually,
-	 * I doubt that anyone can reach such a limit.
+	 * This the layer 4 protocol map for filtering. Not more than 255
+	 * protocols.  Although IPPROTO_MAX is currently 263, there are many
+	 * fewer protocols defined in netinet/in.h, so no one should reach this
+	 * limit.
 	 */
 #define __FILTER_L4PROTO_MAX	255
-	uint32_t 		l4proto_map[IPPROTO_MAX/32];
+	uint32_t 		l4proto_map[DIV_ROUND_UP(IPPROTO_MAX, 32)];
 	uint32_t		l4proto_len;
 
 	struct {
-- 
2.35.1

