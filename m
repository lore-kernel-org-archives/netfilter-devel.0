From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 13/29] add new "save" and correct existing "restore" commands
Date: Wed, 10 Jul 2013 19:25:11 +0100
Message-ID: <1373480727-11254-14-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3GJS0P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:15 -0400
Received: by mail-lb0-f174.google.com with SMTP id x10so6011226lbi.19
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:13 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a new "save" command, which allows nfacct object list to be printed in a
format suitable for use by "restore". All nfacct object properties are shown
as name=value pairs, allowing for flexibility with further (properties)
expansion as the order in which these properties are specified is not
important. Account object names are properly quoted, when necessary. Allow
comments (lines starting with "#") and blank lines to be ommitted from
processing;

* change the existing "restore" command to make a good use of the new format
used by "save" and implement proper data integrity checks prior to adding
nfacct objects. Implement proper error reporting, giving additional
information, like line number, nature of the error occured and so on;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/nfacct.c       | 229 +++++++++++++++++++++++++++++++++++++++++++++++------
 src/nfacct_utils.c |  91 +++++++++++++++++++++
 src/nfacct_utils.h |   3 +
 3 files changed, 300 insertions(+), 23 deletions(-)

diff --git a/src/nfacct.c b/src/nfacct.c
index aebb6ac..c778d1c 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -76,6 +76,7 @@ static int nfacct_cmd_flush(int argc, char *argv[]);
 static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
 static int nfacct_cmd_restore(int argc, char *argv[]);
+static int nfacct_cmd_save(int argc, char *argv[]);
 
 /* main command 'menu' */
 static const struct cmd {
@@ -87,6 +88,7 @@ static const struct cmd {
 	{ "delete",	nfacct_cmd_delete },
 	{ "get",	nfacct_cmd_get },
 	{ "flush",	nfacct_cmd_flush },
+	{ "save",	nfacct_cmd_save },
 	{ "restore",	nfacct_cmd_restore },
 	{ "version",	nfacct_cmd_version },
 	{ "help",	nfacct_cmd_help },
@@ -660,6 +662,7 @@ static const char help_msg[] =
 	"  delete NAME\t\tDelete existing accounting object NAME\n"
 	"  get NAME GET_PARAMS\tGet and list existing accounting object NAME\n"
 	"  flush\t\t\tFlush accounting object table\n"
+	"  save\t\t\tDump current accounting object table to stdout\n"
 	"  restore RST_PARAMS\tRestore accounting object table from stdin\n"
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n\n"
@@ -679,13 +682,119 @@ static int nfacct_cmd_help(int argc, char *argv[])
 	return 0;
 }
 
+static int nfacct_cmd_save(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	unsigned int seq, portid;
+	int ret = -1, i;
+	bool ignore_width = true;
+	struct nfa *nfa = NULL;
+
+	if (argc > 0) {
+		NFACCT_RET_ERR("too many arguments");
+	}
+	seq = time(NULL);
+	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_GET,
+				     NLM_F_DUMP, seq);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		NFACCT_RET_ERR("mnl_socket_open");
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		NFACCT_RET_ERR("mnl_socket_bind");
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		NFACCT_RET_ERR("mnl_socket_send");
+	}
+
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		NFACCT_RET_ERR("OOM");
+	}
+	nfacct_option_set_u16(options, NFACCT_OPT_FMT, NFACCT_FMT_MAX);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	while (i > 0) {
+		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb,
+				&ignore_width);
+		if (i <= 0)
+			break;
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	}
+	if (i == -1) {
+		nfacct_perror("error");
+		goto err_free_nfa;
+	}
+	mnl_socket_close(nl);
+
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				NFACCT_SNPRINTF_T_PLAIN,
+				NFACCT_SNPRINTF_F_SAVE, options);
+		printf("%s\n",buf);
+	}
+
+	ret = 0;
+
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
+err:
+	return ret;
+}
+
+/*
+ * Maximum number of restore tokens accepted:
+ * name= pkts= bytes=
+ *
+ */
+#define NFACCT_MAX_TOKENS 3
+
+/*
+ * Maximum number of value tokens accepted:
+ * t_name=t_value
+ *
+ */
+#define NFACCT_MAX_VTOKENS 2
+
+#define NFACCT_FREE_TOKENS 	for (i = 0; i < ret; i++) \
+				free(tokens[i]);
+
+#define NFACCT_FREE_VTOKENS 	for (n = 0; n < vret; n++) \
+				free(vtokens[n]);
+
+#define NFACCT_SNPRINTF(x,y)	snprintf(err_str,ARRAY_SIZE(err_str), \
+					 x,line,y);
+
+#define NFACCT_PRINT_VERR(x,y)	NFACCT_SNPRINTF(x,y);	\
+				goto err_free_vtokens;
+
+#define NFACCT_PRINT_CERR(x,y)	NFACCT_SNPRINTF(x,y);	\
+				goto err_free_nfacct;
+
+#define NFACCT_PRINT_ERR(x,y)	NFACCT_SNPRINTF(x,y);	\
+				goto err_free_tokens;
+
 static int nfacct_cmd_restore(int argc, char *argv[])
 {
-	uint64_t pkts, bytes;
-	char name[512];
-	char buffer[512];
-	int ret;
 	bool replace = false, flush = false;
+	bool b_name = false, b_pkts = false, b_bytes = false;
+	uint64_t pkts = 0, bytes = 0;
+	char *tokens[NFACCT_MAX_TOKENS + 1];
+	char *vtokens[NFACCT_MAX_VTOKENS + 1];
+	char buf[MAX_TOKEN_SIZE];
+	char err_str[80];
+	int line = 1;
+	int i, j, n;
+	int ret, vret;
 	struct nfacct *nfacct;
 
 	if (argc > 2) {
@@ -710,35 +819,109 @@ static int nfacct_cmd_restore(int argc, char *argv[])
 		}
 	}
 
