From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] ip6tables-restore: implement missing -T option
Date: Sun, 11 Sep 2011 12:38:45 +0200
Message-ID: <1315737527-19595-4-git-send-email-jengelh@medozas.de>
References: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:56943 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1IKKiz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:38:55 -0400
In-Reply-To: <1315737527-19595-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.0-rc1-12-ge8665f8 forgot to port the change to the
ip6tables part.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables-restore.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 985744d..1487504 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -36,6 +36,7 @@ static const struct option options[] = {
 	{.name = "help",     .has_arg = false, .val = 'h'},
 	{.name = "noflush",  .has_arg = false, .val = 'n'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
+	{.name = "table",    .has_arg = true,  .val = 'T'},
 	{NULL},
 };
 
@@ -121,6 +122,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
 	FILE *in;
 	int in_table = 0, testing = 0;
+	const char *tablename = NULL;
 
 	line = 0;
 
@@ -137,7 +139,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				binary = 1;
@@ -161,6 +163,9 @@ int ip6tables_restore_main(int argc, char *argv[])
 			case 'M':
 				xtables_modprobe_program = optarg;
 				break;
+			case 'T':
+				tablename = optarg;
+				break;
 		}
 	}
 
@@ -216,6 +221,8 @@ int ip6tables_restore_main(int argc, char *argv[])
 			strncpy(curtable, table, IP6T_TABLE_MAXNAMELEN);
 			curtable[IP6T_TABLE_MAXNAMELEN] = '\0';
 
+			if (tablename != NULL && strcmp(tablename, table) != 0)
+				continue;
 			if (handle)
 				ip6tc_free(handle);
 
@@ -442,6 +449,8 @@ int ip6tables_restore_main(int argc, char *argv[])
 			free_argv();
 			fflush(stdout);
 		}
+		if (tablename != NULL && strcmp(tablename, curtable) != 0)
+			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
 					ip6tables_globals.program_name,
-- 
1.7.3.4

