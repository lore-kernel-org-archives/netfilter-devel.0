From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] netfilter: xtables: mark initial tables constant
Date: Mon, 10 Aug 2009 21:19:50 +0200
Message-ID: <1249931992-18761-5-git-send-email-jengelh@medozas.de>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33985 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZHJTUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:03 -0400
In-Reply-To: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The inputted table is never modified, so should be considered const.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |    2 +-
 include/linux/netfilter_arp/arp_tables.h  |    2 +-
 include/linux/netfilter_bridge/ebtables.h |    2 +-
 include/linux/netfilter_ipv4/ip_tables.h  |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 net/bridge/netfilter/ebtable_broute.c     |    2 +-
 net/bridge/netfilter/ebtable_filter.c     |    2 +-
 net/bridge/netfilter/ebtables.c           |   13 +++++++------
 net/ipv4/netfilter/arp_tables.c           |    3 ++-
 net/ipv4/netfilter/arptable_filter.c      |    4 ++--
 net/ipv4/netfilter/ip_tables.c            |    3 ++-
 net/ipv4/netfilter/iptable_filter.c       |    2 +-
 net/ipv4/netfilter/iptable_mangle.c       |    4 ++--
 net/ipv4/netfilter/iptable_raw.c          |    4 ++--
 net/ipv4/netfilter/iptable_security.c     |    4 ++--
 net/ipv4/netfilter/nf_nat_rule.c          |    4 ++--
 net/ipv6/netfilter/ip6_tables.c           |    3 ++-
 net/ipv6/netfilter/ip6table_filter.c      |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c      |    4 ++--
 net/ipv6/netfilter/ip6table_raw.c         |    4 ++--
 net/ipv6/netfilter/ip6table_security.c    |    4 ++--
 net/netfilter/x_tables.c                  |    7 ++++---
 22 files changed, 42 insertions(+), 37 deletions(-)

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
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index c751111..d32ab13 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -41,7 +41,7 @@ static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
 	return 0;
 }
 
-static struct ebt_table broute_table =
+static const struct ebt_table broute_table =
 {
 	.name		= "broute",
 	.table		= &initial_table,
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 4b988db..60b1a6c 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -50,7 +50,7 @@ static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
 	return 0;
 }
 
-static struct ebt_table frame_filter =
+static const struct ebt_table frame_filter =
 {
 	.name		= "filter",
 	.table		= &initial_table,
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
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index e07045b..1828a77 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -15,7 +15,7 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
-static struct
+static const struct
 {
 	struct arpt_replace repl;
 	struct arpt_standard entries[3];
@@ -45,7 +45,7 @@ static struct
 	.term = ARPT_ERROR_INIT,
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
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
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index edfa552..18bd254 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -53,7 +53,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index a6840f6..a217de4 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -28,7 +28,7 @@ MODULE_DESCRIPTION("iptables mangle table");
 			    (1 << NF_INET_POST_ROUTING))
 
 /* Ouch - five different hooks? Maybe this should be a config option..... -- BC */
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[5];
@@ -64,7 +64,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_mangler = {
+static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 9f85c9a..7767253 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -9,7 +9,7 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[2];
@@ -36,7 +36,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index ccb527e..118e514 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -27,7 +27,7 @@ MODULE_DESCRIPTION("iptables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
@@ -57,7 +57,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table security_table = {
+static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 6448a9b..9e81e0d 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -28,7 +28,7 @@
 			 (1 << NF_INET_POST_ROUTING) | \
 			 (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
@@ -58,7 +58,7 @@ static struct
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
-static struct xt_table nat_table = {
+static const struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
 	.me		= THIS_MODULE,
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
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 2be11ee..c01d7c2 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -51,7 +51,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_filter = {
+static const struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 500bfbe..8765824 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -21,7 +21,7 @@ MODULE_DESCRIPTION("ip6tables mangle table");
 			    (1 << NF_INET_LOCAL_OUT) | \
 			    (1 << NF_INET_POST_ROUTING))
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[5];
@@ -57,7 +57,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_mangler = {
+static const struct xt_table packet_mangler = {
 	.name		= "mangle",
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index b8f9b41..228a665 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -8,7 +8,7 @@
 
 #define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[2];
@@ -35,7 +35,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table packet_raw = {
+static const struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 6eab20d..7928087 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -26,7 +26,7 @@ MODULE_DESCRIPTION("ip6tables security table, for MAC rules");
 				(1 << NF_INET_FORWARD) | \
 				(1 << NF_INET_LOCAL_OUT)
 
-static struct
+static const struct
 {
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[3];
@@ -56,7 +56,7 @@ static struct
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
-static struct xt_table security_table = {
+static const struct xt_table security_table = {
 	.name		= "security",
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
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
1.6.4

