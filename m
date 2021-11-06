Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20BAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9B9F6136A
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhKFRR7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhKFRRz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:55 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887C4C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5CzEyHUSrQu87wQMex/0E/S6kRXEE4lcGhq0w5+les0=; b=lZX66AR2pleKAa7q9fDcSSbDyc
        7gYeLBa/QdQ3Tqv8b7JYbcidLE8JwmIcEZU1CMY9H4KCSjMmHx01jbey35jAdlEZeXN0o8BQrGdd7
        P2hBOg1y3bFlzQclzS7FgeLXk+dfE9FeuIKD3zcwhyo9bJ+0AhF9T1B+dZFwDx7U6c4FrGgop0P1l
        JY1VGJs8W5cUsa21gpiA0bNi9YnT5+8xn87KcF4chJ39L+VL0PJWR7DP9WpFTYQkX9ezIH67jZ2u4
        cMWPT3pPLnxmFyTSK2zgGowWDq+0OINq1JdSkyBs3ADpdnMZezbxnjMigSuh7m5GcFxmw074YTm+F
        uM0ETbPg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtL-004m1E-Iq
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 25/27] output: JSON: optimize appending of newline to output
Date:   Sat,  6 Nov 2021 16:49:51 +0000
Message-Id: <20211106164953.130024-26-jeremy@azazel.net>
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

We have `buflen` available.  We can remove `strncat` and assign the characters
directly, without traversing the whole buffer.

Correct `buflen` type and fix leak if `realloc` fails.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 6c61eb144135..c15c9f239441 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -275,8 +275,8 @@ static int json_interp(struct ulogd_pluginstance *upi)
 {
 	struct json_priv *opi = (struct json_priv *) &upi->private;
 	unsigned int i;
-	char *buf;
-	int buflen;
+	char *buf, *tmp;
+	size_t buflen;
 	json_t *msg;
 
 	msg = json_object();
@@ -337,8 +337,6 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		json_object_set_new(msg, "dvc", json_string(dvc));
 	}
 
-
-
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = upi->input.keys[i].u.source;
 		char *field_name;
@@ -391,7 +389,6 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		}
 	}
 
-
 	buf = json_dumps(msg, 0);
 	json_decref(msg);
 	if (buf == NULL) {
@@ -399,13 +396,15 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		return ULOGD_IRET_ERR;
 	}
 	buflen = strlen(buf);
-	buf = realloc(buf, sizeof(char)*(buflen+2));
-	if (buf == NULL) {
+	tmp = realloc(buf, buflen + sizeof("\n"));
+	if (tmp == NULL) {
+		free(buf);
 		ulogd_log(ULOGD_ERROR, "Could not create message\n");
 		return ULOGD_IRET_ERR;
 	}
-	strncat(buf, "\n", 1);
-	buflen++;
+	buf = tmp;
+	buf[buflen++] = '\n';
+	buf[buflen]   = '\0';
 
 	if (opi->mode == JSON_MODE_FILE)
 		return json_interp_file(upi, buf);
-- 
2.33.0

