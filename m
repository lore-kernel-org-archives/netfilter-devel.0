From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 nfacct 12/29] add variable width and on-the-fly number formatting
Date: Wed, 10 Jul 2013 19:25:10 +0100
Message-ID: <1373480727-11254-13-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61288 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3GJS0N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:13 -0400
Received: by mail-lb0-f180.google.com with SMTP id o10so5997062lbi.11
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:10 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* re-implement nfacct_cb callback function to make use of the new *_NUMONLY
linfnetfilter_acct template, allowing the maximum width of each column to be
determined in advance prior to printing the nfacct object properties. This
involves using a linked-list to store all nfacct objects temporarily.

* add a new "format" option to the "list" and "get" commands, allowing custom
number formatting to be applied to each of the nfacct object properties. More
than 14 different formats are available for use.

* add nfacct_tools.c file where all help functions are to be stored, thus avoid
cluttering the existing code unnecessarily.

* do some minor code re-factoring tweaks;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/Makefile.am    |   2 +-
 src/nfacct.c       | 279 +++++++++++++++++++++++++++++++++++++++--------------
 src/nfacct_list.h  |  91 +++++++++++++++++
 src/nfacct_utils.c | 242 ++++++++++++++++++++++++++++++++++++++++++++++
 src/nfacct_utils.h |  30 ++++++
 5 files changed, 572 insertions(+), 72 deletions(-)
 create mode 100644 src/nfacct_list.h
 create mode 100644 src/nfacct_utils.c
 create mode 100644 src/nfacct_utils.h

diff --git a/src/Makefile.am b/src/Makefile.am
index 28822fe..133ce61 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,6 +2,6 @@ include $(top_srcdir)/Make_global.am
 
 sbin_PROGRAMS = nfacct
 
-nfacct_SOURCES = nfacct.c
+nfacct_SOURCES = nfacct.c nfacct_utils.c
 
 nfacct_LDADD = ${LIBMNL_LIBS} ${LIBNETFILTER_ACCT_LIBS}
diff --git a/src/nfacct.c b/src/nfacct.c
index 7808ebb..aebb6ac 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -21,7 +21,52 @@
 #include <errno.h>
 
 #include <libmnl/libmnl.h>
-#include <libnetfilter_acct/libnetfilter_acct.h>
+#include "nfacct_list.h"
+#include "nfacct_utils.h"
+
+struct nfa {
+	struct nfacct *nfacct;
+	struct nfacct_list_head head;
+};
+
+/* store nfacct objects information */
+static NFACCT_LIST_HEAD(nfa_list);
+
+static struct nfa *nfa_alloc(void)
+{
+	return calloc(1, sizeof(struct nfa));
+}
+
+static void nfa_free(struct nfa *nfa)
+{
+	if (nfa)
+		free(nfa);
+}
+
+static void free_nfa_list(void) {
+	struct nfa *nfa, *nnfa;
+	nfacct_list_for_each_entry_safe(nfa, nnfa, &nfa_list, head) {
+		if (nfa->nfacct)
+			nfacct_free(nfa->nfacct);
+
+		nfa_free(nfa);
+	}
+}
+
+/* xml header & footer strings */
+#define NFACCT_XML_HEADER	"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" \
+				"<nfacct>\n"
+#define NFACCT_XML_FOOTER	"</nfacct>\n"
+
+/*
+ * maximum total of columns to be shown, except the
+ * "name" column as that is not width-dependent:
+ * "pkts bytes"
+ */
+#define NFACCT_MAX_COLUMNS 2
+
+/* stores nfacct options for snprintf_* and nfacct_cb functions */
+static struct nfacct_options *options;
 
 static int nfacct_cmd_list(int argc, char *argv[]);
 static int nfacct_cmd_add(int argc, char *argv[]);
@@ -32,21 +77,6 @@ static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
 static int nfacct_cmd_restore(int argc, char *argv[]);
 