-	while (fgets(buffer, sizeof(buffer), stdin)) {
-		char *semicolon = strchr(buffer, ';');
-		if (semicolon == NULL) {
-			nfacct_perror("invalid line");
-			return -1;
-		}
-		*semicolon = 0;
-		ret = sscanf(buffer,
-			     "{ pkts = %"PRIu64", bytes = %"PRIu64" } = %s",
-		       &pkts, &bytes, name);
-		if (ret != 3) {
-			nfacct_perror("error reading input");
-			return -1;
+	for (; fgets(buf, ARRAY_SIZE(buf), stdin); pkts = 0, bytes = 0,
+	     b_name = false, b_pkts = false, b_bytes = false, line++) {
+		ret = nfacct_parse_tokens(buf, " \n", NFACCT_MAX_TOKENS + 1,
+					  true, tokens);
+		if (ret == 0)
+			continue;
+
+		if (ret > NFACCT_MAX_TOKENS) {
+			NFACCT_PRINT_ERR("error on line %d: " 
+					 "%d tokens retrieved", ret);
 		}
+
 		nfacct = nfacct_alloc();
 		if (nfacct == NULL) {
-			NFACCT_RET_ERR("OOM error");
+			NFACCT_PRINT_ERR("error on line %d: " 
+					 "OOM error.%s","");
+		}
+		for (j = 0; j < ret; j++) {
+			vret = nfacct_parse_tokens(tokens[j], "=",
+						   NFACCT_MAX_VTOKENS + 1,
+						   false, vtokens);
+			if (vret != NFACCT_MAX_VTOKENS) {
+				NFACCT_PRINT_VERR("error on line %d: "
+					  "invalid token '%s'", tokens[j]);
+			}
+			if (!b_name && strncmp(vtokens[0], "name",
+				    strlen("name") + 1) == 0) {
+				if (strlen(vtokens[1]) == 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+					"invalid 'name' token (%s)",
+					"not set");
+				}
+				nfacct_attr_set(nfacct, NFACCT_ATTR_NAME,
+						vtokens[1]);
+				b_name = true;
+			} else if (!b_pkts && strncmp(vtokens[0], "pkts",
+						   strlen("pkts") + 1) == 0) {
+				if (nfacct_get_uint64_t(&pkts,
+							vtokens[1]) != 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'pkts' token (%s)",
+						vtokens[1]);
+				}
+				nfacct_attr_set_u64(nfacct,
+						    NFACCT_ATTR_PKTS, pkts);
+				b_pkts = true;
+			} else if (!b_bytes && strncmp(vtokens[0], "bytes",
+					         strlen("bytes") + 1) == 0) {
+				if (nfacct_get_uint64_t(&bytes,
+						 vtokens[1]) != 0) {
+					NFACCT_PRINT_VERR("error on line %d: "
+						"invalid 'bytes' token (%s)",
+						vtokens[1]);
+				}
+				nfacct_attr_set_u64(nfacct,
+						    NFACCT_ATTR_BYTES, bytes);
+				b_bytes = true;
+			} else {
+				NFACCT_PRINT_VERR("error on line %d: "
+					  "invalid token '%s'", tokens[j]);
+			}
+			NFACCT_FREE_VTOKENS;
 		}
-		nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, name);
-		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
-		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
+
+		/* Final integrity checks before adding */
+		if (!nfacct_attr_get(nfacct, NFACCT_ATTR_NAME)) {
+			NFACCT_PRINT_CERR("error on line %d: "
+					"invalid 'name' token (%s)",
+					"not set");
+		}
+		if (nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES) &&
+		    !nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS)) {
+			NFACCT_PRINT_CERR("error on line %d: "
+					"invalid 'pkts' token (%s)",
+					"not set");
+		}
+		if (nfacct_attr_get(nfacct, NFACCT_ATTR_PKTS) &&
+		    !nfacct_attr_get(nfacct, NFACCT_ATTR_BYTES)) {
+			NFACCT_PRINT_CERR("error on line %d: "
+					"invalid 'bytes' token (%s)",
+					"not set");
+		}
+		NFACCT_FREE_TOKENS;
+
 		ret = _nfacct_cmd_add(nfacct, replace);
 		if (ret != 0) {
-			NFACCT_RET_ERR("error during add");
+			NFACCT_SNPRINTF("error on line %d: "
+					"element not added%s","");
+			return -1;
 		}
