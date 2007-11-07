From: Peter Warasin <peter@endian.com>
Subject: [PATCH] iptables-restore: renames --test to --dry-run
Date: Wed, 07 Nov 2007 22:25:30 +0100
Message-ID: <47322D4A.3090201@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:55061 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbXKGVZj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:25:39 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id E37C159831F
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Nov 2007 22:25:37 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YV4TfUale4kV for <netfilter-devel@vger.kernel.org>;
	Wed,  7 Nov 2007 22:25:37 +0100 (CET)
Received: from [192.168.75.2] (host115-14-static.23-87-b.business.telecomitalia.it [87.23.14.115])
	by solaria.endian.it (Postfix) with ESMTP id 1C727598310
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Nov 2007 22:25:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by efw-frangart.endian.office (Postfix) with ESMTP id C9AA3277094
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Nov 2007 22:25:33 +0100 (CET)
Received: from [10.7.0.39] (unknown [10.7.0.39])
	by efw-frangart.endian.office (Postfix) with ESMTP id 3E4E6277093
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Nov 2007 22:25:28 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi

The following patch renames the option --test (-t) to --dry-run (-d)
in order to free the letter 't' for --table, which makes the options
more consistent regarding the other *tables tools, where -t is always
--table.

peter

--- patch begins here ---
renames --test (-t) to --dry-run (-d) and -T (--table) to -t
adds missing short options to usage message

Signed-off-by: Peter Warasin <peter@endian.com>
---
Index: iptables-restore.c
===================================================================
--- iptables-restore.c.orig	2007-11-07 21:57:45.000000000 +0100
+++ iptables-restore.c	2007-11-07 22:09:12.000000000 +0100
@@ -29,11 +29,11 @@
 	{ "binary", 0, 0, 'b' },
 	{ "counters", 0, 0, 'c' },
 	{ "verbose", 0, 0, 'v' },
-	{ "test", 0, 0, 't' },
+	{ "dry-run", 0, 0, 'd' },
 	{ "help", 0, 0, 'h' },
 	{ "noflush", 0, 0, 'n'},
 	{ "modprobe", 1, 0, 'M'},
-	{ "table", 1, 0, 'T'},
+	{ "table", 1, 0, 't'},
 	{ 0 }
 };

@@ -41,11 +41,11 @@

 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
+	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-d] [-h] [-n] [-t] [-M]\n"
 			"	   [ --binary ]\n"
 			"	   [ --counters ]\n"
 			"	   [ --verbose ]\n"
-			"	   [ --test ]\n"
+			"	   [ --dry-run ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --table=<TABLE> ]\n"
@@ -139,7 +139,7 @@
 	init_extensions();
 #endif

-	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvdhnM:t:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				binary = 1;
@@ -150,7 +150,7 @@
 			case 'v':
 				verbose = 1;
 				break;
-			case 't':
+			case 'd':
 				testing = 1;
 				break;
 			case 'h':
@@ -163,7 +163,7 @@
 			case 'M':
 				modprobe = optarg;
 				break;
-			case 'T':
+			case 't':
 				tablename = optarg;
 				break;
 		}

