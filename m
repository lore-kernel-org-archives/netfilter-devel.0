Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6DCEE49AF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjHUTnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3883110F
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j6pnHhB1b4PzKZCswkxS7sARXwqw4EeOeyVgyKKFpvg=; b=rBBoh6BW6OPHKzcSQ0vntVqSJR
        v2x+6oIbrcut3TR3YYb55K4Pk4rtJ9iOZV10phzkX2CMGVdAUMgrNP+2gm7MOduFKVlaTN+1QkwZj
        /+f/Geq/DaLJV6xhH81zFrOAkLAQmb0hb7r/9fT2VcbywarIRdyjWF5RYVyPLgabW9HHHZzMVfTla
        m1QfbaxC6YKzBrjEV855U8eN+vXhSIc2i7WuWplOTzvjl34BDPJZiZ1he6VG7UeSeyXPCvqY77IP9
        fbyZjw9dUg4f0k1U6pNJ2GljrFJ3EdVTOQ3NMghsni4XtKUrIGrA/Ah6wb3ob8gkdnOd8aeamzlwO
        GuumdsaA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-2j
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 09/11] sqlite3: correct binding of ipv4 addresses and 64-bit integers
Date:   Mon, 21 Aug 2023 20:42:35 +0100
Message-Id: <20230821194237.51139-10-jeremy@azazel.net>
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

Hitherto we have bound ipv4 addresses as 64-bit ints and 64-bit ints as
32-bit.

Move a `ULOGD_RET_BOOL` case for consistency and fix some nearby
formatting.

Fix some nearby formatting.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 0a9ad67edcff..3a823892a2dd 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -145,6 +145,10 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 		}
 
 		switch (f->key->type) {
+		case ULOGD_RET_BOOL:
+			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.b);
+			break;
+
 		case ULOGD_RET_INT8:
 			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i8);
 			break;
@@ -158,7 +162,7 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 			break;
 
 		case ULOGD_RET_INT64:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.i64);
+			ret = sqlite3_bind_int64(priv->p_stmt, i, k_ret->u.value.i64);
 			break;
 			
 		case ULOGD_RET_UINT8:
@@ -174,17 +178,16 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 			break;
 
 		case ULOGD_RET_IPADDR:
-		case ULOGD_RET_UINT64:
-			ret = sqlite3_bind_int64(priv->p_stmt, i, k_ret->u.value.ui64);
+			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui32);
 			break;
 
-		case ULOGD_RET_BOOL:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.b);
+		case ULOGD_RET_UINT64:
+			ret = sqlite3_bind_int64(priv->p_stmt, i, k_ret->u.value.ui64);
 			break;
 
 		case ULOGD_RET_STRING:
 			ret = sqlite3_bind_text(priv->p_stmt, i, k_ret->u.value.ptr,
-									strlen(k_ret->u.value.ptr), SQLITE_STATIC);
+						strlen(k_ret->u.value.ptr), SQLITE_STATIC);
 			break;
 
 		default:
-- 
2.40.1

