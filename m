From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH] erec: Make error messages in nft consistent
Date: Tue, 15 Nov 2016 17:22:38 -0200
Message-ID: <20161115192237.GA29317@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:35481 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcKOTWp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 14:22:45 -0500
Received: by mail-vk0-f67.google.com with SMTP id x186so9926086vkd.2
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 11:22:44 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Error messages in nft should start with "syntax error" to keep
consistency. A new function add_syntax_error() was created to add this
prefix when necessary.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/erec.h |  3 +++
 src/erec.c     | 23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa..82754e0 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -52,9 +52,12 @@ extern void erec_add_location(struct error_record *erec,
 #define warning(loc, fmt, args...) \
 	erec_create(EREC_WARNING, (loc), (fmt), ## args)
 
+extern void add_syntax_error(struct error_record *erec);
+
 static inline void erec_queue(struct error_record *erec,
 			      struct list_head *queue)
 {
+	add_syntax_error(erec);
 	list_add_tail(&erec->list, queue);
 }
 
diff --git a/src/erec.c b/src/erec.c
index 3603216..e4d7aef 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -194,3 +194,26 @@ int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
 	erec_queue(erec, ctx->msgs);
 	return -1;
 }
+
+void add_syntax_error(struct error_record *erec){
+	if (erec) {
+		const char *stxmsg = "syntax error, ";
+		int mlen = strlen(erec->msg);
+		int slen = strlen(stxmsg);
+		char *tmp;
+
+		if (!strncmp(erec->msg, stxmsg, slen - 2))
+			return;
+
+		if (!mlen)
+			slen -= 2;
+
+		tmp = realloc(erec->msg, slen + mlen + 1);
+		if (tmp) {
+			erec->msg = tmp;
+			memmove(&(erec->msg[slen]), erec->msg, mlen);
+			memcpy(erec->msg, stxmsg, slen);
+			erec->msg[slen + mlen] = '\0';
+		}
+	}
+}
-- 
2.7.4

