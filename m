Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A5DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF1960F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhJ3RNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhJ3RNM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:12 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A545C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1/ww1tM9G1Bdrqq43bg4EZaBAsCHHojr9kMW0gSbYM4=; b=nGWloWL85sSvDgEUwpm8P7J3RR
        F+KdLRBKa7Hlf264a0N3arICg6Sm1yVB2yTvNN6TPhU8PDS432p/jk7yD4LY7P2w/MK3FO48jrDy2
        z2NNXKiL3bn4aYOlChaZEFXTImKH+fWqfMT4rVmGKPVT399YMxARmS+GGD7pX6/F9yppKOdVIkd4a
        ZkrsYSQjcUdlt0pdYjopjw5WgcfSElaTBWJaHpmOmGlABFD2zAX3snAIvkc4/ngkP9hB/mW/4/vLD
        8ZsXsZOwd3fALnGq6ffIKJx5eeAMsJ34+0E2rjts4tD+kO/AaUc11ZqYby2XjfJXuKDWI7H0i2COD
        p7ZoLHSw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTA-00AFgT-9o
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 17/26] output: DBI: fix string truncation warnings
Date:   Sat, 30 Oct 2021 17:44:23 +0100
Message-Id: <20211030164432.1140896-18-jeremy@azazel.net>
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

Replace `strncpy` with `snprintf` and `memcpy`.

Remove intermediate buffer.

Ensure that `dst` is properly initialized if `dbi_conn_quote_string_copy`
returns an error.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 46 +++++++++++++++--------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 461aed4bddb6..babaf58a9a56 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -91,15 +91,6 @@ static struct config_keyset dbi_kset = {
 #define dbtype_ce(x)	(x->ces[DB_CE_NUM+6])
 
 
-/* lower-cases s in place */
-static void str_tolower(char *s)
-{
-	while(*s) {
-		*s = tolower(*s);
-		s++;
-	}
-}
-
 /* find out which columns the table has */
 static int get_columns_dbi(struct ulogd_pluginstance *upi)
 {
@@ -139,25 +130,26 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 		return -ENOMEM;
 	}
 
-	for (ui=1; ui<=upi->input.num_keys; ui++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
-		char *underscore;
-		const char* field_name = dbi_result_get_field_name(pi->result, ui);
+	for (ui = 1; ui <= upi->input.num_keys; ui++) {
+		const char *field_name = dbi_result_get_field_name(pi->result, ui);
+		char *cp;
 
 		if (!field_name)
 			break;
 
-		/* replace all underscores with dots */
-		strncpy(buf, field_name, ULOGD_MAX_KEYLEN);
-		while ((underscore = strchr(buf, '_')))
-			*underscore = '.';
+		snprintf(upi->input.keys[ui - 1].name,
+			 sizeof(upi->input.keys[ui - 1].name),
+			 "%s", field_name);
 
-		str_tolower(buf);
+		/* down-case and replace all underscores with dots */
+		for (cp = upi->input.keys[ui - 1].name; *cp; cp++) {
+			if (*cp == '_')
+				*cp = '.';
+			else
+				*cp = tolower(*cp);
+		}
 
-		DEBUGP("field '%s' found: ", buf);
-
-		/* add it to list of input keys */
-		strncpy(upi->input.keys[ui-1].name, buf, ULOGD_MAX_KEYLEN);
+		DEBUGP("field '%s' found: ", upi->input.keys[ui - 1].name);
 	}
 
 	/* ID is a sequence */
@@ -245,18 +237,20 @@ static int escape_string_dbi(struct ulogd_pluginstance *upi,
 	}
 
 	ret = dbi_conn_quote_string_copy(pi->dbh, src, &newstr);
-	if (ret <= 2)
+	if (ret == 0) {
+		*dst = '\0';
 		return 0;
+	}
 
 	/* dbi_conn_quote_string_copy returns a quoted string,
 	 * but __interp_db already quotes the string
 	 * So we return a string without the quotes
 	 */
-	strncpy(dst,newstr+1,ret-2);
-	dst[ret-2] = '\0';
+	memcpy(dst, newstr + 1, ret - 2);
+	dst[ret - 2] = '\0';
 	free(newstr);
 
-	return (ret-2);
+	return ret - 2;
 }
 
 static int execute_dbi(struct ulogd_pluginstance *upi,
-- 
2.33.0

