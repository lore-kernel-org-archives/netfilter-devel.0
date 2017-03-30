From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Remove unnecessary parenthesis.
Date: Thu, 30 Mar 2017 10:43:02 +0530
Message-ID: <20170330051301.GA25786@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: outreachy-kernel@googlegroups.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35519 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754735AbdC3FNI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 01:13:08 -0400
Received: by mail-pg0-f68.google.com with SMTP id g2so7151739pge.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 22:13:07 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removed parenthesis on the right hand side of assignment, as they are
not required.
The following coccinelle script was used to fix this issue:

@@
local idexpression id;
expression e;
@@

id =
-(
e
-)

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_mark.c  | 8 ++++----
 extensions/libxt_string.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index 7b80b22..d85ed8d 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -86,7 +86,7 @@ brmark_parse(int c, char **argv, int invert, unsigned int *flags,
 		return 1;
 	case MARK_SETMARK:
 		EBT_CHECK_OPTION(flags, OPT_MARK_SETMARK);
-		mask = (OPT_MARK_ORMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
+		mask = OPT_MARK_ORMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK;
 		if (*flags & mask)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--mark-set cannot be used together with"
@@ -96,7 +96,7 @@ brmark_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case MARK_ORMARK:
 		EBT_CHECK_OPTION(flags, OPT_MARK_ORMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
+		mask = OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK;
 		if (*flags & mask)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--mark-or cannot be used together with"
@@ -106,7 +106,7 @@ brmark_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case MARK_ANDMARK:
 		EBT_CHECK_OPTION(flags, OPT_MARK_ANDMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ORMARK|OPT_MARK_XORMARK);
+		mask = OPT_MARK_SETMARK|OPT_MARK_ORMARK|OPT_MARK_XORMARK;
 		if (*flags & mask)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--mark-and cannot be used together with"
@@ -116,7 +116,7 @@ brmark_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case MARK_XORMARK:
 		EBT_CHECK_OPTION(flags, OPT_MARK_XORMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_ORMARK);
+		mask = OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_ORMARK;
 		if (*flags & mask)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--mark-xor cannot be used together with"
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index fb15980..535e63b 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -255,8 +255,8 @@ string_print(const void *ip, const struct xt_entry_match *match, int numeric)
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
 	const int revision = match->u.user.revision;
-	int invert = (revision == 0 ? info->u.v0.invert :
-				    info->u.v1.flags & XT_STRING_FLAG_INVERT);
+	int invert = revision == 0 ? info->u.v0.invert :
+				    info->u.v1.flags & XT_STRING_FLAG_INVERT;
 
 	if (is_hex_string(info->pattern, info->patlen)) {
 		printf(" STRING match %s", invert ? "!" : "");
@@ -279,8 +279,8 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
 	const int revision = match->u.user.revision;
-	int invert = (revision == 0 ? info->u.v0.invert :
-				    info->u.v1.flags & XT_STRING_FLAG_INVERT);
+	int invert = revision == 0 ? info->u.v0.invert :
+				    info->u.v1.flags & XT_STRING_FLAG_INVERT;
 
 	if (is_hex_string(info->pattern, info->patlen)) {
 		printf("%s --hex-string", (invert) ? " !" : "");
-- 
2.11.0

