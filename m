From: Peter Warasin <peter@endian.com>
Subject: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to iptables-restore
Date: Mon, 05 Nov 2007 01:13:53 +0100
Message-ID: <472E6041.7090601@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020007020302060801060402"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:49447 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXKEAN4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:13:56 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 30F5D598323
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 01:13:55 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zi4WLhHOQWSS for <netfilter-devel@vger.kernel.org>;
	Mon,  5 Nov 2007 01:13:54 +0100 (CET)
Received: from [10.139.200.200] (host204-41-dynamic.56-82-r.retail.telecomitalia.it [82.56.41.204])
	by solaria.endian.it (Postfix) with ESMTP id ACFC0598231
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Nov 2007 01:13:53 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020007020302060801060402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------020007020302060801060402
Content-Type: text/x-patch;
 name="iptables-edit-p1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-edit-p1.patch"

adds --table to iptables-restore which allows to restore only the
supplied table

Signed-off-by: Peter Warasin <peter@endian.com>
---
 iptables-restore.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: iptables-restore.c
===================================================================
--- iptables-restore.c.orig
+++ iptables-restore.c
@@ -33,6 +33,7 @@
 	{ "help", 0, 0, 'h' },
 	{ "noflush", 0, 0, 'n'},
 	{ "modprobe", 1, 0, 'M'},
+	{ "table", 1, 0, 'T'},
 	{ 0 }
 };
 
@@ -47,6 +48,7 @@
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
+			"	   [ --table=<TABLE> ]\n"
 		        "          [ --modprobe=<command>]\n", name);
 		
 	exit(1);
@@ -123,6 +125,7 @@
 	FILE *in;
 	const char *modprobe = 0;
 	int in_table = 0, testing = 0;
+	const char *tablename = 0;
 
 	program_name = "iptables-restore";
 	program_version = IPTABLES_VERSION;
@@ -136,7 +139,7 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				binary = 1;
@@ -160,6 +163,9 @@
 			case 'M':
 				modprobe = optarg;
 				break;
+			case 'T':
+				tablename = optarg;
+				break;
 		}
 	}
 	
@@ -212,6 +218,8 @@
 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
 			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
 
+			if (tablename && (strcmp(tablename, table) != 0))
+				continue;
 			if (handle)
 				iptc_free(&handle);
 
@@ -438,6 +446,8 @@
 
 			free_argv();
 		}
+		if (tablename && (strcmp(tablename, curtable) != 0))
+			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
 					program_name, line);

--------------020007020302060801060402
Content-Type: text/x-vcard; charset=utf-8;
 name="peter.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="peter.vcf"

begin:vcard
fn:Peter Warasin
n:;Peter Warasin
org:Endian GmbH/Srl
adr:;;Pillhof 47;Frangart/Frangarto;BZ;I-39010;Italien/Italia
email;internet:peter@endian.com
tel;work:+39 0471 631763
tel;fax:+39 0471 631764
x-mozilla-html:FALSE
url:http://www.endian.com
version:2.1
end:vcard


--------------020007020302060801060402--
