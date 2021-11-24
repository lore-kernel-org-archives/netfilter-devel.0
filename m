Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E35BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343906AbhKXW2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343961AbhKXW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E2C061746
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s4uihXR8SLCY9oUFCpw68HCOYp4JfyKXWeofmfGLfZQ=; b=QnHvUYUAvDhSmqYUR3l0UTEVS6
        goVdvyeJEjiYDcOSSzx2Kqqb9AYQgQccpdPubY1izf0wzXlXURhAe7Pj5d3cKW+LLGqPY1tOLjHcq
        jsxWwHHuLQn0MpMU3OVfOzinkfoA2JBOWFdk6C7bBPrulrJYOt+bc/RCITwBPCuMQdGd+JRXqtMvU
        678kwJCWi0Tzpr9Wq3H2/umB20Fu6v/cpO9FlQMFTbHoKARaSTFyFFDaer9myEVyCLlxq12KRLw15
        KlLidfUI18Lu8nkGwvdCHuv//q70QF+hzBoP4JReMfdy7Gt7VS+2hhNIFhMscJCw++saaJPSisPJn
        A1a9eDEg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-GB
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 03/32] filter: HWHDR: simplify flow-control
Date:   Wed, 24 Nov 2021 22:23:58 +0000
Message-Id: <20211124222444.2597311-4-jeremy@azazel.net>
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

The `interp_mac2str` function concludes with a `switch` followed by a
`return` statement.

The `switch` has one case falling through to a default:

  switch (expr) {
  case X:
    // ... X code ...
  default:
    // ... default code ...
  }

This is equivalent to the simpler and more readily comprehensible:

  if (expr == X) {
    // ... X code ...
  }
  // ... default code ...

Replace the former with the latter.

Doing so makes it obvious that the following `return` statement is never
reached.  Remove it.

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

