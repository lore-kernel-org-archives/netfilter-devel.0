From: Alexandru Ardelean <ardeleanalex@gmail.com>
Subject: [PATCH] ulogd: add +1 char for null char
Date: Mon, 20 Mar 2017 10:31:07 +0200
Message-ID: <1489998667-15183-1-git-send-email-ardeleanalex@gmail.com>
Cc: eric@regit.org, Alexandru Ardelean <ardeleanalex@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35207 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753064AbdCTIc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 04:32:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id z133so12974004wmb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2017 01:32:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a bit zealous to fix like this, but it seems to work.

The crash was reproduced on ppc32, with GCC 5.4 & musl libc 1.1.16.

And also on LEDE (mips_24kc and ARM):
https://github.com/openwrt/packages/issues/4123
https://github.com/openwrt/packages/issues/4090

I personally saw it on ppc32.
The offending code was in `pluginstance_alloc_init()` line 671:
```
memcpy(pi->id, pi_id, sizeof(pi->id));
```

Seems that it would copy 1 char from the stack, and that
caused some failsafes to kick in.

This fix addresses the issue directly.
Maybe a more appropriate rework of string stuff would be needed.

What I also noticed, is that there's also places in the code
that define name[ULOGD_MAX_KEYLEN+1] and some that don't add
the +1 char.
Basically, this just aligns the remaining bits of code
that don't add the +1 char.

Signed-off-by: Alexandru Ardelean <ardeleanalex@gmail.com>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 6 +++---
 src/ulogd.c                           | 2 +-
 util/db.c                             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 20ceb3b..ea66061 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -48,7 +48,7 @@
 
 struct field {
 	TAILQ_ENTRY(field) link;
-	char name[ULOGD_MAX_KEYLEN];
+	char name[ULOGD_MAX_KEYLEN+1]; /* +1 for null char */
 	struct ulogd_key *key;
 };
 
@@ -214,7 +214,7 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
 	struct field *f;
-	char buf[ULOGD_MAX_KEYLEN];
+	char buf[ULOGD_MAX_KEYLEN+1]; /* +1 for null char */
 	char *underscore;
 	char *stmt_pos;
 	int i, cols = 0;
@@ -305,7 +305,7 @@ static int
 sqlite3_init_db(struct ulogd_pluginstance *pi)
 {
 	struct sqlite3_priv *priv = (void *)pi->private;
-	char buf[ULOGD_MAX_KEYLEN];
+	char buf[ULOGD_MAX_KEYLEN+1];
 	char *underscore;
 	struct field *f;
 	sqlite3_stmt *schema_stmt;
diff --git a/src/ulogd.c b/src/ulogd.c
index 5b9a586..0d6a367 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -942,7 +942,7 @@ static int create_stack(const char *option)
 	/* PASS 1: find and instanciate plugins of stack, link them together */
 	for (tok = strtok(buf, ",\n"); tok; tok = strtok(NULL, ",\n")) {
 		char *plname, *equals;
-		char pi_id[ULOGD_MAX_KEYLEN];
+		char pi_id[ULOGD_MAX_KEYLEN+1]; /* +1 for the null char */
 		struct ulogd_pluginstance *pi;
 		struct ulogd_plugin *pl;
 
diff --git a/util/db.c b/util/db.c
index c9aec41..6af4555 100644
--- a/util/db.c
+++ b/util/db.c
@@ -96,7 +96,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 	if (strncasecmp(procedure,"INSERT", strlen("INSERT")) == 0 &&
 	    (procedure[strlen("INSERT")] == '\0' ||
 			procedure[strlen("INSERT")] == ' ')) {
-		char buf[ULOGD_MAX_KEYLEN];
+		char buf[ULOGD_MAX_KEYLEN+1]; /* +1 for null char */
 		char *underscore;
 
 		if(procedure[6] == '\0') {
-- 
2.7.4

