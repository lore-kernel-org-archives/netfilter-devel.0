From: Willem de Bruijn <willemb@google.com>
Subject: [PATCH next] iptables: add xt_bpf match
Date: Fri, 18 Jan 2013 12:17:30 -0500
Message-ID: <1358529450-32413-1-git-send-email-willemb@google.com>
References: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:46118 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3ARRRf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:17:35 -0500
Received: by mail-ie0-f202.google.com with SMTP id s9so966087iec.5
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Jan 2013 09:17:34 -0800 (PST)
In-Reply-To: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes:
- v4: fixed sparse warning and module autoloading
- v3: reverted no longer needed changes to x_tables.c
- v2: use a fixed size match structure to communicate between
      kernel and userspace.

Support arbitrary linux socket filter (BPF) programs as iptables
match rules. This allows for very expressive filters, and on
platforms with BPF JIT appears competitive with traditional hardcoded
iptables rules.

At least, on an x86_64 that achieves 40K netperf TCP_STREAM without
any iptables rules (40 GBps),

inserting 100x this bpf rule gives 28K

    ./iptables -A OUTPUT -m bpf --bytecode '6,40 0 0 14, 21 0 3 2048,48 0 0 25,21 0 1 20,6 0 0 96,6 0 0 0,' -j

inserting 100x this u32 rule gives 21K

    ./iptables -A OUTPUT -m u32 --u32 '6&0xFF=0x20' -j DROP

The two are logically equivalent, as far as I can tell. Let me know
if my test methodology is flawed in some way. Even in cases where
slower, the filter adds functionality currently lacking in iptables,
such as access to sk_buff fields like rxhash and queue_mapping.
---
 include/uapi/linux/netfilter/xt_bpf.h |   17 +++++++
 net/netfilter/Kconfig                 |    9 ++++
 net/netfilter/Makefile                |    1 +
 net/netfilter/xt_bpf.c                |   75 +++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/xt_bpf.h
 create mode 100644 net/netfilter/xt_bpf.c

diff --git a/include/uapi/linux/netfilter/xt_bpf.h b/include/uapi/linux/netfilter/xt_bpf.h
new file mode 100644
index 0000000..5dda450
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_bpf.h
@@ -0,0 +1,17 @@
+#ifndef _XT_BPF_H
+#define _XT_BPF_H
+
+#include <linux/filter.h>
+#include <linux/types.h>
+
+#define XT_BPF_MAX_NUM_INSTR	64
+
+struct xt_bpf_info {
+	__u16 bpf_program_num_elem;
+	struct sock_filter bpf_program[XT_BPF_MAX_NUM_INSTR];
+
+	/* only used in the kernel */
+	struct sk_filter *filter __attribute__((aligned(8)));
+};
+
+#endif /*_XT_BPF_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bb48607..4017d85 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -811,6 +811,15 @@ config NETFILTER_XT_MATCH_ADDRTYPE
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_BPF
+	tristate '"bpf" match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  BPF matching applies a linux socket filter to each packet and
+          accepts those for which the filter returns non-zero.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_CLUSTER
 	tristate '"cluster" match support'
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index b3bbda6..a1abf87 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_ADDRTYPE) += xt_addrtype.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_BPF) += xt_bpf.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
new file mode 100644
index 0000000..62d93f8
--- /dev/null
+++ b/net/netfilter/xt_bpf.c
@@ -0,0 +1,75 @@
+/* Xtables module to match packets using a BPF filter.
+ * Copyright 2013 Google Inc.
+ * Written by Willem de Bruijn <willemb@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ipv6.h>
+#include <linux/filter.h>
+#include <net/ip.h>
+
+#include <linux/netfilter/xt_bpf.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Willem de Bruijn <willemb@google.com>");
+MODULE_DESCRIPTION("Xtables: BPF filter match");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_bpf");
+MODULE_ALIAS("ip6t_bpf");
+
+static int bpf_mt_check(const struct xt_mtchk_param *par)
+{
+	struct xt_bpf_info *info = par->matchinfo;
+	struct sock_fprog program;
+
+	program.len = info->bpf_program_num_elem;
+	program.filter = (struct sock_filter __user *) info->bpf_program;
+	if (sk_unattached_filter_create(&info->filter, &program)) {
+		pr_info("bpf: check failed: parse error\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static bool bpf_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_bpf_info *info = par->matchinfo;
+
+	return SK_RUN_FILTER(info->filter, skb);
+}
+
+static void bpf_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	const struct xt_bpf_info *info = par->matchinfo;
+	sk_unattached_filter_destroy(info->filter);
+}
+
+static struct xt_match bpf_mt_reg __read_mostly = {
+	.name		= "bpf",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.checkentry	= bpf_mt_check,
+	.match		= bpf_mt,
+	.destroy	= bpf_mt_destroy,
+	.matchsize	= sizeof(struct xt_bpf_info),
+	.me		= THIS_MODULE,
+};
+
+static int __init bpf_mt_init(void)
+{
+	return xt_register_match(&bpf_mt_reg);
+}
+
+static void __exit bpf_mt_exit(void)
+{
+	xt_unregister_match(&bpf_mt_reg);
+}
+
+module_init(bpf_mt_init);
+module_exit(bpf_mt_exit);
-- 
1.7.7.3

