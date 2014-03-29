From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd RFC PATCH 1/2] sprint: introduce new output plugin
Date: Sat, 29 Mar 2014 13:27:16 +0900
Message-ID: <20140329042716.GB22821@gmail.com>
References: <20140329042336.GA22821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54819 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaC2E1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:27:24 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so5656561pdj.31
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 21:27:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140329042336.GA22821@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a new string output plugin. The output string can be
specified by "form" in config file. Format is consists of:

    key: struct ulogd_key name enclosed by <>, e.g. <orig.ip.saddr.str>
    group: enclosed by () and separated by |, pick first one if exists.
        (<orig.l4.dport>|<icmp.type>|unknown) means
        pick orig.l4.dport value if exist, or icmp.type value. if both
        of them do not exist, select "unknown" string.
    +: add two key value if it can be
    anything else: as is

meta character <>()|+\ needs to be escaped by \. Sink can be specified by
"proto" and "dest" in config file. "proto" is either file, tcp and udp.
"dest" is file name if "proto" is file, or port@address in tcp or udp.

More patch is needed to work, I think this will be suited for graphite and
statsd to see whole of traffic.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 configure.ac                                |  15 +-
 output/Makefile.am                          |   2 +-
 output/sprint/Makefile.am                   |  21 ++
 output/sprint/ulogd_output_SPRINT-parser.y  | 358 ++++++++++++++++++++
 output/sprint/ulogd_output_SPRINT-scanner.l | 112 +++++++
 output/sprint/ulogd_output_SPRINT.c         | 495 ++++++++++++++++++++++++++++
 output/sprint/ulogd_output_SPRINT.h         |  45 +++
 7 files changed, 1046 insertions(+), 2 deletions(-)
 create mode 100644 output/sprint/Makefile.am
 create mode 100644 output/sprint/ulogd_output_SPRINT-parser.y
 create mode 100644 output/sprint/ulogd_output_SPRINT-scanner.l
 create mode 100644 output/sprint/ulogd_output_SPRINT.c
 create mode 100644 output/sprint/ulogd_output_SPRINT.h

diff --git a/configure.ac b/configure.ac
index 544a256..8ab2b27 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,8 @@ dnl Checks for programs.
 AC_PROG_MAKE_SET
 AC_PROG_CC
 AC_PROG_INSTALL
+AC_PROG_YACC
+AC_PROG_LEX
 AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
@@ -128,6 +130,16 @@ else
 	enable_jansson="no"
 fi
 
+AC_ARG_WITH([sprint], AS_HELP_STRING([--without-sprint], [Build without SPRINT output plugin [default=test]]))
+AS_IF([test "x$with_sprint" != "xno"], [
+if test "x$LEX" = "xflex" -a "x$YACC" = "xbison -y"; then
+	enable_sprint="yes"
+else
+	enable_sprint="no"
+fi
+])
+AM_CONDITIONAL([BUILD_SPRINT], [test "x$enable_sprint" = "xyes"])
+
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
 dnl AC_SUBST(DATABASE_LIB_DIR)
@@ -147,7 +159,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  input/sum/Makefile \
 	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
-	  output/dbi/Makefile \
+	  output/dbi/Makefile output/sprint/Makefile \
 	  src/Makefile Makefile Rules.make)
 AC_OUTPUT
 
@@ -164,5 +176,6 @@ Ulogd configuration:
     SQLITE3 plugin:			${enable_sqlite3}
     DBI plugin:				${enable_dbi}
     JSON plugin:			${enable_jansson}
+    SPRINT plugin:			${enable_sprint}
 "
 echo "You can now run 'make' and 'make install'"
diff --git a/output/Makefile.am b/output/Makefile.am
index ff851ad..7a39150 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -2,7 +2,7 @@ AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS} \
               ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
