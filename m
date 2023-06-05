Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A27C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 22:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjFEWMG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjFEWMF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 18:12:05 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12817100
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 15:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1cTJV7YaiBDsbB0es013VAzE5PJ0BCLRFs079sx67JU=; b=cL2DXvjKpPqqSCgPAlSG0ixYbq
        4NxgwM40iCffex9nC1AxXlwPJGqNt6VMBW6YWaCwwfxKPJsoh35cA04gLyxW5ON5z7W/CIc6gb9m2
        kwzzl+aqHMYSxgmkoqQ9yvvFQ8VE5pv0fBiUCOmSJQ7pCsAWXj0qoGTVMcV0NaE8/bdteCSDxmSwu
        +6STvQvJ3/KEWiWgRHe01eGE0O0Bs1JnRGFhRqkTc+pa2+H0p3aV5kjTsS1u1Swqe3Inr+lX9AKL5
        LNmDy5riWocILNIXigjchZfYPisCTrzTbJaoNJXPnw0lFcPmEJEjMA86zw5D0DoZP3MdTx3/tcIhc
        jp47esiw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6IQl-00H5Wa-Hl
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 23:12:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 1/7] xt_ipp2p: fix Soulseek false-positive matches
Date:   Mon,  5 Jun 2023 23:10:38 +0100
Message-Id: <20230605221044.140855-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605221044.140855-1-jeremy@azazel.net>
References: <20230605221044.140855-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

According to the comment, the last match attempted is:

  14 00 00 00 01 yy 00 00 00 STRING(YY) 01 00 00 00 00 46|50 00 00 00 00

However, the conditional that inspects the last ten bytes is followed by
a semi-colon, so the printk and return statements are executed regard-
less of what the last ten bytes are.

Remove the semi-colon and only execute the printk and return if the
conditional expression is true.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index d11594b871d1..5bdb7eec40d2 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -448,13 +448,13 @@ search_soul(const unsigned char *payload, const unsigned int plen)
 			const unsigned char *w = payload + 9 + y;
 			if (get_u32(w, 0) == 0x01 &&
 			    (get_u16(w, 4) == 0x4600 ||
-			    get_u16(w, 4) == 0x5000) &&
-			    get_u32(w, 6) == 0x00)
-				;
+			     get_u16(w, 4) == 0x5000) &&
+			    get_u32(w, 6) == 0x00) {
 #ifdef IPP2P_DEBUG_SOUL
-	    		printk(KERN_DEBUG "Soulssek special client command recognized\n");
+				printk(KERN_DEBUG "Soulseek special client command recognized\n");
 #endif
-	    		return IPP2P_SOUL * 100 + 9;
+				return IPP2P_SOUL * 100 + 9;
+			}
 		}
 	}
 	return 0;
-- 
2.39.2

