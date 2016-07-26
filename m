From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] netfilter: nft_nth: match every n packets
Date: Tue, 26 Jul 2016 16:22:10 +0200
Message-ID: <20160726142207.GA18550@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34198 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbcGZOWQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 10:22:16 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so1933771wma.1
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 07:22:15 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id wc3sm1197137wjc.47.2016.07.26.07.22.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 26 Jul 2016 07:22:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the nth expression in netfilter. A nft_nth structure is created with dreg (to store the result into a given register), data (a nft_data structure to store the input value, it must be > 0), every (to store the data) and counter (to store atomically the current value).

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/net/netfilter/nft_nth.h          |  31 +++++++
 include/uapi/linux/netfilter/nf_tables.h |  15 ++++
 net/netfilter/Kconfig                    |   6 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_nth.c                  | 145 +++++++++++++++++++++++++++++++
 5 files changed, 198 insertions(+)
 create mode 100644 include/net/netfilter/nft_nth.h
 create mode 100644 net/netfilter/nft_nth.c

diff --git a/include/net/netfilter/nft_nth.h b/include/net/netfilter/nft_nth.h
new file mode 100644
index 0000000..0d8788d
--- /dev/null
+++ b/include/net/netfilter/nft_nth.h
@@ -0,0 +1,31 @@
+#ifndef _NFT_NTH_H_
+#define _NFT_NTH_H_
+
+struct nft_nth {
+	enum nft_registers      dreg:8;
+	struct nft_data         data;
+	u32		every;
+	struct nft_nth_priv *master __attribute__((aligned(8)));
+};
+
+struct nft_nth_priv {
+	atomic_t counter;
+} ____cacheline_aligned_in_smp;
+
+extern const struct nla_policy nft_nth_policy[];
+
+int nft_nth_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[]);
+
+int nft_nth_dump(struct sk_buff *skb,
+		 const struct nft_expr *expr);
+
+void nft_nth_eval(const struct nft_expr *expr,
+		  struct nft_regs *regs,
+		  const struct nft_pktinfo *pkt);
+
+void nft_nth_destroy(const struct nft_ctx *ctx,
+		     const struct nft_expr *expr);
+
+#endif
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6a4dbe0..5ba075a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1076,4 +1076,19 @@ enum nft_trace_types {
 	__NFT_TRACETYPE_MAX
 };
 #define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
+
+/**
+ * enum nft_nth_attributes - nf_tables nth expression netlink attributes
+ * @NFTA_NTH_UNSPEC: unspecified attribute
+ * @NFTA_NTH_DREG: destination register (NLA_U32)
+ * @NFTA_NTH_DATA: source data (NLA_NESTED)
+ */
+enum nft_nth_attributes {
+	NFTA_NTH_UNSPEC,
+	NFTA_NTH_DREG,
+	NFTA_NTH_DATA,
+	__NFTA_NTH_MAX
+};
+#define NFTA_NTH_MAX	(__NFTA_NTH_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 95e757c..6f00d01 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -474,6 +474,12 @@ config NFT_META
 	  This option adds the "meta" expression that you can use to match and
 	  to set packet metainformation such as the packet mark.
 
+config NFT_NTH
+	tristate "Netfilter nf_tables nth module"
+	help
+	  This option adds the "nth" expression that you can use to match a
+	  packet every a specific given value.
+
 config NFT_CT
 	depends on NF_CONNTRACK
 	tristate "Netfilter nf_tables conntrack module"
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 6913454..2378f00 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
+obj-$(CONFIG_NFT_NTH)		+= nft_nth.o
 obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
