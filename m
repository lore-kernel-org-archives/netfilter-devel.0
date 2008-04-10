From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/13] Move libipt_recent to libxt_recent
Date: Thu, 10 Apr 2008 09:38:11 +0200
Message-ID: <d3033172e8809e30f6ce06e9c7e1685bb7a61f86.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50177 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYDJHiV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:21 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/{libipt_recent.c => libxt_recent.c}     |  122 ++++++------
 extensions/{libipt_recent.man => libxt_recent.man} |    2 +-
 include/linux/netfilter/xt_recent.h                |   26 +++
 include/linux/netfilter_ipv4/ipt_recent.h          |   27 ---
 4 files changed, 88 insertions(+), 89 deletions(-)
 rename extensions/{libipt_recent.c => libxt_recent.c} (67%)
 rename extensions/{libipt_recent.man => libxt_recent.man} (99%)
 create mode 100644 include/linux/netfilter/xt_recent.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_recent.h

diff --git a/extensions/libipt_recent.c b/extensions/libxt_recent.c
similarity index 67%
rename from extensions/libipt_recent.c
rename to extensions/libxt_recent.c
index ace778e..2fc5dca 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libxt_recent.c
@@ -5,28 +5,15 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_recent.h>
-
-/* Need these in order to not fail when compiling against an older kernel. */
-#ifndef RECENT_NAME
-#define RECENT_NAME	"ipt_recent"
-#endif /* RECENT_NAME */
-
-#ifndef RECENT_VER
-#define RECENT_VER	"unknown"
-#endif /* RECENT_VER */
-
-#ifndef IPT_RECENT_NAME_LEN
-#define IPT_RECENT_NAME_LEN	200
-#endif /* IPT_RECENT_NAME_LEN */
+#include <xtables.h>
+#include <linux/netfilter/xt_recent.h>
 
 /* Options for this module */
 static const struct option recent_opts[] = {
-	{ .name = "set",      .has_arg = 0, .val = 201 }, 
-	{ .name = "rcheck",   .has_arg = 0, .val = 202 }, 
+	{ .name = "set",      .has_arg = 0, .val = 201 },
+	{ .name = "rcheck",   .has_arg = 0, .val = 202 },
 	{ .name = "update",   .has_arg = 0, .val = 203 },
-	{ .name = "seconds",  .has_arg = 1, .val = 204 }, 
+	{ .name = "seconds",  .has_arg = 1, .val = 204 },
 	{ .name = "hitcount", .has_arg = 1, .val = 205 },
 	{ .name = "remove",   .has_arg = 0, .val = 206 },
 	{ .name = "rttl",     .has_arg = 0, .val = 207 },
@@ -40,7 +27,7 @@ static const struct option recent_opts[] = {
 static void recent_help(void)
 {
 	printf(
-"recent v%s options:\n"
+"\"recent\" match options:\n"
 "[!] --set                       Add source address to list, always matches.\n"
 "[!] --rcheck                    Match if source address in list.\n"
 "[!] --update                    Match if source address in list, also update last-seen time.\n"
@@ -59,23 +46,20 @@ static void recent_help(void)
 "    --name name                 Name of the recent list to be used.  DEFAULT used if none given.\n"
 "    --rsource                   Match/Save the source address of each packet in the recent list table (default).\n"
 "    --rdest                     Match/Save the destination address of each packet in the recent list table.\n"
-RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n"
-,
-IPTABLES_VERSION);
-
+"ipt_recent by: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n"
+);
 }
-  
+
 /* Initialize the match. */
 static void recent_init(struct xt_entry_match *match)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
-
+	struct xt_recent_mtinfo *info = (void *)(match)->data;
 
-	strncpy(info->name,"DEFAULT",IPT_RECENT_NAME_LEN);
-	/* eventhough IPT_RECENT_NAME_LEN is currently defined as 200,
+	strncpy(info->name,"DEFAULT", XT_RECENT_NAME_LEN);
+	/* even though XT_RECENT_NAME_LEN is currently defined as 200,
 	 * better be safe, than sorry */
-	info->name[IPT_RECENT_NAME_LEN-1] = '\0';
-	info->side = IPT_RECENT_SOURCE;
+	info->name[XT_RECENT_NAME_LEN-1] = '\0';
+	info->side = XT_RECENT_SOURCE;
 }
 
 /* Function which parses command options; returns true if it
@@ -83,24 +67,25 @@ static void recent_init(struct xt_entry_match *match)
 static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
+	struct xt_recent_mtinfo *info = (void *)(*match)->data;
+
 	switch (c) {
 		case 201:
 			if (*flags) exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_SET;
+			info->check_set |= XT_RECENT_SET;
 			if (invert) info->invert = 1;
 			*flags = 1;
 			break;
-			
+
 		case 202:
 			if (*flags) exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_CHECK;
+			info->check_set |= XT_RECENT_CHECK;
 			if(invert) info->invert = 1;
 			*flags = 1;
 			break;
@@ -110,7 +95,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_UPDATE;
+			info->check_set |= XT_RECENT_UPDATE;
 			if (invert) info->invert = 1;
 			*flags = 1;
 			break;
@@ -120,7 +105,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_REMOVE;
+			info->check_set |= XT_RECENT_REMOVE;
 			if (invert) info->invert = 1;
 			*flags = 1;
 			break;
@@ -134,20 +119,20 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		case 207:
-			info->check_set |= IPT_RECENT_TTL;
+			info->check_set |= XT_RECENT_TTL;
 			break;
 
 		case 208:
-			strncpy(info->name,optarg,IPT_RECENT_NAME_LEN);
-			info->name[IPT_RECENT_NAME_LEN-1] = '\0';
+			strncpy(info->name,optarg, XT_RECENT_NAME_LEN);
+			info->name[XT_RECENT_NAME_LEN-1] = '\0';
 			break;
 
 		case 209:
-			info->side = IPT_RECENT_SOURCE;
+			info->side = XT_RECENT_SOURCE;
 			break;
 
 		case 210:
-			info->side = IPT_RECENT_DEST;
+			info->side = XT_RECENT_DEST;
 			break;
 
 		default:
@@ -171,50 +156,65 @@ static void recent_check(unsigned int flags)
 static void recent_print(const void *ip, const struct xt_entry_match *match,
                          int numeric)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
+	const struct xt_recent_mtinfo *info = (const void *)match->data;
 
 	if (info->invert)
 		fputc('!', stdout);
 
 	printf("recent: ");
-	if(info->check_set & IPT_RECENT_SET) printf("SET ");
-	if(info->check_set & IPT_RECENT_CHECK) printf("CHECK ");
-	if(info->check_set & IPT_RECENT_UPDATE) printf("UPDATE ");
-	if(info->check_set & IPT_RECENT_REMOVE) printf("REMOVE ");
+	if (info->check_set & XT_RECENT_SET)
+		printf("SET ");
+	if (info->check_set & XT_RECENT_CHECK)
+		printf("CHECK ");
+	if (info->check_set & XT_RECENT_UPDATE)
+		printf("UPDATE ");
+	if (info->check_set & XT_RECENT_REMOVE)
+		printf("REMOVE ");
 	if(info->seconds) printf("seconds: %d ",info->seconds);
 	if(info->hit_count) printf("hit_count: %d ",info->hit_count);
-	if(info->check_set & IPT_RECENT_TTL) printf("TTL-Match ");
+	if (info->check_set & XT_RECENT_TTL)
+		printf("TTL-Match ");
 	if(info->name) printf("name: %s ",info->name);
-	if(info->side == IPT_RECENT_SOURCE) printf("side: source ");
-	if(info->side == IPT_RECENT_DEST) printf("side: dest");
+	if (info->side == XT_RECENT_SOURCE)
+		printf("side: source ");
+	if (info->side == XT_RECENT_DEST)
+		printf("side: dest");
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void recent_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
+	const struct xt_recent_mtinfo *info = (const void *)match->data;
 
 	if (info->invert)
 		printf("! ");
 
-	if(info->check_set & IPT_RECENT_SET) printf("--set ");
-	if(info->check_set & IPT_RECENT_CHECK) printf("--rcheck ");
-	if(info->check_set & IPT_RECENT_UPDATE) printf("--update ");
-	if(info->check_set & IPT_RECENT_REMOVE) printf("--remove ");
+	if (info->check_set & XT_RECENT_SET)
+		printf("--set ");
+	if (info->check_set & XT_RECENT_CHECK)
+		printf("--rcheck ");
+	if (info->check_set & XT_RECENT_UPDATE)
+		printf("--update ");
+	if (info->check_set & XT_RECENT_REMOVE)
+		printf("--remove ");
 	if(info->seconds) printf("--seconds %d ",info->seconds);
 	if(info->hit_count) printf("--hitcount %d ",info->hit_count);
-	if(info->check_set & IPT_RECENT_TTL) printf("--rttl ");
+	if (info->check_set & XT_RECENT_TTL)
+		printf("--rttl ");
 	if(info->name) printf("--name %s ",info->name);
-	if(info->side == IPT_RECENT_SOURCE) printf("--rsource ");
-	if(info->side == IPT_RECENT_DEST) printf("--rdest ");
+	if (info->side == XT_RECENT_SOURCE)
+		printf("--rsource ");
+	if (info->side == XT_RECENT_DEST)
+		printf("--rdest ");
 }
 
 /* Structure for iptables to use to communicate with module */
