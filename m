From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 024/103] netfilter: xtables: mark table constant for registering functions
Date: Tue,  4 Aug 2009 09:25:08 +0200
Message-ID: <1249370787-17583-25-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbZHDH07 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:59 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The inputted table is never modified, so should be considered const.
This will allow future constification of the next layers higher up.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |    2 +-
 include/linux/netfilter_arp/arp_tables.h  |    2 +-
 include/linux/netfilter_bridge/ebtables.h |    2 +-
 include/linux/netfilter_ipv4/ip_tables.h  |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 net/bridge/netfilter/ebtables.c           |   13 +++++++------
 net/ipv4/netfilter/arp_tables.c           |    3 ++-
 net/ipv4/netfilter/ip_tables.c            |    3 ++-
 net/ipv6/netfilter/ip6_tables.c           |    3 ++-
 net/netfilter/x_tables.c                  |    7 ++++---
 10 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1a1e4d2..b71d9fa 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -407,7 +407,7 @@ extern int xt_check_target(struct xt_tgchk_param *,
 			   unsigned int size, u_int8_t proto, bool inv_proto);
 
 extern struct xt_table *xt_register_table(struct net *net,
-					  struct xt_table *table,
+					  const struct xt_table *table,
 					  struct xt_table_info *bootstrap,
 					  struct xt_table_info *newinfo);
 extern void *xt_unregister_table(struct xt_table *table);
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 590ac3d..6fe3e6a 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -265,7 +265,7 @@ struct arpt_error
 }
 
 extern struct xt_table *arpt_register_table(struct net *net,
-					    struct xt_table *table,
+					    const struct xt_table *table,
 					    const struct arpt_replace *repl);
 extern void arpt_unregister_table(struct xt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index e40ddb9..ea281e6 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -301,7 +301,7 @@ struct ebt_table
 #define EBT_ALIGN(s) (((s) + (__alignof__(struct ebt_replace)-1)) & \
 		     ~(__alignof__(struct ebt_replace)-1))
 extern struct ebt_table *ebt_register_table(struct net *net,
-					    struct ebt_table *table);
+					    const struct ebt_table *table);
 extern void ebt_unregister_table(struct ebt_table *table);
 extern unsigned int ebt_do_table(unsigned int hook, struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out,
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 092bd50..61fafc8 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -245,7 +245,7 @@ ipt_get_target(struct ipt_entry *e)
 extern void ipt_init(void) __init;
 
 extern struct xt_table *ipt_register_table(struct net *net,
-					   struct xt_table *table,
+					   const struct xt_table *table,
 					   const struct ipt_replace *repl);
 extern void ipt_unregister_table(struct xt_table *table);
 
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 1089e33..a64e145 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -306,7 +306,7 @@ ip6t_get_target(struct ip6t_entry *e)
 extern void ip6t_init(void) __init;
 
 extern struct xt_table *ip6t_register_table(struct net *net,
-					    struct xt_table *table,
+					    const struct xt_table *table,
 					    const struct ip6t_replace *repl);
 extern void ip6t_unregister_table(struct xt_table *table);
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 37928d5..bd1c654 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1103,23 +1103,24 @@ free_newinfo:
 	return ret;
 }
 
-struct ebt_table *ebt_register_table(struct net *net, struct ebt_table *table)
+struct ebt_table *
+ebt_register_table(struct net *net, const struct ebt_table *input_table)
 {
 	struct ebt_table_info *newinfo;
-	struct ebt_table *t;
+	struct ebt_table *t, *table;
 	struct ebt_replace_kernel *repl;
 	int ret, i, countersize;
 	void *p;
 
-	if (!table || !(repl = table->table) || !repl->entries ||
-	    repl->entries_size == 0 ||
-	    repl->counters || table->private) {
+	if (input_table == NULL || (repl = input_table->table) == NULL ||
+	    repl->entries == 0 || repl->entries_size == 0 ||
+	    repl->counters != NULL || input_table->private != NULL) {
 		BUGPRINT("Bad table data for ebt_register_table!!!\n");
 		return ERR_PTR(-EINVAL);
 	}
 
 	/* Don't add one table to multiple lists. */
-	table = kmemdup(table, sizeof(struct ebt_table), GFP_KERNEL);
+	table = kmemdup(input_table, sizeof(struct ebt_table), GFP_KERNEL);
 	if (!table) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7bc11ff..27774c9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1778,7 +1778,8 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 	return ret;
 }
 
-struct xt_table *arpt_register_table(struct net *net, struct xt_table *table,
+struct xt_table *arpt_register_table(struct net *net,
+				     const struct xt_table *table,
 				     const struct arpt_replace *repl)
 {
 	int ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0b43fd7..cde755d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2065,7 +2065,8 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ipt_register_table(struct net *net, struct xt_table *table,
+struct xt_table *ipt_register_table(struct net *net,
+				    const struct xt_table *table,
 				    const struct ipt_replace *repl)
 {
 	int ret;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a5d0c27..cc9f8ef 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2100,7 +2100,8 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-struct xt_table *ip6t_register_table(struct net *net, struct xt_table *table,
+struct xt_table *ip6t_register_table(struct net *net,
+				     const struct xt_table *table,
 				     const struct ip6t_replace *repl)
 {
 	int ret;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 7e3f51d..f7c4c39 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -736,16 +736,17 @@ xt_replace_table(struct xt_table *table,
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
 
-struct xt_table *xt_register_table(struct net *net, struct xt_table *table,
+struct xt_table *xt_register_table(struct net *net,
+				   const struct xt_table *input_table,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo)
 {
 	int ret;
 	struct xt_table_info *private;
-	struct xt_table *t;
+	struct xt_table *t, *table;
 
 	/* Don't add one object to multiple lists. */
-	table = kmemdup(table, sizeof(struct xt_table), GFP_KERNEL);
+	table = kmemdup(input_table, sizeof(struct xt_table), GFP_KERNEL);
 	if (!table) {
 		ret = -ENOMEM;
 		goto out;
-- 
1.6.3.3

