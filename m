From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 1/2] iptables: save&restore: warn that -b/--binary isn't implemented
Date: Fri, 14 Mar 2014 12:52:47 +0100
Message-ID: <1394797968-9525-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaCNLxA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:53:00 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2EBqx4c029575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2014 07:52:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

see also 296dca39be
---
 iptables/ip6tables-restore.c | 8 +++-----
 iptables/ip6tables-save.c    | 3 +++
 iptables/iptables-restore.c  | 8 +++-----
 iptables/iptables-save.c     | 3 +++
 iptables/xtables-restore.c   | 8 +++-----
 iptables/xtables-save.c      | 3 +++
 6 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index b8b9e0d..0f4dd97 100644
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
@@ -207,7 +205,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
-				binary = 1;
+				fprintf(stderr, "-b/--binary option is not implemented\n");
 				break;
 			case 'c':
 				counters = 1;
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index a86a64a..16821da 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -139,6 +139,9 @@ int ip6tables_save_main(int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
 		switch (c) {
+		case 'b':
+			fprintf(stderr, "-b/--binary option is not implemented\n");
+			break;
 		case 'c':
 			show_counters = 1;
 			break;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 8c942ff..261822d 100644
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
@@ -207,7 +205,7 @@ iptables_restore_main(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
-				binary = 1;
+				fprintf(stderr, "-b/--binary option is not implemented\n");
 				break;
 			case 'c':
 				counters = 1;
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 2999c7f..2c25b71 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -138,6 +138,9 @@ iptables_save_main(int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
 		switch (c) {
+		case 'b':
+			fprintf(stderr, "-b/--binary option is not implemented\n");
+			break;
 		case 'c':
 			show_counters = 1;
 			break;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index f7850bb..3cb095f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -24,11 +24,10 @@
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
@@ -47,8 +46,7 @@ static void print_usage(const char *name, const char *version) __attribute__((no
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
-			"	   [ --binary ]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --test ]\n"
@@ -208,7 +206,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "bcvthnM:T:46", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
-				binary = 1;
+				fprintf(stderr, "-b/--binary option is not implemented\n");
 				break;
 			case 'c':
 				counters = 1;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 42d2907..fe77283 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -106,6 +106,9 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "bcdt:46", options, NULL)) != -1) {
 		switch (c) {
+		case 'b':
+			fprintf(stderr, "-b/--binary option is not implemented\n");
+			break;
 		case 'c':
 			show_counters = true;
 			break;
-- 
1.8.5.3

