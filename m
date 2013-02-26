From: jonh.wendell@gmail.com
Subject: [PATCH] iptables-save: add --chain argument, limits output to a chain
Date: Tue, 26 Feb 2013 08:33:02 -0300
Message-ID: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
Cc: Jonh Wendell <jonh.wendell@oiwifi.com.br>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f182.google.com ([209.85.160.182]:33210 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab3BZLdK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:33:10 -0500
Received: by mail-gh0-f182.google.com with SMTP id z15so653739ghb.41
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2013 03:33:09 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jonh Wendell <jonh.wendell@oiwifi.com.br>

Similar to the --table argument, if a --chain (or -C) argument
is passed, we limit the output to rules of that chain.

Signed-off-by: Jonh Wendell <jonh.wendell@oiwifi.com.br>
---
 iptables/iptables-save.8 |    8 ++++++--
 iptables/iptables-save.c |   13 ++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables-save.8 b/iptables/iptables-save.8
index c2e0a94..2f510d0 100644
--- a/iptables/iptables-save.8
+++ b/iptables/iptables-save.8
@@ -1,4 +1,4 @@
-.TH IPTABLES-SAVE 8 "Jan 04, 2001" "" ""
+.TH IPTABLES-SAVE 8 "Feb 25, 2013" "" ""
 .\"
 .\" Man page written by Harald Welte <laforge@gnumonks.org>
 .\" It is based on the iptables man page.
@@ -22,7 +22,7 @@
 iptables-save \(em dump iptables rules to stdout
 .SH SYNOPSIS
 \fBiptables\-save\fP [\fB\-M\fP \fImodprobe\fP] [\fB\-c\fP]
-[\fB\-t\fP \fItable\fP]
+[\fB\-t\fP \fItable\fP] [\fB\-C\fP \fIchain\fP]
 .SH DESCRIPTION
 .PP
 .B iptables-save
@@ -39,6 +39,10 @@ include the current values of all packet and byte counters in the output
 \fB\-t\fR, \fB\-\-table\fR \fItablename\fP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-C\fR, \fB\-\-chain\fR \fIchainname\fP
+restrict output to only one chain. If not specified, output includes all
+available chains.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHOR
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..aae77b6 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -22,12 +22,14 @@
 #endif
 
 static int show_counters = 0;
+static char *chainname = NULL;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "dump",     .has_arg = false, .val = 'd'},
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "chain",    .has_arg = true,  .val = 'C'},
 	{NULL},
 };
 
@@ -85,6 +87,9 @@ static int do_output(const char *tablename)
 	     chain;
 	     chain = iptc_next_chain(h)) {
 
+		if (chainname && *chainname && strcmp(chain, chainname))
+			continue;
+
 		printf(":%s ", chain);
 		if (iptc_builtin(chain, h)) {
 			struct xt_counters count;
@@ -101,6 +106,9 @@ static int do_output(const char *tablename)
 	     chain = iptc_next_chain(h)) {
 		const struct ipt_entry *e;
 
+		if (chainname && *chainname && strcmp(chain, chainname))
+			continue;
+
 		/* Dump out rules */
 		e = iptc_first_rule(chain, h);
 		while(e) {
@@ -140,7 +148,7 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcdt:C:", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			show_counters = 1;
@@ -153,6 +161,9 @@ iptables_save_main(int argc, char *argv[])
 		case 'M':
 			xtables_modprobe_program = optarg;
 			break;
+		case 'C':
+			chainname = optarg;
+			break;
 		case 'd':
 			do_output(tablename);
 			exit(0);
-- 
1.7.10.4