-SUBDIRS= pcap mysql pgsql sqlite3 dbi
+SUBDIRS= pcap mysql pgsql sqlite3 dbi sprint
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
diff --git a/output/sprint/Makefile.am b/output/sprint/Makefile.am
new file mode 100644
index 0000000..90cbb34
--- /dev/null
+++ b/output/sprint/Makefile.am
@@ -0,0 +1,21 @@
+AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CFLAGS = ${regular_CFLAGS}
+AM_YFLAGS = -d
+#AM_LFLAGS = --header-file=scanner.h
+
+if BUILD_SPRINT
+
+pkglib_LTLIBRARIES = ulogd_output_SPRINT.la
+
+ulogd_output_SPRINT_la_SOURCES = ulogd_output_SPRINT.c ulogd_output_SPRINT-scanner.l ulogd_output_SPRINT-parser.y
+ulogd_output_SPRINT_la_LDFLAGS = -avoid-version -module
+# ulogd_output_SPRINT_la_LFLAGS =  --header-file=scanner.h
+
+BUILT_SOURCES = ulogd_output_SPRINT-parser.h ulogd_output_SPRINT-parser.c \
+		ulogd_output_SPRINT-scanner.h ulogd_output_SPRINT-scanner.c
+CLEANFILES = $(BUILT_SOURCES)
+
+ulogd_output_SPRINT-scanner.h: ulogd_output_SPRINT-scanner.l
+	$(LEX) -o /dev/null --header-file=$@ $<
+
+endif
diff --git a/output/sprint/ulogd_output_SPRINT-parser.y b/output/sprint/ulogd_output_SPRINT-parser.y
new file mode 100644
index 0000000..83f5af9
--- /dev/null
+++ b/output/sprint/ulogd_output_SPRINT-parser.y
@@ -0,0 +1,358 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+%{
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdarg.h>
+#include <string.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/linuxlist.h>
+#include "ulogd_output_SPRINT.h"
+#include "ulogd_output_SPRINT-scanner.h"
+
+static int yyerror(YYLTYPE *loc, yyscan_t scanner, const char *msg, ...);
+
+static struct node *sprint_string_node(char *string)
+{
+	struct node *node = calloc(sizeof(struct node), 1);
+
+	if (node == NULL)
+		return NULL;
+
+	node->type = NODE_STRING;
+	node->string = string;
+
+	return node;
+}
+
+static int sprint_key_index(struct outform *form, char *name)
+{
+	struct keysym *cur;
+	int i = 0;
+
+	llist_for_each_entry(cur, &form->keysyms, list) {
+		if (!strcmp(cur->name, name))
+			return i;
+		i++;
+	}
+
+	return -1;
+}
+
+static struct node *sprint_key_node(struct outform *form, char *name)
+{
+	struct node *node;
+	struct keysym *sym;
+
+	if (strlen(name) > ULOGD_MAX_KEYLEN) {
+		ulogd_log(ULOGD_ERROR, "too long key: %s\n", name);
+		return NULL;
+	}
+
+	node = calloc(sizeof(struct node), 1);
+	if (node == NULL)
+		return NULL;
+
+	node->type = NODE_KEY;
+	node->kindex = sprint_key_index(form, name);
+	if (node->kindex < 0) {
+		sym = calloc(sizeof(struct keysym), 1);
+		if (sym == NULL) {
+			free(node);
+			return NULL;
+		}
+		sym->name = name;
+		node->kindex = form->num_keys++;
+		llist_add_tail(&sym->list, &form->keysyms);
+	}
+
+	return node;
+}
+
+static struct node *sprint_list_node(enum sprint_node_type type, struct node *term)
+{
+	struct node *node = calloc(sizeof(struct node), 1);
+
+	if (node == NULL)
+		return NULL;
+
+	node->type = type;
+	INIT_LLIST_HEAD(&node->group);
+	llist_add_tail(&term->list, &node->group);
+	return node;
+}
+
+static struct node *sprint_group_add(struct node *group, struct node *term)
+{
+	llist_add_tail(&term->list, &group->group);
+	return group;
+}
+
+static struct node *sprint_keycalc_node(int opcode, struct node *l, struct node *r)
+{
+	struct node *node = calloc(sizeof(struct node), 1);
+
+	if (node == NULL)
+		return NULL;
+
+	node->type = NODE_KEYCALC;
+	node->keycalc.opcode = opcode;
+	node->keycalc.l = l;
+	node->keycalc.r = r;
+
+	return node;
+}
+%}
+
+%code requires {
+	#ifndef YY_TYPEDEF_YY_SCANNER_T
+	#define YY_TYPEDEF_YY_SCANNER_T
+	typedef void* yyscan_t;
+	#endif
+
+	#ifndef YY_TYPEDEF_YY_BUFFER_STATE
+	#define YY_TYPEDEF_YY_BUFFER_STATE
+	typedef struct yy_buffer_state *YY_BUFFER_STATE;
+	#endif
+}
+
+%debug
+%pure-parser
+%lex-param { scanner }
+%parse-param { yyscan_t scanner }
+%error-verbose
+%locations
+
+%union {
+	char *string;
+	struct node *node;
+}
+
+%token <string> STRING
+%token <string> KEY
+%token <string> ERR_TERM /* just notifying from scanner */
+
+%type <node> form part selector group term key
+
+%%
+
+form:
+	  /* empty */		{
+		$$ = &(yyget_extra(scanner))->head;
+	  }
+	| form part		{
+		llist_add_tail(&$2->list, &$1->list);
+		$$ = $1;
+	  }
+	;
+
+part:
+	  term
+	| group
+	;
+
+group:
+	  '(' selector ')'	{
+		$$ = $2;
+	  }
+	;
+
+selector:
+	  term			{
+		$$ = sprint_list_node(NODE_GROUP, $1);
+		if ($$ == NULL) {
+			yyerror(&yylloc, scanner, "could not create group node");
+			YYABORT;
+		}
+	  }
+	| selector '|' term	{
+		$$ = sprint_group_add($1, $3);
+	  }
+	;
+
+term:
+	  key
+	| STRING		{
+		$$ = sprint_string_node($1);
+		if ($$ == NULL) {
+			yyerror(&yylloc, scanner, "could not create string node");
+			YYABORT;
+		}
+	  }
+	| term key		{
+		if ($1->type != NODE_CONCAT) {
+			$1 = sprint_list_node(NODE_CONCAT, $1);
+			if ($1 == NULL) {
+				yyerror(&yylloc, scanner, "could not concat term");
+				YYABORT;
+			}
+		}
+		$$ = sprint_group_add($1, $2);
+	  }
+	| term STRING		{
+		if ($1->type == NODE_STRING) { /* concat string by using realloc */
+			int len1 = strlen($1->string), len2 = strlen($2);
+			$1->string = realloc($1->string, len1 + len2);
+			if ($1->string == NULL) {
+				yyerror(&yylloc, scanner, "could not reallocate string area");
+				YYABORT;
+			}
+			strncpy($1->string + len1, $2, len2);
+		} else {
+			struct node *n = sprint_string_node($2);
+			if ($1->type != NODE_CONCAT) {
+				$1 = sprint_list_node(NODE_CONCAT, $1);
+				if ($1 == NULL) {
+					yyerror(&yylloc, scanner, "could not concat term\n");
+					YYABORT;
+				}
+			}
+			$$ = sprint_group_add($1, n);
+		}
+	  }
+	| ERR_TERM		{
+		$$ = NULL; /* supress warning */
+		yyerror(&yylloc, scanner, $1);
+		YYABORT;
+	  }
+	;
+
+key:
+	KEY			{
+		$$ = sprint_key_node(yyget_extra(scanner), $1);
+		if ($$ == NULL) {
+			yyerror(&yylloc, scanner, "could not create key node");
+			YYABORT;
+		}
+	  }
+	| key '+' key		{
+		$$ = sprint_keycalc_node('+', $1, $3);
+		if ($$ == NULL) {
+			yyerror(&yylloc, scanner, "could not create key calc node");
+			YYABORT;
+		}
+	  }
+	;
+%%
+
+int yyerror(YYLTYPE *loc, yyscan_t scanner, const char *msg, ...)
+{
+	va_list ap;
+	char buf[4096];
+
+	va_start(ap, msg);
+	snprintf(buf, sizeof(buf), msg, ap);
+	va_end(ap);
+
+	ulogd_log(ULOGD_ERROR, "form error - %s, at: %d\n", buf, yyget_column(scanner));
+
+	return 0;
+}
+
+char *sprint_key_name(struct llist_head *head, int kindex)
+{
+	struct keysym *sym;
+	int i = 0;
+
+	llist_for_each_entry(sym, head, list) {
+		if (i++ == kindex)
+			return sym->name;
+	}
+
+	return NULL;
+}
+
+void sprint_free_nodes(struct llist_head *nodes);
+
+void sprint_free_node(struct node *node)
+{
+	switch (node->type) {
+	case NODE_STRING:
+		free(node->string);
+		break;
+	case NODE_KEY:
+		break;
+	case NODE_GROUP:
+	case NODE_CONCAT:
+		sprint_free_nodes(&node->group);
+		break;
+	case NODE_KEYCALC:
+		sprint_free_node(node->keycalc.l);
+		sprint_free_node(node->keycalc.r);
+		break;
+	default:
+		ulogd_log(ULOGD_ERROR, "unknown node: %p"
+			  " type: %d\n", node, node->type);
+		break;
+	}
+}
+
+void sprint_free_nodes(struct llist_head *nodes)
+{
+	struct node *node, *nnode;
+
+	llist_for_each_entry_safe(node, nnode, nodes, list) {
+		sprint_free_node(node);
+		llist_del(&node->list);
+		free(node);
+	}
+}
+
+void sprint_free_keysyms(struct llist_head *head)
+{
+	struct keysym *sym, *nsym;
+
+	llist_for_each_entry_safe(sym, nsym, head, list) {
+		llist_del(&sym->list);
+		free(sym->name);
+		free(sym);
+	}
+}
+
+/*
+ * This function returns 0 on success
+ * error on parsing: > 0
+ * otherwise < 0 means negative errno
+ */
+int parse_form(char *str, struct outform *form)
+{
+	yyscan_t scanner;
+	YY_BUFFER_STATE buf;
+	int ret = 0;
+
+	if (yylex_init_extra(form, &scanner))
+		return -errno;
+	buf = yy_scan_string(str, scanner);
+	if (buf == NULL) {
+		ret = -errno;
+		/* XXX: needs free? what's the status of extra data and buffer */
+		goto free_scanner;
+	}
+
+	ret = yyparse(scanner);
+	if (ret == 0)
+		ret = form->yy_fatal_errno;
+	if (ret != 0) {
+		sprint_free_nodes(&form->head.list);
+		sprint_free_keysyms(&form->keysyms);
+	}
+
+	yy_delete_buffer(buf, scanner);
+free_scanner:
+	yylex_destroy(scanner);
+
+	return ret;
+}
diff --git a/output/sprint/ulogd_output_SPRINT-scanner.l b/output/sprint/ulogd_output_SPRINT-scanner.l
new file mode 100644
index 0000000..a401aea
--- /dev/null
+++ b/output/sprint/ulogd_output_SPRINT-scanner.l
@@ -0,0 +1,112 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+%{
+#include <string.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/linuxlist.h>
+#include "ulogd_output_SPRINT.h"
+#include "ulogd_output_SPRINT-parser.h"
+
+#define YY_USER_ACTION \
+	yyset_column(yyget_column(yyscanner) \
+	+ yyget_leng(yyscanner), yyscanner);
+
+#define YY_FATAL_ERROR(msg) { \
+	ulogd_log(ULOGD_FATAL, msg);\
+	yyget_extra(yyscanner)->yy_fatal_errno = \
+		errno != 0 ? -errno : 1;\
+}
+%}
+
+%option debug
+%option warn
+
+%option reentrant
+%option noyywrap
+%option nounput
+%option noinput
+%option bison-bridge
+%option bison-locations
+%option nodefault
+%option never-interactive
+%option extra-type="struct outform *"
+
+%x escape
+%x key
+
+%%
+
+<INITIAL>"\\"	{ BEGIN(escape); }
+<INITIAL>"<"	{ BEGIN(key); }
+<INITIAL>">"	{
+		yylval->string = "unexpected key end";
+		return ERR_TERM;
+	}
+<INITIAL>[()|]	{
+		return *yytext;
+	}
+
+<INITIAL>[ \t]*"+"[ \t]*	{
+		return '+';
+	}
+<INITIAL>[^\\<>()|]+	{
+		yylval->string = strdup(yytext);
+		return STRING;
+	}
+
+<escape><<EOF>>	{ 
+		yylval->string = "EOF in escaped char";
+		BEGIN(INITIAL);
+		return ERR_TERM;
+	}
+<escape>[nt\\<>()|\+] {
+		switch(*yytext) {
+		case 'n':
+			yylval->string = strdup("\n");
+			break;
+		case 't':
+			yylval->string = strdup("\t");
+			break;
+		default:
+			yylval->string = strdup(yytext);
+			break;
+		}
+		BEGIN(INITIAL);
+		return STRING;
+	}
+<escape>(.|"\n")	{
+		yylval->string = "invalid escape char";
+		BEGIN(INITIAL);
+		return ERR_TERM;
+	}
+
+	/* XXX: no empty key `<>' handling. */
+<key><<EOF>>	{
+		yylval->string = "EOF in key";
+		BEGIN(INITIAL);
+		return ERR_TERM;
+	}
+<key>[a-zA-Z][a-zA-Z0-9\._-]* {
+		yylval->string = strdup(yytext);
+		return KEY;
+	}
+<key>">"	{ BEGIN(INITIAL); }
+<key>(.|"\n")	{
+		yylval->string = "invalid key char";
+		BEGIN(INITIAL);
+		return ERR_TERM;
+	}
+%%
diff --git a/output/sprint/ulogd_output_SPRINT.c b/output/sprint/ulogd_output_SPRINT.c
new file mode 100644
index 0000000..92ca663
--- /dev/null
+++ b/output/sprint/ulogd_output_SPRINT.c
@@ -0,0 +1,495 @@
+/* ulogd_output_SPRINT.c
+ *
+ * ulogd output target for sending value specified `form' in config.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <string.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <fcntl.h>
+#include <netdb.h>
+
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+
+#include "ulogd_output_SPRINT.h"
+
+#ifndef ULOGD_SPRINT_DEFAULT
+#define ULOGD_SPRINT_DEFAULT	"/var/log/ulogd.sprint"
+#endif
+
+struct sprint_priv {
+	int ofd;
+	struct llist_head form_head;
+};
+
+enum sprint_conf {
+	SPRINT_CONF_FORM = 0,
+	SPRINT_CONF_PROTO,
+	SPRINT_CONF_DEST,
+	SPRINT_CONF_MAX
+};
+
+static struct config_keyset sprint_kset = {
+	.num_ces = SPRINT_CONF_MAX,
+	.ces = {
+		[SPRINT_CONF_FORM] = {
+			.key = "form",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+		[SPRINT_CONF_PROTO] = {
+			.key = "proto",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = "file" },
+
+		},
+		[SPRINT_CONF_DEST] = {
+			.key = "dest",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = ULOGD_SPRINT_DEFAULT },
+		},
+	},
+};
+
+static int open_connect_descriptor(struct ulogd_pluginstance *upi)
+{
+	char *proto, *host, *port;
+	struct addrinfo hint, *result, *rp;
+	int ret, fd;
+
+	proto = upi->config_kset->ces[SPRINT_CONF_PROTO].u.string;
+	port = upi->config_kset->ces[SPRINT_CONF_DEST].u.string;
+
+	/* file */
+	if (!strcasecmp(proto, "file")) {
+		if (strlen(port) == 0)
+			return STDOUT_FILENO;
+		return open(port, O_CREAT|O_WRONLY|O_APPEND);
+	}
+
+	/* socket */
+	host = strchr(port, '@');
+	if (host == NULL) {
+		ulogd_log(ULOGD_ERROR, "unknown destination `%s'\n",
+			  port);
+		errno = EINVAL;
+		return -1;
+	}
+	*host++ = '\0';
+
+	memset(&hint, 0, sizeof(struct addrinfo));
+	hint.ai_family = AF_UNSPEC;
+	if (!strcasecmp(proto, "udp")) {
+		hint.ai_socktype = SOCK_DGRAM;
+		hint.ai_protocol = IPPROTO_UDP;
+	} else if (!strcasecmp(proto, "tcp")) {
+		hint.ai_socktype = SOCK_STREAM;
+		hint.ai_protocol = IPPROTO_TCP;
+	} else {
+		ulogd_log(ULOGD_ERROR, "unknown protocol `%s'\n",
+			  proto);
+		errno = EINVAL;
+		return -1;
+	}
+
+	ret = getaddrinfo(host, port, &hint, &result);
+	if (ret != 0) {
+		ulogd_log(ULOGD_ERROR, "can't resolve host/service: %s\n",
+			  gai_strerror(ret));
+		if (ret != EAI_SYSTEM)
+			errno = EINVAL;
+		return -1;
+	}
+
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		int on = 1;
+
+		fd = socket(rp->ai_family, rp->ai_socktype,
+			     rp->ai_protocol);
+		if (fd == -1)
+			continue;
+
+		setsockopt(fd, SOL_SOCKET, SO_REUSEADDR,
+			   (void *)&on, sizeof(on));
+		if (connect(fd, rp->ai_addr, rp->ai_addrlen) == 0)
+			break;
+	}
+
+	freeaddrinfo(result);
+
+	if (rp == NULL) {
+		ulogd_log(ULOGD_ERROR, "could not connect\n");
+		/* XXX: errno? */
+		return -1;
+	}
+
+	return fd;
+}
+
+static double sprint_key_calc(struct ulogd_key *keys, struct node *node,
+			      bool *is_valid)
+{
+	*is_valid = false;
+	if (node->type == NODE_KEY) {
+		struct ulogd_key *key = keys[node->kindex].u.source;
+		if (!(key->flags & ULOGD_RETF_VALID))
+			return 0.0;
+
+		switch (key->type) {
+		case ULOGD_RET_BOOL:
+		case ULOGD_RET_INT8:
+		case ULOGD_RET_INT16:
+		case ULOGD_RET_INT32:
+			*is_valid = true;
+			return (double)key->u.value.i32;
+			break;
+		case ULOGD_RET_UINT8:
+		case ULOGD_RET_UINT16:
+		case ULOGD_RET_UINT32:
+		case ULOGD_RET_UINT64:
+			*is_valid = true;
+			return (double)key->u.value.ui64;
+			break;
+		default:
+			ulogd_log(ULOGD_INFO, "could not calc"
+				  " key: %s type: %d\n", key->name, key->type);
+		}
+	} else if (node->type == NODE_KEYCALC) {
+		bool lvalid, rvalid;
+		double lval = sprint_key_calc(keys, node->keycalc.l, &lvalid),
+			rval = sprint_key_calc(keys, node->keycalc.r, &rvalid);
+
+		if (!lvalid || !rvalid)
+			return 0.0; /* without setting is_valid */
+
+		switch (node->keycalc.opcode) {
+		case '+':
+			*is_valid = true;
+			return lval + rval;
+			break;
+		default:
+			ulogd_log(ULOGD_NOTICE, "unknown opcode: %c\n",
+				  node->keycalc.opcode);
+			break;
+		}
+	} else {
+		ulogd_log(ULOGD_NOTICE, "invalid node type in keycalc: %d\n",
+			  node->type);
+	}
+
+	return 0.0; /* without setting is_valid */
+}
+
+static int sprint_keycalc_puts(char *buf, size_t size, bool in_group,
+			       struct ulogd_key *keys, struct node *node)
+{
+	bool is_valid;
+	double ret = sprint_key_calc(keys, node, &is_valid);
+
+	if (!is_valid && in_group)
+		return 0;
+
+	return snprintf(buf, size, "%.0f", ret);
+}
+
+static int sprint_key_puts(char *buf, size_t size, bool in_group,
+			   struct ulogd_key *keys, struct node *node)
+{
+	struct ulogd_key *key = keys[node->kindex].u.source;
+
+	if (!(key->flags & ULOGD_RETF_VALID)) {
+		if (!in_group) {
+			ulogd_log(ULOGD_INFO, "no key value: %s\n", key->name);
+			return printf("<>");
+		}
+		return 0;
+	}
+
+	switch (key->type) {
+	case ULOGD_RET_STRING:
+		return snprintf(buf, size, "%s", (char *)key->u.value.ptr);
+		break;
+	case ULOGD_RET_BOOL:
+	case ULOGD_RET_INT8:
+	case ULOGD_RET_INT16:
+	case ULOGD_RET_INT32:
+		return snprintf(buf, size, "%d", key->u.value.i32);
+		break;
+	case ULOGD_RET_UINT8:
+	case ULOGD_RET_UINT16:
+	case ULOGD_RET_UINT32:
+	case ULOGD_RET_UINT64:
+		return snprintf(buf, size, "%" PRIu64, key->u.value.ui64);
+		break;
+	default:
+		ulogd_log(ULOGD_INFO, "could not interpret"
+			  " key: %s, type: %d\n", key->name, key->type);
+		break;
+	}
+	return 0; /* default */
+}
+
+static int sprint_term_puts(char *buf, size_t size, bool in_group,
+			    struct ulogd_key *keys, struct node *node)
+{
+	struct node *n;
+	int ret;
+	size_t len = 0;
+
+	switch (node->type) {
+	case NODE_KEY:
+		return sprint_key_puts(buf, size, in_group, keys, node);
+		break;
+	case NODE_STRING:
+		return snprintf(buf, size, "%s", node->string);
+		break;
+	case NODE_KEYCALC:
+		return sprint_keycalc_puts(buf, size, in_group, keys, node);
+		break;
+	case NODE_CONCAT:
+		llist_for_each_entry(n, &node->group, list) {
+			ret = sprint_term_puts(buf + len, size - len,
+					       in_group, keys, n);
+			if ((n->type == NODE_KEY || n->type == NODE_KEYCALC)
+			    && ret <= 0) {
+				/* no key value found in a group */
+				return 0;
+			}
+			len += ret;
+			if (len >= size) {
+				ulogd_log(ULOGD_NOTICE, "exceeds bufsize\n");
+				return len;
+			}
+		}
+		return len;
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "unknown node type: %d\n",
+			  node->type);
+		break;
+	}
+
+	return 0; /* unknown node type */
+}
+
+static int sprint_group_puts(char *buf, size_t size,
+			     struct ulogd_key *keys, struct node *node)
+{
+	int ret;
+	struct node *n;
+
+	llist_for_each_entry(n, &node->group, list) {
+		ret = sprint_term_puts(buf, size, true, keys, n);
+		if (ret > 0) /* put first valid value and return */
+			return ret;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "no value found in group\n");
+	return snprintf(buf, size, "()");
+}
+
+static int sprint_interp(struct ulogd_pluginstance *upi)
+{
+	struct sprint_priv *sp = (struct sprint_priv *)&upi->private;
+	struct node *cur;
+	char buf[4096];
+	int rem = sizeof(buf) - 1, len = 0, ret;
+
+	llist_for_each_entry(cur, &sp->form_head, list) {
+		switch (cur->type) {
+		case NODE_KEY:
+		case NODE_STRING:
+		case NODE_CONCAT:
+		case NODE_KEYCALC:
+			len += sprint_term_puts(buf + len, rem, false,
+						upi->input.keys, cur);
+			break;
+		case NODE_GROUP:
+			len += sprint_group_puts(buf + len, rem,
+						 upi->input.keys, cur);
+			break;
+		default:
+			ulogd_log(ULOGD_NOTICE, "unknown node type: %d\n",
+				  cur->type);
+		}
+		rem -= len;
+		if (rem <= 0) {
+			ulogd_log(ULOGD_NOTICE,
+				  "sprint_term_puts exceeds bufsize\n");
+			len = sizeof(buf);
+			break;
+		}
+	}
+
+	ret = write(sp->ofd, buf, len);
+	if (ret != len) {
+		buf[len] = '\0';
+		ulogd_log(ULOGD_ERROR, "Failure sending message: %s\n", buf);
+		if (ret == -1) {
+			sp->ofd = open_connect_descriptor(upi);
+			if (sp->ofd == -1)
+				return ULOGD_IRET_ERR;
+		}
+	}
+	return ULOGD_IRET_OK;
+}
+
+static void sighup_handler_print(struct ulogd_pluginstance *upi, int signal)
+{
+	struct sprint_priv *sp = (struct sprint_priv *)&upi->private;
+	int old = sp->ofd;
+
+	switch (signal) {
+	case SIGHUP:
+		ulogd_log(ULOGD_NOTICE, "SPRINT: reopening logfile\n");
+		sp->ofd = open_connect_descriptor(upi);
+		if (sp->ofd == -1) {
+			ulogd_log(ULOGD_ERROR, "can't open SPRINT "
+					       "log file: %s\n",
+				  strerror(errno));
+			sp->ofd = old;
+		} else {
+			close(old);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int sprint_set_inputkeys(struct ulogd_pluginstance *upi)
+{
+	struct sprint_priv *priv = (struct sprint_priv *)&upi->private;
+	struct keysym *sym, *nsym;
+	struct ulogd_key *ikey;
+	int ret;
+	struct outform form;
+
+	INIT_LLIST_HEAD(&priv->form_head);
+	INIT_LLIST_HEAD(&form.keysyms);
+	INIT_LLIST_HEAD(&form.head.list);
+	form.head.type = NODE_HEAD;
+	form.yy_fatal_errno = 0;
+
+	ret = parse_form(upi->config_kset->ces[SPRINT_CONF_FORM].u.string,
+			 &form);
+	if (ret > 0) {
+		/* parser error, already logged by yyerror */
+		return -ret;
+	} else if (ret < 0) { /* errno */
+		ulogd_log(ULOGD_ERROR, "could not parse form: %s\n",
+			  strerror(-ret));
+		return ret;
+	}
+
+	llist_add(&priv->form_head, &form.head.list);
+	llist_del(&form.head.list);
+
+	ulogd_log(ULOGD_DEBUG, "allocating %u input keys for SPRINT\n",
+		  form.num_keys);
+	upi->input.keys = ikey = calloc(sizeof(struct ulogd_key),
+					form.num_keys);
+
+	if (!upi->input.keys)
+		return -ENOMEM;
+
+	/* create input keys from key symbol list created by form parsing */
+	llist_for_each_entry_safe(sym, nsym, &form.keysyms, list) {
+		ikey->flags = ULOGD_RETF_NONE;
+		strncpy(ikey->name, sym->name, strlen(sym->name));
+		free(sym->name);
+		free(sym);
+		ikey++;
+	}
+	upi->input.num_keys = form.num_keys;
+
+	return ret;
+}
+
+static int sprint_configure(struct ulogd_pluginstance *upi,
+			    struct ulogd_pluginstance_stack *stack)
+{
+	int ret;
+
+	ret = config_parse_file(upi->id, upi->config_kset);
+	if (ret < 0)
+		return ret;
+
+	ret = sprint_set_inputkeys(upi);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int sprint_init(struct ulogd_pluginstance *upi)
+{
+	struct sprint_priv *sp = (struct sprint_priv *) &upi->private;
+
+	sp->ofd = open_connect_descriptor(upi);
+	if (sp->ofd < 0) {
+		ulogd_log(ULOGD_FATAL, "can't open SPRINT destination: %s\n",
+			  strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int sprint_fini(struct ulogd_pluginstance *pi)
+{
+	struct sprint_priv *sp = (struct sprint_priv *) &pi->private;
+
+	if (sp->ofd != STDOUT_FILENO)
+		close(sp->ofd);
+
+	return 0;
+}
+
+static struct ulogd_plugin sprint_plugin = {
+	.name = "SPRINT",
+	.input = {
+		.type	= ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM,
+	},
+	.output = {
+		.type	= ULOGD_DTYPE_SINK,
+	},
+	.configure	= &sprint_configure,
+	.interp		= &sprint_interp,
+	.start		= &sprint_init,
+	.stop		= &sprint_fini,
+	.signal		= &sighup_handler_print,
+	.config_kset	= &sprint_kset,
+	.version	= VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&sprint_plugin);
+}
diff --git a/output/sprint/ulogd_output_SPRINT.h b/output/sprint/ulogd_output_SPRINT.h
new file mode 100644
index 0000000..729f1f9
--- /dev/null
+++ b/output/sprint/ulogd_output_SPRINT.h
@@ -0,0 +1,45 @@
+#ifndef _SPRINT_H
+#define _SPRINT_H
+
+#include "ulogd_output_SPRINT-parser.h"
+
+enum sprint_node_type {
+	NODE_HEAD,
+	NODE_STRING,
+	NODE_KEY,
+	NODE_CONCAT,
+	NODE_GROUP,
+	NODE_KEYCALC,
+};
+
+struct keyop {
+	int opcode;
+	struct node *l;
+	struct node *r;
+};
+
+struct node {
+	enum sprint_node_type type;
+	struct llist_head list;
+	union {
+		char *string;			/* NODE_STRING */
+		int kindex;			/* NODE_KEY */
+		struct llist_head group;	/* NODE_CONCAT, NODE_GROUP */
+		struct keyop keycalc;		/* NODE_KEYCALC */
+	};
+};
+
+struct keysym {
+	struct llist_head list;
+	char *name;
+};
+
+struct outform {
+  	int yy_fatal_errno;		/* ugly way of avoiding YY_FATAL_ERROR exit() call */
+	int num_keys;			/* number of keys */
+	struct node head;		/* list of sprint node */
+	struct llist_head keysyms;	/* key symbol list generating ulogd_key */
+};
+
+int parse_form(char *str, struct outform *form);
+#endif
-- 
1.8.5.3

