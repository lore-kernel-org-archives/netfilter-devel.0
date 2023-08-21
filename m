Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C33EE49B1
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjHUTnL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F4F10B
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oQDue8zyDolGI9XhEATRWpIVTGX6wrP0RuXSx/UrrpI=; b=EgfFdq52D9Iu2J4M19CFeaWnoa
        0lQzi0pgGJFqtqw+JXzOxTNrW8RuJ6+CUU9Cz7C/nwaiut+e6zld7BJkzJQF1wtCeijuRZGq7hrv4
        +44ZhItdOJfSLFl49mGcDgulOPmJtvJc/Iy0A1Kh/QZbp5utvEgl8TJuUWfo7qOg5XvGZXlMZtp/M
        DeKcOhf3HqksSVcrgoD9AZV11R7dzmqmZhlQMhLouuDzW4Biyo2hO7Wf4WBgV8xvjgQfy81PnlMCA
        TvQqwOuDX7o7PJWzdqUR6tWVNlY4R5HO9DITYaF3yHW/Rr51XSa72KhjEMRM8qxbYPTqXScc9kJ1t
        LCmVrVlA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-2Z
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 08/11] gprint, oprint: add support for printing ipv6 addresses
Date:   Mon, 21 Aug 2023 20:42:34 +0100
Message-Id: <20230821194237.51139-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821194237.51139-1-jeremy@azazel.net>
References: <20230821194237.51139-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_GPRINT.c | 16 ++++++++++++++--
 output/ulogd_output_OPRINT.c | 21 ++++++++++++++++-----
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 093d3ea2b254..37829fa49e9d 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -155,7 +155,10 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
 			size += ret;
 			break;
 		case ULOGD_RET_IPADDR: {
+			struct in6_addr ipv6addr;
 			struct in_addr ipv4addr;
+			int family;
+			void *addr;
 
 			ret = snprintf(buf+size, rem, "%s=", key->name);
 			if (ret < 0)
@@ -163,8 +166,17 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
 			rem -= ret;
 			size += ret;
 
-			ipv4addr.s_addr = key->u.value.ui32;
-			if (!inet_ntop(AF_INET, &ipv4addr, buf + size, rem))
+			if (key->len == sizeof(ipv6addr)) {
+				memcpy(ipv6addr.s6_addr, key->u.value.ui128,
+				       sizeof(ipv6addr.s6_addr));
+				addr = &ipv6addr;
+				family = AF_INET6;
+			} else {
+				ipv4addr.s_addr = key->u.value.ui32;
+				addr = &ipv4addr;
+				family = AF_INET;
+			}
+			if (!inet_ntop(family, addr, buf + size, rem))
 				break;
 			ret = strlen(buf + size);
 
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index b5586e850aa4..13934ff19efb 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -76,12 +76,23 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 			fprintf(opi->of, "%" PRIu64 "\n", ret->u.value.ui64);
 			break;
 		case ULOGD_RET_IPADDR: {
-			char addrbuf[INET_ADDRSTRLEN + 1] = "";
+			char addrbuf[INET6_ADDRSTRLEN + 1] = "";
+			struct in6_addr ipv6addr;
 			struct in_addr ipv4addr;
-
-			ipv4addr.s_addr = ret->u.value.ui32;
-			if (!inet_ntop(AF_INET, &ipv4addr, addrbuf,
-				       sizeof(addrbuf)))
+			int family;
+			void *addr;
+
+			if (ret->len == sizeof(ipv6addr)) {
+				memcpy(ipv6addr.s6_addr, ret->u.value.ui128,
+				       sizeof(ipv6addr.s6_addr));
+				addr = &ipv6addr;
+				family = AF_INET6;
+			} else {
+				ipv4addr.s_addr = ret->u.value.ui32;
+				addr = &ipv4addr;
+				family = AF_INET;
+			}
+			if (!inet_ntop(family, addr, addrbuf, sizeof(addrbuf)))
 				break;
 
 			fprintf(opi->of, "%s\n", addrbuf);
-- 
2.40.1

