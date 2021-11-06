Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C02C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF2D61360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhKFRRc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhKFRRc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:32 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BFFC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lvLJl34V0eM1gJJTEKqj2eYwZlA5FUYN9t/oms6+r9s=; b=tQ1P/Q7R9ewR/tCTr4EDMhi4lD
        bIvdwxiJkPuAqh0in8nrq8Z+9eHj+hq9b7tv7HeADhYlVRwvxJQSzMp3xUviz50J8M3mRdqz4DBs+
        5F0IcF7mUZkcurGybabojyKO/WrSeGRU5xyZ6uXCMRwn8JZq7SMXEBCWo8xRHsRUYJRArDxqPa3uy
        KK1izp5OreeLHqs10PKQRfITGcsJQ9HxqKIVNZvjt5NaWfvWIHN/JcszoNS/Uw66oTcFCZcl8yGy9
        vjfTENVjeaf20NPlfxusjM+ydQMhrCFPduqI/tlaMyYGjOTVpibjbFIZZ5tu+tQiwVswQP8+c75gB
        HDbyYhhA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-IN
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 17/27] output: DBI: fix string truncation warnings
Date:   Sat,  6 Nov 2021 16:49:43 +0000
Message-Id: <20211106164953.130024-18-jeremy@azazel.net>
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

Replace `strncpy` with `snprintf` and `memcpy`.

Remove superfluous intermediate buffer.

Ensure that `dst` is properly initialized if `dbi_conn_quote_string_copy`
returns an error.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 44 +++++++++++++++--------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index 461aed4bddb6..b3e523df778c 100644
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
@@ -140,24 +131,25 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 	}
 
 	for (ui=1; ui<=upi->input.num_keys; ui++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
-		char *underscore;
-		const char* field_name = dbi_result_get_field_name(pi->result, ui);
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

