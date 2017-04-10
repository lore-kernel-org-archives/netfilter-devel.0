From: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 1/2 v2] iptables-restore/ip6tables-restore: add --version/-V
 argument
Date: Mon, 10 Apr 2017 12:31:56 -0500
Message-ID: <1491845516.28450.3.camel@redhat.com>
References: <1491255160.5423.16.camel@redhat.com>
         <20170408220418.GA8524@salvia> <1491707416.27302.1.camel@redhat.com>
         <20170410115356.GC2155@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753437AbdDJRcE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 13:32:04 -0400
In-Reply-To: <20170410115356.GC2155@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prints program version just like iptables/ip6tables.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
v2: documented new options in manpage

 iptables/ip6tables-restore.c   | 15 +++++++++++----
 iptables/iptables-restore.8.in |  7 +++++--
 iptables/iptables-restore.c    | 10 ++++++++--
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 30a4ade..419a2b0 100644
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
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 7a286b9..bba505d 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -23,10 +23,10 @@ iptables-restore \(em Restore IP Tables
 .P
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
+\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-M\fP \fImodprobe\fP]
 [\fB\-T\fP \fIname\fP] [\fBfile\fP]
 .P
-\fBip6tables\-restore\fP [\fB\-chntv\fP] [\fB\-M\fP \fImodprobe\fP]
+\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-M\fP \fImodprobe\fP]
 [\fB\-T\fP \fIname\fP] [\fBfile\fP]
 .SH DESCRIPTION
 .PP
@@ -53,6 +53,9 @@ Only parse and construct the ruleset, but do not commit it.
 \fB\-v\fP, \fB\-\-verbose\fP
 Print additional debug info during ruleset processing.
 .TP
+\fB\-V\fP, \fB\-\-version\fP
+Print the program version number.
+.TP
 \fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
 Specify the path to the modprobe program. By default, iptables-restore will
 inspect /proc/sys/kernel/modprobe to determine the executable's path.
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 15db358..cb06559 100644
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
