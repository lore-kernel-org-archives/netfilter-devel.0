From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: add fib expression to the netdev family
Date: Fri, 21 Jul 2017 01:54:38 +0200
Message-ID: <20170720235438.18576-2-pablombg@gmail.com>
References: <20170720235438.18576-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34210 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965610AbdGTXzU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2017 19:55:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id p204so5241430wmg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2017 16:55:19 -0700 (PDT)
In-Reply-To: <20170720235438.18576-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add fib expression support for netdev family. Like inet family, netdev
delegates the actual decision to the corresponding backend, either ipv4
or ipv6.

This allows to perform very early reverse path filtering, among other
things.

You can find more information about fib expression in the f6d0cbcf09c5
("<netfilter: nf_tables: add fib expression>") commit message.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 net/netfilter/Kconfig          |  9 +++++
 net/netfilter/Makefile         |  1 +
 net/netfilter/nft_fib_netdev.c | 87 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)
 create mode 100644 net/netfilter/nft_fib_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9b28864cc36a..e4a13cc8a2e7 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -636,6 +636,15 @@ config NFT_FWD_NETDEV
 	help
 	  This option enables packet forwarding for the "netdev" family.
 
+config NFT_FIB_NETDEV
+	depends on NFT_FIB_IPV4
+	depends on NFT_FIB_IPV6
+	tristate "Netfilter nf_tables netdev fib lookups support"
+	help
+	  This option allows using the FIB expression from the netdev table.
+	  The lookup will be delegated to the IPv4 or IPv6 FIB depending
+	  on the protocol of the packet.
+
 endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 913380919301..d3891c93edd6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_NFT_REDIR)		+= nft_redir.o
 obj-$(CONFIG_NFT_HASH)		+= nft_hash.o
 obj-$(CONFIG_NFT_FIB)		+= nft_fib.o
 obj-$(CONFIG_NFT_FIB_INET)	+= nft_fib_inet.o
+obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
new file mode 100644
index 000000000000..3997ee36cfbd
--- /dev/null
+++ b/net/netfilter/nft_fib_netdev.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2017 Pablo M. Bermudo Garay <pablombg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This code is based on net/netfilter/nft_fib_inet.c, written by
+ * Florian Westphal <fw@strlen.de>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables.h>
+
+#include <net/netfilter/nft_fib.h>
+
+static void nft_fib_netdev_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+
+	switch (ntohs(pkt->skb->protocol)) {
+	case ETH_P_IP:
+		switch (priv->result) {
+		case NFT_FIB_RESULT_OIF:
+		case NFT_FIB_RESULT_OIFNAME:
+			return nft_fib4_eval(expr, regs, pkt);
+		case NFT_FIB_RESULT_ADDRTYPE:
+			return nft_fib4_eval_type(expr, regs, pkt);
+		}
+		break;
+	case ETH_P_IPV6:
+		switch (priv->result) {
+		case NFT_FIB_RESULT_OIF:
+		case NFT_FIB_RESULT_OIFNAME:
+			return nft_fib6_eval(expr, regs, pkt);
+		case NFT_FIB_RESULT_ADDRTYPE:
+			return nft_fib6_eval_type(expr, regs, pkt);
+		}
+		break;
+	}
+
+	regs->verdict.code = NFT_BREAK;
+}
+
+static struct nft_expr_type nft_fib_netdev_type;
+static const struct nft_expr_ops nft_fib_netdev_ops = {
+	.type		= &nft_fib_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_fib)),
+	.eval		= nft_fib_netdev_eval,
+	.init		= nft_fib_init,
+	.dump		= nft_fib_dump,
+	.validate	= nft_fib_validate,
+};
+
+static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "fib",
+	.ops		= &nft_fib_netdev_ops,
+	.policy		= nft_fib_policy,
+	.maxattr	= NFTA_FIB_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_fib_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_fib_netdev_type);
+}
+
+static void __exit nft_fib_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_fib_netdev_type);
+}
+
+module_init(nft_fib_netdev_module_init);
+module_exit(nft_fib_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo M. Bermudo Garay <pablombg@gmail.com>");
+MODULE_ALIAS_NFT_AF_EXPR(5, "fib");
-- 
2.11.0

