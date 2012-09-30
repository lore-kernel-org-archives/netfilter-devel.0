From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 08/17] iptables-restore: kill unused -b option
Date: Sun, 30 Sep 2012 12:22:11 +0200
Message-ID: <1349000540-17508-9-git-send-email-jengelh@inai.de>
References: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38815 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2I3KW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:27 -0400
In-Reply-To: <1349000540-17508-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"-b"/"--binary" never ever did anything. Remove it.

References: http://bugs.debian.org/644221
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.c |   11 +++--------
 iptables/iptables-restore.c  |   11 +++--------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 0e8252f..4ddbe46 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -25,11 +25,10 @@
 #define DEBUGP(x, args...)
 #endif
 
-static int binary = 0, counters = 0, verbose = 0, noflush = 0;
+static int counters = 0, verbose = 0, noflush = 0;
 
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
-	{.name = "binary",   .has_arg = false, .val = 'b'},
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "verbose",  .has_arg = false, .val = 'v'},
 	{.name = "test",     .has_arg = false, .val = 't'},
@@ -44,8 +43,7 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
-			"	   [ --binary ]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
@@ -204,11 +202,8 @@ int ip6tables_restore_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
-			case 'b':
-				binary = 1;
-				break;
 			case 'c':
 				counters = 1;
 				break;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 0822513..af54b6e 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -22,11 +22,10 @@
 #define DEBUGP(x, args...)
 #endif
 
-static int binary = 0, counters = 0, verbose = 0, noflush = 0;
+static int counters = 0, verbose = 0, noflush = 0;
 
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
-	{.name = "binary",   .has_arg = false, .val = 'b'},
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "verbose",  .has_arg = false, .val = 'v'},
 	{.name = "test",     .has_arg = false, .val = 't'},
@@ -43,8 +42,7 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
-			"	   [ --binary ]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
@@ -204,11 +202,8 @@ iptables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
-			case 'b':
-				binary = 1;
-				break;
 			case 'c':
 				counters = 1;
 				break;
-- 
1.7.10.4

