From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/14] Delete empty ->init() functions
Date: Thu, 4 Oct 2007 12:11:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209330.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58020 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbXJDKLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:11:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 54A061C070210
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:11:18 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Deletes empty ->init() functions. ip[6]tables already
checks for .init being NULL or not.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_HL.c       |    5 -----
 extensions/libip6t_policy.c   |    5 -----
 extensions/libipt_CLUSTERIP.c |    6 ------
 extensions/libipt_ECN.c       |    5 -----
 extensions/libipt_MIRROR.c    |    7 -------
 extensions/libipt_TOS.c       |    7 -------
 extensions/libipt_TTL.c       |    5 -----
 extensions/libipt_policy.c    |    5 -----
 extensions/libxt_CLASSIFY.c   |    8 --------
 extensions/libxt_CONNMARK.c   |    8 --------
 extensions/libxt_DSCP.c       |    7 -------
 extensions/libxt_MARK.c       |    9 ---------
 extensions/libxt_NFQUEUE.c    |    6 ------
 extensions/libxt_NOTRACK.c    |    8 --------
 extensions/libxt_SECMARK.c    |    6 ------
 extensions/libxt_TCPMSS.c     |    8 --------
 extensions/libxt_TRACE.c      |    8 --------
 extensions/libxt_multiport.c  |   10 ----------
 extensions/libxt_physdev.c    |    7 -------
 extensions/libxt_standard.c   |    8 --------
 20 files changed, 138 deletions(-)

Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables.orig/extensions/libip6t_HL.c
+++ iptables/extensions/libip6t_HL.c
@@ -16,10 +16,6 @@
 
 #define IP6T_HL_USED	1
 
