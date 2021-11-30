Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D97C43217
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbhK3K73 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbhK3K70 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99801C061748
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uJPyc8Um7TiptWK8LwD+zUMbwdgd+J05Ge9aSnvU6xU=; b=HhmC4UW5Wi1pXHwsYVezG3bbII
        7U3vdn19fSPlMRnRu3R/6d7Jj9QLxC65UL/ilckSn8eBH2O6KXoSSGXQ/F9pNrGXtr1fpjPDjfmjX
        0wrxu+hePGsxUlFeAlr0glrYqpcZYqNWOV0GvzE8RTfxHmuGaH3NzsWMbvickv6/HISO3xF9stM2C
        f+b+1LrJIRY1LaQAlGFmgMysDdGWQPk1RcRZHmeMKcAJEPasSPdebcJGgRFnkaZZ1c5+OQ7+cgL+I
        I5Ti+2X3IjBRfPpgCgjU9imiZ+uXuw4piDvBcPofgFLm4khluuKMD/FSpJiVFphmBL5+Io0mi+M2E
        Z/XVW8ZA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-2Y
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 01/32] jhash: add "fall through" comments to switch cases
Date:   Tue, 30 Nov 2021 10:55:29 +0000
Message-Id: <20211130105600.3103609-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
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