-/* Matches two strings, including partial matches */
-static int nfacct_matches(const char *cmd, const char *pattern)
-{
-	size_t len;
-
-	if (cmd == NULL || pattern == NULL)
-		return 0;
-
-	len = strlen(cmd);
-	if (len == 0 || len > strlen(pattern))
-		return 0;
-
-	return (strncmp(cmd, pattern, len) == 0);
-}
-
 /* main command 'menu' */
 static const struct cmd {
 	const char *cmd;
@@ -98,6 +128,12 @@ static void nfacct_perror(const char *msg)
 #define NFACCT_RET_ERR(x)	nfacct_perror(x); \
 				goto err;
 #define NFACCT_RET_ARG_ERR()	NFACCT_RET_ERR("unknown argument")
+#define NFACCT_GET_NEXT_ARG() 	do {					\
+					argv++;				\
+					if (--argc <= 0) {		\
+						NFACCT_RET_ARG_ERR();	\
+					}				\
+				} while(0)
 #define NFACCT_NEXT_ARG() 	do {		\
 					argv++;	\
 					argc--;	\
@@ -115,39 +151,65 @@ int main(int argc, char *argv[])
 	usage(argv);
 }
 
-static bool xml_header = false;
-
 static int nfacct_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nfacct *nfacct;
-	char buf[4096];
-	bool *xml = (bool *)data;
+	struct nfa *nfa = NULL;
+	size_t bl[NFACCT_MAX_COLUMNS];
+	char buf[MAX_TOKEN_SIZE];
+	int i;
+	bool *ignore_col_width = (bool *)data;
+	static const enum nfacct_option_type o_num[NFACCT_MAX_COLUMNS] =
+				{ NFACCT_OPT_PCW,
+				  NFACCT_OPT_BCW,
+				};
+
+	if (ignore_col_width == NULL || options == NULL) {
+		NFACCT_RET_ERR("nfacct_cb_data_and_options");
+	}
+
+	nfa = nfa_alloc();
+	if (nfa == NULL) {
+		NFACCT_RET_ERR("OOM");
+	}
 
-	nfacct = nfacct_alloc();
-	if (nfacct == NULL) {
+	nfa->nfacct = nfacct_alloc();
+	if (nfa->nfacct == NULL) {
 		nfacct_perror("OOM");
-		goto err;
+		goto err_nfa_free;
 	}
 
-	if (nfacct_nlmsg_parse_payload(nlh, nfacct) < 0) {
+	if (nfacct_nlmsg_parse_payload(nlh, nfa->nfacct) < 0) {
 		nfacct_perror("nfacct_parse_nl_msg");
-		goto err_free;
+		goto err_nfacct_free;
 	}
 
-	if (*xml && !xml_header) {
-		printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
-			"<nfacct>\n");
-		xml_header = true;
+	if (!*ignore_col_width) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+			       NFACCT_SNPRINTF_T_PLAIN,
+				NFACCT_SNPRINTF_F_NUMONLY, options);
+		i = nfacct_parse_tokens_length(buf, " ", ARRAY_SIZE(bl),
+					       false, bl);
+		if (i < NFACCT_MAX_COLUMNS) {
+			nfacct_perror("nfacct_parse_tokens_length");
+			goto err_nfacct_free;
+		}
+		for (i = 0; i < NFACCT_MAX_COLUMNS; i++) {
+			if (bl[(i)] > nfacct_option_get_tsize(options,
+							       o_num[(i)]))
+				nfacct_option_set_tsize(options, o_num[(i)],
+							bl[i]);
+		}
 	}
+	nfacct_list_add_tail(&nfa->head, &nfa_list);
+	return MNL_CB_OK;
 
-	nfacct_snprintf(buf, sizeof(buf), nfacct,
-			*xml ? NFACCT_SNPRINTF_T_XML :
-			       NFACCT_SNPRINTF_T_PLAIN,
-			NFACCT_SNPRINTF_F_FULL);
-	printf("%s\n", buf);
+err_nfacct_free:
+	nfacct_free(nfa->nfacct);
+
+err_nfa_free:
+	nfa_free(nfa);
 
-err_free:
-	nfacct_free(nfacct);
 err:
 	return MNL_CB_OK;
 }
