From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/13] xt_comment: remove redundant cast
Date: Sat,  8 Jan 2011 16:20:04 +0100
Message-ID: <1294500015-10691-4-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32887 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1AHPUT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:19 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_comment.c           |    2 +-
 include/linux/netfilter/xt_comment.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index a9325a5..dba8bb2 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -86,7 +86,7 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
 	printf("--comment ");
-	xtables_save_string((const char *)commentinfo->comment);
+	xtables_save_string(commentinfo->comment);
 }
 
 static struct xtables_match comment_match = {
diff --git a/include/linux/netfilter/xt_comment.h b/include/linux/netfilter/xt_comment.h
index eacfedc..0ea5e79 100644
--- a/include/linux/netfilter/xt_comment.h
+++ b/include/linux/netfilter/xt_comment.h
@@ -4,7 +4,7 @@
 #define XT_MAX_COMMENT_LEN 256
 
 struct xt_comment_info {
-	unsigned char comment[XT_MAX_COMMENT_LEN];
+	char comment[XT_MAX_COMMENT_LEN];
 };
 
 #endif /* XT_COMMENT_H */
-- 
1.7.1

