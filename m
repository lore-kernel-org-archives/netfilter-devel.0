From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 21/29] add byte threshold capabilities to nfacct objects
Date: Wed, 10 Jul 2013 19:25:19 +0100
Message-ID: <1373480727-11254-22-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:59868 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3GJS0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:41 -0400
Received: by mail-lb0-f179.google.com with SMTP id w20so5876855lbh.24
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:39 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add support for storing byte threshold in nfacct objects permanently and
then reported if/when the value of bytes passing through the accounting object
exceeded it.

* alter the existing "add", "get" and "list" commands to take advantage of
this new feature.

* modify the existing "save" and "restore" commands to include that new
property.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/linux/netfilter/nfnetlink_acct.h | 10 +++++
 src/nfacct.c                             | 72 ++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 4c4ce88..5d64afa 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -19,11 +19,21 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_BTHR,
 	NFACCT_FMT,
+	NFACCT_FLAGS,
+	NFACCT_CMD,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+enum nfnl_acct_flags {
+	NFACCT_FLAG_BIT_BTHR 	= 0,
+	NFACCT_FLAG_BTHR	= (1 << NFACCT_FLAG_BIT_BTHR),
+	NFACCT_FLAG_BIT_MAX	= 1,
+	NFACCT_FLAG_MAX		= (1 << NFACCT_FLAG_BIT_MAX),
+};
+
 #ifdef __KERNEL__
 
 struct nf_acct;
diff --git a/src/nfacct.c b/src/nfacct.c
index e2f5a79..f2ece72 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -58,6 +58,7 @@ enum nfacct_sort_mode {
 	NFACCT_SORT_NAME,
 	NFACCT_SORT_PKTS,
 	NFACCT_SORT_BYTES,
+	NFACCT_SORT_BTHR,
 };
 
 static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list_head *b)
@@ -76,6 +77,9 @@ static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list
 				break;
 	case NFACCT_SORT_BYTES:
 				attr = NFACCT_ATTR_BYTES;
+				break;
+	case NFACCT_SORT_BTHR:
+				attr = NFACCT_ATTR_BTHR;
 	case NFACCT_SORT_NAME:
 				break;
 	default: /* unsorted */
@@ -104,9 +108,9 @@ static int nfacct_cmp(void *priv, struct nfacct_list_head *a, struct nfacct_list
 /*
  * maximum total of columns to be shown, except the
  * "name" column as that is not width-dependent:
- * "pkts bytes"
+ * "pkts bytes bthr"
  */
-#define NFACCT_MAX_COLUMNS 2
+#define NFACCT_MAX_COLUMNS 3
 
 /* stores nfacct options for snprintf_* and nfacct_cb functions */
 static struct nfacct_options *options;
@@ -206,6 +210,7 @@ static int nfacct_cb(const struct nlmsghdr *nlh, void *data)
 	static const enum nfacct_option_type o_num[NFACCT_MAX_COLUMNS] =
 				{ NFACCT_OPT_PCW,
 				  NFACCT_OPT_BCW,
+				  NFACCT_OPT_BTCW,
 				};
 
 	if (ignore_col_width == NULL || options == NULL) {
@@ -297,6 +302,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
 				sort_mode = NFACCT_SORT_PKTS;
 			} else if (nfacct_matches(argv[0],"bytes")) {
 				sort_mode = NFACCT_SORT_BYTES;
+			} else if (nfacct_matches(argv[0],"threshold")) {
+				sort_mode = NFACCT_SORT_BTHR;
 			} else if (nfacct_matches(argv[0],"none")) {
 				sort_mode = NFACCT_SORT_NONE;
 			} else {
@@ -438,10 +445,11 @@ static int _nfacct_cmd_add(struct nfacct *nfacct, bool replace)
 static int nfacct_cmd_add(int argc, char *argv[])
 {
 	int ret = -1;
-	bool replace = false;
+	bool replace = false, bthr_set = false;
 	bool b_fmt = false;
 	char *name;
-	uint16_t fmt = NFACCT_FMT_MAX;
+	uint16_t cmd = 0, flags = 0, fmt = NFACCT_FMT_MAX;
+	uint64_t bthr = 0;
 	struct nfacct *nfacct;
 
 	if (argc < 1 || strlen(argv[0]) == 0) {
@@ -465,6 +473,18 @@ static int nfacct_cmd_add(int argc, char *argv[])
 				NFACCT_RET_ARG_ERR();
 			}
 			b_fmt = true;
+		} else if (!bthr_set &&
+			   nfacct_matches(argv[0],"threshold")) {
+			NFACCT_GET_NEXT_ARG();
+			if (strncmp(argv[0], "-", 2) != 0) {
+				if (nfacct_get_uint64_t(&bthr,
+							argv[0]) != 0) {
+					NFACCT_RET_ARG_ERR();
+				}
+				flags |= NFACCT_FLAG_BTHR;
+			}
+			cmd |= NFACCT_FLAG_BTHR;
+			bthr_set = true;
 		} else {
 			NFACCT_RET_ARG_ERR();
 		}
@@ -481,6 +501,13 @@ static int nfacct_cmd_add(int argc, char *argv[])
 	if (fmt != NFACCT_FMT_MAX)
 		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT, fmt);
 
+	if (bthr_set) {
+		if (flags)
+			nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BTHR, bthr);
+
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FLAGS, flags);
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_CMD, cmd);
+	}
 	ret = _nfacct_cmd_add(nfacct, replace);
 
 err:
