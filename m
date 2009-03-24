From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: avoid files with duplicate basenames
Date: Wed, 25 Mar 2009 00:31:06 +0100
Message-ID: <1237937468-31476-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34659 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZCXXbM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:31:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When -I. is passed to gcc=C2=A0=E2=80=94 as autotools will do=C2=A0=E2=80=
=94,
src/parser.h). Rename include/parser.h to parscan.h ("parser and
scanner").

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/parscan.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/parser.h  |   44 --------------------------------------------
 src/cli.c         |    2 +-
 src/main.c        |    2 +-
 src/parser.y      |    2 +-
 src/scanner.l     |    2 +-
 6 files changed, 48 insertions(+), 48 deletions(-)
 create mode 100644 include/parscan.h
 delete mode 100644 include/parser.h

diff --git a/include/parscan.h b/include/parscan.h
new file mode 100644
index 0000000..b807707
--- /dev/null
+++ b/include/parscan.h
@@ -0,0 +1,44 @@
+#ifndef NFTABLES_PARSCAN_H
+#define NFTABLES_PARSCAN_H
+
+#include <list.h>
+#include <rule.h> // FIXME
+
+#define MAX_INCLUDE_DEPTH		16
+#define TABSIZE				8
+
+#define YYLTYPE				struct location
+#define YYLTYPE_IS_TRIVIAL		0
+#define YYENABLE_NLS			0
+
+#define SCOPE_NEST_MAX			3
+
+struct parser_state {
+	struct input_descriptor		*indesc;
+	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
+	unsigned int			indesc_idx;
+
+	struct list_head		*msgs;
+
+	struct scope			top_scope;
+	struct scope			*scopes[SCOPE_NEST_MAX];
+	unsigned int			scope;
+
+	struct list_head		cmds;
+};
+
+extern void parser_init(struct parser_state *state, struct list_head *=
msgs);
+extern int nft_parse(void *, struct parser_state *state);
+
+extern void *scanner_init(struct parser_state *state);
+extern void scanner_destroy(struct parser_state *state);
+
+extern int scanner_read_file(void *scanner, const char *filename,
+			     const struct location *loc);
+extern int scanner_include_file(void *scanner, const char *filename,
+				const struct location *loc);
+extern void scanner_push_buffer(void *scanner,
+				const struct input_descriptor *indesc,
+				const char *buffer);
+
+#endif /* NFTABLES_PARSCAN_H */
diff --git a/include/parser.h b/include/parser.h
deleted file mode 100644
index f5dd6f4..0000000
--- a/include/parser.h
+++ /dev/null
@@ -1,44 +0,0 @@
-#ifndef NFTABLES_PARSER_H
-#define NFTABLES_PARSER_H
-
-#include <list.h>
-#include <rule.h> // FIXME
-
-#define MAX_INCLUDE_DEPTH		16
-#define TABSIZE				8
-
-#define YYLTYPE				struct location
-#define YYLTYPE_IS_TRIVIAL		0
-#define YYENABLE_NLS			0
-
-#define SCOPE_NEST_MAX			3
-
-struct parser_state {
-	struct input_descriptor		*indesc;
-	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
-	unsigned int			indesc_idx;
-
-	struct list_head		*msgs;
-
-	struct scope			top_scope;
-	struct scope			*scopes[SCOPE_NEST_MAX];
-	unsigned int			scope;
-
-	struct list_head		cmds;
-};
-
-extern void parser_init(struct parser_state *state, struct list_head *=
msgs);
-extern int nft_parse(void *, struct parser_state *state);
-
-extern void *scanner_init(struct parser_state *state);
-extern void scanner_destroy(struct parser_state *state);
-
-extern int scanner_read_file(void *scanner, const char *filename,
-			     const struct location *loc);
-extern int scanner_include_file(void *scanner, const char *filename,
-				const struct location *loc);
-extern void scanner_push_buffer(void *scanner,
-				const struct input_descriptor *indesc,
-				const char *buffer);
-
-#endif /* NFTABLES_PARSER_H */
diff --git a/src/cli.c b/src/cli.c
index e302dfa..bb519f4 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -24,7 +24,7 @@
 #include <readline/history.h>
=20
 #include <nftables.h>
-#include <parser.h>
+#include <parscan.h>
 #include <erec.h>
 #include <utils.h>
=20
diff --git a/src/main.c b/src/main.c
index 3daa294..11dd21e 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,7 +20,7 @@
=20
 #include <nftables.h>
 #include <utils.h>
-#include <parser.h>
+#include <parscan.h>
 #include <rule.h>
 #include <netlink.h>
 #include <erec.h>
diff --git a/src/parser.y b/src/parser.y
index 90f9052..cb44372 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -22,7 +22,7 @@
 #include <statement.h>
 #include <expression.h>
 #include <utils.h>
-#include <parser.h>
+#include <parscan.h>
 #include <erec.h>
=20
 #include "parser.h"
diff --git a/src/scanner.l b/src/scanner.l
index 7fc01f7..21994cb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -19,7 +19,7 @@
 #include <nftables.h>
 #include <erec.h>
 #include <rule.h>
-#include <parser.h>
+#include <parscan.h>
 #include "parser.h"
=20
 #define YY_NO_INPUT
--=20
1.6.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
