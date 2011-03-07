From: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Subject: [PATCH] ip(6)tables-multi: unify subcommand handling
Date: Mon, 7 Mar 2011 18:30:27 +0100
Message-ID: <20110307173027.GA16468@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zirkel.wertarbyte.de ([188.40.44.137]:58086 "EHLO
	zirkel.wertarbyte.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1CGSEG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:04:06 -0500
Received: from stefan by zirkel.wertarbyte.de with local (Exim 4.72)
	(envelope-from <stefan.tomanek@wertarbyte.de>)
	id 1PweGJ-0004II-8I
	for netfilter-devel@vger.kernel.org; Mon, 07 Mar 2011 18:30:27 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I found the subcommand handling and naming done by iptables-multi and
ip6tables-multi very confusing and complicated; this patch reorganizes
the subcommands in a single table, allowing both variants of them to be
used (iptables/main) and also prints a list of the allowed commands if
an unknown command is entered by the user.
The selection and execution of the desired subcommand is handled by the
code placed in subcmd-multi.h, which is now included by iptables-multi.c
and ip6tables-multi.c containing the needed mapping tables.

Signed-off-by: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
---
 ip6tables-multi.c |   46 ++++++++++++--------------------------------
 iptables-multi.c  |   52 ++++++++++++++------------------------------------
 subcmd-multi.h    |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 70 deletions(-)
 create mode 100644 subcmd-multi.h

diff --git a/ip6tables-multi.c b/ip6tables-multi.c
index 671558c..11fc6e7 100644
--- a/ip6tables-multi.c
+++ b/ip6tables-multi.c
@@ -3,43 +3,23 @@
 #include <string.h>
 #include <libgen.h>
 
+#include "subcmd-multi.h"
+
 int ip6tables_main(int argc, char **argv);
 int ip6tables_save_main(int argc, char **argv);
 int ip6tables_restore_main(int argc, char **argv);
 
+subcmd_cb subcommands[] = {
+	{ "ip6tables",		&ip6tables_main },
+	{ "main",		&ip6tables_main },
+	{ "ip6tables-save",	&ip6tables_save_main },
+	{ "save",		&ip6tables_save_main },
+	{ "ip6tables-restore",	&ip6tables_restore_main },
+	{ "restore",		&ip6tables_restore_main },
+	{ NULL,			NULL }
+};
+
 int main(int argc, char **argv)
 {
-	char *progname;
-
-	if (argc < 1) {
-		fprintf(stderr, "ERROR: This should not happen.\n");
-		exit(EXIT_FAILURE);
-	}
-
-	progname = basename(argv[0]);
-	if (strcmp(progname, "ip6tables") == 0)
-		return ip6tables_main(argc, argv);
-	if (strcmp(progname, "ip6tables-save") == 0)
-		return ip6tables_save_main(argc, argv);
-	if (strcmp(progname, "ip6tables-restore") == 0)
-		return ip6tables_restore_main(argc, argv);
-
-	++argv;
-	--argc;
-	if (argc < 1) {
-		fprintf(stderr, "ERROR: No subcommand given.\n");
-		exit(EXIT_FAILURE);
-	}
-
-	progname = basename(argv[0]);
-	if (strcmp(progname, "main") == 0)
-		return ip6tables_main(argc, argv);
-	if (strcmp(progname, "save") == 0)
-		return ip6tables_save_main(argc, argv);
-	if (strcmp(progname, "restore") == 0)
-		return ip6tables_restore_main(argc, argv);
-
-	fprintf(stderr, "ip6tables multi-purpose version: "
-	        "unknown subcommand \"%s\"\n", progname);
-	exit(EXIT_FAILURE);
+	return subcmd_main(argc, argv, subcommands);
 }
diff --git a/iptables-multi.c b/iptables-multi.c
index 4dcc26d..bba36b7 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -3,48 +3,26 @@
 #include <string.h>
 #include <libgen.h>
 
+#include "subcmd-multi.h"
+
 int iptables_main(int argc, char **argv);
 int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
 int iptables_xml_main(int argc, char **argv);
 
+subcmd_cb subcommands[] = {
+	{ "iptables",		&iptables_main },
+	{ "main",		&iptables_main },
+	{ "iptables-save",	&iptables_save_main },
+	{ "save",		&iptables_save_main },
+	{ "iptables-restore",	&iptables_restore_main },
+	{ "restore",		&iptables_restore_main },
+	{ "iptables-xml",	&iptables_xml_main },
+	{ "xml",		&iptables_xml_main },
+	{ NULL,			NULL }
+};
+
 int main(int argc, char **argv)
 {
-	char *progname;
-
-	if (argc < 1) {
-		fprintf(stderr, "ERROR: This should not happen.\n");
-		exit(EXIT_FAILURE);
-	}
-
-	progname = basename(argv[0]);
-	if (strcmp(progname, "iptables") == 0)
-		return iptables_main(argc, argv);
-	if (strcmp(progname, "iptables-save") == 0)
-		return iptables_save_main(argc, argv);
-	if (strcmp(progname, "iptables-restore") == 0)
-		return iptables_restore_main(argc, argv);
-	if (strcmp(progname, "iptables-xml") == 0)
-		return iptables_xml_main(argc, argv);
-
-	++argv;
-	--argc;
-	if (argc < 1) {
-		fprintf(stderr, "ERROR: No subcommand given.\n");
-		exit(EXIT_FAILURE);
-	}
-
-	progname = basename(argv[0]);
-	if (strcmp(progname, "main") == 0)
-		return iptables_main(argc, argv);
-	if (strcmp(progname, "save") == 0)
-		return iptables_save_main(argc, argv);
-	if (strcmp(progname, "restore") == 0)
-		return iptables_restore_main(argc, argv);
-	if (strcmp(progname, "xml") == 0)
-		return iptables_xml_main(argc, argv);
-
-	fprintf(stderr, "iptables multi-purpose version: "
-	        "unknown subcommand \"%s\"\n", progname);
-	exit(EXIT_FAILURE);
+	return subcmd_main(argc, argv, subcommands);
 }
diff --git a/subcmd-multi.h b/subcmd-multi.h
new file mode 100644
index 0000000..3f3e914
--- /dev/null
+++ b/subcmd-multi.h
@@ -0,0 +1,54 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <libgen.h>
+
+typedef int(*mainfunc)(int, char**);
+typedef struct { char *name; mainfunc main; } subcmd_cb;
+
+mainfunc get_subcommand(char *cmd, subcmd_cb cbs[]);
+int subcmd_main(int argc, char **argv, subcmd_cb cbs[]);
+
+mainfunc get_subcommand(char *cmd, subcmd_cb cbs[])
+{
+	int i = 0;
+	while ( cbs[i].name ) {
+		if ( strcmp(cmd, cbs[i].name) == 0 ) {
+			return cbs[i].main;
+		}
+		i++;
+	}
+	return NULL;
+}
+
+int subcmd_main(int argc, char **argv, subcmd_cb cbs[])
+{
+	if (argc < 1) {
+		fprintf(stderr, "ERROR: This should not happen.\n");
+		exit(EXIT_FAILURE);
+	}
+	char *cmd = basename(argv[0]);
+	mainfunc f = get_subcommand(cmd, cbs);
+
+	/* Unable to find a main method for our command name?
+	 * Let's try again with the first argument!
+	 */
+	if (! f && argc > 0) {
+		argv++; argc--;
+		cmd = argv[0];
+		f = get_subcommand(cmd, cbs);
+	}
+
+	/* now we should have a valid function pointer */
+	if (f) {
+		return f(argc, argv);
+	} else {
+		fprintf(stderr, "ERROR: No valid subcommand given.\nValid subcommands:\n");
+		int i = 0;
+		while ( cbs[i].name ) {
+			fprintf(stderr, " * %s\n", cbs[i].name);
+			i++;
+		}
+		exit(EXIT_FAILURE);
+	}
+}
-- 
1.7.2.3
