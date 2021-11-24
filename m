Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60799C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345477AbhKXWsb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347800AbhKXWsb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:31 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B474C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O3F2qM0cpdAn4I5/l4MW1gDhk2alS4YlJVZ/5rVPSUE=; b=ew8L1qujTDKiASlRD3KEROWGzu
        uBHYDdP0WJiSxa9JXfSDDm5+39Dl0kLP4LCXwtg5yFIoo6IO526w1Smb5Cg9ccWbQAwPX+5IYnELa
        y+/AxvTTkwyDwKiXgzn97a5d4nZQpheFSQpqxiojxg7h6v76IFvigPc3s595qPKKhVnoP1XqInKsS
        QNhZHCZwJ22gI9+nu5Xxz+rzWLLBfm+PW0T9hRU+wAXcojI2TkNfJHVgbk/iw+mqSyXccxldsY5K3
        7HvdQOXiHmEeYsA3K+JF0vDbUPolladYh9gw000qeNqqjCmIk6hjoO7UT+jjrgnfZNmNLl4jRUYD2
        NDqTnCZQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-TO
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 29/32] output: JSON: fix possible leak in error-handling.
Date:   Wed, 24 Nov 2021 22:24:39 +0000
Message-Id: <20211124222444.2597311-45-jeremy@azazel.net>
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

