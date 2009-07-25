From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] multi binary: allow subcommand via argv[1]
Date: Sat, 25 Jul 2009 22:22:40 +0200
Message-ID: <1248553363-26903-3-git-send-email-jengelh@medozas.de>
References: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZGYUWr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:47 -0400
In-Reply-To: <1248553363-26903-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libtool does not play well with symlinks when trying to run commands
in the build directory. So provide an alternate way to call
iptables-multi: when argv[0] is not a recognized name, inspect [1]
for an alternate identifer.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-multi.c |   53 +++++++++++++++++++++++++++++-----------------
 iptables-multi.c  |   60 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 70 insertions(+), 43 deletions(-)

diff --git a/ip6tables-multi.c b/ip6tables-multi.c
index 3313bfd..671558c 100644
--- a/ip6tables-multi.c
+++ b/ip6tables-multi.c
@@ -7,26 +7,39 @@ int ip6tables_main(int argc, char **argv);
 int ip6tables_save_main(int argc, char **argv);
 int ip6tables_restore_main(int argc, char **argv);
 
-int main(int argc, char **argv) {
-  char *progname;
+int main(int argc, char **argv)
+{
+	char *progname;
 
-  if (argc == 0) {
-    fprintf(stderr, "no argv[0]?");
-    exit(1);
-  } else {
-    progname = basename(argv[0]);
+	if (argc < 1) {
+		fprintf(stderr, "ERROR: This should not happen.\n");
+		exit(EXIT_FAILURE);
+	}
 
-    if (!strcmp(progname, "ip6tables") ||
-        strcmp(progname, "ip6tables-static") == 0)
-      return ip6tables_main(argc, argv);
-    
-    if (!strcmp(progname, "ip6tables-save"))
-      return ip6tables_save_main(argc, argv);
-    
-    if (!strcmp(progname, "ip6tables-restore"))
-      return ip6tables_restore_main(argc, argv);
-    
-    fprintf(stderr, "ip6tables multi-purpose version: unknown applet name %s\n", progname);
-    exit(1);
-  }
+	progname = basename(argv[0]);
+	if (strcmp(progname, "ip6tables") == 0)
+		return ip6tables_main(argc, argv);
+	if (strcmp(progname, "ip6tables-save") == 0)
+		return ip6tables_save_main(argc, argv);
+	if (strcmp(progname, "ip6tables-restore") == 0)
+		return ip6tables_restore_main(argc, argv);
+
+	++argv;
+	--argc;
+	if (argc < 1) {
+		fprintf(stderr, "ERROR: No subcommand given.\n");
+		exit(EXIT_FAILURE);
+	}
+
+	progname = basename(argv[0]);
+	if (strcmp(progname, "main") == 0)
+		return ip6tables_main(argc, argv);
+	if (strcmp(progname, "save") == 0)
+		return ip6tables_save_main(argc, argv);
+	if (strcmp(progname, "restore") == 0)
+		return ip6tables_restore_main(argc, argv);
+
+	fprintf(stderr, "ip6tables multi-purpose version: "
+	        "unknown subcommand \"%s\"\n", progname);
+	exit(EXIT_FAILURE);
 }
diff --git a/iptables-multi.c b/iptables-multi.c
index 28c1737..4dcc26d 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -8,29 +8,43 @@ int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
 int iptables_xml_main(int argc, char **argv);
 
-int main(int argc, char **argv) {
-  char *progname;
+int main(int argc, char **argv)
+{
+	char *progname;
 
-  if (argc == 0) {
-    fprintf(stderr, "no argv[0]?");
-    exit(1);
-  } else {
-    progname = basename(argv[0]);
+	if (argc < 1) {
+		fprintf(stderr, "ERROR: This should not happen.\n");
+		exit(EXIT_FAILURE);
+	}
 
-    if (!strcmp(progname, "iptables") ||
-        strcmp(progname, "iptables-static") == 0)
-      return iptables_main(argc, argv);
-    
-    if (!strcmp(progname, "iptables-save"))
-      return iptables_save_main(argc, argv);
-    
-    if (!strcmp(progname, "iptables-restore"))
-      return iptables_restore_main(argc, argv);
-    
-    if (!strcmp(progname, "iptables-xml"))
-      return iptables_xml_main(argc, argv);
-    
-    fprintf(stderr, "iptables multi-purpose version: unknown applet name %s\n", progname);
-    exit(1);
-  }
+	progname = basename(argv[0]);
+	if (strcmp(progname, "iptables") == 0)
+		return iptables_main(argc, argv);
+	if (strcmp(progname, "iptables-save") == 0)
+		return iptables_save_main(argc, argv);
+	if (strcmp(progname, "iptables-restore") == 0)
+		return iptables_restore_main(argc, argv);
+	if (strcmp(progname, "iptables-xml") == 0)
+		return iptables_xml_main(argc, argv);
+
+	++argv;
+	--argc;
+	if (argc < 1) {
+		fprintf(stderr, "ERROR: No subcommand given.\n");
+		exit(EXIT_FAILURE);
+	}
+
+	progname = basename(argv[0]);
+	if (strcmp(progname, "main") == 0)
+		return iptables_main(argc, argv);
+	if (strcmp(progname, "save") == 0)
+		return iptables_save_main(argc, argv);
+	if (strcmp(progname, "restore") == 0)
+		return iptables_restore_main(argc, argv);
+	if (strcmp(progname, "xml") == 0)
+		return iptables_xml_main(argc, argv);
+
+	fprintf(stderr, "iptables multi-purpose version: "
+	        "unknown subcommand \"%s\"\n", progname);
+	exit(EXIT_FAILURE);
 }
-- 
1.6.3.3

