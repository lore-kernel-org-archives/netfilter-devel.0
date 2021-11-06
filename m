Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1DCAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD79E61165
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbhKFQw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbhKFQwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:50 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36896C06120B
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DXS1W7Szn1gH60MuxyP+Skf8qOtZuhKsbVR+ewNj+4M=; b=MYAZBvdoJHvUQLh2LO+qh/AyN7
        VIb24Oz+lxw6aHmtd/ntuOx05WzV4nnVABPbKyaSHCUrw95bLjzmaH3M9ToEAYQpbSE4LW500hDhi
        Bj+dm1Bu4tO7G6UUEzXRFWXJrLriKAYi4TFuTmWhXbI0at5Co9Mm6GX3/7tpwL1a/A1c3BNbtqaGH
        O9yonF5T8dX2D2SAfNKirs0lIlXfP0RHDoDt3oUw94ZbJ2UqO7IeRbvHB+lF+qAhN6R6QQiVAYnM2
        wIpHDHDtnj8cVf1mtYwLIJylFTg2W1R756mzIRB3I+ICTRzlJLRUrT4R6duS4dn02M9qRF0oW590I
        fkB2xEHQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-NK
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 08/27] filter: HWHDR: replace `switch` with `if`
Date:   Sat,  6 Nov 2021 16:49:34 +0000
Message-Id: <20211106164953.130024-9-jeremy@azazel.net>
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

The `switch` has one case falling through to a default.  Simplify the
flow-control.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 10c95c4e9bb0..d756d35577f0 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -207,19 +207,17 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 		okey_set_u16(&ret[KEY_MAC_TYPE], type);
 	}
 
-	switch (type) {
-		case ARPHRD_ETHER:
-			parse_ethernet(ret, inp);
-		default:
-			if (!pp_is_valid(inp, KEY_RAW_MAC))
-				return ULOGD_IRET_OK;
-			/* convert raw header to string */
-			return parse_mac2str(ret,
-					    ikey_get_ptr(&inp[KEY_RAW_MAC]),
-					    KEY_MAC_ADDR,
-					    ikey_get_u16(&inp[KEY_RAW_MACLEN]));
-	}
-	return ULOGD_IRET_OK;
+	if (type == ARPHRD_ETHER)
+		parse_ethernet(ret, inp);
+
+	if (!pp_is_valid(inp, KEY_RAW_MAC))
+		return ULOGD_IRET_OK;
+
+	/* convert raw header to string */
+	return parse_mac2str(ret,
+			     ikey_get_ptr(&inp[KEY_RAW_MAC]),
+			     KEY_MAC_ADDR,
+			     ikey_get_u16(&inp[KEY_RAW_MACLEN]));
 }
 
 
-- 
2.33.0

