From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 26/29] add setmark and clrmark to "get" and "list" commands
Date: Wed, 10 Jul 2013 19:25:24 +0100
Message-ID: <1373480727-11254-27-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58121 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab3GJS0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:53 -0400
Received: by mail-la0-f46.google.com with SMTP id eg20so6012652lab.5
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:52 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add "setmark" (to set a mark) and "clrmark" (to cleaar existing mark, if
present) options to the "get" and "list" commands. Setting a mark allows
short-term traffic to be reported via the pmark and bmark nfacct object
properties. If *any* traffic has passed through a given accounting object
since a mark has been placed, that is indicated with a plus (+) sign next to
the packet counters. The exact value of this traffic (i.e. how much traffic
has passed through since a "mark" was placed) could be shown using
"show extended" option.

* existing "save" and "restore" commands have been modofied to take into
account the new nfacct object properties and data integrity checks have
also been implemented.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/linux/netfilter/nfnetlink_acct.h |   8 ++-
 src/nfacct.c                             | 115 ++++++++++++++++++++++++++-----
 2 files changed, 104 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 5d64afa..ace3428 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,6 +10,8 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_GET_SETMARK,
+	NFNL_MSG_ACCT_GET_CLRMARK,
 	NFNL_MSG_ACCT_MAX
 };
 
