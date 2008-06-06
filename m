From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/11: ip_tables: add iptables security table for mandatory access control rules
Date: Fri,  6 Jun 2008 17:17:49 +0200 (MEST)
Message-ID: <20080606151748.25286.32679.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48140 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbYFFPRw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:52 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ip_tables: add iptables security table for mandatory access control rules

The following patch implements a new "security" table for iptables, so
that MAC (SELinux etc.) networking rules can be managed separately to
standard DAC rules.

This is to help with distro integration of the new secmark-based
network controls, per various previous discussions.

The need for a separate table arises from the fact that existing tools
and usage of iptables will likely clash with centralized MAC policy
management.

The SECMARK and CONNSECMARK targets will still be valid in the mangle
table to prevent breakage of existing users.

Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9ca9e6f29c9a45b477de6f6ec63bc39331c384a2
tree 8cf9e0db3c50b215b470494ba3a3f11c86fb8f4b
parent f3cca975999eb8009c2e912cd11948e0208a2de7
author James Morris <jmorris@namei.org> Fri, 06 Jun 2008 17:10:43 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:10:43 +0200

 include/linux/netfilter_ipv4.h        |    1 
 include/net/netns/ipv4.h              |    1 
 net/ipv4/netfilter/Kconfig            |   12 ++
 net/ipv4/netfilter/Makefile           |    1 
 net/ipv4/netfilter/iptable_security.c |  180 +++++++++++++++++++++++++++++++++
 net/netfilter/xt_CONNSECMARK.c        |   10 +-
 net/netfilter/xt_SECMARK.c            |   10 +-
 7 files changed, 209 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 650318b..29c7727 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -60,6 +60,7 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_MANGLE = -150,
 	NF_IP_PRI_NAT_DST = -100,
 	NF_IP_PRI_FILTER = 0,
