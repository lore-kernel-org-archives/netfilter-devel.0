From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/41]: remove arpt_target indirection macro
Date: Mon, 14 Apr 2008 12:16:34 +0200 (MEST)
Message-ID: <20080414101631.32717.63687.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36267 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDNKQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:36 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove arpt_target indirection macro

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6e5de8e607daf200cab5e3061903ba71b825324f
tree 05d79c58bb32bd4ec259173037bda98f4fa51b97
parent 9c710d1a92fd88a1070eb9a2cf972257e05c5540
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:45 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:45 +0200

 include/linux/netfilter_arp/arp_tables.h |    1 -
 net/ipv4/netfilter/arp_tables.c          |    8 ++++----
 net/ipv4/netfilter/arpt_mangle.c         |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 102c413..782b83e 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -23,7 +23,6 @@
 
 #define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
-#define arpt_target xt_target
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 34c42c8..d55f3b4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -457,7 +457,7 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
+	struct xt_target *target;
 	int ret;
 
 	t = arpt_get_target(e);
@@ -480,7 +480,7 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 		 unsigned int *i)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
+	struct xt_target *target;
 	int ret;
 
 	ret = check_entry(e, name);
@@ -1784,7 +1784,7 @@ void arpt_unregister_table(struct xt_table *table)
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct arpt_target arpt_standard_target __read_mostly = {
+static struct xt_target arpt_standard_target __read_mostly = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= NF_ARP,
@@ -1795,7 +1795,7 @@ static struct arpt_target arpt_standard_target __read_mostly = {
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
