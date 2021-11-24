Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2B2C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344168AbhKXW2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbhKXW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF52C06173E
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uJPyc8Um7TiptWK8LwD+zUMbwdgd+J05Ge9aSnvU6xU=; b=LTkPe496+DQ1nJAAOCKM1fTSwu
        Z+nFVK33Sk1rru9ncS3HlAmXn4e0A1FABo5yH+uhw4eYZHvrLZRJDI07LZ5xvtt8AlFClxyOUJE2y
        XC5i7NXdFY2WCwGZmku63DRb2bRYUstWUsr5J1FJRQa6ixGa/ISdQVsXRP3svoYMQxqKEtb5rMl7r
        qzZ0z7q9gqkoPg9M3S2O8vVVDTUD9l/7gWI43Jl1MA3NthokLSqvWj1fe4F1e52glOJu8Q7Zscf/5
        V3iUCqCWrN6SlN15XSbeZ2HEqklWiY9zeewZZgJKy9sGZiaCCx8Fyr/nxtknXedBfrrZ2N+qrOV20
        FJlYnyvg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-9x
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 01/32] jhash: add "fall through" comments to switch cases
Date:   Wed, 24 Nov 2021 22:23:56 +0000
Message-Id: <20211124222444.2597311-2-jeremy@azazel.net>
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

gcc warns about undocumented fall-throughs in switches.  In this case,
the fall-throughs are intended, so add commnts to indicate this to the
compiler.

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

