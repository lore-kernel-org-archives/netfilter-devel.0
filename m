From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/14] Delete empty ->print() and ->save() functions
Date: Thu, 4 Oct 2007 12:11:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209410.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58022 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbXJDKLs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:11:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 41AF71C07DF86
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:11:47 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Deletes empty ->print() and ->save() functions.
ip[6]tables prints the trivial thing automatically.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_eui64.c  |   17 -----------------
 extensions/libipt_unclean.c |    2 --
 extensions/libxt_TRACE.c    |    4 ----
 extensions/libxt_standard.c |   10 ----------
 4 files changed, 33 deletions(-)

Index: iptables/extensions/libip6t_eui64.c
===================================================================
--- iptables.orig/extensions/libip6t_eui64.c
+++ iptables/extensions/libip6t_eui64.c
@@ -32,21 +32,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Prints out the matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	printf("eui64 ");
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-
-}
-
 static struct ip6tables_match eui64 = {
 	.name 		= "eui64",
 	.version	= IPTABLES_VERSION,
@@ -54,8 +39,6 @@ static struct ip6tables_match eui64 = {
 	.userspacesize	= IP6T_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= &print,
-	.save		= &save,
 };
 
 void _init(void)
Index: iptables/extensions/libipt_unclean.c
===================================================================
--- iptables.orig/extensions/libipt_unclean.c
+++ iptables/extensions/libipt_unclean.c
@@ -31,8 +31,6 @@ struct iptables_match unclean = { 
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= NULL,
-	.save		= NULL,
 };
 
 void _init(void)
Index: iptables/extensions/libxt_TRACE.c
===================================================================
--- iptables.orig/extensions/libxt_TRACE.c
+++ iptables/extensions/libxt_TRACE.c
@@ -34,8 +34,6 @@ static struct xtables_target trace = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= NULL, /* print */
-	.save		= NULL, /* save */
 };
 
 static struct xtables_target trace6 = {
@@ -46,8 +44,6 @@ static struct xtables_target trace6 = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= NULL, /* print */
-	.save		= NULL, /* save */
 };
 
 void _init(void)
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -26,12 +26,6 @@ parse(int c, char **argv, int invert, un
 	return 0;
 }
 
-/* Saves the targinfo in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
-{
-}
-
 static
 struct xtables_target standard = { 
 	.family		= AF_INET,
@@ -41,8 +35,6 @@ struct xtables_target standard = { 
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= NULL,
-	.save		= &save,
 };
 
 static
@@ -54,8 +46,6 @@ struct xtables_target standard6 = { 
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= &help,
 	.parse		= &parse,
-	.print		= NULL,
-	.save		= &save,
 };
 
 void _init(void)