@@ -155,12 +217,15 @@ err:
 static int nfacct_cmd_list(int argc, char *argv[])
 {
 	bool nfnl_msg = false, xml = false;
+	bool b_fmt = false;
 	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
+	char buf[70000];
 	struct nlmsghdr *nlh;
 	unsigned int seq, portid;
-	int ret;
+	int ret = -1, i;
+	struct nfa *nfa = NULL;
 	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
+	uint16_t fmt = NFACCT_FMT_MAX;
 
 	while (argc > 0) {
 		if (!nfnl_msg && nfacct_matches(argv[0],"reset")) {
@@ -168,9 +233,16 @@ static int nfacct_cmd_list(int argc, char *argv[])
 			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
+		} else if (!b_fmt && (nfacct_matches(argv[0],"format") ||
+			   nfacct_matches(argv[0],"fmt"))) {
+			NFACCT_GET_NEXT_ARG();
+			fmt = nfacct_parse_format_options(argv[0]);
+			if (fmt == NFACCT_FMT_MAX) {
+				NFACCT_RET_ARG_ERR();
+			}
+			b_fmt = true;
 		} else {
-			nfacct_perror("unknown argument");
-			return -1;
+			NFACCT_RET_ARG_ERR();
 		}
 		argc--; argv++;
 	}
@@ -180,38 +252,60 @@ static int nfacct_cmd_list(int argc, char *argv[])
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-		nfacct_perror("mnl_socket_open");
-		return -1;
+		NFACCT_RET_ERR("mnl_socket_open");
 	}
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		nfacct_perror("mnl_socket_bind");
-		return -1;
+		NFACCT_RET_ERR("mnl_socket_bind");
 	}
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		nfacct_perror("mnl_socket_send");
-		return -1;
+		NFACCT_RET_ERR("mnl_socket_send");
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
-		if (ret <= 0)
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		NFACCT_RET_ERR("OOM");
+	}
+	nfacct_option_set_u16(options, NFACCT_OPT_FMT, fmt);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
+	while (i > 0) {
+		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
+		if (i <= 0)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
-	if (ret == -1) {
+	if (i == -1) {
 		nfacct_perror("error");
-		return -1;
+		goto err_free_nfa;
 	}
 	mnl_socket_close(nl);
 
-	if (xml_header)
-		printf("</nfacct>\n");
+	if (xml)
+		printf(NFACCT_XML_HEADER);
 
-	return 0;
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				xml ? NFACCT_SNPRINTF_T_XML :
+				      NFACCT_SNPRINTF_T_PLAIN,
+				NFACCT_SNPRINTF_F_FULL, options);
+		printf("%s\n",buf);
+	}
+
+	if (xml)
+		printf(NFACCT_XML_FOOTER);
+
+	ret = 0;
+
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
+err:
+	return ret;
 }
 
 static int _nfacct_cmd_add(struct nfacct *nfacct, bool replace)
