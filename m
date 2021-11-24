Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52381C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345787AbhKXWs3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345477AbhKXWs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:29 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433C5C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MMazRB2Olf+xYmkxUvoA7SihVk0MB3w2TDEyAtOBUgM=; b=lLD23Yq4c4aPaDrrU4JJxWkiU7
        oJuPDi3qJB/N9d+NzlL4EXmfMF7LaF3VM9i8IGwAo1t2M+uWoZp8tRyNYsr/jbHn9i/3k1ZxKkKf7
        3qQRHlM2eV7/cGEH2y/rQ5uAT/sykwdEqmM3OqFnpVwiugqv9ClAWxe0G5gGwR3XMW4CNl+r7hr1z
        UZl894hQmZp3mfeM9bTvPX31V7XmNC7qRYAne2wENpAMDYFHRs6t6lnenGdYaKyhj+C5nGbAWra2v
        X+rMQszEYFWY8AG2RvZ3YE52f703/qsxd7Cc6UI1/XEyUFAP7MURoQ73mkHGuYKmA9MHXkyDiVDlJ
        0XUWBHuw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h8-00563U-LR
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 19/30] output: SQLITE3: improve mapping of DB columns to fields
Date:   Wed, 24 Nov 2021 22:24:20 +0000
Message-Id: <20211124222444.2597311-26-jeremy@azazel.net>
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

Hitherto, we copied the column-name to a buffer, iterated over it to
replace the underscores with full-stops, using `strchr` from the start
of the buffer on each iteration, then copied the buffer to the
field's `name` member.

Apart from the inefficiency, `strncpy` was used to do the copies, which
led gcc to complain:

  ulogd_output_SQLITE3.c:341:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Furthermore, the buffer was not initialized, which meant that there was
also a possible buffer overrun if the column-name was too long, since
`strncpy` would not append a NUL.

Instead, we now copy the column-name directly to the field using
`snprintf`, and run `strchr` from the last underscore on each iteration.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index da1c09f08047..d0d6ad283215 100644
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
+                     (underscore = strchr(underscore, '_')) != NULL; )
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

