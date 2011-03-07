From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] ip(6)tables-multi: unify subcommand handling
Date: Mon, 7 Mar 2011 20:16:19 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103072008250.16675@obet.zrqbmnf.qr>
References: <20110307173027.GA16468@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38591 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1CGTQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:16:21 -0500
In-Reply-To: <20110307173027.GA16468@zirkel.wertarbyte.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2011-03-07 18:30, Stefan Tomanek wrote:
>
>I found the subcommand handling and naming done by iptables-multi and
>ip6tables-multi very confusing and complicated; this patch reorganizes
>the subcommands in a single table, allowing both variants of them to be
>used (iptables/main) and also prints a list of the allowed commands if
>an unknown command is entered by the user.

I took the patch and already revised it for the points mentioned below.


>diff --git a/ip6tables-multi.c b/ip6tables-multi.c
>index 671558c..11fc6e7 100644
>--- a/ip6tables-multi.c
>+++ b/ip6tables-multi.c
>@@ -3,43 +3,23 @@
> #include <string.h>
> #include <libgen.h>
> 
>+#include "subcmd-multi.h"
>+

There is xshared.h that can be used.

>+subcmd_cb subcommands[] = {
>+	{ "ip6tables",		&ip6tables_main },
>+	{ "main",		&ip6tables_main },
>+	{ "ip6tables-save",	&ip6tables_save_main },
>+	{ "save",		&ip6tables_save_main },
>+	{ "ip6tables-restore",	&ip6tables_restore_main },
>+	{ "restore",		&ip6tables_restore_main },
>+	{ NULL,			NULL }
>+};

No typedefs for non-(function pointers). Also, & on the function pointer 
is undesired (it makes macro substitution - though not used here - a 
hassle). subcommands array be const.

>index 0000000..3f3e914
>--- /dev/null
>+++ b/subcmd-multi.h
>@@ -0,0 +1,54 @@
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <libgen.h>
>+
>+typedef int(*mainfunc)(int, char**);
>+typedef struct { char *name; mainfunc main; } subcmd_cb;
>+
>+mainfunc get_subcommand(char *cmd, subcmd_cb cbs[]);
>+int subcmd_main(int argc, char **argv, subcmd_cb cbs[]);

Unnecessary prototypes (in case of subcmd-multi.h).

>+
>+mainfunc get_subcommand(char *cmd, subcmd_cb cbs[])

Should be static because it is not used from anywhere but subcmd_main. 
cbs be const.