@@ -23,6 +25,8 @@ enum nfnl_acct_type {
 	NFACCT_FMT,
 	NFACCT_FLAGS,
 	NFACCT_CMD,
+	NFACCT_PMARK,
+	NFACCT_BMARK,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
@@ -30,7 +34,9 @@ enum nfnl_acct_type {
 enum nfnl_acct_flags {
 	NFACCT_FLAG_BIT_BTHR 	= 0,
 	NFACCT_FLAG_BTHR	= (1 << NFACCT_FLAG_BIT_BTHR),
-	NFACCT_FLAG_BIT_MAX	= 1,
+	NFACCT_FLAG_BIT_MARK	= 1,
+	NFACCT_FLAG_MARK	= (1 << NFACCT_FLAG_BIT_MARK),
+	NFACCT_FLAG_BIT_MAX	= 2,
 	NFACCT_FLAG_MAX		= (1 << NFACCT_FLAG_BIT_MAX),
 };
 
diff --git a/src/nfacct.c b/src/nfacct.c
index 4504143..2cb0256 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -57,7 +57,9 @@ enum nfacct_sort_mode {
 	NFACCT_SORT_NONE = 0,
 	NFACCT_SORT_NAME,
 	NFACCT_SORT_PKTS,
+	NFACCT_SORT_PMARK,
 	NFACCT_SORT_BYTES,
+	NFACCT_SORT_BMARK,
 	NFACCT_SORT_BTHR,
 };
 
@@ -75,9 +77,15 @@ static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list
 	case NFACCT_SORT_PKTS:
 				attr = NFACCT_ATTR_PKTS;
 				break;
+	case NFACCT_SORT_PMARK:
+				attr = NFACCT_ATTR_PMARK;
+				break;
 	case NFACCT_SORT_BYTES:
 				attr = NFACCT_ATTR_BYTES;
 				break;
+	case NFACCT_SORT_BMARK:
+				attr = NFACCT_ATTR_BMARK;
+				break;
 	case NFACCT_SORT_BTHR:
 				attr = NFACCT_ATTR_BTHR;
 	case NFACCT_SORT_NAME:
@@ -108,9 +116,9 @@ static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list
 /*
  * maximum total of columns to be shown, except the
  * "name" column as that is not width-dependent:
- * "pkts bytes bthr"
+ * "pkts pmark bytes bmark bthr"
  */
-#define NFACCT_MAX_COLUMNS 3
+#define NFACCT_MAX_COLUMNS 5
 
 /* stores nfacct options for snprintf_* and nfacct_cb functions */
 static struct nfacct_options *options;
@@ -209,7 +217,9 @@ static int nfacct_cb(const struct nlmsghdr *nlh, void *data)
 	bool *ignore_col_width = (bool *)data;
 	static const enum nfacct_option_type o_num[NFACCT_MAX_COLUMNS] =
 				{ NFACCT_OPT_PCW,
+				  NFACCT_OPT_PMCW,
 				  NFACCT_OPT_BCW,
+				  NFACCT_OPT_BMCW,
 				  NFACCT_OPT_BTCW,
 				};
 
@@ -283,6 +293,12 @@ static int nfacct_cmd_list(int argc, char *argv[])
 		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
 			nfnl_cmd = NFNL_MSG_ACCT_GET_CTRZERO;
 			nfnl_msg = true;
+		} else if (!nfnl_msg && nfacct_matches(argv[0],"clrmark")) {
+			nfnl_cmd = NFNL_MSG_ACCT_GET_CLRMARK;
+			nfnl_msg = true;
+		} else if (!nfnl_msg && nfacct_matches(argv[0],"setmark")) {
+			nfnl_cmd = NFNL_MSG_ACCT_GET_SETMARK;
+			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
 		} else if (!b_sh && nfacct_matches(argv[0],"show")) {
@@ -302,8 +318,12 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			} else if (nfacct_matches(argv[0],"packets") ||
 				   nfacct_matches(argv[0],"pkts")) {
 				sort_mode = NFACCT_SORT_PKTS;
+			} else if (nfacct_matches(argv[0],"pmark")) {
+				sort_mode = NFACCT_SORT_PMARK;
 			} else if (nfacct_matches(argv[0],"bytes")) {
 				sort_mode = NFACCT_SORT_BYTES;
+			} else if (nfacct_matches(argv[0],"bmark")) {
+				sort_mode = NFACCT_SORT_BMARK;
 			} else if (nfacct_matches(argv[0],"threshold")) {
 				sort_mode = NFACCT_SORT_BTHR;
 			} else if (nfacct_matches(argv[0],"none")) {
@@ -613,6 +633,12 @@ static int nfacct_cmd_get(int argc, char *argv[])
 		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
 			nfnl_cmd = NFNL_MSG_ACCT_GET_CTRZERO;
 			nfnl_msg = true;
+		} else if (!nfnl_msg && nfacct_matches(argv[0],"clrmark")) {
+			nfnl_cmd = NFNL_MSG_ACCT_GET_CLRMARK;
+			nfnl_msg = true;
+		} else if (!nfnl_msg && nfacct_matches(argv[0],"setmark")) {
+			nfnl_cmd = NFNL_MSG_ACCT_GET_SETMARK;
+			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
 		} else if (!b_sh && nfacct_matches(argv[0],"show")) {
@@ -792,15 +818,17 @@ static const char help_msg[] =
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n\n"
 	"Parameters:\n"
-	"  LST_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ]\n"
-			"\t\t[ sort SORT_SPEC ] [ xml ]\n"
+	"  LST_PARAMS := [ reset | setmark | clrmark ] [ show SHOW_SPEC ]\n"
+			"\t\t[ format FMT_SPEC ] [ sort SORT_SPEC ] [ xml ]\n"
 	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ] "
 			"[ threshold [NUMBER | '-'] ]\n"
-	"  GET_PARAMS := [ reset ] [ show SHOW_SPEC ] [ format FMT_SPEC ] [ xml ]\n"
+	"  GET_PARAMS := [ reset | setmark | clrmark ] [ show SHOW_SPEC ]\n"
+			"\t\t[ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
 	"  SHOW_SPEC := { bytes | extended }\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
-	"  SORT_SPEC := { none | name | packets | bytes | threshold }"
+	"  SORT_SPEC := { none | name | packets | pmark | bytes | bmark |"
+			" threshold }\n"
 	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib |"
 		  " eib |\n"
 	"  \t   si | kb | mb | gb | tb | pb | eb }\n";
@@ -885,10 +913,10 @@ err:
 
 /*
  * Maximum number of restore tokens accepted:
- * name= fmt= pkts= bytes= thr=
+ * name= fmt= pkts= bytes= pmark= bmark= thr=
  *
  */
-#define NFACCT_MAX_TOKENS 5
+#define NFACCT_MAX_TOKENS 7
 
 /*
  * Maximum number of value tokens accepted:
@@ -919,9 +947,9 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 {
 	bool replace = false, flush = false;
 	bool b_name = false, b_fmt = false, b_pkts = false, b_bytes = false;
-	bool b_thr = false;
+	bool b_pmark = false, b_bmark = false, b_thr = false;
 	uint16_t cmd = 0, fmt = NFACCT_FMT_DEFAULT;
-	uint64_t pkts = 0, bytes = 0, thr = 0;
+	uint64_t pkts = 0, pmark = 0, bytes = 0, bmark = 0, thr = 0;
 	char *tokens[NFACCT_MAX_TOKENS + 1];
 	char *vtokens[NFACCT_MAX_VTOKENS + 1];
 	char buf[MAX_TOKEN_SIZE];
@@ -953,9 +981,11 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 		}
 	}
 
-	for (; fgets(buf, ARRAY_SIZE(buf), stdin); fmt = NFACCT_FMT_DEFAULT,
-	     pkts = 0, bytes = 0, thr = 0, b_name = false, b_fmt = false,
-	     b_pkts = false, b_bytes = false, b_thr = false, line++) {
+	for (; fgets(buf, ARRAY_SIZE(buf), stdin); cmd = 0,
+	     fmt = NFACCT_FMT_DEFAULT, pkts = 0, pmark = 0, bytes = 0,
+	     bmark = 0, thr = 0, b_name = false, b_fmt = false,
+	     b_pkts = false, b_bytes = false, b_pmark = false,
+	     b_bmark = false, b_thr = false, line++) {
 		ret = nfacct_parse_tokens(buf, " \n", NFACCT_MAX_TOKENS + 1,
 					  true, tokens);
 		if (ret == 0)
@@ -1022,6 +1052,30 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 				nfacct_attr_set_u64(nfacct,
 						    NFACCT_ATTR_BYTES, bytes);
 				b_bytes = true;
+			} else if (!b_pmark && strncmp(vtokens[0], "pmark",
+					         strlen("pmark") + 1) == 0) {
+				if (nfacct_get_uint64_t(&pmark,
+						 vtokens[1]) != 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'pmark' token (%s)",
+						vtokens[1]);
+				}
+				cmd |= NFACCT_FLAG_MARK;
+				nfacct_attr_set_u64(nfacct,
+						    NFACCT_ATTR_PMARK, pmark);
+				b_pmark = true;
+			} else if (!b_bmark && strncmp(vtokens[0], "bmark",
+					         strlen("bmark") + 1) == 0) {
+				if (nfacct_get_uint64_t(&bmark,
+						 vtokens[1]) != 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'bmark' token (%s)",
+						vtokens[1]);
+				}
+				cmd |= NFACCT_FLAG_MARK;
+				nfacct_attr_set_u64(nfacct,
+						    NFACCT_ATTR_BMARK, bmark);
+				b_bmark = true;
 			} else if (!b_thr && strncmp(vtokens[0], "thr",
 					   	strlen("thr") + 1) == 0) {
 				if (nfacct_get_uint64_t(&thr,
@@ -1047,19 +1101,44 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 					"invalid 'name' token (%s)",
 					"not set");
 		}
-		if (nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES) &&
-		    !nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS)) {
+		if ((nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES) &&
+		     !nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS)) ||
+		    (cmd & NFACCT_FLAG_MARK &&
+		     !nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS))) {
 			NFACCT_PRINT_CERR("error on line %d: "
 					"invalid 'pkts' token (%s)",
 					"not set");
 		}
-		if ((nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS) ||
-		     cmd & NFACCT_FLAG_BTHR) &&
-		    !nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES)) {
+		if ((nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS) &&
+		    !nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES)) ||
+		    ((cmd & NFACCT_FLAG_BTHR || cmd & NFACCT_FLAG_MARK) &&
+		    !nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES))) {
 			NFACCT_PRINT_CERR("error on line %d: "
 					"invalid 'bytes' token (%s)",
 					"not set");
 		}
+		if (cmd & NFACCT_FLAG_MARK) {
+			if (!nfacct_attr_get(nfacct, NFACCT_ATTR_PMARK)) {
+				NFACCT_PRINT_CERR("error on line %d: "
+						"invalid 'pmark' token (%s)",
+						"not set");
+			}
+			if (!nfacct_attr_get(nfacct, NFACCT_ATTR_BMARK)) {
+				NFACCT_PRINT_CERR("error on line %d: "
+						"invalid 'bmark' token (%s)",
+						"not set");
+			}
+			if (pmark > pkts) {
+				NFACCT_PRINT_CERR("error on line %d: "
+						"invalid 'pmark' token (%s)",
+						"> 'pkts'");
+			}
+			if (bmark > bytes) {
+				NFACCT_PRINT_CERR("error on line %d: "
+						"invalid 'bmark' token (%s)",
+						"> 'bytes'");
+			}
+		}
 		NFACCT_FREE_TOKENS;
 
 		if (cmd) {
-- 
1.8.3.1