+	NF_IP_PRI_SECURITY = 50,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
 	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 34ee348..6ef90b5 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -36,6 +36,7 @@ struct netns_ipv4 {
 	struct xt_table		*iptable_mangle;
 	struct xt_table		*iptable_raw;
 	struct xt_table		*arptable_filter;
+	struct xt_table		*iptable_security;
 #endif
 
 	int sysctl_icmp_echo_ignore_all;
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 2767841..fe8344f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -365,6 +365,18 @@ config IP_NF_RAW
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+# security table for MAC policy
+config IP_NF_SECURITY
+	tristate "Security table"
+	depends on IP_NF_IPTABLES
+	depends on SECURITY
+	default m if NETFILTER_ADVANCED=n
+	help
+	  This option adds a `security' table to iptables, for use
+	  with Mandatory Access Control (MAC) policy.
+	 
+	  If unsure, say N.
+
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index d9b92fb..3f31291 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
 obj-$(CONFIG_IP_NF_MANGLE) += iptable_mangle.o
 obj-$(CONFIG_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
+obj-$(CONFIG_IP_NF_SECURITY) += iptable_security.o
 
 # matches
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
new file mode 100644
index 0000000..2b472ac
--- /dev/null
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -0,0 +1,180 @@
+/*
+ * "security" table
+ *
+ * This is for use by Mandatory Access Control (MAC) security models,
+ * which need to be able to manage security policy in separate context
+ * to DAC.
+ *
+ * Based on iptable_mangle.c
+ *
+ * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ * Copyright (C) 2000-2004 Netfilter Core Team <coreteam <at> netfilter.org>
+ * Copyright (C) 2008 Red Hat, Inc., James Morris <jmorris <at> redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/ip.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("James Morris <jmorris <at> redhat.com>");
+MODULE_DESCRIPTION("iptables security table, for MAC rules");
+
+#define SECURITY_VALID_HOOKS	(1 << NF_INET_LOCAL_IN) | \
+				(1 << NF_INET_FORWARD) | \
+				(1 << NF_INET_LOCAL_OUT)
+
+static struct
+{
+	struct ipt_replace repl;
+	struct ipt_standard entries[3];
+	struct ipt_error term;
+} initial_table __initdata = {
+	.repl = {
+		.name = "security",
+		.valid_hooks = SECURITY_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
+		.hook_entry = {
+			[NF_INET_LOCAL_IN] 	= 0,
+			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard),
+			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 2,
+		},
+		.underflow = {
+			[NF_INET_LOCAL_IN] 	= 0,
+			[NF_INET_FORWARD] 	= sizeof(struct ipt_standard),
+			[NF_INET_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 2,
+		},
+	},
+	.entries = {
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+	},
+	.term = IPT_ERROR_INIT,			/* ERROR */
+};
+
+static struct xt_table security_table = {
+	.name		= "security",
+	.valid_hooks	= SECURITY_VALID_HOOKS,
+	.lock		= __RW_LOCK_UNLOCKED(security_table.lock),
+	.me		= THIS_MODULE,
+	.af		= AF_INET,
+};
+
+static unsigned int
+ipt_local_in_hook(unsigned int hook,
+		  struct sk_buff *skb,
+		  const struct net_device *in,
+		  const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
+{
+	return ipt_do_table(skb, hook, in, out,
+			    nf_local_in_net(in, out)->ipv4.iptable_security);
+}
+
+static unsigned int
+ipt_forward_hook(unsigned int hook,
+		 struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 int (*okfn)(struct sk_buff *))
+{
+	return ipt_do_table(skb, hook, in, out,
+			    nf_forward_net(in, out)->ipv4.iptable_security);
+}
+
+static unsigned int
+ipt_local_out_hook(unsigned int hook,
+		   struct sk_buff *skb,
+		   const struct net_device *in,
+		   const struct net_device *out,
+		   int (*okfn)(struct sk_buff *))
+{
+	/* Somebody is playing with raw sockets. */
+	if (skb->len < sizeof(struct iphdr)
+	    || ip_hdrlen(skb) < sizeof(struct iphdr)) {
+		if (net_ratelimit())
+			printk(KERN_INFO "iptable_security: ignoring short "
+			       "SOCK_RAW packet.\n");
+		return NF_ACCEPT;
+	}
+	return ipt_do_table(skb, hook, in, out,
+			    nf_local_out_net(in, out)->ipv4.iptable_security);
+}
+
+static struct nf_hook_ops ipt_ops[] __read_mostly = {
+	{
+		.hook		= ipt_local_in_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_INET_LOCAL_IN,
+		.priority	= NF_IP_PRI_SECURITY,
+	},
+	{
+		.hook		= ipt_forward_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_INET_FORWARD,
+		.priority	= NF_IP_PRI_SECURITY,
+	},
+	{
+		.hook		= ipt_local_out_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET,
+		.hooknum	= NF_INET_LOCAL_OUT,
+		.priority	= NF_IP_PRI_SECURITY,
+	},
+};
+
+static int __net_init iptable_security_net_init(struct net *net)
+{
+	net->ipv4.iptable_security =
+		ipt_register_table(net, &security_table, &initial_table.repl);
+
+	if (IS_ERR(net->ipv4.iptable_security))
+		return PTR_ERR(net->ipv4.iptable_security);
+
+	return 0;
+}
+
+static void __net_exit iptable_security_net_exit(struct net *net)
+{
+	ipt_unregister_table(net->ipv4.iptable_security);
+}
+
+static struct pernet_operations iptable_security_net_ops = {
+	.init = iptable_security_net_init,
+	.exit = iptable_security_net_exit,
+};
+
+static int __init iptable_security_init(void)
+{
+	int ret;
+
+	ret = register_pernet_subsys(&iptable_security_net_ops);
+        if (ret < 0)
+		return ret;
+
+	ret = nf_register_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	if (ret < 0)
+		goto cleanup_table;
+
+	return ret;
+
+cleanup_table:
+	unregister_pernet_subsys(&iptable_security_net_ops);
+	return ret;
+}
+
+static void __exit iptable_security_fini(void)
+{
+	nf_unregister_hooks(ipt_ops, ARRAY_SIZE(ipt_ops));
+	unregister_pernet_subsys(&iptable_security_net_ops);
+}
+
+module_init(iptable_security_init);
+module_exit(iptable_security_fini);
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 211189e..76ca1f2 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -8,7 +8,7 @@
  *   Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  *    by Henrik Nordstrom <hno@marasystems.com>
  *
- * (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * (C) 2006,2008 Red Hat, Inc., James Morris <jmorris@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -94,6 +94,12 @@ connsecmark_tg_check(const char *tablename, const void *entry,
 {
 	const struct xt_connsecmark_target_info *info = targinfo;
 
+	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
+		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		return false;
+	}
+
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
 	case CONNSECMARK_RESTORE:
@@ -126,7 +132,6 @@ static struct xt_target connsecmark_tg_reg[] __read_mostly = {
 		.destroy	= connsecmark_tg_destroy,
 		.target		= connsecmark_tg,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
@@ -136,7 +141,6 @@ static struct xt_target connsecmark_tg_reg[] __read_mostly = {
 		.destroy	= connsecmark_tg_destroy,
 		.target		= connsecmark_tg,
 		.targetsize	= sizeof(struct xt_connsecmark_target_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index c028485..94f87ee 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -5,7 +5,7 @@
  * Based on the nfmark match by:
  * (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
  *
- * (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * (C) 2006,2008 Red Hat, Inc., James Morris <jmorris@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -89,6 +89,12 @@ secmark_tg_check(const char *tablename, const void *entry,
 {
 	struct xt_secmark_target_info *info = targinfo;
 
+	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
+		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		return false;
+	}
+
 	if (mode && mode != info->mode) {
 		printk(KERN_INFO PFX "mode already set to %hu cannot mix with "
 		       "rules for mode %hu\n", mode, info->mode);
@@ -127,7 +133,6 @@ static struct xt_target secmark_tg_reg[] __read_mostly = {
 		.destroy	= secmark_tg_destroy,
 		.target		= secmark_tg,
 		.targetsize	= sizeof(struct xt_secmark_target_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 	{
@@ -137,7 +142,6 @@ static struct xt_target secmark_tg_reg[] __read_mostly = {
 		.destroy	= secmark_tg_destroy,
 		.target		= secmark_tg,
 		.targetsize	= sizeof(struct xt_secmark_target_info),
-		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
 };
