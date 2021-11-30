Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58783C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbhK3K7b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbhK3K71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:27 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD89C061758
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X7t6qzt0h2nvMcKH4tuvSFbzWyUx2mABGHa9D3wJbcU=; b=JN9P1aOXSeQIC/HcFeTXW5HmsX
        z99wj76z1FVqPwSuXGKNaxlwyjGQd01VJioyJzkHThLr0XYMd9GPK1gXR44hkZpQJhYcA9XnTGpjU
        tRlCAUruPJlHTGYPoIbNVUnxiIBW95IJlbNDkfQUEJWT1uYF+3WmbidBEJWXQXHi3rLTWGwQZtk80
        DBwjVl1+y0zhbMYmIUFgbija44lv4WxeC0aSCGSrT5Ygv/WFJvip+a9GJgsPE50ba0nl/719CU4Xm
        9v10a7OyMfqwQcaUA/lw5CnKJM10y3s1e3Nw5wyzBtNO4blufrjTCoI1ntlPmYqtP9SKPQGbeGYHh
        AV37fXZw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-I0
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 07/32] filter: PWSNIFF: replace malloc+strncpy with strndup
Date:   Tue, 30 Nov 2021 10:55:35 +0000
Message-Id: <20211130105600.3103609-8-jeremy@azazel.net>
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

