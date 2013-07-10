From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 28/29] add "show marks" option to "list" and "get" commands
Date: Wed, 10 Jul 2013 19:25:26 +0100
Message-ID: <1373480727-11254-29-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44308 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab3GJS06 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:58 -0400
Received: by mail-lb0-f179.google.com with SMTP id w20so5931780lbh.38
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:57 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add "show marks" option to "list" and "get" commands, allwoing only
mark-specific nfacct object properties to be shown - pmark (the amount of
packets passed through the accounting object since a "mark" was set), bmark
(the amount of bytes passed through the accounting object since a "mark" was
set) and name. The formatting used for showing pmark and bmark is the same as
pkts and bytes properties respectively, unless overwritten with the "format"
option.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 2cb0256..4ce6854 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -305,6 +305,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			NFACCT_GET_NEXT_ARG();
 			if (nfacct_matches(argv[0],"bytes")) {
 				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"marks")) {
+				flags = NFACCT_SNPRINTF_F_MONLY;
 			} else if (nfacct_matches(argv[0],"extended")) {
 				flags = NFACCT_SNPRINTF_F_EXTENDED;
 			} else {
@@ -645,6 +647,8 @@ static int nfacct_cmd_get(int argc, char *argv[])
 			NFACCT_GET_NEXT_ARG();
 			if (nfacct_matches(argv[0],"bytes")) {
 				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"marks")) {
+				flags = NFACCT_SNPRINTF_F_MONLY;
 			} else if (nfacct_matches(argv[0],"extended")) {
 				flags = NFACCT_SNPRINTF_F_EXTENDED;
 			} else {
@@ -825,7 +829,7 @@ static const char help_msg[] =
 	"  GET_PARAMS := [ reset | setmark | clrmark ] [ show SHOW_SPEC ]\n"
 			"\t\t[ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
-	"  SHOW_SPEC := { bytes | extended }\n"
+	"  SHOW_SPEC := { bytes | marks | extended }\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
 	"  SORT_SPEC := { none | name | packets | pmark | bytes | bmark |"
 			" threshold }\n"
-- 
1.8.3.1

