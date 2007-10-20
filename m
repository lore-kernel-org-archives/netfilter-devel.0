From: Peter Warasin <peter@endian.com>
Subject: [PATCH 1/3] iptables-edit: adds --table to iptables-restore
Date: Sat, 20 Oct 2007 02:57:00 +0200
Message-ID: <4719525C.2080400@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030807010303050708060501"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:40331 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935381AbXJTBYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:24:42 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id BA95D598230
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:57:03 +0200 (CEST)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eNxu7mIgM7+e for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Oct 2007 02:57:01 +0200 (CEST)
Received: from [10.139.200.200] (host92-108-dynamic.54-82-r.retail.telecomitalia.it [82.54.108.92])
	by solaria.endian.it (Postfix) with ESMTP id 4BF9E59821F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:57:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030807010303050708060501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

adds --table to iptables-restore which allows to restore only the
supplied table

Signed-off-by: Peter Warasin <peter@endian.com>

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------030807010303050708060501
Content-Type: text/x-patch;
 name="iptables-1.3.8-edit-p1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.3.8-edit-p1.patch"

--- iptables-1.3.8.patch/iptables-restore.c.orig	2007-10-19 01:17:49.000000000 +0200
+++ iptables-1.3.8.patch/iptables-restore.c	2007-10-19 01:33:06.000000000 +0200
@@ -32,6 +32,7 @@
 	{ "help", 0, 0, 'h' },
 	{ "noflush", 0, 0, 'n'},
 	{ "modprobe", 1, 0, 'M'},
+	{ "table", 1, 0, 'T'},
 	{ 0 }
 };
 
@@ -46,6 +47,7 @@
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
+			"	   [ --table=<TABLE> ]\n"
 		        "          [ --modprobe=<command>]\n", name);
 		
 	exit(1);
@@ -114,6 +116,7 @@
 	FILE *in;
 	const char *modprobe = 0;
 	int in_table = 0, testing = 0;
+	const char *tablename = 0;
 
 	program_name = "iptables-restore";
 	program_version = IPTABLES_VERSION;
@@ -127,7 +130,7 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				binary = 1;
@@ -151,6 +154,9 @@
 			case 'M':
 				modprobe = optarg;
 				break;
+			case 'T':
+				tablename = optarg;
+				break;
 		}
 	}
 	
@@ -203,6 +209,8 @@
 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
 			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
 
+			if (tablename && (strcmp(tablename, table) != 0))
+				continue;
 			if (handle)
 				iptc_free(&handle);
 
@@ -429,6 +437,8 @@
 
 			free_argv();
 		}
+		if (tablename && (strcmp(tablename, curtable) != 0))
+			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
 					program_name, line);

--------------030807010303050708060501--
