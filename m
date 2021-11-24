Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483A0C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbhKXWsk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhKXWsk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:40 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A58C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kVb7PIHvxGcpiVFTyFAN3ndXM30ZwDzJyS2qjEHGJ+4=; b=PsMPhwKy6w7Lha6a8pZC9TtVL8
        LB0/BF7k1YtWvmQ42wRmnyGZSo7HOI7BF1qXoNkFKChJ6YFvzyvMVmxQ3BUZmym8XwZFTprEy3nUa
        7A7AuOzXxtclOQvpxUs7BCqAaxHOuHbklqViuAhdC7wb+dVChZlykEIVqWucP/WQB7QOp5kgpi4cR
        bLlkYpoolGGlg2jmm3os4eLAyBHHjagIn47yh4mg5qnbqV4ILHG7R9mZpoONmPaxUI+Akc6izi3EH
        OO5W+pBQLPtkg2r+ycg3u4V5gzmxemtEcSbvOjdVlDESGgrzaYQHjRSAyBUvka0xQ3witDwL4QmOQ
        hDkMJ/fg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h9-00563U-JE
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:51 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 22/32] output: SQLITE3: improve mapping of fields to DB columns
Date:   Wed, 24 Nov 2021 22:24:26 +0000
Message-Id: <20211124222444.2597311-32-jeremy@azazel.net>
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

Currently, we derive a field-name by replacing all the underscores in a
DB column-name with full-stops and use the field-name to find the
matching input-key.  However, every time we create a new insert SQL
statement, we derive the column-names by copying the field-names to a
buffer, replacing all the full-stops with underscores, and then
appending the buffer containing the column-name to the one containing
the statments.

Apart from the inefficiency, `strncpy` is used to do the copies, which
leads gcc to complain:

  ulogd_output_SQLITE3.c:234:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Instead, leave the underscores in the field-name, but copy it once to a
buffer in which the underscores are replaced and use this to find the
input-key.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index e3040a8a2fac..c61694a51d47 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -214,8 +214,6 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 	struct field *f;
-	char buf[ULOGD_MAX_KEYLEN + 1];
-	char *underscore;
 	char *stmt_pos;
 	int i, cols = 0;
 
@@ -231,13 +229,7 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 	stmt_pos += sprintf(stmt_pos, "insert into %s (", table_ce(pi));
 
 	tailq_for_each(f, priv->fields, link) {
-		strncpy(buf, f->name, ULOGD_MAX_KEYLEN);
-
-		while ((underscore = strchr(buf, '.')))
-			*underscore = '_';
-
-		stmt_pos += sprintf(stmt_pos, "%s,", buf);
-
+		stmt_pos += sprintf(stmt_pos, "%s,", f->name);
 		cols++;
 	}
 
@@ -271,10 +263,15 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 static struct ulogd_key *
 ulogd_find_key(struct ulogd_pluginstance *pi, const char *name)
 {
+	char buf[ULOGD_MAX_KEYLEN + 1] = "";
 	unsigned int i;
 
+	/* replace all underscores with dots */
+	for (i = 0; i < sizeof(buf) - 1 && name[i]; ++i)
+		buf[i] = name[i] != '_' ? name[i] : '.';
+
 	for (i = 0; i < pi->input.num_keys; i++) {
-		if (strcmp(pi->input.keys[i].name, name) == 0)
+		if (strcmp(pi->input.keys[i].name, buf) == 0)
 			return &pi->input.keys[i];
 	}
 
@@ -323,7 +320,6 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
 
 	for (col = 0; col < num_cols; col++) {
 		struct field *f;
-		char *underscore;
 
 		/* prepend it to the linked list */
 		if ((f = calloc(1, sizeof(struct field))) == NULL) {
@@ -333,11 +329,6 @@ sqlite3_init_db(struct ulogd_pluginstance *pi)
 		snprintf(f->name, sizeof(f->name),
 			 "%s", sqlite3_column_name(schema_stmt, col));
 
-		/* replace all underscores with dots */
-		for (underscore = f->name;
-		     (underscore = strchr(underscore, '_')) != NULL; )
-			*underscore = '.';
-
 		DEBUGP("field '%s' found\n", f->name);
 
 		if ((f->key = ulogd_find_key(pi, f->name)) == NULL) {
-- 
2.33.0