@@ -763,11 +790,12 @@ static const char help_msg[] =
 	"Parameters:\n"
 	"  LST_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ]\n"
 			"\t\t[ sort SORT_SPEC ] [ xml ]\n"
-	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ]\n"
+	"  ADD_PARAMS := [ replace ] [ format FMT_SPEC ] "
+			"[ threshold [NUMBER | '-'] ]\n"
 	"  GET_PARAMS := [ reset ] [ show bytes ] [ format FMT_SPEC ] [ xml ]\n"
 	"  RST_PARAMS := [ flush ] [ replace ]\n"
 	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
-	"  SORT_SPEC := { none | name | packets | bytes }"
+	"  SORT_SPEC := { none | name | packets | bytes | threshold }"
 	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib |"
 		  " eib |\n"
 	"  \t   si | kb | mb | gb | tb | pb | eb }\n";
@@ -852,10 +880,10 @@ err:
 
 /*
  * Maximum number of restore tokens accepted:
- * name= fmt= pkts= bytes=
+ * name= fmt= pkts= bytes= thr=
  *
  */
-#define NFACCT_MAX_TOKENS 4
+#define NFACCT_MAX_TOKENS 5
 
 /*
  * Maximum number of value tokens accepted:
@@ -886,8 +914,9 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 {
 	bool replace = false, flush = false;
 	bool b_name = false, b_fmt = false, b_pkts = false, b_bytes = false;
-	uint16_t fmt = NFACCT_FMT_DEFAULT;
-	uint64_t pkts = 0, bytes = 0;
+	bool b_thr = false;
+	uint16_t cmd = 0, fmt = NFACCT_FMT_DEFAULT;
+	uint64_t pkts = 0, bytes = 0, thr = 0;
 	char *tokens[NFACCT_MAX_TOKENS + 1];
 	char *vtokens[NFACCT_MAX_VTOKENS + 1];
 	char buf[MAX_TOKEN_SIZE];
@@ -920,8 +949,8 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 	}
 
 	for (; fgets(buf, ARRAY_SIZE(buf), stdin); fmt = NFACCT_FMT_DEFAULT,
-	     pkts = 0, bytes = 0, b_name = false, b_fmt = false,
-	     b_pkts = false, b_bytes = false, line++) {
+	     pkts = 0, bytes = 0, thr = 0, b_name = false, b_fmt = false,
+	     b_pkts = false, b_bytes = false, b_thr = false, line++) {
 		ret = nfacct_parse_tokens(buf, " \n", NFACCT_MAX_TOKENS + 1,
 					  true, tokens);
 		if (ret == 0)
@@ -988,6 +1017,18 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 				nfacct_attr_set_u64(nfacct,
 						    NFACCT_ATTR_BYTES, bytes);
 				b_bytes = true;
+			} else if (!b_thr && strncmp(vtokens[0], "thr",
+					   	strlen("thr") + 1) == 0) {
+				if (nfacct_get_uint64_t(&thr,
+						 vtokens[1]) != 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'thr' token (%s)",
+						vtokens[1]);
+				}
+				cmd |= NFACCT_FLAG_BTHR;
+				nfacct_attr_set_u64(nfacct,
+						    NFACCT_ATTR_BTHR, thr);
+				b_thr = true;
 			} else {
 				NFACCT_PRINT_VERR("error on line %d: "
 					  "invalid token '%s'", tokens[j]);
@@ -1007,7 +1048,8 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 					"invalid 'pkts' token (%s)",
 					"not set");
 		}
-		if (nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS) &&
+		if ((nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS) ||
+		     cmd & NFACCT_FLAG_BTHR) &&
 		    !nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES)) {
 			NFACCT_PRINT_CERR("error on line %d: "
 					"invalid 'bytes' token (%s)",
@@ -1015,6 +1057,10 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 		}
 		NFACCT_FREE_TOKENS;
 
+		if (cmd) {
+			nfacct_attr_set_u16(nfacct, NFACCT_ATTR_CMD, cmd);
+			nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FLAGS, cmd);
+		}
 		if (!b_fmt)
 			nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT,
 					    NFACCT_FMT_DEFAULT);
-- 
1.8.3.1

