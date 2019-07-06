Return-Path: <SRS0=/Ma8=VD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE47CC48BD3
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 14:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CBD206A3
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Jul 2019 14:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfGFOQB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Jul 2019 10:16:01 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:38144 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfGFOQB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jul 2019 10:16:01 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 06BAF41704;
        Sat,  6 Jul 2019 22:15:56 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, nikolay@cumulusnetworks.com, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH 5/5 nf-next v4] netfilter: Flow table support the bridge family for ipv4
Date:   Sat,  6 Jul 2019 22:15:52 +0800
Message-Id: <1562422552-26065-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562422552-26065-1-git-send-email-wenxu@ucloud.cn>
References: <1562422552-26065-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0JNQkJCTE1PT09JT09ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PU06GTo4Ejg2Kg8dERU8Og4O
        DUsaCkNVSlVKTk1JT0lJTk5NSklJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhCQ0o3Bg++
X-HM-Tid: 0a6bc7a435912086kuqy06baf41704
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch adds the bridge flow table type, that implements the datapath
flow table to forward IPv4 traffic through bridge.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/bridge/netfilter/Kconfig                |  8 +++++
 net/bridge/netfilter/Makefile               |  1 +
 net/bridge/netfilter/nf_flow_table_bridge.c | 46 +++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)
 create mode 100644 net/bridge/netfilter/nf_flow_table_bridge.c

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f4fb0b9..cba5f71 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -33,6 +33,14 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_FLOW_TABLE_BRIDGE
+	tristate "Netfilter flow table bridge module"
+	depends on NF_FLOW_TABLE && NF_CONNTRACK_BRIDGE
+	help
+          This option adds the flow table bridge support.
+
+	  To compile it as a module, choose M here.
+
 endif # NF_TABLES_BRIDGE
 
 menuconfig BRIDGE_NF_EBTABLES
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 9d77673..deb81e6 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
+obj-$(CONFIG_NF_FLOW_TABLE_BRIDGE) += nf_flow_table_bridge.o
 
 # packet logging
 obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
diff --git a/net/bridge/netfilter/nf_flow_table_bridge.c b/net/bridge/netfilter/nf_flow_table_bridge.c
new file mode 100644
index 0000000..3a65b44
--- /dev/null
+++ b/net/bridge/netfilter/nf_flow_table_bridge.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
+
+static unsigned int
+nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
+			    const struct nf_hook_state *state)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return nf_flow_offload_ip_hook(priv, skb, state);
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct nf_flowtable_type flowtable_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.init		= nf_flow_table_init,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_bridge_hook,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nf_flow_bridge_module_init(void)
+{
+	nft_register_flowtable_type(&flowtable_bridge);
+
+	return 0;
+}
+
+static void __exit nf_flow_bridge_module_exit(void)
+{
+	nft_unregister_flowtable_type(&flowtable_bridge);
+}
+
+module_init(nf_flow_bridge_module_init);
+module_exit(nf_flow_bridge_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
-- 
1.8.3.1

