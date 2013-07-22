From: Sanket Shah <sanket.shah@cyberoam.com>
Subject: [PATCH] ebtables: Adding --noflush command line support for ebtables-restore
Date: Mon, 22 Jul 2013 19:31:16 +0530
Message-ID: <1374501676-28005-1-git-send-email-sanket.shah@cyberoam.com>
Cc: bdschuym@pandora.be, Sanket Shah <sanket.shah@cyberoam.com>,
	Ankit Shah <ankit.shah.sm@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:10115 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755599Ab3GVOH1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:07:27 -0400
Received: from unknown (HELO localhost.localdomain) (sanket.shah@[10.103.6.186])
          (envelope-sender <sanket.shah@cyberoam.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 22 Jul 2013 14:00:44 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to iptables-restore with noflush.

Signed-off-by: Ankit Shah <ankit.shah.sm@gmail.com>
Signed-off-by: Sanket Shah <sanket.shah@cyberoam.com>
---
 userspace/ebtables2/ebtables-restore.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/userspace/ebtables2/ebtables-restore.c b/userspace/ebtables2/ebtables-restore.c
index ea02960..bb4d0cf 100644
--- a/userspace/ebtables2/ebtables-restore.c
+++ b/userspace/ebtables2/ebtables-restore.c
@@ -22,13 +22,25 @@
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
+#include <getopt.h>
 #include "include/ebtables_u.h"
 
+static const struct option options[] = {
+	{.name = "noflush", .has_arg = 0, .val = 'n'},
+	{ 0 }
+};
+
 static struct ebt_u_replace replace[3];
 void ebt_early_init_once();
 
 #define OPT_KERNELDATA  0x800 /* Also defined in ebtables.c */
 
+static void print_usage()
+{
+	fprintf(stderr, "Usage: ebtables-restore [ --noflush ]\n");
+	exit(1);
+}
+
 static void copy_table_names()
 {
 	strcpy(replace[0].name, "filter");
@@ -41,11 +53,20 @@ static void copy_table_names()
 int main(int argc_, char *argv_[])
 {
 	char *argv[EBTD_ARGC_MAX], cmdline[EBTD_CMDLINE_MAXLN];
-	int i, offset, quotemode = 0, argc, table_nr = -1, line = 0, whitespace;
+	int i, offset, quotemode = 0, argc, table_nr = -1, line = 0, whitespace, c, flush = 1;
 	char ebtables_str[] = "ebtables";
 
-	if (argc_ != 1)
-		ebtrest_print_error("options are not supported");
+	while ((c = getopt_long(argc_, argv_, "n", options, NULL)) != -1) {
+		switch(c) {
+			case 'n':
+				flush = 0;
+				break;
+			default:
+				print_usage();
+				break;
+		}
+	}
+
 	ebt_silent = 0;
 	copy_table_names();
 	ebt_early_init_once();
@@ -68,7 +89,7 @@ int main(int argc_, char *argv_[])
 				ebtrest_print_error("table '%s' was not recognized", cmdline+1);
 			table_nr = i;
 			replace[table_nr].command = 11;
-			ebt_get_kernel_table(&replace[table_nr], 1);
+			ebt_get_kernel_table(&replace[table_nr], flush);
 			replace[table_nr].command = 0;
 			replace[table_nr].flags = OPT_KERNELDATA; /* Prevent do_command from initialising replace */
 			continue;
-- 
1.7.6.4

