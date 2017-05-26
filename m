From: Oliver Ford <ojford@gmail.com>
Subject: [PATCH 1/1] iptables: Add file output option to iptables-save
Date: Fri, 26 May 2017 12:25:16 +0000
Message-ID: <1495801516-14937-1-git-send-email-ojford@gmail.com>
Cc: Oliver Ford <ojford@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36589 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761180AbdEZMZX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 08:25:23 -0400
Received: by mail-wm0-f66.google.com with SMTP id k15so3735859wmh.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 05:25:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds an option to output the results of iptables-save,
ip6tables-save, and xtables-save save to a file.
Updates the man page with this new option.

Uses the dup2 call to replace stdout with the specified file.
Error output is unchanged.

This is a feature requested by a Gentoo developer in
Bugzilla #905.

Signed-off-by: Oliver Ford <ojford@gmail.com>
---
 iptables/ip6tables-save.c   | 20 +++++++++++++++++++-
 iptables/iptables-save.8.in | 14 +++++++++-----
 iptables/iptables-save.c    | 20 +++++++++++++++++++-
 iptables/xtables-save.c     | 20 +++++++++++++++++++-
 4 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 250ca20..21396e4 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -14,6 +14,7 @@
 #include <time.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <unistd.h>
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
 #include "ip6tables-multi.h"
@@ -25,6 +26,7 @@ static const struct option options[] = {
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "file",     .has_arg = true,  .val = 'f'},
 	{NULL},
 };
 
@@ -129,6 +131,7 @@ int ip6tables_save_main(int argc, char *argv[])
 {
 	const char *tablename = NULL;
 	int c;
+	FILE *file = NULL;
 
 	ip6tables_globals.program_name = "ip6tables-save";
 	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
@@ -143,7 +146,7 @@ int ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:M:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:f:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -159,6 +162,21 @@ int ip6tables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'f':
+			file = fopen(optarg, "w");
+			if (file == NULL) {
+				fprintf(stderr, "Failed to open file, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			int ret = dup2(fileno(file), STDOUT_FILENO);
+			if (ret == -1) {
+				fprintf(stderr, "Failed to redirect stdout, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			fclose(file);
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 7f99d8a..51e11f3 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -19,27 +19,31 @@
 .\"
 .\"
 .SH NAME
-iptables-save \(em dump iptables rules to stdout
+iptables-save \(em dump iptables rules
 .P
-ip6tables-save \(em dump iptables rules to stdout
+ip6tables-save \(em dump iptables rules
 .SH SYNOPSIS
 \fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP]
+[\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
 .P
 \fBip6tables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP]
+[\fB\-t\fP \fItable\fP] [\fB\-f\fP \fIfilename\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-save
 and
 .B ip6tables-save
 are used to dump the contents of IP or IPv6 Table in easily parseable format
-to STDOUT. Use I/O-redirection provided by your shell to write to a file.
+either to STDOUT or to a specified file.
 .TP
 \fB\-M\fR, \fB\-\-modprobe\fR \fImodprobe_program\fP
 Specify the path to the modprobe program. By default, iptables-save will
 inspect /proc/sys/kernel/modprobe to determine the executable's path.
 .TP
+\fB\-f\fR, \fB\-\-file\fR \fIfilename\fP
+Specify a filename to log the output to. If not specified, iptables-save
+will log to STDOUT.
+.TP
 \fB\-c\fR, \fB\-\-counters\fR
 include the current values of all packet and byte counters in the output
 .TP
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 52929b0..00ff05e 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <time.h>
 #include <netdb.h>
+#include <unistd.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
 #include "iptables-multi.h"
@@ -24,6 +25,7 @@ static const struct option options[] = {
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "file",     .has_arg = true,  .val = 'f'},
 	{NULL},
 };
 
@@ -128,6 +130,7 @@ iptables_save_main(int argc, char *argv[])
 {
 	const char *tablename = NULL;
 	int c;
+	FILE *file = NULL;
 
 	iptables_globals.program_name = "iptables-save";
 	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
@@ -142,7 +145,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:M:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:f:", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -158,6 +161,21 @@ iptables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'f':
+			file = fopen(optarg, "w");
+			if (file == NULL) {
+				fprintf(stderr, "Failed to open file, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			int ret = dup2(fileno(file), STDOUT_FILENO);
+			if (ret == -1) {
+				fprintf(stderr, "Failed to redirect stdout, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			fclose(file);
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index abd840a..45bb690 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <time.h>
 #include <netdb.h>
+#include <unistd.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
 #include "xtables-multi.h"
@@ -32,6 +33,7 @@ static const struct option options[] = {
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "file",     .has_arg = true,  .val = 'f'},
 	{.name = "ipv4",     .has_arg = false, .val = '4'},
 	{.name = "ipv6",     .has_arg = false, .val = '6'},
 	{NULL},
@@ -83,6 +85,7 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		.family	= family,
 	};
 	int c;
+	FILE *file = NULL;
 
 	xtables_globals.program_name = progname;
 	c = xtables_init_all(&xtables_globals, family);
@@ -104,7 +107,7 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcdt:M:46", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:M:f:46", options, NULL)) != -1) {
 		switch (c) {
 		case 'b':
 			fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -120,6 +123,21 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'f':
+			file = fopen(optarg, "w");
+			if (file == NULL) {
+				fprintf(stderr, "Failed to open file, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			int ret = dup2(fileno(file), STDOUT_FILENO);
+			if (ret == -1) {
+				fprintf(stderr, "Failed to redirect stdout, error: %s\n",
+					strerror(errno));
+				exit(1);
+			}
+			fclose(file);
+			break;
 		case 'd':
 			dump = true;
 			break;
-- 
2.11.0


