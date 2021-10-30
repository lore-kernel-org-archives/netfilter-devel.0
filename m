Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714F6C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52F6C60F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJ3RNc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJ3RNb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:31 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB81C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cRX0wHvQ1Ck9Jm1IFhSPupYNwm/g/t95FGVnPd4fcpg=; b=TUHk6JNvNWbt0PZHTh7ny4Gpy2
        LvfGFzSMzOEZIlqpFz270Dx6+EdKBMfSGYwCiQ3kDUxHgwF5w3qwb6ttslbWCzaCLyME8SJsMYLZk
        NRFVi2aakp/5SMhhygmr2PS4Q7d2rYh0vxhbk5cn6xph7TrxfZmaKnJK7bp/auDJNO8zsOdkt8fBk
        aKRBZqXRvxCgLXSeQdT9YxYaGbV7vS8hBWJKho4PyWvyEpLSAtZr/vX8rESCpDocHPzHhZaJ+K/kW
        aLrIHrOVfD3w9d80+Jb/5aJWK+PUiwWDqxtgejVZqhOQ1XnL/mbx4SNLtZReGEAYWqAb+NCLZoPY3
        d25W/CRA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTA-00AFgT-J3
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 20/26] output: SQLITE3: Fix string truncation warnings and possible buffer overruns.
Date:   Sat, 30 Oct 2021 17:44:26 +0100
Message-Id: <20211030164432.1140896-21-jeremy@azazel.net>
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

Extend name length to match input key.

Replace strncpy with snprintf.

Remove intermediate buffers.

Leave `field->name` with underscores: we can get the key-name from
`field->key->name`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 38 +++++++++++----------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 20ceb3b5d6e2..053d7a3b0238 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -48,7 +48,7 @@
 
 struct field {
 	TAILQ_ENTRY(field) link;
-	char name[ULOGD_MAX_KEYLEN];
+	char name[ULOGD_MAX_KEYLEN + 1];
 	struct ulogd_key *key;
 };
 
@@ -214,8 +214,6 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 	struct field *f;
-	char buf[ULOGD_MAX_KEYLEN];
-	char *underscore;
 	char *stmt_pos;
 	int i, cols = 0;
 
@@ -231,12 +229,7 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 	stmt_pos = priv->stmt + strlen(priv->stmt);
 
 	tailq_for_each(f, priv->fields, link) {
-		strncpy(buf, f->name, ULOGD_MAX_KEYLEN);
-
-		while ((underscore = strchr(buf, '.')))
-			*underscore = '_';
-
-		sprintf(stmt_pos, "%s,", buf);
+		sprintf(stmt_pos, "%s,", f->name);
 		stmt_pos = priv->stmt + strlen(priv->stmt);
 
 		cols++;
@@ -273,10 +266,15 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 static struct ulogd_key *
 ulogd_find_key(struct ulogd_pluginstance *pi, const char *name)
 {
+	char key_name[ULOGD_MAX_KEYLEN + 1] = "";
 	unsigned int i;
 
+	/* replace all underscores with dots */
+	for (i = 0; i < sizeof(key_name) && name[i]; ++i)
+		key_name[i] = name[i] != '_' ? name[i] : '.';
+
 	for (i = 0; i < pi->input.num_keys; i++) {
-		if (strcmp(pi->input.keys[i].name, name) == 0)
+		if (strcmp(pi->input.keys[i].name, key_name) == 0)
 			return &pi->input.keys[i];
 	}
 
@@ -305,9 +303,6 @@ static int
 sqlite3_init_db(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
-	char buf[ULOGD_MAX_KEYLEN];
-	char *underscore;
-	struct field *f;
 	sqlite3_stmt *schema_stmt;
 	int col, num_cols;
 
@@ -327,23 +322,22 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
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
 
 		/* prepend it to the linked list */
 		if ((f = calloc(1, sizeof(struct field))) == NULL) {
 			ulogd_log(ULOGD_ERROR, "SQLITE3: out of memory\n");
 			return -1;
 		}
-		strncpy(f->name, buf, ULOGD_MAX_KEYLEN);
+		snprintf(f->name, sizeof(f->name),
+			 "%s", sqlite3_column_name(schema_stmt, col));
 
-		if ((f->key = ulogd_find_key(pi, buf)) == NULL)
+		DEBUGP("field '%s' found\n", f->name);
+
+		if ((f->key = ulogd_find_key(pi, f->name)) == NULL) {
+			free(f);
 			return -1;
+		}
 
 		TAILQ_INSERT_TAIL(&priv->fields, f, link);
 	}
-- 
2.33.0

