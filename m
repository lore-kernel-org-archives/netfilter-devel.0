From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/33]: x_tables: add NFLOG target
Date: Wed, 29 Nov 2006 03:09:29 +0100 (MET)
Message-ID: <20061129020928.21082.41818.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: x_tables: add NFLOG target

Add new NFLOG target to allow use of nfnetlink_log for both IPv4 and IPv6.
Currently we have two (unsupported by userspace) hacks in the LOG and ULOG
targets to optionally call to the nflog API. They lack a few features,
namely the IPv4 and IPv6 LOG targets can not specify a number of arguments
related to nfnetlink_log, while the ULOG target is only available for IPv4.
Remove those hacks and add a clean way to use nfnetlink_log.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a212f14ec0dccdfd5c3f77017dfe3c23fa944d2c
tree 5250c5c39ab3a3acbf1369c4c7e43e22f6c4ed2b
parent 5fbcf255408abf92eac14816032a4ecac6a7f8c1
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:12 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:53 +0100

 include/linux/netfilter/Kbuild          |    1 
 include/linux/netfilter/xt_NFLOG.h      |   18 ++++++
 include/linux/netfilter_ipv4/ipt_LOG.h  |    2 -
 include/linux/netfilter_ipv6/ip6t_LOG.h |    2 -
 net/ipv4/netfilter/ipt_LOG.c            |    9 +--
 net/ipv6/netfilter/ip6t_LOG.c           |    9 +--
 net/netfilter/Kconfig                   |   11 ++++
 net/netfilter/Makefile                  |    1 
 net/netfilter/xt_NFLOG.c                |   86 +++++++++++++++++++++++++++++++
 9 files changed, 123 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index e379a2d..6328175 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -22,6 +22,7 @@ header-y += xt_mark.h
 header-y += xt_MARK.h
 header-y += xt_multiport.h
 header-y += xt_NFQUEUE.h
+header-y += xt_NFLOG.h
 header-y += xt_pkttype.h
 header-y += xt_policy.h
 header-y += xt_realm.h
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
new file mode 100644
index 0000000..cdcd0ed
--- /dev/null
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -0,0 +1,18 @@
+#ifndef _XT_NFLOG_TARGET
+#define _XT_NFLOG_TARGET
+
+#define XT_NFLOG_DEFAULT_GROUP		0x1
+#define XT_NFLOG_DEFAULT_THRESHOLD	1
+
+#define XT_NFLOG_MASK			0x0
+
+struct xt_nflog_info {
+	u_int32_t	len;
+	u_int16_t	group;
+	u_int16_t	threshold;
+	u_int16_t	flags;
+	u_int16_t	pad;
+	char		prefix[64];
+};
+
+#endif /* _XT_NFLOG_TARGET */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 892f9a3..90fa652 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -6,7 +6,7 @@ #define IPT_LOG_TCPSEQ		0x01	/* Log TCP 
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
 #define IPT_LOG_UID		0x08	/* Log UID owning local socket */
-#define IPT_LOG_NFLOG		0x10	/* Log using nf_log backend */
+#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
 #define IPT_LOG_MASK		0x1f
 
 struct ipt_log_info {
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 060c1a1..0d0119b 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -6,7 +6,7 @@ #define IP6T_LOG_TCPSEQ		0x01	/* Log TCP
 #define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IP6T_LOG_IPOPT		0x04	/* Log IP options */
 #define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
-#define IP6T_LOG_NFLOG		0x10	/* Log using nf_log backend */
+#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
 #define IP6T_LOG_MASK		0x1f
 
 struct ip6t_log_info {
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 46eee64..c96de16 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -430,13 +430,8 @@ ipt_log_target(struct sk_buff **pskb,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	if (loginfo->logflags & IPT_LOG_NFLOG)
-		nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
-		              "%s", loginfo->prefix);
-	else
-		ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
-		               loginfo->prefix);
-
+	ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
+	               loginfo->prefix);
 	return IPT_CONTINUE;
 }
 
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index f4857cf..33b1faa 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -440,13 +440,8 @@ ip6t_log_target(struct sk_buff **pskb,
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	if (loginfo->logflags & IP6T_LOG_NFLOG)
-		nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
-		              "%s", loginfo->prefix);
-	else
-		ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
-		                loginfo->prefix);
-
+	ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
+	                loginfo->prefix);
 	return IP6T_CONTINUE;
 }
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 7e61254..d191dac 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -184,6 +184,17 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_NFLOG
+	tristate '"NFLOG" target support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option enables the NFLOG target, which allows to LOG
+	  messages through the netfilter logging API, which can use
+	  either the old LOG target, the old ULOG target or nfnetlink_log
+	  as backend.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  '"NOTRACK" target support'
 	depends on NETFILTER_XTABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f85811b..7f0089c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMAR
 obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
new file mode 100644
index 0000000..901ed7a
--- /dev/null
+++ b/net/netfilter/xt_NFLOG.c
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NFLOG.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("x_tables NFLOG target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_NFLOG");
+MODULE_ALIAS("ip6t_NFLOG");
+
+static unsigned int
+nflog_target(struct sk_buff **pskb,
+	     const struct net_device *in, const struct net_device *out,
+	     unsigned int hooknum, const struct xt_target *target,
+	     const void *targinfo)
+{
+	const struct xt_nflog_info *info = targinfo;
+	struct nf_loginfo li;
+
+	li.type		     = NF_LOG_TYPE_ULOG;
+	li.u.ulog.copy_len   = info->len;
+	li.u.ulog.group	     = info->group;
+	li.u.ulog.qthreshold = info->threshold;
+
+	nf_log_packet(target->family, hooknum, *pskb, in, out, &li,
+		      "%s", info->prefix);
+	return XT_CONTINUE;
+}
+
+static int
+nflog_checkentry(const char *tablename, const void *entry,
+		 const struct xt_target *target, void *targetinfo,
+		 unsigned int hookmask)
+{
+	struct xt_nflog_info *info = targetinfo;
+
+	if (info->flags & ~XT_NFLOG_MASK)
+		return 0;
+	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
+		return 0;
+	return 1;
+}
+
+static struct xt_target xt_nflog_target[] = {
+	{
+		.name		= "NFLOG",
+		.family		= AF_INET,
+		.checkentry	= nflog_checkentry,
+		.target		= nflog_target,
+		.targetsize	= sizeof(struct xt_nflog_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "NFLOG",
+		.family		= AF_INET6,
+		.checkentry	= nflog_checkentry,
+		.target		= nflog_target,
+		.targetsize	= sizeof(struct xt_nflog_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_nflog_init(void)
+{
+	return xt_register_targets(xt_nflog_target,
+				   ARRAY_SIZE(xt_nflog_target));
+}
+
+static void __exit xt_nflog_fini(void)
+{
+	xt_unregister_targets(xt_nflog_target, ARRAY_SIZE(xt_nflog_target));
+}
+
+module_init(xt_nflog_init);
+module_exit(xt_nflog_fini);
