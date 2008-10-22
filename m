From: Jan Engelhardt <jengelh@medozas.de>
Subject: Move libipt_recent to libxt_recent
Date: Wed, 22 Oct 2008 12:45:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810221245140.13144@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJVQpf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:45:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d4cc5a5eb6c20f4771f6e348849a3cfef3e283c7
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 22 12:20:32 2008 -0400

Move libipt_recent to libxt_recent

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/{libipt_recent.c => libxt_recent.c}     |  127 ++++++------
 extensions/{libipt_recent.man => libxt_recent.man} |    2 +-
 include/linux/netfilter/xt_recent.h                |   26 +++
 include/linux/netfilter_ipv4/ipt_recent.h          |   27 ---
 4 files changed, 91 insertions(+), 91 deletions(-)
 rename extensions/{libipt_recent.c => libxt_recent.c} (65%)
 rename extensions/{libipt_recent.man => libxt_recent.man} (99%)
 create mode 100644 include/linux/netfilter/xt_recent.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_recent.h

diff --git a/extensions/libipt_recent.c b/extensions/libxt_recent.c
similarity index 65%
rename from extensions/libipt_recent.c
rename to extensions/libxt_recent.c
index 7281fe5..028c563 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libxt_recent.c
@@ -5,27 +5,14 @@
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
@@ -57,29 +44,29 @@ static void recent_help(void)
 "    --name name                 Name of the recent list to be used.  DEFAULT used if none given.\n"
 "    --rsource                   Match/Save the source address of each packet in the recent list table (default).\n"
 "    --rdest                     Match/Save the destination address of each packet in the recent list table.\n"
-RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n");
+"xt_recent by: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n");
 }
 
 static void recent_init(struct xt_entry_match *match)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
+	struct xt_recent_mtinfo *info = (void *)(match)->data;
 
-
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
 
 #define RECENT_CMDS \
-	(IPT_RECENT_SET | IPT_RECENT_CHECK | \
-	IPT_RECENT_UPDATE | IPT_RECENT_REMOVE)
+	(XT_RECENT_SET | XT_RECENT_CHECK | \
+	XT_RECENT_UPDATE | XT_RECENT_REMOVE)
 
 static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
+	struct xt_recent_mtinfo *info = (void *)(*match)->data;
+
 	switch (c) {
 		case 201:
 			if (*flags & RECENT_CMDS)
@@ -87,20 +74,20 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_SET;
+			info->check_set |= XT_RECENT_SET;
 			if (invert) info->invert = 1;
-			*flags |= IPT_RECENT_SET;
+			*flags |= XT_RECENT_SET;
 			break;
-			
+
 		case 202:
 			if (*flags & RECENT_CMDS)
 				exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_CHECK;
+			info->check_set |= XT_RECENT_CHECK;
 			if(invert) info->invert = 1;
-			*flags |= IPT_RECENT_CHECK;
+			*flags |= XT_RECENT_CHECK;
 			break;
 
 		case 203:
@@ -109,9 +96,9 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_UPDATE;
+			info->check_set |= XT_RECENT_UPDATE;
 			if (invert) info->invert = 1;
-			*flags |= IPT_RECENT_UPDATE;
+			*flags |= XT_RECENT_UPDATE;
 			break;
 
 		case 206:
@@ -120,9 +107,9 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_REMOVE;
+			info->check_set |= XT_RECENT_REMOVE;
 			if (invert) info->invert = 1;
-			*flags |= IPT_RECENT_REMOVE;
+			*flags |= XT_RECENT_REMOVE;
 			break;
 
 		case 204:
@@ -134,21 +121,21 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		case 207:
-			info->check_set |= IPT_RECENT_TTL;
-			*flags |= IPT_RECENT_TTL;
+			info->check_set |= XT_RECENT_TTL;
+			*flags |= XT_RECENT_TTL;
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
@@ -164,8 +151,8 @@ static void recent_check(unsigned int flags)
 		exit_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
 			"`--update' or `--remove'");
-	if ((flags & IPT_RECENT_TTL) &&
-	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE)))
+	if ((flags & XT_RECENT_TTL) &&
+	    (flags & (XT_RECENT_SET | XT_RECENT_REMOVE)))
 		exit_error(PARAMETER_PROBLEM,
 		           "recent: --rttl may only be used with --rcheck or "
 		           "--update");
@@ -174,49 +161,63 @@ static void recent_check(unsigned int flags)
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
 
 static struct xtables_match recent_mt_reg = {
     .name          = "recent",
     .version       = XTABLES_VERSION,
     .family        = PF_INET,
-    .size          = XT_ALIGN(sizeof(struct ipt_recent_info)),
-    .userspacesize = XT_ALIGN(sizeof(struct ipt_recent_info)),
+    .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+    .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
     .help          = recent_help,
     .init          = recent_init,
     .parse         = recent_parse,
diff --git a/extensions/libipt_recent.man b/extensions/libxt_recent.man
similarity index 99%
rename from extensions/libipt_recent.man
rename to extensions/libxt_recent.man
index d5bdaa0..f36457c 100644
--- a/extensions/libipt_recent.man
+++ b/extensions/libxt_recent.man
@@ -67,7 +67,7 @@ Examples:
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

