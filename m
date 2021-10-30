Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4429AC4167D
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFD060F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhJ3QrK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97477C0613F5
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gg/nhjW9y7NO5fIUwewAAmhG9JuymfPcRYUnrZ8P1I8=; b=FhAXa0pvmic6gL5r1U1urgIaL+
        rykvJoB6Z5ex122ZBc4XwNZsGlrKtus0WU816uspqcWOJSxzxmOCOdRYpSj9SDyohCe5fDv8CKyAT
        PjKRdhBJ2fEQxzXeMHWUlY/fCVpER1nfhqoWVeyatFta/uOeAU15aPhO+rT1U3UacOfLn2ap1wiOX
        xvCap3Ua3XyisMrOUonPdiBkzZI80HYRi+92W8SAcSn+XTX+nOsaGzGdFtq4wi+OBQFTny/JIGGim
        Ar6LRly6y2witfELtM/hY81LPjngIC96lj3g9m+/f0GqJewW3BGwdYIVOF7cgfD00E6dECH3VAfZ5
        nVUwWVyA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-MM
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 06/26] jhash: add "fall through" comments to switch cases.
Date:   Sat, 30 Oct 2021 17:44:12 +0100
Message-Id: <20211030164432.1140896-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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

