From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [08/10] [IPTABLES]: Move libipt_recent to libxt_recent
Date: Fri, 1 Feb 2008 01:29:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010129330.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38776 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYBAA3r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:29:47 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move libipt_recent to libxt_recent

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_recent.c                |  231 ------------------------------
 extensions/libipt_recent.man              |   93 ------------
 extensions/libxt_recent.c                 |  217 ++++++++++++++++++++++++++++
 extensions/libxt_recent.man               |   93 ++++++++++++
 include/linux/netfilter/xt_recent.h       |   26 +++
 include/linux/netfilter_ipv4/ipt_recent.h |   27 ---
 6 files changed, 336 insertions(+), 351 deletions(-)

Index: iptables/extensions/libipt_recent.c
===================================================================
--- iptables.orig/extensions/libipt_recent.c
+++ /dev/null
@@ -1,231 +0,0 @@
-/* Shared library add-on to iptables to add recent matching support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-
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
-
-/* Options for this module */
-static const struct option recent_opts[] = {
-	{ .name = "set",      .has_arg = 0, .val = 201 }, 
-	{ .name = "rcheck",   .has_arg = 0, .val = 202 }, 
-	{ .name = "update",   .has_arg = 0, .val = 203 },
-	{ .name = "seconds",  .has_arg = 1, .val = 204 }, 
-	{ .name = "hitcount", .has_arg = 1, .val = 205 },
-	{ .name = "remove",   .has_arg = 0, .val = 206 },
-	{ .name = "rttl",     .has_arg = 0, .val = 207 },
-	{ .name = "name",     .has_arg = 1, .val = 208 },
-	{ .name = "rsource",  .has_arg = 0, .val = 209 },
-	{ .name = "rdest",    .has_arg = 0, .val = 210 },
-	{},
-};
-
-/* Function which prints out usage message. */
-static void recent_help(void)
-{
-	printf(
-"recent v%s options:\n"
-"[!] --set                       Add source address to list, always matches.\n"
-"[!] --rcheck                    Match if source address in list.\n"
-"[!] --update                    Match if source address in list, also update last-seen time.\n"
-"[!] --remove                    Match if source address in list, also removes that address from list.\n"
-"    --seconds seconds           For check and update commands above.\n"
-"                                Specifies that the match will only occur if source address last seen within\n"
-"                                the last 'seconds' seconds.\n"
-"    --hitcount hits             For check and update commands above.\n"
-"                                Specifies that the match will only occur if source address seen hits times.\n"
-"                                May be used in conjunction with the seconds option.\n"
-"    --rttl                      For check and update commands above.\n"
-"                                Specifies that the match will only occur if the source address and the TTL\n"
-"                                match between this packet and the one which was set.\n"
-"                                Useful if you have problems with people spoofing their source address in order\n"
-"                                to DoS you via this module.\n"
-"    --name name                 Name of the recent list to be used.  DEFAULT used if none given.\n"
-"    --rsource                   Match/Save the source address of each packet in the recent list table (default).\n"
-"    --rdest                     Match/Save the destination address of each packet in the recent list table.\n"
-RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n"
-,
-IPTABLES_VERSION);
-
-}
-  
-/* Initialize the match. */
-static void recent_init(struct xt_entry_match *match)
-{
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
-
-
-	strncpy(info->name,"DEFAULT",IPT_RECENT_NAME_LEN);
-	/* eventhough IPT_RECENT_NAME_LEN is currently defined as 200,
-	 * better be safe, than sorry */
-	info->name[IPT_RECENT_NAME_LEN-1] = '\0';
-	info->side = IPT_RECENT_SOURCE;
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
-	switch (c) {
-		case 201:
-			if (*flags) exit_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_SET;
-			if (invert) info->invert = 1;
-			*flags = 1;
-			break;
-			
-		case 202:
-			if (*flags) exit_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_CHECK;
-			if(invert) info->invert = 1;
-			*flags = 1;
-			break;
-
-		case 203:
-			if (*flags) exit_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_UPDATE;
-			if (invert) info->invert = 1;
-			*flags = 1;
-			break;
-
-		case 206:
-			if (*flags) exit_error(PARAMETER_PROBLEM,
-					"recent: only one of `--set', `--rcheck' "
-					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
-			info->check_set |= IPT_RECENT_REMOVE;
-			if (invert) info->invert = 1;
-			*flags = 1;
-			break;
-
-		case 204:
-			info->seconds = atoi(optarg);
-			break;
-
-		case 205:
-			info->hit_count = atoi(optarg);
-			break;
-
-		case 207:
-			info->check_set |= IPT_RECENT_TTL;
-			break;
-
-		case 208:
-			strncpy(info->name,optarg,IPT_RECENT_NAME_LEN);
-			info->name[IPT_RECENT_NAME_LEN-1] = '\0';
-			break;
-
-		case 209:
-			info->side = IPT_RECENT_SOURCE;
-			break;
-
-		case 210:
-			info->side = IPT_RECENT_DEST;
-			break;
-
-		default:
-			return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; must have specified a specific option. */
-static void recent_check(unsigned int flags)
-{
-
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			"recent: you must specify one of `--set', `--rcheck' "
-			"`--update' or `--remove'");
-}
-
-/* Prints out the matchinfo. */
-static void recent_print(const void *ip, const struct xt_entry_match *match,
-                         int numeric)
-{
-	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
-
-	if (info->invert)
-		fputc('!', stdout);
-
-	printf("recent: ");
-	if(info->check_set & IPT_RECENT_SET) printf("SET ");
-	if(info->check_set & IPT_RECENT_CHECK) printf("CHECK ");
-	if(info->check_set & IPT_RECENT_UPDATE) printf("UPDATE ");
-	if(info->check_set & IPT_RECENT_REMOVE) printf("REMOVE ");
-	if(info->seconds) printf("seconds: %d ",info->seconds);
-	if(info->hit_count) printf("hit_count: %d ",info->hit_count);
-	if(info->check_set & IPT_RECENT_TTL) printf("TTL-Match ");
-	if(info->name) printf("name: %s ",info->name);
-	if(info->side == IPT_RECENT_SOURCE) printf("side: source ");
-	if(info->side == IPT_RECENT_DEST) printf("side: dest");
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void recent_save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
-
-	if (info->invert)
-		printf("! ");
-
-	if(info->check_set & IPT_RECENT_SET) printf("--set ");
-	if(info->check_set & IPT_RECENT_CHECK) printf("--rcheck ");
-	if(info->check_set & IPT_RECENT_UPDATE) printf("--update ");
-	if(info->check_set & IPT_RECENT_REMOVE) printf("--remove ");
-	if(info->seconds) printf("--seconds %d ",info->seconds);
-	if(info->hit_count) printf("--hitcount %d ",info->hit_count);
-	if(info->check_set & IPT_RECENT_TTL) printf("--rttl ");
-	if(info->name) printf("--name %s ",info->name);
-	if(info->side == IPT_RECENT_SOURCE) printf("--rsource ");
-	if(info->side == IPT_RECENT_DEST) printf("--rdest ");
-}
-
-/* Structure for iptables to use to communicate with module */
-static struct iptables_match recent_match = {
-    .name          = "recent",
-    .version       = IPTABLES_VERSION,
-    .size          = IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    .userspacesize = IPT_ALIGN(sizeof(struct ipt_recent_info)),
-    .help          = recent_help,
-    .init          = recent_init,
-    .parse         = recent_parse,
-    .final_check   = recent_check,
-    .print         = recent_print,
-    .save          = recent_save,
-    .extra_opts    = recent_opts,
-};
-
-void _init(void);
-void _init(void)
-{
-	register_match(&recent_match);
-}
Index: iptables/extensions/libipt_recent.man
===================================================================
--- iptables.orig/extensions/libipt_recent.man
+++ /dev/null
@@ -1,93 +0,0 @@
-Allows you to dynamically create a list of IP addresses and then match
-against that list in a few different ways.
-
-For example, you can create a `badguy' list out of people attempting
-to connect to port 139 on your firewall and then DROP all future
-packets from them without considering them.
-.TP
-.BI "--name " "name"
-Specify the list to use for the commands. If no name is given then 'DEFAULT'
-will be used.
-.TP
-[\fB!\fR] \fB--set\fR
-This will add the source address of the packet to the list. If the
-source address is already in the list, this will update the existing
-entry. This will always return success (or failure if `!' is passed
-in).
-.TP
-[\fB!\fR] \fB--rcheck\fR
-Check if the source address of the packet is currently in
-the list.
-.TP
-[\fB!\fR] \fB--update\fR
-Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
-matches.
-.TP
-[\fB!\fR] \fB--remove\fR
-Check if the source address of the packet is currently in the list and
-if so that address will be removed from the list and the rule will
-return true. If the address is not found, false is returned.
-.TP
-[\fB!\fR] \fB--seconds \fIseconds\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and was seen within the last given
-number of seconds.
-.TP
-[\fB!\fR] \fB--hitcount \fIhits\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and packets had been received greater
-than or equal to the given value. This option may be used along with
-\fB--seconds\fR to create an even narrower match requiring a certain
-number of hits within a specific time frame.
-.TP
-\fB--rttl\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
-\fB--update\fR. When used, this will narrow the match to only happen
-when the address is in the list and the TTL of the current packet
-matches that of the packet which hit the \fB--set\fR rule. This may be
-useful if you have problems with people faking their source address in
-order to DoS you via this module by disallowing others access to your
-site by sending bogus packets to you.
-.P
-Examples:
-.IP
-# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
-
-# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
-.P
-Official website (http://snowman.net/projects/ipt_recent/) also has
-some examples of usage.
-
-/proc/net/ipt_recent/* are the current lists of addresses and information 
-about each entry of each list.
-
-Each file in /proc/net/ipt_recent/ can be read from to see the current list
-or written two using the following commands to modify the list:
-.TP
-echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
-to Add to the DEFAULT list
-.TP
-echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
-to Remove from the DEFAULT list
-.TP
-echo clear > /proc/net/ipt_recent/DEFAULT
-to empty the DEFAULT list.
-.P
-The module itself accepts parameters, defaults shown:
-.TP
-.BI "ip_list_tot=" "100"
-Number of addresses remembered per table
-.TP
-.BI "ip_pkt_list_tot=" "20"
-Number of packets per address remembered
-.TP
-.BI "ip_list_hash_size=" "0"
-Hash table size. 0 means to calculate it based on ip_list_tot, default: 512
-.TP
-.BI "ip_list_perms=" "0644"
-Permissions for /proc/net/ipt_recent/* files
-.TP
-.BI "debug=" "0"
-Set to 1 to get lots of debugging info
Index: iptables/extensions/libxt_recent.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_recent.c
@@ -0,0 +1,217 @@
+/* Shared library add-on to iptables to add recent matching support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_recent.h>
+
+/* Options for this module */
+static const struct option recent_opts[] = {
+	{ .name = "set",      .has_arg = 0, .val = 201 },
+	{ .name = "rcheck",   .has_arg = 0, .val = 202 },
+	{ .name = "update",   .has_arg = 0, .val = 203 },
+	{ .name = "seconds",  .has_arg = 1, .val = 204 },
+	{ .name = "hitcount", .has_arg = 1, .val = 205 },
+	{ .name = "remove",   .has_arg = 0, .val = 206 },
+	{ .name = "rttl",     .has_arg = 0, .val = 207 },
+	{ .name = "name",     .has_arg = 1, .val = 208 },
+	{ .name = "rsource",  .has_arg = 0, .val = 209 },
+	{ .name = "rdest",    .has_arg = 0, .val = 210 },
+	{},
+};
+
+/* Function which prints out usage message. */
+static void recent_help(void)
+{
+	printf(
+"\"recent\" match options:\n"
+"[!] --set                       Add source address to list, always matches.\n"
+"[!] --rcheck                    Match if source address in list.\n"
+"[!] --update                    Match if source address in list, also update last-seen time.\n"
+"[!] --remove                    Match if source address in list, also removes that address from list.\n"
+"    --seconds seconds           For check and update commands above.\n"
+"                                Specifies that the match will only occur if source address last seen within\n"
+"                                the last 'seconds' seconds.\n"
+"    --hitcount hits             For check and update commands above.\n"
+"                                Specifies that the match will only occur if source address seen hits times.\n"
+"                                May be used in conjunction with the seconds option.\n"
+"    --rttl                      For check and update commands above.\n"
+"                                Specifies that the match will only occur if the source address and the TTL\n"
+"                                match between this packet and the one which was set.\n"
+"                                Useful if you have problems with people spoofing their source address in order\n"
+"                                to DoS you via this module.\n"
+"    --name name                 Name of the recent list to be used.  DEFAULT used if none given.\n"
+"    --rsource                   Match/Save the source address of each packet in the recent list table (default).\n"
+"    --rdest                     Match/Save the destination address of each packet in the recent list table.\n"
+"ipt_recent by: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/\n"
+);
+}
+
+/* Initialize the match. */
+static void recent_init(struct xt_entry_match *match)
+{
+	struct xt_recent_mtinfo *info = (void *)(match)->data;
+
+	strncpy(info->name,"DEFAULT", XT_RECENT_NAME_LEN);
+	/* even though XT_RECENT_NAME_LEN is currently defined as 200,
+	 * better be safe, than sorry */
+	info->name[XT_RECENT_NAME_LEN-1] = '\0';
+	info->side = XT_RECENT_SOURCE;
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_match **match)
+{
+	struct xt_recent_mtinfo *info = (void *)(*match)->data;
+
+	switch (c) {
+		case 201:
+			if (*flags) exit_error(PARAMETER_PROBLEM,
+					"recent: only one of `--set', `--rcheck' "
+					"`--update' or `--remove' may be set");
+			check_inverse(optarg, &invert, &optind, 0);
+			info->check_set |= XT_RECENT_SET;
+			if (invert) info->invert = 1;
+			*flags = 1;
+			break;
+
+		case 202:
+			if (*flags) exit_error(PARAMETER_PROBLEM,
+					"recent: only one of `--set', `--rcheck' "
+					"`--update' or `--remove' may be set");
+			check_inverse(optarg, &invert, &optind, 0);
+			info->check_set |= XT_RECENT_CHECK;
+			if(invert) info->invert = 1;
+			*flags = 1;
+			break;
+
+		case 203:
+			if (*flags) exit_error(PARAMETER_PROBLEM,
+					"recent: only one of `--set', `--rcheck' "
+					"`--update' or `--remove' may be set");
+			check_inverse(optarg, &invert, &optind, 0);
+			info->check_set |= XT_RECENT_UPDATE;
+			if (invert) info->invert = 1;
+			*flags = 1;
+			break;
+
+		case 206:
+			if (*flags) exit_error(PARAMETER_PROBLEM,
+					"recent: only one of `--set', `--rcheck' "
+					"`--update' or `--remove' may be set");
+			check_inverse(optarg, &invert, &optind, 0);
+			info->check_set |= XT_RECENT_REMOVE;
+			if (invert) info->invert = 1;
+			*flags = 1;
+			break;
+
+		case 204:
+			info->seconds = atoi(optarg);
+			break;
+
+		case 205:
+			info->hit_count = atoi(optarg);
+			break;
+
+		case 207:
+			info->check_set |= XT_RECENT_TTL;
+			break;
+
+		case 208:
+			strncpy(info->name,optarg, XT_RECENT_NAME_LEN);
+			info->name[XT_RECENT_NAME_LEN-1] = '\0';
+			break;
+
+		case 209:
+			info->side = XT_RECENT_SOURCE;
+			break;
+
+		case 210:
+			info->side = XT_RECENT_DEST;
+			break;
+
+		default:
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; must have specified a specific option. */
+static void recent_check(unsigned int flags)
+{
+
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"recent: you must specify one of `--set', `--rcheck' "
+			"`--update' or `--remove'");
+}
+
+/* Prints out the matchinfo. */
+static void recent_print(const void *ip, const struct xt_entry_match *match,
+                         int numeric)
+{
+	const struct xt_recent_mtinfo *info = (const void *)match->data;
+
+	if (info->invert)
+		fputc('!', stdout);
+
+	printf("recent: ");
+	if(info->check_set & XT_RECENT_SET) printf("SET ");
+	if(info->check_set & XT_RECENT_CHECK) printf("CHECK ");
+	if(info->check_set & XT_RECENT_UPDATE) printf("UPDATE ");
+	if(info->check_set & XT_RECENT_REMOVE) printf("REMOVE ");
+	if(info->seconds) printf("seconds: %d ",info->seconds);
+	if(info->hit_count) printf("hit_count: %d ",info->hit_count);
+	if(info->check_set & XT_RECENT_TTL) printf("TTL-Match ");
+	if(info->name) printf("name: %s ",info->name);
+	if(info->side == XT_RECENT_SOURCE) printf("side: source ");
+	if(info->side == XT_RECENT_DEST) printf("side: dest");
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void recent_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_recent_mtinfo *info = (const void *)match->data;
+
+	if (info->invert)
+		printf("! ");
+
+	if(info->check_set & XT_RECENT_SET) printf("--set ");
+	if(info->check_set & XT_RECENT_CHECK) printf("--rcheck ");
+	if(info->check_set & XT_RECENT_UPDATE) printf("--update ");
+	if(info->check_set & XT_RECENT_REMOVE) printf("--remove ");
+	if(info->seconds) printf("--seconds %d ",info->seconds);
+	if(info->hit_count) printf("--hitcount %d ",info->hit_count);
+	if(info->check_set & XT_RECENT_TTL) printf("--rttl ");
+	if(info->name) printf("--name %s ",info->name);
+	if(info->side == XT_RECENT_SOURCE) printf("--rsource ");
+	if(info->side == XT_RECENT_DEST) printf("--rdest ");
+}
+
+/* Structure for iptables to use to communicate with module */
+static struct xtables_match recent_match = {
+    .name          = "recent",
+    .version       = IPTABLES_VERSION,
+    .family        = AF_INET,
+    .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+    .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
+    .help          = recent_help,
+    .init          = recent_init,
+    .parse         = recent_parse,
+    .final_check   = recent_check,
+    .print         = recent_print,
+    .save          = recent_save,
+    .extra_opts    = recent_opts,
+};
+
+void _init(void);
+void _init(void)
+{
+	xtables_register_match(&recent_match);
+}
Index: iptables/extensions/libxt_recent.man
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_recent.man
@@ -0,0 +1,93 @@
+Allows you to dynamically create a list of IP addresses and then match
+against that list in a few different ways.
+
+For example, you can create a `badguy' list out of people attempting
+to connect to port 139 on your firewall and then DROP all future
+packets from them without considering them.
+.TP
+.BI "--name " "name"
+Specify the list to use for the commands. If no name is given then 'DEFAULT'
+will be used.
+.TP
+[\fB!\fR] \fB--set\fR
+This will add the source address of the packet to the list. If the
+source address is already in the list, this will update the existing
+entry. This will always return success (or failure if `!' is passed
+in).
+.TP
+[\fB!\fR] \fB--rcheck\fR
+Check if the source address of the packet is currently in
+the list.
+.TP
+[\fB!\fR] \fB--update\fR
+Like \fB--rcheck\fR, except it will update the "last seen" timestamp if it
+matches.
+.TP
+[\fB!\fR] \fB--remove\fR
+Check if the source address of the packet is currently in the list and
+if so that address will be removed from the list and the rule will
+return true. If the address is not found, false is returned.
+.TP
+[\fB!\fR] \fB--seconds \fIseconds\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and was seen within the last given
+number of seconds.
+.TP
+[\fB!\fR] \fB--hitcount \fIhits\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and packets had been received greater
+than or equal to the given value. This option may be used along with
+\fB--seconds\fR to create an even narrower match requiring a certain
+number of hits within a specific time frame.
+.TP
+\fB--rttl\fR
+This option must be used in conjunction with one of \fB--rcheck\fR or
+\fB--update\fR. When used, this will narrow the match to only happen
+when the address is in the list and the TTL of the current packet
+matches that of the packet which hit the \fB--set\fR rule. This may be
+useful if you have problems with people faking their source address in
+order to DoS you via this module by disallowing others access to your
+site by sending bogus packets to you.
+.P
+Examples:
+.IP
+# iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP
+
+# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP
+.P
+Official website (http://snowman.net/projects/ipt_recent/) also has
+some examples of usage.
+
+/proc/net/ipt_recent/* are the current lists of addresses and information
+about each entry of each list.
+
+Each file in /proc/net/ipt_recent/ can be read from to see the current list
+or written two using the following commands to modify the list:
+.TP
+echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
+to Add to the DEFAULT list
+.TP
+echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT
+to Remove from the DEFAULT list
+.TP
+echo clear > /proc/net/ipt_recent/DEFAULT
+to empty the DEFAULT list.
+.P
+The module itself accepts parameters, defaults shown:
+.TP
+.BI "ip_list_tot=" "100"
+Number of addresses remembered per table
+.TP
+.BI "ip_pkt_list_tot=" "20"
+Number of packets per address remembered
+.TP
+.BI "ip_list_hash_size=" "0"
+Hash table size. 0 means to calculate it based on ip_list_tot, default: 512
+.TP
+.BI "ip_list_perms=" "0644"
+Permissions for /proc/net/ipt_recent/* files
+.TP
+.BI "debug=" "0"
+Set to 1 to get lots of debugging info
Index: iptables/include/linux/netfilter/xt_recent.h
===================================================================
--- /dev/null
+++ iptables/include/linux/netfilter/xt_recent.h
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
Index: iptables/include/linux/netfilter_ipv4/ipt_recent.h
===================================================================
--- iptables.orig/include/linux/netfilter_ipv4/ipt_recent.h
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
