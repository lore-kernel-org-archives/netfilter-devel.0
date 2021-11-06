Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0213C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BEC61056
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhKFQxA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbhKFQwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:50 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E6C06120A
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gg/nhjW9y7NO5fIUwewAAmhG9JuymfPcRYUnrZ8P1I8=; b=HHGWykwzmG6oOIw1MLpSoR1Srr
        4ON8EsuN+wCRph6RrncOMz/OvkRe6nq64KW4j1NpjSkrQTU+XYRuFjOe6ysyQ/luDZjduagHT/COb
        UTSdxsGYkiRL8DeH902PSpVzmJJPO2bfqMA9oNAQpFenn2Pir5z7pdm+l609lfVJgvcAmQAfhowD9
        bbC3nAGK9Za9Th0k+c/t/H38fBxRgQiUmUL17EC76nwLhat5hbgQIfiKBVCisSJn7wY1SzuLJrYo/
        mGn7axA5mFDYgmZNGEu/w00cpaBKSN9gQZgtZRpfEwhUddk40uPETtmMVljTt86HVbapY3LdIkLEI
        KKVPo//Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-HQ
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 06/27] jhash: add "fall through" comments to switch cases
Date:   Sat,  6 Nov 2021 16:49:32 +0000
Message-Id: <20211106164953.130024-7-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/jhash.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/ulogd/jhash.h b/include/ulogd/jhash.h
index 38b87801a795..e5ca287e7e58 100644
--- a/include/ulogd/jhash.h
+++ b/include/ulogd/jhash.h
@@ -66,18 +66,18 @@ static inline u32 jhash(const void *key, u32 length, u32 initval)
 
 	c += length;
 	switch (len) {
-	case 11: c += ((u32)k[10]<<24);
-	case 10: c += ((u32)k[9]<<16);
-	case 9 : c += ((u32)k[8]<<8);
-	case 8 : b += ((u32)k[7]<<24);
-	case 7 : b += ((u32)k[6]<<16);
-	case 6 : b += ((u32)k[5]<<8);
-	case 5 : b += k[4];
-	case 4 : a += ((u32)k[3]<<24);
-	case 3 : a += ((u32)k[2]<<16);
-	case 2 : a += ((u32)k[1]<<8);
-	case 1 : a += k[0];
-	};
+	case 11: c += ((u32)k[10]<<24);	// fall through
+	case 10: c += ((u32)k[9]<<16);	// fall through
+	case 9 : c += ((u32)k[8]<<8);	// fall through
+	case 8 : b += ((u32)k[7]<<24);	// fall through
+	case 7 : b += ((u32)k[6]<<16);	// fall through
+	case 6 : b += ((u32)k[5]<<8);	// fall through
+	case 5 : b += k[4];		// fall through
+	case 4 : a += ((u32)k[3]<<24);	// fall through
+	case 3 : a += ((u32)k[2]<<16);	// fall through
+	case 2 : a += ((u32)k[1]<<8);	// fall through
+	case 1 : a += k[0];		// fall through
+	}
 
 	__jhash_mix(a,b,c);
 
-- 
2.33.0