@@ -376,14 +470,17 @@ static int nfacct_cmd_delete(int argc, char *argv[])
 static int nfacct_cmd_get(int argc, char *argv[])
 {
 	bool nfnl_msg = false, xml = false;
+	bool b_fmt = false;
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
 	struct nfacct *nfacct;
 	int ret = -1, i;
+	struct nfa *nfa = NULL;
 	char *name;
 	uint8_t nfnl_cmd = NFNL_MSG_ACCT_GET;
+	uint16_t fmt = NFACCT_FMT_MAX;
 
 	if (argc < 1 || strlen(argv[0]) == 0) {
 		nfacct_perror("missing object name");
@@ -401,6 +498,14 @@ static int nfacct_cmd_get(int argc, char *argv[])
 			nfnl_msg = true;
 		} else if (!xml && nfacct_matches(argv[0],"xml")) {
 			xml = true;
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
@@ -434,23 +539,46 @@ static int nfacct_cmd_get(int argc, char *argv[])
 		NFACCT_RET_ERR("mnl_socket_send");
 	}
 
-	i = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	options = nfacct_options_alloc();
+	if (options == NULL) {
+		NFACCT_RET_ERR("OOM");
+	}
+	nfacct_option_set_u16(options, NFACCT_OPT_FMT, fmt);
+
+	i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	while (i > 0) {
 		i = mnl_cb_run(buf, i, seq, portid, nfacct_cb, &xml);
 		if (i <= 0)
 			break;
-		i = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		i = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
 	if (i == -1) {
-		NFACCT_RET_ERR("error");
+		nfacct_perror("error");
+		goto err_free_nfa;
 	}
 	mnl_socket_close(nl);
 
-	if (xml_header)
-		printf("</nfacct>\n");
+	if (xml)
+		printf(NFACCT_XML_HEADER);
+
+	nfacct_list_for_each_entry(nfa, &nfa_list, head) {
+		nfacct_snprintf_with_options(buf, ARRAY_SIZE(buf),
+				nfa->nfacct,
+				xml ? NFACCT_SNPRINTF_T_XML :
+				      NFACCT_SNPRINTF_T_PLAIN,
+				NFACCT_SNPRINTF_F_FULL, options);
+		printf("%s\n",buf);
+	}
+
+	if (xml)
+		printf(NFACCT_XML_FOOTER);
 
 	ret = 0;
 
+err_free_nfa:
+	free_nfa_list();
+	nfacct_options_free(options);
+
 err:
 	free(name);
 	return ret;
@@ -489,12 +617,12 @@ static int nfacct_cmd_flush(int argc, char *argv[])
 		return -1;
 	}
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	ret = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	while (ret > 0) {
 		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
 		if (ret <= 0)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		ret = mnl_socket_recvfrom(nl, buf, ARRAY_SIZE(buf));
 	}
 	if (ret == -1) {
 		nfacct_perror("error");
@@ -527,14 +655,23 @@ static const char help_msg[] =
 	"infrastructure\n"
 	"Usage: nfacct command [parameters]...\n\n"
 	"Commands:\n"
-	"  list [reset]\t\t\tList the accounting object table (and reset)\n"
-	"  add object-name [replace]\tAdd new accounting object to table\n"
-	"  delete object-name\t\tDelete existing accounting object\n"
-	"  get object-name\t\tGet existing accounting object\n"
+	"  list LST_PARAMS\tList the accounting object table\n"
+	"  add NAME ADD_PARAMS\tAdd new accounting object NAME to table\n"
+	"  delete NAME\t\tDelete existing accounting object NAME\n"
+	"  get NAME GET_PARAMS\tGet and list existing accounting object NAME\n"
 	"  flush\t\t\tFlush accounting object table\n"
-	"  restore [flush] [replace]\tRestore accounting object table reading 'list' output from stdin\n"
-	"  version\t\t\tDisplay version and disclaimer\n"
-	"  help\t\t\t\tDisplay this help message\n";
+	"  restore RST_PARAMS\tRestore accounting object table from stdin\n"
+	"  version\t\tDisplay version and disclaimer\n"
+	"  help\t\t\tDisplay this help message\n\n"
+	"Parameters:\n"
+	"  LST_PARAMS := [ reset ] [ format FMT_SPEC ] [ xml ]\n"
+	"  ADD_PARAMS := [ replace ]\n"
+	"  GET_PARAMS := [ reset ] [ format FMT_SPEC ] [ xml ]\n"
+	"  RST_PARAMS := [ flush ] [ replace ]\n"
+	"  FMT_SPEC := { [FMT] | [,] | [FMT] ... }\n"
+	"  FMT := { def | raw | 3pl | iec | kib | mib | gib | tib | pib |"
+		  " eib |\n"
+	"  \t   si | kb | mb | gb | tb | pb | eb }\n";
 
 static int nfacct_cmd_help(int argc, char *argv[])
 {
diff --git a/src/nfacct_list.h b/src/nfacct_list.h
new file mode 100644
index 0000000..5ef1b9d
--- /dev/null
+++ b/src/nfacct_list.h
@@ -0,0 +1,91 @@
+/*
+ * 	Based on netlink/list.h
+ *	by Thomas Graf <tgraf@suug.ch>
+ *
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ */
+
+#ifndef _NFACCT_LIST_H_
+#define _NFACCT_LIST_H_
+
+struct nfacct_list_head
+{
+	struct nfacct_list_head *	next;
+	struct nfacct_list_head *	prev;
+};
+
+
+static inline void __nfacct_list_add(struct nfacct_list_head *obj,
+				 struct nfacct_list_head *prev,
+				 struct nfacct_list_head *next)
+{
+	prev->next = obj;
+	obj->prev = prev;
+	next->prev = obj;
+	obj->next = next;
+}
+
+static inline void nfacct_list_add_tail(struct nfacct_list_head *obj,
+					struct nfacct_list_head *head)
+{
+	__nfacct_list_add(obj, head->prev, head);
+}
+
+static inline void nfacct_list_add_head(struct nfacct_list_head *obj,
+					struct nfacct_list_head *head)
+{
+	__nfacct_list_add(obj, head, head->next);
+}
+
+static inline void nfacct_list_del(struct nfacct_list_head *obj)
+{
+	obj->next->prev = obj->prev;
+	obj->prev->next = obj->next;
+}
+
+static inline int nfacct_list_empty(struct nfacct_list_head *head)
+{
+	return head->next == head;
+}
+
+#define nfacct_container_of(ptr, type, member) ({			\
+        typeof( ((type *)0)->member ) *__mptr = (ptr);			\
+        (type *)( (char *)__mptr - ((size_t) &((type *)0)->member));})
+
+#define nfacct_list_entry(ptr, type, member) \
+	nfacct_container_of(ptr, type, member)
+
+#define nfacct_list_at_tail(pos, head, member) \
+	((pos)->member.next == (head))
+
+#define nfacct_list_at_head(pos, head, member) \
+	((pos)->member.prev == (head))
+
+#define NFACCT_LIST_HEAD(name) \
+	struct nfacct_list_head name = { &(name), &(name) }
+
+#define nfacct_list_for_each_entry(pos, head, member)			\
+	for (pos = nfacct_list_entry((head)->next,			\
+				     typeof(*pos), member);		\
+	     &(pos)->member != (head); 					\
+	     (pos) = nfacct_list_entry((pos)->member.next,		\
+				    typeof(*(pos)), member))
+
+#define nfacct_list_for_each_entry_safe(pos, n, head, member)		\
+	for (pos = nfacct_list_entry((head)->next,			\
+				  typeof(*pos), member),		\
+		n = nfacct_list_entry(pos->member.next,			\
+				   typeof(*pos), member);		\
+	     &(pos)->member != (head); 					\
+	     pos = n, n = nfacct_list_entry(n->member.next,		\
+					 typeof(*n), member))
+
+#define nfacct_init_list_head(head) \
+	do { (head)->next = (head); (head)->prev = (head); } while (0)
+
+#endif
+
diff --git a/src/nfacct_utils.c b/src/nfacct_utils.c
new file mode 100644
index 0000000..61b2ad5
--- /dev/null
+++ b/src/nfacct_utils.c
@@ -0,0 +1,242 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <limits.h>
+
+#include <libnetfilter_acct/libnetfilter_acct.h>
+
+#include "nfacct_utils.h"
+
+/* Matches two strings, including partial matches */
+int nfacct_matches(const char *cmd, const char *pattern)
+{
+	size_t len;
+
+	if (cmd == NULL || pattern == NULL)
+		return 0;
+
+	len = strlen(cmd);
+	if (len == 0 || len > strlen(pattern))
+		return 0;
+
+	return (strncmp(cmd, pattern, len) == 0);
+}
+
+/*
+ * Takes 'str' and breaks it in maximum of 'len' tokens, using 'sep'
+ * as separators, taking into account character escaping (\) and
+ * string quotation (e.g. "abc de"). Each token length is stored in 't_len'.
+ * The function returns the number of tokens actually processed.
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
+int nfacct_parse_tokens_length(const char *str, const char *sep, const size_t len,
+			   	const int skip_comment, size_t t_len[])
+{
+	bool quote_open = false, escaped = false;
+	static const char comment = '#';
+	size_t param_len = 0, i = 0;
+	char buf[MAX_TOKEN_SIZE], *ptr, *tmp;
+
+	if (str == NULL || strlen(str) == 0 || t_len == NULL ||
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
+			t_len[i] = strlen(buf);
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
+		t_len[i] = strlen(buf);
+		i++;
+	}
+
+err_free:
+	free(tmp);
+err:
+	return i;
+}
+
+/* maximum length of any format options */
+#define NFACCT_MAX_FMT_LEN 3
+
+/*
+ *
+ * Parses 'str' into a pair of nfacct_format values
+ * as defined in nfacct_fmt_keys and returns either
+ * 8bits:packet_fmt, 8bits:bytes_fmt or NFACCT_FMT_MAX if incorrect
+ * format was specified.
+ *
+ * N.B.:
+ *	1. "3pl" is the equivalent of "3pl,3pl";
+ *	2. ",3pl" is the equivalent of "def,3pl";
+ *	3. "3pl," is the equivalent of "3pl,def";
+ *	4. "," is the equivalent of "def,def";
+ *
+ */
+uint16_t nfacct_parse_format_options(const char *str)
+{
+	uint16_t ret = NFACCT_FMT_MAX;
+	size_t i = 0, j = 0, param_len = 0;
+	char buf[(NFACCT_MAX_FMT_LEN + 1) * 2], *ptr, *tmp;
+	enum nfacct_format fmt[2] = { NFACCT_FMT_MAX, NFACCT_FMT_MAX };
+
+	if (str == NULL || strlen(str) > ARRAY_SIZE(buf))
+		goto err;
+
+	tmp = strdup(str);
+	for (ptr = tmp; *ptr && i < ARRAY_SIZE(fmt); ptr++) {
+		if (strchr(",", *ptr)) {
+			if (!param_len) {
+				fmt[i] = NFACCT_FMT_DEFAULT;
+				i++;
+				continue;
+			}
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+
+			buf[param_len] = '\0';
+			for (j = NFACCT_FMT_DEFAULT;
+			     j <= NFACCT_FMT_MAX &&
+			     strncmp(buf, nfacct_fmt_keys[j],
+				strlen(nfacct_fmt_keys[j])+1) != 0; j++) {;}
+			if (j >= NFACCT_FMT_MAX) {
+				/* syntax error, exit */
+				goto err_free;
+			}
+
+			fmt[i] = j;
+			i++;
+			param_len = 0;
+		} else {
+			/* regular character, copy to buffer */
+			if (param_len >= ARRAY_SIZE(buf))
+				goto err_free;
+			buf[param_len++] = *ptr;
+		}
+	}
+	if (!param_len) {
+		fmt[i] = NFACCT_FMT_DEFAULT;
+	} else if (param_len < ARRAY_SIZE(buf)) {
+		buf[param_len] = '\0';
+		for (j = NFACCT_FMT_DEFAULT; j <= NFACCT_FMT_MAX &&
+		     strncmp(buf, nfacct_fmt_keys[j],
+				strlen(nfacct_fmt_keys[j])+1) != 0; j++) {;}
+
+		if (j >= NFACCT_FMT_MAX) {
+			/* syntax error, exit */
+			goto err_free;
+		}
+		fmt[i] = j;
+	}
+
+	if (fmt[0] == NFACCT_FMT_MAX)
+		fmt[0] = fmt[1];
+
+	if (fmt[1] == NFACCT_FMT_MAX)
+		fmt[1] = fmt[0];
+
+	ret = (fmt[0] << 8) | fmt[1];
+
+err_free:
+	free(tmp);
+	if (i > 2 || j >= NFACCT_FMT_MAX)
+		ret = NFACCT_FMT_MAX;
+err:
+	return ret;
+}
+
+/* converts 'arg' to 64-bit unsigned long long */
+int nfacct_get_uint64_t(uint64_t *val, const char *arg)
+{
+	unsigned long long res;
+	char *ptr;
+
+	if (!arg || !*arg || strchr(arg,'-') ||
+	    strlen(arg) == 0)
+		return -1;
+
+	errno = 0;
+	res = strtoull(arg, &ptr, 10);
+
+	/* empty string or trailing non-digits */
+	if (!ptr || ptr == arg || *ptr)
+		return -1;
+
+	/* overflow */
+	if (res == ULLONG_MAX && errno == ERANGE)
+		return -1;
+
+	/* in case ULL is 128 bits */
+	if (res > 0xFFFFFFFFFFFFFFFFULL)
+		return -1;
+
+	*val = res;
+	return 0;
+}
+
+
diff --git a/src/nfacct_utils.h b/src/nfacct_utils.h
new file mode 100644
index 0000000..56f6f33
--- /dev/null
+++ b/src/nfacct_utils.h
@@ -0,0 +1,30 @@
+/*
+ *	This library is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU Lesser General Public
+ *	License as published by the Free Software Foundation version 2.1
+ *	of the License.
+ *
+ */
+
+#ifndef _NFACCT_UTILS_H_
+#define _NFACCT_UTILS_H_
+
+#include <libnetfilter_acct/libnetfilter_acct.h>
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+#endif
+
+/* maximum length of a token */
+#define MAX_TOKEN_SIZE 256
+
+extern int nfacct_matches(const char *cmd, const char *pattern);
+extern int nfacct_parse_tokens_length(const char *str, const char *sep,
+				      const size_t len,
+				      const int skip_comment,
+				      size_t t_len[]);
+extern uint16_t nfacct_parse_format_options(const char *str);
+extern int nfacct_get_uint64_t(uint64_t *val, const char *arg);
+
+#endif
+
-- 
1.8.3.1

