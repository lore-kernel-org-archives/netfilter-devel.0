Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265EFC7EE24
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjFETUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbjFETTv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:51 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5331702
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nYuY1ihBvSji0HCIpSK5PJx4FHWv/wqhbesM3GboJGE=; b=GL+z/mItEEUSjxt8Fu78gQ5N3l
        RrHtVHOxCYkCWAAg2OEd1hgqXxmnZb66tyTG2mkRJLPlVIpeNxQsuDif0Iz4bU++4O32JaoEWxIX/
        c4Afb5G0sro+gMQrlh2QYOZS6UkE4xQ9sbtzllW1DNp4shp92iwx7L0YSEKQHD4j54fT6qonjZeG2
        l29i+ZZ5cCMZw9YoqX71up9ML1mJ71Or43Jt3dc5dsiUz5o7L3w60IZgMS4/FDvxUsxUOzBSsH6LO
        oY9k58k1KUdLkNLXSNFEnEclyZTIypr/KUgQmR/OlMaFq51EoKbMQRMMOiswogdk4h7fCOq2GP12f
        HNDgxZKw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-48
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/8] xt_ipp2p: fix Soulseek false-positive matches
Date:   Mon,  5 Jun 2023 20:17:29 +0100
Message-Id: <20230605191735.119210-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605191735.119210-1-jeremy@azazel.net>
References: <20230605191735.119210-1-jeremy@azazel.net>
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
index a90d1b3d57c8..5f7d5f61b96e 100644
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