-
 	}
 	return 0;
 
+err_free_vtokens:
+	NFACCT_FREE_VTOKENS;
+
+err_free_nfacct:
+	nfacct_free(nfacct);
+
+err_free_tokens:
+	NFACCT_FREE_TOKENS;
+	nfacct_perror(err_str);
+
 err:
 	return -1;
 }
diff --git a/src/nfacct_utils.c b/src/nfacct_utils.c
index 61b2ad5..96cc811 100644
--- a/src/nfacct_utils.c
+++ b/src/nfacct_utils.c
@@ -33,6 +33,97 @@ int nfacct_matches(const char *cmd, const char *pattern)
 /*
  * Takes 'str' and breaks it in maximum of 'len' tokens, using 'sep'
  * as separators, taking into account character escaping (\) and
+ * string quotation (e.g. "abc de"). Each token is stored in 'tokens'.
+ * The function returns the number of tokens actually processed and stored.
+ *
+ * N.B.:
+ *	1. Character escaping is NOT translated/taken into account. In
+ *	   other words, "\t" translates to "t".
+ *	2. If skip_comment=true and if 'str' starts with 'comment',
+ *	   then the parsing is skipped and nothing is returned.
+ *	3. It is assumed that each resulting token is no more than
+ *	   MAX_TOKEN_SIZE characters.
+ *
+ */
+int nfacct_parse_tokens(const char *str, const char *sep, const size_t len,
+			const int skip_comment, char *tokens[])
+{
+	bool quote_open = false, escaped = false;
+	size_t param_len = 0, i = 0;
+	static const char comment = '#';
+	char buf[MAX_TOKEN_SIZE], *ptr, *tmp;
+
+	if (str == NULL || strlen(str) == 0 || tokens == NULL ||
+	    sep == NULL || strlen(sep) == 0 ||
+	    (skip_comment && strchr(str, comment) != NULL &&
+	     *strchr(str, comment) == str[0]))
+		goto err;
+
+	tmp = strdup(str);
+	for (ptr = tmp; *ptr; ptr++) {
+		if (quote_open) {
+			if (escaped) {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				escaped = false;
+				continue;
+			} else if (*ptr == '\\') {
+				escaped = true;
+				continue;
+			} else if (*ptr == '"') {
+				quote_open = false;
+				*ptr = *sep;
+			} else {
+				if (param_len >= ARRAY_SIZE(buf))
+					goto err_free;
+				buf[param_len++] = *ptr;
+				continue;
+			}
+		} else {
+			if (*ptr == '"') {
+				quote_open = true;
+				continue;
+			}
+		}
+		if (strchr(sep, *ptr)) {
+			if (!param_len)
+				continue;
+
+			if (!param_len || i >= len ||
+			    param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+
+			buf[param_len] = '\0';
+			tokens[i] = strdup(buf);
+			i++;
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+			buf[param_len++] = *ptr;
+		}
+	}
+
+	if (escaped || quote_open || !param_len || i >= len)
+		goto err_free;
+
+	if (param_len && param_len < ARRAY_SIZE(buf)) {
+		buf[param_len] = '\0';
+		tokens[i] = strdup(buf);
+		i++;
+	}
+
+err_free:
+	free(tmp);
+err:
+	return i;
+}
+
+/*
+ * Takes 'str' and breaks it in maximum of 'len' tokens, using 'sep'
+ * as separators, taking into account character escaping (\) and
  * string quotation (e.g. "abc de"). Each token length is stored in 't_len'.
  * The function returns the number of tokens actually processed.
  *
diff --git a/src/nfacct_utils.h b/src/nfacct_utils.h
index 56f6f33..d9c5bb7 100644
--- a/src/nfacct_utils.h
+++ b/src/nfacct_utils.h
@@ -19,6 +19,9 @@
 #define MAX_TOKEN_SIZE 256
 
 extern int nfacct_matches(const char *cmd, const char *pattern);
+extern int nfacct_parse_tokens(const char *str, const char *sep,
+				const size_t len, const int skip_comment,
+				char *tokens[]);
 extern int nfacct_parse_tokens_length(const char *str, const char *sep,
 				      const size_t len,
 				      const int skip_comment,
-- 
1.8.3.1