-static struct iptables_match recent_match = {
+static struct xtables_match recent_match = {
     .name          = "recent",
     .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_recent_info)),
+    .family        = AF_INET,
+    .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+    .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
     .help          = recent_help,
     .init          = recent_init,
     .parse         = recent_parse,
@@ -226,5 +226,5 @@ static struct iptables_match recent_match = {
 
 void _init(void)
 {
-	register_match(&recent_match);
+	xtables_register_match(&recent_match);
 }
diff --git a/extensions/libipt_recent.man b/extensions/libxt_recent.man
similarity index 99%
rename from extensions/libipt_recent.man
rename to extensions/libxt_recent.man
index bf5d710..25be677 100644
--- a/extensions/libipt_recent.man
+++ b/extensions/libxt_recent.man
@@ -60,7 +60,7 @@ Examples:
 Official website (http://snowman.net/projects/ipt_recent/) also has
 some examples of usage.
 
-/proc/net/ipt_recent/* are the current lists of addresses and information 
+/proc/net/ipt_recent/* are the current lists of addresses and information
 about each entry of each list.
 
 Each file in /proc/net/ipt_recent/ can be read from to see the current list
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
new file mode 100644
index 0000000..5cfeb81
--- /dev/null
+++ b/include/linux/netfilter/xt_recent.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_NETFILTER_XT_RECENT_H
+#define _LINUX_NETFILTER_XT_RECENT_H 1
+
+enum {
+	XT_RECENT_CHECK    = 1 << 0,
+	XT_RECENT_SET      = 1 << 1,
+	XT_RECENT_UPDATE   = 1 << 2,
+	XT_RECENT_REMOVE   = 1 << 3,
+	XT_RECENT_TTL      = 1 << 4,
+
+	XT_RECENT_SOURCE   = 0,
+	XT_RECENT_DEST     = 1,
+
+	XT_RECENT_NAME_LEN = 200,
+};
+
+struct xt_recent_mtinfo {
+	u_int32_t seconds;
+	u_int32_t hit_count;
+	u_int8_t check_set;
+	u_int8_t invert;
+	char name[XT_RECENT_NAME_LEN];
+	u_int8_t side;
+};
+
+#endif /* _LINUX_NETFILTER_XT_RECENT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_recent.h b/include/linux/netfilter_ipv4/ipt_recent.h
deleted file mode 100644
index 6508a45..0000000
--- a/include/linux/netfilter_ipv4/ipt_recent.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef _IPT_RECENT_H
-#define _IPT_RECENT_H
-
-#define RECENT_NAME	"ipt_recent"
-#define RECENT_VER	"v0.3.1"
-
-#define IPT_RECENT_CHECK  1
-#define IPT_RECENT_SET    2
-#define IPT_RECENT_UPDATE 4
-#define IPT_RECENT_REMOVE 8
-#define IPT_RECENT_TTL   16
-
-#define IPT_RECENT_SOURCE 0
-#define IPT_RECENT_DEST   1
-
-#define IPT_RECENT_NAME_LEN 200
-
-struct ipt_recent_info {
-	u_int32_t   seconds;
-	u_int32_t   hit_count;
-	u_int8_t    check_set;
-	u_int8_t    invert;
-	char        name[IPT_RECENT_NAME_LEN];
-	u_int8_t    side;
-};
-
-#endif /*_IPT_RECENT_H*/
-- 
1.5.5.rc3

