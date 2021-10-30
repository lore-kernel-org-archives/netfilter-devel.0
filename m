Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753C5C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF8C60FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhJ3QrJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1871C061205
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7iOccRfWF6c5hJzk9ZN5WdIOm1i/84PJ3S++pQrKPQM=; b=gh1C2gNjJ2xpBdVL05d8bM4pig
        FSKgg6P0OSsGTqU2iA6yOEjHClPwQHV5poBaAtsd2xdyZvK+/B0vKFV12iE8XKyeiqOsr2GGarTvc
        H1J9AWiL6pou3Uu5TYbvTT+GufAtxZXdQD+XOWxB7Ei/sB30AZm5jnio8pQ2Ikkqz+wr2XzttK0nn
        dtfs77bzYCCFl2nYHVwceyHTkKy3PmMWxOxnu6auagKObJjyBYRJJgamoVv768U9j1vc4WoON+eRE
        8uMGPlWuLKZLvo+oadT+o0VJA2tyknvJmh6WT9jLBj6ShDq3O1w6Wm7ECj3rT0HNDfnh9yIkv/+gt
        Uu7pMqiA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-Uh
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 09/26] filter: HWHDR: re-order KEY_RAW_MAC checks.
Date:   Sat, 30 Oct 2021 17:44:15 +0100
Message-Id: <20211030164432.1140896-10-jeremy@azazel.net>
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

