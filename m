Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE66C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 754DE603E8
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ3RM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3RM5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:12:57 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B70C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5CzEyHUSrQu87wQMex/0E/S6kRXEE4lcGhq0w5+les0=; b=fvCaa8i3kjg3lFgvfeWUUuM2Tx
        Zyle60aHjyyxZzQqDIjwpY/U6NEX8FK/wU5/p/fPOEarFeKeDu0mh4uI1qDPCVGJmrEeX61GCkd/E
        bQ48/mzNHI+GFTSVsGp9Ki5cea9rpZUlTkLgfl1o2utnXXjzyuD0zqC16csH5Hib9Cgw054r5/yju
        Wtjc/fSndd8BCrccfNjbkIB4jYXVWUutAcUmR1gLc8COE1X2qhMd3y2cnHgZWkEtvhp+KSSwhy5nT
        NiMd8tPq+/Tm/3rfAoLdY/DBbb7EghpTGKOEhywTZw9rLfpXWpuu3l8fD8/HuNWP7nKjZa41DPqzl
        DNclIQSw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTB-00AFgT-9R
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 25/26] output: JSON: optimize appending of newline to output.
Date:   Sat, 30 Oct 2021 17:44:31 +0100
Message-Id: <20211030164432.1140896-26-jeremy@azazel.net>
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

