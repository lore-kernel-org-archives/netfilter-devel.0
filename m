Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69174C43217
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343984AbhKXW2H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344084AbhKXW2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEE4C061758
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X7t6qzt0h2nvMcKH4tuvSFbzWyUx2mABGHa9D3wJbcU=; b=fy8y/mUFJLsmYCdngE4ItBBkA6
        507xnTHE1MGF0hz/0jcFbON454aavcxw0sqho04I3XZ7kdg8kEzcOvlmUsfnfiFhJ/ImB8cW5JHPW
        +bm02ovRIncPPGIXxYs4YOdb0/dHy+56z5IOUWtETylk8FIkHXqR7LHr4JVyAmktCrugakvnWd9v1
        b+CIw2x1Fkr2fivB/S/3jju8JC5H08V+ETCKnCDcp3AMt/YsLiU6pXB2JBtkgt3T/r+v40ICLyI5G
        xBvpfisIwzkDP+4rlbUxpgTLRhdXeCkdok7nxArI8JIIS9NB4nZWsO/0FSAECYqw3e75E9pk0+wEG
        uoi0J9Og==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-Se
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 07/32] filter: PWSNIFF: replace malloc+strncpy with strndup
Date:   Wed, 24 Nov 2021 22:24:02 +0000
Message-Id: <20211124222444.2597311-8-jeremy@azazel.net>
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

There are a couple of instances of allocating memory with `malloc`,
followed by copying a string to it with `strncpy` and adding an explicit
assignment of `\0` to terminate the string.  Replace them with
`strndup`.

Add an enum to name indices of output keys.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_PWSNIFF.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 934ff0e09c4f..ef9e02115d84 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -35,10 +35,14 @@
 #define DEBUGP(format, args...)
 #endif
 
-
 #define PORT_POP3	110
 #define PORT_FTP	21
 
+enum pwsniff_output_keys {
+	PWSNIFF_OUT_KEY_USER,
+	PWSNIFF_OUT_KEY_PASS,
+};
+
 static uint16_t pwsniff_ports[] = {
 	PORT_POP3,
 	PORT_FTP,
@@ -116,21 +120,17 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 
 	if (len) {
 		char *ptr;
-		ptr = (char *) malloc(len+1);
+		ptr = strndup((char *)begp, len);
 		if (!ptr)
 			return ULOGD_IRET_ERR;
-		strncpy(ptr, (char *)begp, len);
-		ptr[len] = '\0';
-		okey_set_ptr(&ret[0], ptr);
+		okey_set_ptr(&ret[PWSNIFF_OUT_KEY_USER], ptr);
 	}
 	if (pw_len) {
 		char *ptr;
-		ptr = (char *) malloc(pw_len+1);
+		ptr = strndup((char *)pw_begp, pw_len);
 		if (!ptr)
 			return ULOGD_IRET_ERR;
-		strncpy(ptr, (char *)pw_begp, pw_len);
-		ptr[pw_len] = '\0';
-		okey_set_ptr(&ret[1], ptr);
+		okey_set_ptr(&ret[PWSNIFF_OUT_KEY_PASS], ptr);
 	}
 	return ULOGD_IRET_OK;
 }
-- 
2.33.0