-static void init(struct xt_entry_target *t)
-{
-}
-
 static void help(void) 
 {
 	printf(
@@ -152,7 +148,6 @@ struct ip6tables_target HL = {
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
 	.help		= &help, 
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -133,10 +133,6 @@ extern void parse_hostnetworkmask(const 
 
 /* End duplicated code from ip6tables.c */
 
-static void init(struct xt_entry_match *m)
-{
-}
-
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
@@ -462,7 +458,6 @@ struct ip6tables_match policy = {
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
 	.help		= help,
-	.init		= init,
 	.parse		= parse,
 	.final_check	= final_check,
 	.print		= print,
Index: iptables/extensions/libipt_CLUSTERIP.c
===================================================================
--- iptables.orig/extensions/libipt_CLUSTERIP.c
+++ iptables/extensions/libipt_CLUSTERIP.c
@@ -55,11 +55,6 @@ static const struct option opts[] = {
 };
 
 static void
-init(struct xt_entry_target *t)
-{
-}
-
-static void
 parse_mac(const char *mac, char *macbuf)
 {
 	unsigned int i = 0;
@@ -253,7 +248,6 @@ static struct iptables_target clusterip 
 	.size		= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
 	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
  	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libipt_ECN.c
===================================================================
--- iptables.orig/extensions/libipt_ECN.c
+++ iptables/extensions/libipt_ECN.c
@@ -17,10 +17,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
-static void init(struct xt_entry_target *t)
-{
-}
-
 static void help(void) 
 {
 	printf(
@@ -170,7 +166,6 @@ struct iptables_target ecn = { 
 	.size		= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libipt_MIRROR.c
===================================================================
--- iptables.orig/extensions/libipt_MIRROR.c
+++ iptables/extensions/libipt_MIRROR.c
@@ -16,12 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -43,7 +37,6 @@ static struct iptables_target mirror = {
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
  	.help		= &help,
-	.init		= &init,
  	.parse		= &parse,
 	.final_check 	= &final_check,
 	.print		= NULL,
Index: iptables/extensions/libipt_TOS.c
===================================================================
--- iptables.orig/extensions/libipt_TOS.c
+++ iptables/extensions/libipt_TOS.c
@@ -52,12 +52,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 static void
 parse_tos(const char *s, struct ipt_tos_target_info *info)
 {
@@ -159,7 +153,6 @@ static struct iptables_target tos = {
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libipt_TTL.c
===================================================================
--- iptables.orig/extensions/libipt_TTL.c
+++ iptables/extensions/libipt_TTL.c
@@ -16,10 +16,6 @@
 
 #define IPT_TTL_USED	1
 
-static void init(struct xt_entry_target *t)
-{
-}
-
 static void help(void) 
 {
 	printf(
@@ -152,7 +148,6 @@ static struct iptables_target TTL = {
 	.size		= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libipt_policy.c
===================================================================
--- iptables.orig/extensions/libipt_policy.c
+++ iptables/extensions/libipt_policy.c
@@ -93,10 +93,6 @@ static const struct option opts[] =
 	{ }
 };
 
-static void init(struct xt_entry_match *m)
-{
-}
-
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
@@ -420,7 +416,6 @@ struct iptables_match policy = {
 	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_policy_info)),
 	.help		= help,
-	.init		= init,
 	.parse		= parse,
 	.final_check	= final_check,
 	.print		= print,
Index: iptables/extensions/libxt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libxt_CLASSIFY.c
+++ iptables/extensions/libxt_CLASSIFY.c
@@ -26,12 +26,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 int string_to_priority(const char *s, unsigned int *p)
 {
 	unsigned int i, j;
@@ -115,7 +109,6 @@ static struct xtables_target classify = 
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -130,7 +123,6 @@ static struct xtables_target classify6 =
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c
+++ iptables/extensions/libxt_CONNMARK.c
@@ -56,12 +56,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -207,7 +201,6 @@ static struct xtables_target connmark_ta
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -222,7 +215,6 @@ static struct xtables_target connmark_ta
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_DSCP.c
===================================================================
--- iptables.orig/extensions/libxt_DSCP.c
+++ iptables/extensions/libxt_DSCP.c
@@ -21,11 +21,6 @@
 /* This is evil, but it's my code - HW*/
 #include "libipt_dscp_helper.c"
 
-
-static void init(struct xt_entry_target *t)
-{
-}
-
 static void help(void) 
 {
 	printf(
@@ -150,7 +145,6 @@ static struct xtables_target dscp = { 
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -165,7 +159,6 @@ static struct xtables_target dscp6 = { 
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_MARK.c
===================================================================
--- iptables.orig/extensions/libxt_MARK.c
+++ iptables/extensions/libxt_MARK.c
@@ -28,12 +28,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -192,7 +186,6 @@ static struct xtables_target mark_v0 = {
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse_v0,
 	.final_check	= &final_check,
 	.print		= &print_v0,
@@ -208,7 +201,6 @@ static struct xtables_target mark_v1 = {
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse_v1,
 	.final_check	= &final_check,
 	.print		= &print_v1,
@@ -224,7 +216,6 @@ static struct xtables_target mark6_v0 = 
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse_v0,
 	.final_check	= &final_check,
 	.print		= &print_v0,
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -14,10 +14,6 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFQUEUE.h>
 
-static void init(struct xt_entry_target *t)
-{
-}
-
 static void help(void) 
 {
 	printf(
@@ -100,7 +96,6 @@ static struct xtables_target nfqueue = {
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -115,7 +110,6 @@ static struct xtables_target nfqueue6 = 
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_NOTRACK.c
===================================================================
--- iptables.orig/extensions/libxt_NOTRACK.c
+++ iptables/extensions/libxt_NOTRACK.c
@@ -16,12 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -46,7 +40,6 @@ struct xtables_target notrack =
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 };
@@ -60,7 +53,6 @@ struct xtables_target notrack6 =
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 };
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -28,10 +28,6 @@ static const struct option opts[] = {
 	{ 0 }
 };
 
-/* Initialize the target. */
-static void init(struct xt_entry_target *t)
-{ }
-
 /*
  * Function which parses command options; returns true if it
  * ate an option.
@@ -111,7 +107,6 @@ static struct xtables_target secmark = {
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -127,7 +122,6 @@ static struct xtables_target secmark6 = 
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -42,12 +42,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -146,7 +140,6 @@ static struct xtables_target mss = {
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -161,7 +154,6 @@ static struct xtables_target mss6 = {
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= &help6,
-	.init		= &init,
 	.parse		= &parse6,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_TRACE.c
===================================================================
--- iptables.orig/extensions/libxt_TRACE.c
+++ iptables/extensions/libxt_TRACE.c
@@ -16,12 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -44,7 +38,6 @@ static struct xtables_target trace = {
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= NULL, /* print */
@@ -58,7 +51,6 @@ static struct xtables_target trace6 = {
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= NULL, /* print */
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -133,12 +133,6 @@ parse_multi_ports_v1(const char *portstr
  	free(buffer);
 }
 
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m)
-{
-}
-
 static const char *
 check_proto(u_int16_t pnum, u_int8_t invflags)
 {
@@ -523,7 +517,6 @@ static struct xtables_match multiport = 
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -539,7 +532,6 @@ static struct xtables_match multiport6 =
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse6,
 	.final_check	= &final_check,
 	.print		= &print6,
@@ -555,7 +547,6 @@ static struct xtables_match multiport_v1
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.help		= &help_v1,
-	.init		= &init,
 	.parse		= &parse_v1,
 	.final_check	= &final_check,
 	.print		= &print_v1,
@@ -571,7 +562,6 @@ static struct xtables_match multiport6_v
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.help		= &help_v1,
-	.init		= &init,
 	.parse		= &parse6_v1,
 	.final_check	= &final_check,
 	.print		= &print6_v1,
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -34,11 +34,6 @@ static const struct option opts[] = {
 	{ }
 };
 
-static void
-init(struct xt_entry_match *m)
-{
-}
-
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
@@ -178,7 +173,6 @@ static struct xtables_match physdev = { 
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
@@ -193,7 +187,6 @@ static struct xtables_match physdev6 = {
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= &print,
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -16,12 +16,6 @@ help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
 }
 
-/* Initialize the target. */
-static void
-init(struct xt_entry_target *t)
-{
-}
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -51,7 +45,6 @@ struct xtables_target standard = { 
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= NULL,
@@ -66,7 +59,6 @@ struct xtables_target standard6 = { 
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
-	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
 	.print		= NULL,
