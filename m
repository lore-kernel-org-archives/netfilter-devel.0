Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDDAC4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344345AbhKXW2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344012AbhKXW2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B39C061756
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qG8L8Mz7JLP3xS5Tn6TAobOp5tmrRkR2gASclGI5iPE=; b=X531SRrLyXXV6T48NLf/7+xqkE
        oaTKVPEkmoljDUIG1Miq8W2lAS7+DdTHDdNsdM/KrCPbSQvzl/Harip4VDcJQTDY2PiExeunBJsS1
        c5gYR9qV6HXVzeLSzdnMXko00owhpxS3Hkehc33prZ/uLUdk9002lM+rOjci94VQQ0Xjp3AkfF0hN
        dpRyZT0TgAG89ZYEiQpkInsoTXmSGwviiUHOzxcRSNjYNYUWNVSnPob5tfi42eDNZkK4aB6hyYGkF
        r5TEKKqruNU2eufBCmtNtS5yafhusjgpnPSK3MdqGcGfOGF9cbTQLzUb3juGjCgeYhY8Clgl6sCxs
        dvuxzHCQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-Id
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 04/32] filter: HWHDR: re-order KEY_RAW_MAC checks
Date:   Wed, 24 Nov 2021 22:23:59 +0000
Message-Id: <20211124222444.2597311-5-jeremy@azazel.net>
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

Currently, in `interp_mac2str` we have:

  if (/* KEY_RAW_MAC is valid */) {
    /*
     * set mac type
     */
  }

  if (/* mac type is ethernet */)
    // parse ethernet

  if (/* KEY_RAW_MAC is not valid */)
    // return early.

The MAC type will not be set to ethernet unless KEY_RAW_MAC is valid,
so we can move the last check up and drop the first one:

  if (/* KEY_RAW_MAC is not valid */)
    // return early.

  /*
   * set mac type
   */

  if (/* mac type is ethernet */)
    // parse ethernet

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index d756d35577f0..015121511b08 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -191,28 +191,26 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 		okey_set_u16(&ret[KEY_MAC_TYPE], ARPHRD_VOID);
 	}
 
-	if (pp_is_valid(inp, KEY_RAW_MAC)) {
-		if (! pp_is_valid(inp, KEY_RAW_MACLEN))
-			return ULOGD_IRET_ERR;
-		if (pp_is_valid(inp, KEY_RAW_TYPE)) {
-			/* NFLOG with Linux >= 2.6.27 case */
-			type = ikey_get_u16(&inp[KEY_RAW_TYPE]);
-		} else {
-			/* ULOG case, treat ethernet encapsulation */
-			if (ikey_get_u16(&inp[KEY_RAW_MACLEN]) == ETH_HLEN)
-				type = ARPHRD_ETHER;
-			else
-				type = ARPHRD_VOID;
-		}
-		okey_set_u16(&ret[KEY_MAC_TYPE], type);
-	}
+	if (!pp_is_valid(inp, KEY_RAW_MAC))
+		return ULOGD_IRET_OK;
+
+	if (!pp_is_valid(inp, KEY_RAW_MACLEN))
+		return ULOGD_IRET_ERR;
+
+	if (pp_is_valid(inp, KEY_RAW_TYPE))
+		/* NFLOG with Linux >= 2.6.27 case */
+		type = ikey_get_u16(&inp[KEY_RAW_TYPE]);
+	else if (ikey_get_u16(&inp[KEY_RAW_MACLEN]) == ETH_HLEN)
+		/* ULOG case, treat ethernet encapsulation */
+		type = ARPHRD_ETHER;
+	else
+		type = ARPHRD_VOID;
+
+	okey_set_u16(&ret[KEY_MAC_TYPE], type);
 
 	if (type == ARPHRD_ETHER)
 		parse_ethernet(ret, inp);
 
-	if (!pp_is_valid(inp, KEY_RAW_MAC))
-		return ULOGD_IRET_OK;
-
 	/* convert raw header to string */
 	return parse_mac2str(ret,
 			     ikey_get_ptr(&inp[KEY_RAW_MAC]),
-- 
2.33.0

