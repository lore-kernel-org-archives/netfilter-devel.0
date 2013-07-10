From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 23/29] add "show extended" option to "list" and "get" commands
Date: Wed, 10 Jul 2013 19:25:21 +0100
Message-ID: <1373480727-11254-24-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:63197 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3GJS0q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:46 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so6063112lab.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:44 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a separate "show extended" option to "list" and "get" commands showing
all accounting object properties in separate columns: name, packet & byte
counters, threshold exceeded indicator and the threshold value itself.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index f2ece72..4504143 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -289,6 +289,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			NFACCT_GET_NEXT_ARG();
 			if (nfacct_matches(argv[0],"bytes")) {
 				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"extended")) {
+				flags = NFACCT_SNPRINTF_F_EXTENDED;
 			} else {
 				NFACCT_RET_ARG_ERR();
 			}
@@ -617,6 +619,8 @@ static int nfacct_cmd_get(int argc, char *argv[])
 			NFACCT_GET_NEXT_ARG();
 			if (nfacct_matches(argv[0],"bytes")) {
 				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else if (nfacct_matches(argv[0],"extended")) {
+				flags = NFACCT_SNPRINTF_F_EXTENDED;
 			} else {
 				NFACCT_RET_ARG_ERR();
 			}
@@ -788,12 +792,13 @@ static const char help_msg[] =
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n\n"
 	"Parameters:\n"
-	"  LST_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ]\n"
+	"  LST_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ]\n"
 			"\t\t[ sort SORT_SPEC ] [ xml ]\n"
 	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ] "
 			"[ threshold [NUMBER | '-'] ]\n"
-	"  GET_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ] [ xml ]\n"
+	"  GET_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
+	"  SHOW_SPEC := { bytes | extended }\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
 	"  SORT_SPEC := { none | name | packets | bytes | threshold }"
 	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib |"
-- 
1.8.3.1

