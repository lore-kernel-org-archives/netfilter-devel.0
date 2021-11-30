Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD72C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhK3LSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhK3LSH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D9C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6DeriJC9ToutIxYShYBrIiqaFs1BSOfIJICtIUZo6vM=; b=lCAvJe4pztvIyOV+KjZfF4i7JA
        02fuldhFznJqvHFOEBIcfWYNg63ktQ2Ptf3w1ESS2fRtvsRpjkD1ueuOznBqeyTic0g0a2OJPQinm
        i6OTQubS9lAHW8b95XFw3iXXt+n/OKkiBFpGgYWSf4hUV70WdVHLw7tVDydxXeiguyPwVCQJJyiJj
        3vEcHPV9rskCaseFy5aLlhUPbHrq7Gz2rDujxeBJJXOJDyXysFqBOVHrNQE/4BpBOKfQVIUm/5FjK
        W+WMusR8NXb2ugieuiYVDKRNF4IFjSklUPBRy12Es8xu6vdxF3yZ5BHJWKezCUMjYGAvrpZoThg62
        PLoXaFDg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-Vy
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 21/32] output: SQLITE3: improve mapping of DB columns to fields
Date:   Tue, 30 Nov 2021 10:55:49 +0000
Message-Id: <20211130105600.3103609-22-jeremy@azazel.net>
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

Currently, we copy the column-name to a buffer, iterate over it to
replace the underscores with full-stops, using `strchr` from the start
of the buffer on each iteration, then copy the buffer to the field's
`name` member.

Apart from the inefficiency, `strncpy` is used to do the copies, which
leads gcc to complain:

  ulogd_output_SQLITE3.c:341:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Furthermore, the buffer is not initialized, which means that there is
also a possible buffer overrun if the column-name is too long, since
`strncpy` will not append a NUL.

Instead, copy the column-name directly to the field using `snprintf`,
and run `strchr` from the last underscore on each iteration.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index da1c09f08047..e3040a8a2fac 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -303,9 +303,6 @@ static int
 sqlite3_init_db(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
-	char buf[ULOGD_MAX_KEYLEN + 1];
-	char *underscore;
-	struct field *f;
 	sqlite3_stmt *schema_stmt;
 	int col, num_cols;
 
@@ -325,24 +322,27 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
 	}
 
 	for (col = 0; col < num_cols; col++) {
-		strncpy(buf, sqlite3_column_name(schema_stmt, col), ULOGD_MAX_KEYLEN);
-
-		/* replace all underscores with dots */
-		while ((underscore = strchr(buf, '_')) != NULL)
-			*underscore = '.';
-
-		DEBUGP("field '%s' found\n", buf);
+		struct field *f;
+		char *underscore;
 
 		/* prepend it to the linked list */
 		if ((f = calloc(1, sizeof(struct field))) == NULL) {
 			ulogd_log(ULOGD_ERROR, "SQLITE3: out of memory\n");
 			return -1;
 		}
-		strncpy(f->name, buf, ULOGD_MAX_KEYLEN);
+		snprintf(f->name, sizeof(f->name),
+			 "%s", sqlite3_column_name(schema_stmt, col));
+
+		/* replace all underscores with dots */
+		for (underscore = f->name;
+		     (underscore = strchr(underscore, '_')) != NULL; )
+			*underscore = '.';
+
+		DEBUGP("field '%s' found\n", f->name);
 
-		if ((f->key = ulogd_find_key(pi, buf)) == NULL) {
+		if ((f->key = ulogd_find_key(pi, f->name)) == NULL) {
 			ulogd_log(ULOGD_ERROR,
-				  "SQLITE3: unknown input key: %s\n", buf);
+				  "SQLITE3: unknown input key: %s\n", f->name);
 			free(f);
 			return -1;
 		}
-- 
2.33.0

