From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: add generic inet packet logger
Date: Mon, 23 Jun 2014 16:41:12 +0200
Message-ID: <1403534473-5178-9-git-send-email-pablo@netfilter.org>
References: <1403534473-5178-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, fw@strlen.de,
	eric.dumazet@gmail.com, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42286 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbaFWOll (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:41:41 -0400
In-Reply-To: <1403534473-5178-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to log packets from the special inet chains.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig       |    4 +++
 net/netfilter/Makefile      |    3 +-
 net/netfilter/nf_log_inet.c |   78 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nf_log_inet.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f17b273..280ed9c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -362,6 +362,10 @@ config NETFILTER_NETLINK_QUEUE_CT
 config NF_LOG_COMMON
 	tristate
 
+config NF_LOG_INET
+	tristate "INET packet logging"
+	default m if NETFILTER_ADVANCED=n
+
 config NF_NAT
 	tristate
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 8308624..81ca236 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -47,7 +47,8 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 nf_nat-y	:= nf_nat_core.o nf_nat_proto_unknown.o nf_nat_proto_common.o \
 		   nf_nat_proto_udp.o nf_nat_proto_tcp.o nf_nat_helper.o
 
-# generic transport layer logging
+# packet logging
+obj-$(CONFIG_NF_LOG_INET) += nf_log_inet.o
 obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
 
 obj-$(CONFIG_NF_NAT) += nf_nat.o
diff --git a/net/netfilter/nf_log_inet.c b/net/netfilter/nf_log_inet.c
new file mode 100644
index 0000000..c1ca67a
--- /dev/null
+++ b/net/netfilter/nf_log_inet.c
@@ -0,0 +1,78 @@
+/*
+ * (c) 2014 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <net/route.h>
+
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_log.h>
+
+static void nf_log_inet_packet(struct net *net, u_int8_t pf,
+			       unsigned int hooknum, const struct sk_buff *skb,
+			       const struct net_device *in,
+			       const struct net_device *out,
+			       const struct nf_loginfo *loginfo,
+			       const char *prefix)
+{
+	nf_log_packet(net, pf, hooknum, skb, in, out, loginfo, "%s", prefix);
+}
+
+static struct nf_logger nf_inet_logger __read_mostly = {
+	.name		= "nf_log_inet",
+	.type		= NF_LOG_TYPE_LOG,
+	.logfn		= nf_log_inet_packet,
+	.me		= THIS_MODULE,
+};
+
+static int __net_init nf_log_inet_net_init(struct net *net)
+{
+	nf_log_set(net, NFPROTO_INET, &nf_inet_logger);
+	return 0;
+}
+
+static void __net_exit nf_log_inet_net_exit(struct net *net)
+{
+	nf_log_unset(net, &nf_inet_logger);
+}
+
+static struct pernet_operations nf_log_inet_net_ops = {
+	.init = nf_log_inet_net_init,
+	.exit = nf_log_inet_net_exit,
+};
+
+static int __init nf_log_inet_init(void)
+{
+	int ret;
+
+	/* Request to load the real packet loggers. */
+	nf_logger_request_module(NFPROTO_IPV4, NF_LOG_TYPE_LOG);
+	nf_logger_request_module(NFPROTO_IPV6, NF_LOG_TYPE_LOG);
+
+	ret = register_pernet_subsys(&nf_log_inet_net_ops);
+	if (ret < 0)
+		return ret;
+
+	nf_log_register(NFPROTO_INET, &nf_inet_logger);
+	return 0;
+}
+
+static void __exit nf_log_inet_exit(void)
+{
+	unregister_pernet_subsys(&nf_log_inet_net_ops);
+	nf_log_unregister(&nf_inet_logger);
+}
+
+module_init(nf_log_inet_init);
+module_exit(nf_log_inet_exit);
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Netfilter inet packet logging");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_NF_LOGGER(1, 0);
-- 
1.7.10.4

