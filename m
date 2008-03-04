From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/19] [NETFILTER]: remove arpt_target indirection macro
Date: Tue, 4 Mar 2008 17:33:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041732520.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40670 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765545AbYCDQdK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:33:10 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 3ae5fb14df1c2dcd945441b4cf34db3892f9346f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Feb 9 00:45:44 2008 +0100

    [NETFILTER]: remove arpt_target indirection macro
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    1 -
 net/ipv4/netfilter/arp_tables.c          |    8 ++++----
 net/ipv4/netfilter/arpt_mangle.c         |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index b61f044..4aed7c4 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -23,7 +23,6 @@
 
 #define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
-#define arpt_target xt_target
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d3f4eb6..d399725 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -460,7 +460,7 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
+	struct xt_target *target;
 	int ret;
 
 	t = arpt_get_target(e);
@@ -483,7 +483,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 		 unsigned int *i)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
+	struct xt_target *target;
 	int ret;
 
 	ret = check_entry(e, name);
@@ -1787,7 +1787,7 @@ void arpt_unregister_table(struct xt_table *table)
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct arpt_target arpt_standard_target __read_mostly = {
+static struct xt_target arpt_standard_target __read_mostly = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= NF_ARP,
@@ -1798,7 +1798,7 @@ static struct arpt_target arpt_standard_target __read_mostly = {
 #endif
 };
 
-static struct arpt_target arpt_error_target __read_mostly = {
+static struct xt_target arpt_error_target __read_mostly = {
 	.name		= ARPT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 3e732c8..f9c102a 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -73,7 +73,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 	return true;
 }
 
-static struct arpt_target arpt_mangle_reg __read_mostly = {
+static struct xt_target arpt_mangle_reg __read_mostly = {
 	.name		= "mangle",
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
