From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 18/29] add permanent number formatting to nfacct objects
Date: Wed, 10 Jul 2013 19:25:16 +0100
Message-ID: <1373480727-11254-19-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:37514 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3GJS0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:30 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so6142369lab.31
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:28 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add support for permanent number formatting of nfacct objects, enhancing
the "add" and "get" commands, modifying the exisitng "save" and "restore"
commands also. That way, each nfacct object can have its own independent
formatting, which is stored permanently when the object was created with
"add". That formatting is then used in the "list" and "get" commands, unless
the "format" option is specified. More than 14 different formats can be used
to format both bytes and packets. The formatting of packets and bytes is also
independent and can be specified separately.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/linux/netfilter/nfnetlink_acct.h |  1 +
 src/nfacct.c                             | 43 +++++++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..4c4ce88 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -19,6 +19,7 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FMT,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/src/nfacct.c b/src/nfacct.c
index 3f25334..e2f5a79 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -439,7 +439,9 @@ static int nfacct_cmd_add(int argc, char *argv[])
 {
 	int ret = -1;
 	bool replace = false;
+	bool b_fmt = false;
 	char *name;
+	uint16_t fmt = NFACCT_FMT_MAX;
 	struct nfacct *nfacct;
 
 	if (argc < 1 || strlen(argv[0]) == 0) {
@@ -455,6 +457,14 @@ static int nfacct_cmd_add(int argc, char *argv[])
 	while (argc > 0) {
 		if (!replace && nfacct_matches(argv[0],"replace")) {
 			replace = true;
+		} else if (!b_fmt && (nfacct_matches(argv[0],"format") ||
+			   nfacct_matches(argv[0],"fmt"))) {
+			NFACCT_GET_NEXT_ARG();
+			fmt = nfacct_parse_format_options(argv[0]);
+			if (fmt == NFACCT_FMT_MAX) {
+				NFACCT_RET_ARG_ERR();
+			}
+			b_fmt = true;
 		} else {
 			NFACCT_RET_ARG_ERR();
 		}
@@ -467,6 +477,10 @@ static int nfacct_cmd_add(int argc, char *argv[])
 	}
 
 	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
+
+	if (fmt != NFACCT_FMT_MAX)
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT, fmt);
+
 	ret = _nfacct_cmd_add(nfacct, replace);
 
 err:
@@ -749,7 +763,7 @@ static const char help_msg[] =
 	"Parameters:\n"
 	"  LST_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ]\n"
 			"\t\t[ sort SORT_SPEC ] [ xml ]\n"
-	"  ADD_PARAMS := [ replace ]\n"
+	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ]\n"
 	"  GET_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
@@ -838,10 +852,10 @@ err:
 
 /*
  * Maximum number of restore tokens accepted:
- * name= pkts= bytes=
+ * name= fmt= pkts= bytes=
  *
  */
-#define NFACCT_MAX_TOKENS 3
+#define NFACCT_MAX_TOKENS 4
 
 /*
  * Maximum number of value tokens accepted:
@@ -871,7 +885,8 @@ err:
 static int nfacct_cmd_restore(int argc, char *argv[])
 {
 	bool replace = false, flush = false;
-	bool b_name = false, b_pkts = false, b_bytes = false;
+	bool b_name = false, b_fmt = false, b_pkts = false, b_bytes = false;
+	uint16_t fmt = NFACCT_FMT_DEFAULT;
 	uint64_t pkts = 0, bytes = 0;
 	char *tokens[NFACCT_MAX_TOKENS + 1];
 	char *vtokens[NFACCT_MAX_VTOKENS + 1];
@@ -904,8 +919,9 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 		}
 	}
 
-	for (; fgets(buf, ARRAY_SIZE(buf), stdin); pkts = 0, bytes = 0,
-	     b_name = false, b_pkts = false, b_bytes = false, line++) {
+	for (; fgets(buf, ARRAY_SIZE(buf), stdin); fmt = NFACCT_FMT_DEFAULT,
+	     pkts = 0, bytes = 0, b_name = false, b_fmt = false,
+	     b_pkts = false, b_bytes = false, line++) {
 		ret = nfacct_parse_tokens(buf, " \n", NFACCT_MAX_TOKENS + 1,
 					  true, tokens);
 		if (ret == 0)
@@ -939,6 +955,17 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 				nfacct_attr_set(nfacct, NFACCT_ATTR_NAME,
 						vtokens[1]);
 				b_name = true;
+			} else if (!b_fmt && strncmp(vtokens[0], "fmt",
+						    strlen("fmt") + 1) == 0) {
+				fmt = nfacct_parse_format_options(vtokens[1]);
+				if (fmt == NFACCT_FMT_MAX) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'format' token (%s)",
+						vtokens[1]);
+				}
+				nfacct_attr_set_u16(nfacct,
+						    NFACCT_ATTR_FMT, fmt);
+				b_fmt = true;
 			} else if (!b_pkts && strncmp(vtokens[0], "pkts",
 						   strlen("pkts") + 1) == 0) {
 				if (nfacct_get_uint64_t(&pkts,
@@ -988,6 +1015,10 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 		}
 		NFACCT_FREE_TOKENS;
 
+		if (!b_fmt)
+			nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT,
+					    NFACCT_FMT_DEFAULT);
+
 		ret = _nfacct_cmd_add(nfacct, replace);
 		if (ret != 0) {
 			NFACCT_SNPRINTF("error on line %d: "
-- 
1.8.3.1

