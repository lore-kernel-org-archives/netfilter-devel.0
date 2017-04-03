From: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] iptables-restore/ip6tables-restore: add --version/-V
 argument
Date: Mon, 03 Apr 2017 16:32:40 -0500
Message-ID: <1491255160.5423.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751842AbdDCVcm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2017 17:32:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1E4031F3E9
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Apr 2017 21:32:41 +0000 (UTC)
Received: from ovpn-112-30.phx2.redhat.com (ovpn-112-30.phx2.redhat.com [10.3.112.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32A0B78491
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Apr 2017 21:32:41 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prints program version just like iptables/ip6tables.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 iptables/ip6tables-restore.c | 15 +++++++++++----
 iptables/iptables-restore.c  | 10 ++++++++--
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 8a47f09..83f4e4c 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -36,6 +36,7 @@ static struct timeval wait_interval = {
 static const struct option options[] = {
 	{.name = "counters",      .has_arg = 0, .val = 'c'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
+	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "test",          .has_arg = 0, .val = 't'},
 	{.name = "help",          .has_arg = 0, .val = 'h'},
 	{.name = "noflush",       .has_arg = 0, .val = 'n'},
@@ -48,11 +49,15 @@ static const struct option options[] = {
 
 static void print_usage(const char *name, const char *version) __attribute__((noreturn));
 
+#define prog_name ip6tables_globals.program_name
+#define prog_vers ip6tables_globals.program_version
+
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-w secs] [-W usecs] [-T table] [-M command]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-V] [-t] [-h] [-n] [-w secs] [-W usecs] [-T table] [-M command]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
+			"	   [ --version]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
@@ -78,8 +83,7 @@ static struct xtc_handle *create_handle(const char *tablename)
 
 	if (!handle) {
 		xtables_error(PARAMETER_PROBLEM, "%s: unable to initialize "
-			"table '%s'\n", ip6tables_globals.program_name,
-			tablename);
+			"table '%s'\n", prog_name, tablename);
 		exit(1);
 	}
 	return handle;
@@ -213,7 +217,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnwWM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvVthnwWM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -224,6 +228,9 @@ int ip6tables_restore_main(int argc, char *argv[])
 			case 'v':
 				verbose = 1;
 				break;
+			case 'V':
+				printf("%s v%s\n", prog_name, prog_vers);
+				exit(0);
 			case 't':
 				testing = 1;
 				break;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 7bb06d8..a51deb5 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -33,6 +33,7 @@ static struct timeval wait_interval = {
 static const struct option options[] = {
 	{.name = "counters",      .has_arg = 0, .val = 'c'},
 	{.name = "verbose",       .has_arg = 0, .val = 'v'},
+	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "test",          .has_arg = 0, .val = 't'},
 	{.name = "help",          .has_arg = 0, .val = 'h'},
 	{.name = "noflush",       .has_arg = 0, .val = 'n'},
@@ -46,12 +47,14 @@ static const struct option options[] = {
 static void print_usage(const char *name, const char *version) __attribute__((noreturn));
 
 #define prog_name iptables_globals.program_name
+#define prog_vers iptables_globals.program_version
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-t] [-h] [-n] [-w secs] [-W usecs] [-T table] [-M command]\n"
+	fprintf(stderr, "Usage: %s [-c] [-v] [-V] [-t] [-h] [-n] [-w secs] [-W usecs] [-T table] [-M command]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
+			"	   [ --version]\n"
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
@@ -212,7 +215,7 @@ iptables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnwWM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvVthnwWM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -223,6 +226,9 @@ iptables_restore_main(int argc, char *argv[])
 			case 'v':
 				verbose = 1;
 				break;
+			case 'V':
+				printf("%s v%s\n", prog_name, prog_vers);
+				exit(0);
 			case 't':
 				testing = 1;
 				break;
-- 
2.9.3