diff --git a/net/netfilter/nft_nth.c b/net/netfilter/nft_nth.c
new file mode 100644
index 0000000..d0a5387
--- /dev/null
+++ b/net/netfilter/nft_nth.c
@@ -0,0 +1,145 @@
+/*
+ * Copyright (c) 2016 Laura Garcia <nevola@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/smp.h>
+#include <linux/static_key.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nft_nth.h>
+
+void nft_nth_eval(const struct nft_expr *expr,
+		  struct nft_regs *regs,
+		  const struct nft_pktinfo *pkt)
+{
+	struct nft_nth *nth = nft_expr_priv(expr);
+	u32 nval, oval;
+
+	do {
+		oval = atomic_read(&nth->master->counter);
+		nval = (oval+1 < nth->every) ? oval+1 : 0;
+	} while (atomic_cmpxchg(&nth->master->counter, oval, nval) != oval);
+
+	memcpy(&regs->data[nth->dreg], &nth->master->counter, sizeof(u32));
+}
+EXPORT_SYMBOL_GPL(nft_nth_eval);
+
+const struct nla_policy nft_nth_policy[NFTA_NTH_MAX + 1] = {
+	[NFTA_NTH_DREG]	= { .type = NLA_U32 },
+	[NFTA_NTH_DATA]	= { .type = NLA_NESTED },
+};
+
+int nft_nth_init(const struct nft_ctx *ctx,
+		 const struct nft_expr *expr,
+		 const struct nlattr * const tb[])
+{
+	struct nft_nth *nth = nft_expr_priv(expr);
+	struct nft_data_desc desc;
+	int err = 0;
+
+	err = nft_data_init(NULL, &nth->data,
+			    sizeof(nth->data), &desc,
+			    tb[NFTA_NTH_DATA]);
+	if (err < 0)
+		goto err;
+
+	memcpy(&nth->every, &nth->data, sizeof(u32));
+	if (nth->every == 0)
+		return -EINVAL;
+
+	nth->dreg = nft_parse_register(tb[NFTA_NTH_DREG]);
+
+	nth->master = kzalloc(sizeof(*nth->master), GFP_KERNEL);
+	if (!nth->master)
+		return -ENOMEM;
+	atomic_set(&nth->master->counter, 0);
+
+err:
+	return err;
+}
+EXPORT_SYMBOL_GPL(nft_nth_init);
+
+int nft_nth_dump(struct sk_buff *skb,
+		 const struct nft_expr *expr)
+{
+	const struct nft_nth *nth = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_NTH_DREG, nth->dreg))
+		goto nla_put_failure;
+	if (nft_data_dump(skb, NFTA_NTH_DATA, &nth->data,
+			  NFT_DATA_VALUE, sizeof(nth->data)) < 0)
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nft_nth_dump);
+
+void nft_nth_destroy(const struct nft_ctx *ctx,
+		     const struct nft_expr *expr)
+{
+	struct nft_nth *nth = nft_expr_priv(expr);
+
+	kfree(nth->master);
+}
+EXPORT_SYMBOL_GPL(nft_nth_destroy);
+
+static struct nft_expr_type nft_nth_type;
+static const struct nft_expr_ops nft_nth_ops = {
+	.type		= &nft_nth_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_nth)),
+	.eval		= nft_nth_eval,
+	.init		= nft_nth_init,
+	.destroy	= nft_nth_destroy,
+	.dump		= nft_nth_dump,
+};
+
+static const struct nft_expr_ops *
+nft_nth_select_ops(const struct nft_ctx *ctx,
+		   const struct nlattr * const tb[])
+{
+	if (!tb[NFTA_NTH_DREG] ||
+	    !tb[NFTA_NTH_DATA])
+		return ERR_PTR(-EINVAL);
+
+	return &nft_nth_ops;
+}
+
+static struct nft_expr_type nft_nth_type __read_mostly = {
+	.name		= "nth",
+	.select_ops	= &nft_nth_select_ops,
+	.policy		= nft_nth_policy,
+	.maxattr	= NFTA_NTH_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_nth_module_init(void)
+{
+	return nft_register_expr(&nft_nth_type);
+}
+
+static void __exit nft_nth_module_exit(void)
+{
+	nft_unregister_expr(&nft_nth_type);
+}
+
+module_init(nft_nth_module_init);
+module_exit(nft_nth_module_exit);
+
+MODULE_LICENSE("GPL");
-- 
2.8.1

