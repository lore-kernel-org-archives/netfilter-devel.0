Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD5AC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhK3LSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbhK3LSl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:41 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A017C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O3F2qM0cpdAn4I5/l4MW1gDhk2alS4YlJVZ/5rVPSUE=; b=m16uTcr/oEsxLGRsF5rdQoZi67
        fYEZCMFcTG/EHRqgckJgTX/6rYsXVW+X6WF32Y2UQZAc8pV8dRvy9avklAUPxkdM2J4pfeAuh7sBB
        MiXBmQwwmRsJ36HpjXtaRnWW6CHcfNO2TLZvFYI/PFf1fUe5q4aqOX2rTBgOmn3/FhKIk6ae7sNmB
        WgPHh1C3e42m2RvimxA/FfxVgrC+MRBVj0ftfVfKazqsqCbWhcx6zPKJj10C2YCnXRaa8yrP5bECP
        OWNbuH7c8j9j1hlG3vspfsMWq1CKuTdbAnRW42/ek8DBE4uy59+kuuVnuiy5k9OixkjEdH3TCP2rL
        mHXOsUxg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nt-00Awwr-NW
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 29/32] output: JSON: fix possible leak in error-handling.
Date:   Tue, 30 Nov 2021 10:55:57 +0000
Message-Id: <20211130105600.3103609-30-jeremy@azazel.net>
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

The `realloc` extending the buffer containing the JSON to allow us to
insert a final new-line may fail.  Therefore, we need to assign the
return-value to a temporary variable or we will not able to free the
existing buffer on error.

Use the correct type for `buflen`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index d949df6bb530..6af872c64391 100644
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
@@ -338,8 +338,6 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		json_object_set_new(msg, "dvc", json_string(dvc));
 	}
 
-
-
 	for (i = 0; i < upi->input.num_keys; i++) {
 		struct ulogd_key *key = upi->input.keys[i].u.source;
 		char *field_name;
@@ -392,7 +390,6 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		}
 	}
 
-
 	buf = json_dumps(msg, 0);
 	json_decref(msg);
 	if (buf == NULL) {
@@ -400,11 +397,13 @@ static int json_interp(struct ulogd_pluginstance *upi)
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
+	buf = tmp;
 	strncat(buf, "\n", 1);
 	buflen++;
 
-- 
2.33.0

