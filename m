From: Jan Engelhardt <jengelh@medozas.de>
Subject: env: augment deprecation notice
Date: Wed, 7 Jan 2009 06:01:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901070600500.15968@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59853 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZAGFBP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:01:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


parent 6fdeb9468f1bac11698b200530cd454a167e1e39
commit f19f52defad1145b062528db75eab6db43be7446
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jan 7 06:00:41 2009 +0100

env: augment deprecation notice

Tell the user what to use instead of IP*TABLES_LIBDIR.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c    |    3 ++-
 ip6tables-save.c       |    3 ++-
 ip6tables-standalone.c |    3 ++-
 iptables-restore.c     |    3 ++-
 iptables-save.c        |    3 ++-
 iptables-standalone.c  |    3 ++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 01bccf7..a84c2e3 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -133,7 +133,8 @@ int main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IP6TABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
diff --git a/ip6tables-save.c b/ip6tables-save.c
index d5f8e54..11ef8c4 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -143,7 +143,8 @@ int main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IP6TABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 11c7cb0..f4b1f18 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -56,7 +56,8 @@ main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IP6TABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
diff --git a/iptables-restore.c b/iptables-restore.c
index 4ea9306..7cc6d6d 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -135,7 +135,8 @@ main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IPTABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
diff --git a/iptables-save.c b/iptables-save.c
index 6252c0b..7118d1f 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -143,7 +143,8 @@ main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IPTABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
diff --git a/iptables-standalone.c b/iptables-standalone.c
index dbfae5b..3f2432f 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -57,7 +57,8 @@ main(int argc, char *argv[])
 	if (lib_dir == NULL) {
 		lib_dir = getenv("IPTABLES_LIB_DIR");
 		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated\n");
+			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
+			        "use XTABLES_LIBDIR.\n");
 	}
 	if (lib_dir == NULL)
 		lib_dir = XTABLES_LIBDIR;
