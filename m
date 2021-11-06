Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76895C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5655861361
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhKFRR2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhKFRR0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2EC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hGC4RrcXVMRSlx6XwMiAmpFlBpeII/ByhEuLzr8rA/k=; b=GEelzXnliyANwEedVGBrmgO8Rz
        o4ohdYb+TTN5Iijzn8XuwDSJBTOVafuN7cZ0Ipoi6CGh4uZHm4HUr96z7g1TaDTwYZS3yN8Zpkn14
        Uyh+ikuoNE+T3MMFZKkFNProNllItvjxPRTLPZAC8AO2k9Aj7rBBoFw3fLl4gVwbtcCTMEf0m4XtV
        AaaL/yaSFeT1RN+TPYmgax3L++K/Iyj6H8n6Mba5NK3xBBmLcED3dN+e553GYSLxVKfMCll9/gWzF
        pF7LAM145DpQRLQKFeC5VXnqUehmMJyvJvhq1K96q2SCJTRiDBz/JZnQZWr+KrOhdAfbN8JAZ/bnm
        8xiLzkDQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-31
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 12/27] filter: PWSNIFF: replace malloc+strncpy with strndup
Date:   Sat,  6 Nov 2021 16:49:38 +0000
Message-Id: <20211106164953.130024-13-jeremy@azazel.net>
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