>+{

Code does not belong in header files. Inconsistent mixed use of * and 
[].

>+	int i = 0;
>+	while ( cbs[i].name ) {
>+		if ( strcmp(cmd, cbs[i].name) == 0 ) {
>+			return cbs[i].main;
>+		}
>+		i++;
>+	}

Can be written much shorter by making cbs walk itself:

	for (; cbs->name != NULL; ++cbs)
		if (strcmp...
			return;

>+	return NULL;
>+}
>+
>+int subcmd_main(int argc, char **argv, subcmd_cb cbs[])
>+{
>+	if (argc < 1) {
>+		fprintf(stderr, "ERROR: This should not happen.\n");
>+		exit(EXIT_FAILURE);
>+	}

Unlikely to happen.

>+	char *cmd = basename(argv[0]);
>+	mainfunc f = get_subcommand(cmd, cbs);

Incosistent naming.

>+	/* Unable to find a main method for our command name?
>+	 * Let's try again with the first argument!
>+	 */
>+	if (! f && argc > 0) {

Must be argc > 1 or it will run into undefined behavior when accessing 
argv[0].

>+		argv++; argc--;

At least one line per statement.

>+		cmd = argv[0];
>+		f = get_subcommand(cmd, cbs);
>+	}
>+
>+	/* now we should have a valid function pointer */
>+	if (f) {
>+		return f(argc, argv);

Else-considered-harmful.

>+	} else {
>+		fprintf(stderr, "ERROR: No valid subcommand given.\nValid subcommands:\n");
>+		int i = 0;
>+		while ( cbs[i].name ) {
>+			fprintf(stderr, " * %s\n", cbs[i].name);
>+			i++;
>+		}

Using a walking pointer again.

Authorship has been preserved. The finalized patch now looks like:


parent f96cb8094ceffb9ffe8e94b4ee6800aa581dd021 (v1.4.10-87-gf96cb80)
commit 9cc4f24e72f87ca191c2e723e7cd293f6477481c
Author: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Date:   Mon Mar 7 18:30:27 2011 +0100

ip(6)tables-multi: unify subcommand handling

I found the subcommand handling and naming done by iptables-multi and
ip6tables-multi very confusing and complicated; this patch
reorganizes the subcommands in a single table, allowing both variants
of them to be used (iptables/main) and also prints a list of the
allowed commands if an unknown command is entered by the user.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-multi.c |   46 ++++++++++-----------------------------
 iptables-multi.c  |   52 ++++++++++++--------------------------------
 xshared.c         |   36 +++++++++++++++++++++++++++++++
 xshared.h         |   11 +++++++++
 4 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/ip6tables-multi.c b/ip6tables-multi.c
index 671558c..7e6603f 100644
--- a/ip6tables-multi.c
+++ b/ip6tables-multi.c
@@ -1,45 +1,23 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <libgen.h>
+#include "xshared.h"
 
 int ip6tables_main(int argc, char **argv);
 int ip6tables_save_main(int argc, char **argv);
 int ip6tables_restore_main(int argc, char **argv);
 
+static const struct subcommand multi6_subcommands[] = {
+	{"ip6tables",         ip6tables_main},
+	{"main",              ip6tables_main},
+	{"ip6tables-save",    ip6tables_save_main},
+	{"save",              ip6tables_save_main},
+	{"ip6tables-restore", ip6tables_restore_main},
+	{"restore",           ip6tables_restore_main},
+	{NULL},
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
+	return subcmd_main(argc, argv, multi6_subcommands);
 }
diff --git a/iptables-multi.c b/iptables-multi.c
index 4dcc26d..754b587 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -1,50 +1,26 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <libgen.h>
+#include "xshared.h"
 
 int iptables_main(int argc, char **argv);
 int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
 int iptables_xml_main(int argc, char **argv);
 
+static const struct subcommand multi4_subcommands[] = {
+	{"iptables",         iptables_main},
+	{"main",             iptables_main},
+	{"iptables-save",    iptables_save_main},
+	{"save",             iptables_save_main},
+	{"iptables-restore", iptables_restore_main},
+	{"restore",          iptables_restore_main},
+	{"iptables-xml",     iptables_xml_main},
+	{"xml",              iptables_xml_main},
+	{NULL},
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
+	return subcmd_main(argc, argv, multi4_subcommands);
 }
diff --git a/xshared.c b/xshared.c
index c5a9015..404a9f5 100644
--- a/xshared.c
+++ b/xshared.c
@@ -1,7 +1,10 @@
+#include <libgen.h>
 #include <netdb.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 #include <xtables.h>
 #include "xshared.h"
 
@@ -99,3 +102,36 @@ struct xtables_match *load_proto(struct iptables_command_state *cs)
 	return find_proto(cs->protocol, XTF_TRY_LOAD,
 			  cs->options & OPT_NUMERIC, &cs->matches);
 }
+
+static mainfunc_t subcmd_get(const char *cmd, const struct subcommand *cb)
+{
+	for (; cb->name != NULL; ++cb)
+		if (strcmp(cb->name, cmd) == 0)
+			return cb->main;
+	return NULL;
+}
+
+int subcmd_main(int argc, char **argv, const struct subcommand *cb)
+{
+	const char *cmd = basename(*argv);
+	mainfunc_t f = subcmd_get(cmd, cb);
+
+	if (f == NULL && argc > 1) {
+		/*
+		 * Unable to find a main method for our command name?
+		 * Let's try again with the first argument!
+		 */
+		++argv;
+		--argc;
+		f = subcmd_get(*argv, cb);
+	}
+
+	/* now we should have a valid function pointer */
+	if (f != NULL)
+		return f(argc, argv);
+
+	fprintf(stderr, "ERROR: No valid subcommand given.\nValid subcommands:\n");
+	for (; cb->name != NULL; ++cb)
+		fprintf(stderr, " * %s\n", cb->name);
+	exit(EXIT_FAILURE);
+}
diff --git a/xshared.h b/xshared.h
index a08e6d9..94abb39 100644
--- a/xshared.h
+++ b/xshared.h
@@ -1,7 +1,10 @@
 #ifndef IPTABLES_XSHARED_H
 #define IPTABLES_XSHARED_H 1
 
+#include <limits.h>
 #include <stdint.h>
+#include <netinet/in.h>
+#include <net/if.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
@@ -39,6 +42,13 @@ struct iptables_command_state {
 	char **argv;
 };
 
+typedef int (*mainfunc_t)(int, char **);
+
+struct subcommand {
+	const char *name;
+	mainfunc_t main;
+};
+
 enum {
 	XT_OPTION_OFFSET_SCALE = 256,
 };
@@ -47,5 +57,6 @@ extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern const char *proto_to_name(uint8_t, int);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
+extern int subcmd_main(int, char **, const struct subcommand *);
 
 #endif /* IPTABLES_XSHARED_H */
-- 
# Created with git-export-patch
