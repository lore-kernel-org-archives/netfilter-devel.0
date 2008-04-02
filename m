From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/24] [NETFILTER]: remove arpt_target indirection macro
Date: Wed,  2 Apr 2008 13:11:44 +0200
Message-ID: <ef59f093e2edf2c64a70167450794466c5823c5a.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43145 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYDBLMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:08 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
index a658bee..41579c6 100644
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
-- 
1.5.4.4

