From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH v3 1/2] erec: Make error messages in nft consistent
Date: Wed, 16 Nov 2016 20:03:16 -0200
Message-ID: <20161116220316.GA18713@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:32859 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753215AbcKPWDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 17:03:23 -0500
Received: by mail-vk0-f65.google.com with SMTP id l126so13101780vkh.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 14:03:23 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Error messages in nft from parser_bison should state "syntax error" to
keep consistency. A new error type was defined to include this message.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 v2: Create new error_record_type instead of modify the message within
 the error_record struct.
 v3: Separate changes in different patches

 include/erec.h | 5 ++++-
 src/erec.c     | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa..8fee151 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -15,6 +15,7 @@ enum error_record_types {
 	EREC_INFORMATIONAL,
 	EREC_WARNING,
 	EREC_ERROR,
+	EREC_SYNTAX_ERROR,
 };
 
 #define EREC_MSGBUFSIZE		1024
@@ -47,8 +48,10 @@ extern struct error_record *erec_create(enum error_record_types type,
 extern void erec_add_location(struct error_record *erec,
 			      const struct location *loc);
 
-#define error(loc, fmt, args...) \
+#define __error(loc, fmt, args...) \
 	erec_create(EREC_ERROR, (loc), (fmt), ## args)
+#define error(loc, fmt, args...) \
+	erec_create(EREC_SYNTAX_ERROR, (loc), (fmt), ## args)
 #define warning(loc, fmt, args...) \
 	erec_create(EREC_WARNING, (loc), (fmt), ## args)
 
diff --git a/src/erec.c b/src/erec.c
index 3603216..9f01238 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -30,7 +30,8 @@ const struct location internal_location = {
 static const char *error_record_names[] = {
 	[EREC_INFORMATIONAL]	= NULL,
 	[EREC_WARNING]		= "Warning",
-	[EREC_ERROR]		= "Error"
+	[EREC_ERROR]		= "Error",
+	[EREC_SYNTAX_ERROR]     = "Error: syntax error"
 };
 
 void erec_add_location(struct error_record *erec, const struct location *loc)
-- 
2.7.4

