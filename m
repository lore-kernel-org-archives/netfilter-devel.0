Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E4BC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68ED7611EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhKFQxB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbhKFQwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:50 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84B3C06120D
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7iOccRfWF6c5hJzk9ZN5WdIOm1i/84PJ3S++pQrKPQM=; b=K0Zf0B0VseMPZIoYg0s/StI6CV
        eV2Wv26mF+f+yqYO0U7PnbhCCtu3UVvZzk4kIqnF9YDMjiMboGeksGafIEKkb3/nh0q3u6wrr6jXx
        9V3yYIDuv+hyMWsgh196qgdNaBTMWNW5Sow3bzdEUKr3i7+OC9otIfU/hckfrh0rV22YyuOjOXjH1
        Y2zsarpMre9oZMXjEdybfaSzY0VsM1fW1g8CDS0L8AkHLKOiKKYxQvqoSI7872Xn+iwCvEAbvBT4P
        crlwNKMjBjBb0PZ/7BN5h29a7tuQsVrBz98RF0X/vR8vFXRmuW4cedoVZ4sfKVrGuMtnPYAMUxJob
        n8+6/6wg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtJ-004m1E-Px
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 09/27] filter: HWHDR: re-order KEY_RAW_MAC checks
Date:   Sat,  6 Nov 2021 16:49:35 +0000
Message-Id: <20211106164953.130024-10-jeremy@azazel.net>
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

Currently we have:

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

