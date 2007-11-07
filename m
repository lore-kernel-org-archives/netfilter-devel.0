From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
 iptables-restore
Date: Wed, 7 Nov 2007 11:52:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
References: <472E6041.7090601@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43203 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXKGKwI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 05:52:08 -0500
In-Reply-To: <472E6041.7090601@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Nov 5 2007 01:13, Peter Warasin wrote:

>Date: Mon, 05 Nov 2007 01:13:53 +0100
>From: Peter Warasin <peter@endian.com>
>To:  <netfilter-devel@vger.kernel.org>
>Subject: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
>    iptables-restore
>
>
>-- 
>:: e n d i a n
>:: open source - open minds
>
>:: peter warasin
>:: http://www.endian.com   :: peter@endian.com
>

Well, please send patches inline so I can reply to something.


|adds --table to iptables-restore which allows to restore only the
|supplied table
|
|Signed-off-by: Peter Warasin <peter@endian.com>
|---
| iptables-restore.c |   12 +++++++++++-
| 1 file changed, 11 insertions(+), 1 deletion(-)
|
|Index: iptables-restore.c
|===================================================================
|--- iptables-restore.c.orig
|+++ iptables-restore.c
|@@ -33,6 +33,7 @@
| 	{ "help", 0, 0, 'h' },
| 	{ "noflush", 0, 0, 'n'},
| 	{ "modprobe", 1, 0, 'M'},
|+	{ "table", 1, 0, 'T'},
| 	{ 0 }
| };
| 
|@@ -47,6 +48,7 @@
| 			"	   [ --test ]\n"
| 			"	   [ --help ]\n"
| 			"	   [ --noflush ]\n"
|+			"	   [ --table=<TABLE> ]\n"
| 		        "          [ --modprobe=<command>]\n", name);
| 		
| 	exit(1);
|@@ -123,6 +125,7 @@
| 	FILE *in;
| 	const char *modprobe = 0;
| 	int in_table = 0, testing = 0;
|+	const char *tablename = 0;

Use NULL instead.

| 
| 	program_name = "iptables-restore";
| 	program_version = IPTABLES_VERSION;
|@@ -136,7 +139,7 @@
| 	init_extensions();
| #endif
| 
|-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
|+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {

Use -t instead, that would go in line with the -t from iptables.

| 		switch (c) {
| 			case 'b':
| 				binary = 1;
|@@ -160,6 +163,9 @@
| 			case 'M':
| 				modprobe = optarg;
| 				break;
|+			case 'T':
|+				tablename = optarg;
|+				break;
| 		}
| 	}
| 	
|@@ -212,6 +218,8 @@
| 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
| 			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
| 
|+			if (tablename && (strcmp(tablename, table) != 0))
|+				continue;

drop extra ()

| 			if (handle)
| 				iptc_free(&handle);
| 
|@@ -438,6 +446,8 @@
| 
| 			free_argv();
| 		}
|+		if (tablename && (strcmp(tablename, curtable) != 0))
|+			continue;
| 		if (!ret) {
| 			fprintf(stderr, "%s: line %u failed\n",
| 					program_name, line);

same
