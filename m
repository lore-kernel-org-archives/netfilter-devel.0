From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 15/29] add "show bytes" option to "list" and "get" commands
Date: Wed, 10 Jul 2013 19:25:13 +0100
Message-ID: <1373480727-11254-16-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62042 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3GJS0T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:19 -0400
Received: by mail-lb0-f177.google.com with SMTP id 10so5869040lbf.8
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:18 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a new "show bytes" option to the "list" and get commands, allowing only
the byte counter column (in addition to nfacct name) to be shown.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index 3eb8b68..3f25334 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -262,7 +262,7 @@ err:
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool nfnl_msg = false, xml = false;
-	bool b_fmt = false, b_sort = false;
+	bool b_fmt = false, b_sh = false, b_sort = false;
 	struct mnl_socket *nl;
 	char buf[70000];
 	struct nlmsghdr *nlh;
@@ -271,6 +271,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	struct nfa *nfa = NULL;
 	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
 	uint16_t fmt = NFACCT_FMT_MAX;
+	uint16_t flags = NFACCT_SNPRINTF_F_FULL;
 	enum nfacct_sort_mode sort_mode = NFACCT_SORT_NAME;
 
 	while (argc > 0) {
@@ -279,6 +280,14 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
+		} else if (!b_sh && nfacct_matches(argv[0],"show")) {
+			NFACCT_GET_NEXT_ARG();
+			if (nfacct_matches(argv[0],"bytes")) {
+				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else {
+				NFACCT_RET_ARG_ERR();
+			}
+			b_sh = true;
 		} else if (!b_sort && nfacct_matches(argv[0],"sort")) {
 			NFACCT_GET_NEXT_ARG();
 			if (nfacct_matches(argv[0],"name")) {
@@ -355,7 +364,7 @@ static int nfacct_cmd_list(int argc, char *argv[])
 				nfa->nfacct,
 				xml ? NFACCT_SNPRINTF_T_XML :
 				      NFACCT_SNPRINTF_T_PLAIN,
-				NFACCT_SNPRINTF_F_FULL, options);
+				flags, options);
 		printf("%s\n",buf);
 	}
 
@@ -534,7 +543,7 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 static int nfacct_cmd_get(int argc, char *argv[])
 {
 	bool nfnl_msg = false, xml = false;
-	bool b_fmt = false;
+	bool b_sh = false, b_fmt = false;
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -545,6 +554,7 @@ static int nfacct_cmd_get(int argc, char *argv[])
 	char *name;
 	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
 	uint16_t fmt = NFACCT_FMT_MAX;
+	uint16_t flags = NFACCT_SNPRINTF_F_FULL;
 
 	if (argc < 1 || strlen(argv[0]) == 0) {
 		nfacct_perror("missing object name");
@@ -562,6 +572,14 @@ static int nfacct_cmd_get(int argc, char *argv[])
 			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
+		} else if (!b_sh && nfacct_matches(argv[0],"show")) {
+			NFACCT_GET_NEXT_ARG();
+			if (nfacct_matches(argv[0],"bytes")) {
+				flags = NFACCT_SNPRINTF_F_BONLY;
+			} else {
+				NFACCT_RET_ARG_ERR();
+			}
+			b_sh = true;
 		} else if (!b_fmt && (nfacct_matches(argv[0],"format") ||
 			   nfacct_matches(argv[0],"fmt"))) {
 			NFACCT_GET_NEXT_ARG();
@@ -630,7 +648,7 @@ static int nfacct_cmd_get(int argc, char *argv[])
 				nfa->nfacct,
 				xml ? NFACCT_SNPRINTF_T_XML :
 				      NFACCT_SNPRINTF_T_PLAIN,
-				NFACCT_SNPRINTF_F_FULL, options);
+				flags, options);
 		printf("%s\n",buf);
 	}
 
@@ -729,9 +747,10 @@ static const char help_msg[] =
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n\n"
 	"Parameters:\n"
-	"  LST_PARAMS := [ reset ] [ format FMT_SPEC ] [ sort SORT_SPEC ] [ xml ]\n"
+	"  LST_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ]\n"
+			"\t\t[ sort SORT_SPEC ] [ xml ]\n"
 	"  ADD_PARAMS := [ replace ]\n"
-	"  GET_PARAMS := [ reset ] [ format FMT_SPEC ] [ xml ]\n"
+	"  GET_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
 	"  SORT_SPEC := { none | name | packets | bytes }"
-- 
1.8.3.1

