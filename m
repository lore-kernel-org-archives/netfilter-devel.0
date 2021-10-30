Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4414EC4321E
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEEE60FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhJ3QrJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21E0C0613B9
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DXS1W7Szn1gH60MuxyP+Skf8qOtZuhKsbVR+ewNj+4M=; b=WTjdV3EGfwBFFE0HIvX8y1QoX4
        F3gnsfivLORNF4w8RpJGgLKOIacNwqcbp3bxXuKQYZyOsopV5z8CtORGfv4V85pryAXhT21uhZZSH
        ZMb4DSCBc87ooWlf6RsmoKfT7mzKbMSd+qVICL+yML+UBf0hVoe9t7dFeIrmafIdcLTOYc79pTzLP
        uqKCLYFSSeLpBuh0+43ViwYxHqxj8MEmPZ4COMNpdDNo4msI6cyO1u7u4VKtxIh+Hl6J4w5F4PFMu
        dAnfgbhYuVIyuR+X0QBKMd35fj9En9dHI6dEj1Dp9il4booSmEl5sdLLUA78PyizPDcGUmaiRT1DV
        BX/KGqcA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-SC
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 08/26] filter: HWHDR: replace `switch` with `if`.
Date:   Sat, 30 Oct 2021 17:44:14 +0100
Message-Id: <20211030164432.1140896-9-jeremy@azazel.net>
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

