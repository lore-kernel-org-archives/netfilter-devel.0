From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/11] libxt_mac: use guided option parser
Date: Wed, 11 May 2011 15:52:49 +0200
Message-ID: <1305121977-4361-5-git-send-email-jengelh@medozas.de>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58954 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1EKPxQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:53:16 -0400
In-Reply-To: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_mac.c |   80 ++++++++++++------------------------------------
 1 files changed, 20 insertions(+), 60 deletions(-)

diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index d7e65da..f171d15 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -1,10 +1,4 @@
-/* Shared library add-on to iptables to add MAC address support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
 #else
@@ -13,6 +7,10 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_mac.h>
 
+enum {
+	O_MAC = 0,
+};
+
 static void mac_help(void)
 {
 	printf(
@@ -21,70 +19,33 @@ static void mac_help(void)
 "				Match source MAC address\n");
 }
 
-static const struct option mac_opts[] = {
-	{.name = "mac-source", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
+#define s struct xt_mac_info
+static const struct xt_option_entry mac_opts[] = {
+	{.name = "mac-source", .id = O_MAC, .type = XTTYPE_ETHERMAC,
+	 .flags = XTOPT_MAND | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, srcaddr)},
+	XTOPT_TABLEEND,
 };
+#undef s
 
-static void
-parse_mac(const char *mac, struct xt_mac_info *info)
-{
-	unsigned int i = 0;
-
-	if (strlen(mac) != ETH_ALEN*3-1)
-		xtables_error(PARAMETER_PROBLEM, "Bad mac address \"%s\"", mac);
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		long number;
-		char *end;
-
-		number = strtol(mac + i*3, &end, 16);
-
-		if (end == mac + i*3 + 2
-		    && number >= 0
-		    && number <= 255)
-			info->srcaddr[i] = number;
-		else
-			xtables_error(PARAMETER_PROBLEM,
-				   "Bad mac address `%s'", mac);
-	}
-}
-
-static int
-mac_parse(int c, char **argv, int invert, unsigned int *flags,
-          const void *entry, struct xt_entry_match **match)
+static void mac_parse(struct xt_option_call *cb)
 {
-	struct xt_mac_info *macinfo = (struct xt_mac_info *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		parse_mac(optarg, macinfo);
-		if (invert)
-			macinfo->invert = 1;
-		*flags = 1;
-		break;
-	}
+	struct xt_mac_info *macinfo = cb->data;
 
-	return 1;
+	xtables_option_parse(cb);
+	if (cb->invert)
+		macinfo->invert = 1;
 }
 
-static void print_mac(const unsigned char macaddress[ETH_ALEN])
+static void print_mac(const unsigned char *macaddress)
 {
 	unsigned int i;
 
 	printf(" %02X", macaddress[0]);
-	for (i = 1; i < ETH_ALEN; i++)
+	for (i = 1; i < ETH_ALEN; ++i)
 		printf(":%02X", macaddress[i]);
 }
 
-static void mac_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "You must specify `--mac-source'");
-}
-
 static void
 mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
@@ -115,11 +76,10 @@ static struct xtables_match mac_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.help		= mac_help,
-	.parse		= mac_parse,
-	.final_check	= mac_check,
+	.x6_parse	= mac_parse,
 	.print		= mac_print,
 	.save		= mac_save,
-	.extra_opts	= mac_opts,
+	.x6_options	= mac_opts,
 };
 
 void _init(void)
-- 
1.7.1

