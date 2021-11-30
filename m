Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0331BC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhK3K72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbhK3K70 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99837C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s4uihXR8SLCY9oUFCpw68HCOYp4JfyKXWeofmfGLfZQ=; b=BZZuyWT9OPy23vLtVV/rPguHbs
        8w35KqfRw7TBrIrAjfFKp+qQ/ftvdmSF3UIaW/NXDjz8LFwAFwkVOHh52iheSQJCUqQlvv8lzkHSA
        Vr2ha/badWHFd4LPWqD/xowYXHu1hfLNrxPHFZaabm5Tc+KQn/kMcFD56YKnptKiepI/VBgzPqU9X
        ZU1LLKoS7Ep/QfXQfuf4fuirgyB1NF/usmzOD+jo614g/h6jBZckKf9EzB25Fz9K+AzgO1Jo4/mWD
        g7Q9fcFkdoKv0KjOOXHh1cVE6x2pLegpvA2shTo8RSFnT+8boheS+wyWOLYa4+B87e9gfv9b0UFyF
        ZDZccXXg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-7Q
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 03/32] filter: HWHDR: simplify flow-control
Date:   Tue, 30 Nov 2021 10:55:31 +0000
Message-Id: <20211130105600.3103609-4-jeremy@azazel.net>
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

