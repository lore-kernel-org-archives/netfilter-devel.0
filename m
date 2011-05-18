From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] netfilter: the "none" conntrack helper module
Date: Thu, 19 May 2011 00:21:05 +0200
Message-ID: <1305757266-8730-2-git-send-email-jengelh@medozas.de>
References: <1305757266-8730-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50562 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1ERWVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 18:21:11 -0400
In-Reply-To: <1305757266-8730-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To cope with some crappy, easily DOS-able network equipment, a
customer put Linux on each side of the shabby shaper in question.
Since NFCT supports zones since recently, these two system images can
be collapsed without causing tracking problems. The layout thus is
something like:

graph {
	subgraph cluster_1 {
		label="linux";
		subgraph cluster_2 { label="ctzone0"; eth0; eth1; };
		subgraph cluster_3 { label="ctzone1"; eth2; eth3; };
	};
	subgraph cluster_4 {
		label="shaper";
		"FE/0"; "FE/1";
	};
	netA -- eth0 -- eth1 -- "FE/0" -- "FE/1" --
	eth2 -- eth3 -- netB;
};

With this setup however, nf_conntrack_ftp seems to discard packets
when they re-enter nfct_ftp for the second time. To work around this,
I devised this "none" helper module, which can be used in the raw
table with `-j CT --helper none` in one zone to avoid automatically
running nfct_ftp - or any other helper for that matter. `-j CT
--notrack` was out of the option, as both zones needed tracking
support for xt_connlimit.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig             |    8 +++
 net/netfilter/Makefile            |    1 +
 net/netfilter/nf_conntrack_none.c |  111 +++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 0 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_none.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..9300b11 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -132,6 +132,14 @@ config NF_CT_PROTO_UDPLITE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_NONE
+	tristate '"none" helper'
+	depends on NETFILTER_ADVANCED
+	---help---
+	This helper does nothing, and is a workaround for
+	nf_conntrack_* breaking down on expectations when traffic
+	is fed back into the system.
+
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1a02853..d710ec5 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_NF_CT_NETLINK) += nf_conntrack_netlink.o
 # connection tracking helpers
 nf_conntrack_h323-objs := nf_conntrack_h323_main.o nf_conntrack_h323_asn1.o
 
+obj-$(CONFIG_NF_CONNTRACK_NONE) += nf_conntrack_none.o
 obj-$(CONFIG_NF_CONNTRACK_AMANDA) += nf_conntrack_amanda.o
 obj-$(CONFIG_NF_CONNTRACK_FTP) += nf_conntrack_ftp.o
 obj-$(CONFIG_NF_CONNTRACK_H323) += nf_conntrack_h323.o
diff --git a/net/netfilter/nf_conntrack_none.c b/net/netfilter/nf_conntrack_none.c
new file mode 100644
index 0000000..5ae618f
--- /dev/null
+++ b/net/netfilter/nf_conntrack_none.c
@@ -0,0 +1,111 @@
+#include <linux/module.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+
+static int nohelp_helper(struct sk_buff *skb, unsigned int protoff,
+			 struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	return NF_ACCEPT;
+}
+
+static const struct nf_conntrack_expect_policy noexp_policy = {
+	.max_expected = 1,
+	.timeout      = 5 * 60,
+};
+
+static struct nf_conntrack_helper nohelp_reg[] __read_mostly = {
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV6,
+		.tuple.dst.protonum = IPPROTO_TCP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV6,
+		.tuple.dst.protonum = IPPROTO_SCTP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV6,
+		.tuple.dst.protonum = IPPROTO_UDP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV6,
+		.tuple.dst.protonum = IPPROTO_DCCP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV4,
+		.tuple.dst.protonum = IPPROTO_TCP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV4,
+		.tuple.dst.protonum = IPPROTO_SCTP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV4,
+		.tuple.dst.protonum = IPPROTO_UDP,
+	},
+	{
+		.name               = "none",
+		.me                 = THIS_MODULE,
+		.help               = nohelp_helper,
+		.expect_policy      = &noexp_policy,
+		.tuple.src.l3num    = NFPROTO_IPV4,
+		.tuple.dst.protonum = IPPROTO_DCCP,
+	},
+};
+
+static int __init nfct_none_init(void)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(nohelp_reg); ++i) {
+		ret = nf_conntrack_helper_register(&nohelp_reg[i]);
+		if (ret < 0)
+			goto out;
+	}
+	return 0;
+out:
+	while (i-- > 0)
+		nf_conntrack_helper_unregister(&nohelp_reg[i]);
+	return ret;
+}
+
+static void __exit nfct_none_exit(void)
+{
+	unsigned int i = ARRAY_SIZE(nohelp_reg);
+
+	while (i-- > 0)
+		nf_conntrack_helper_unregister(&nohelp_reg[i]);
+}
+
+module_init(nfct_none_init);
+module_exit(nfct_none_exit);
+MODULE_LICENSE("GPL");
-- 
1.7.3.4

