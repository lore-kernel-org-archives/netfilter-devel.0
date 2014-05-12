From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v2 09/11] br_netfilter: added pernet_operations without
 sysctl registration
Date: Mon, 12 May 2014 16:57:58 +0400
Message-ID: <5370C556.9020206@parallels.com>
References: <536FD0FD.8010204@pandora.de> <cover.1399897184.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34523 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaELM7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 08:59:08 -0400
In-Reply-To: <cover.1399897184.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

added registration of per-netns operation without sysctl registration
also reworked rollback in br_netfilter_init()

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   50 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 55794c4..a079c06 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -40,6 +40,7 @@
 #include "br_private.h"
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
+#include <net/netns/generic.h>
 #endif
 
 #define skb_origaddr(skb)	 (((struct bridge_skb_cb *) \
@@ -58,6 +59,7 @@ static struct ctl_table_header *brnf_sysctl_header;
 #define brnf_pass_vlan_indev 0
 
 #ifdef CONFIG_SYSCTL
+static int brnf_net_id __read_mostly;
 static struct brnf_net init_brnf_net = {
 	.hdr			= NULL,
 	.call_arptables		= brnf_call_arptables,
@@ -67,6 +69,11 @@ static struct brnf_net init_brnf_net = {
 	.filter_pppoe_tagged	= brnf_filter_pppoe_tagged,
 	.pass_vlan_indev	= brnf_pass_vlan_indev,
 };
+
+static inline struct brnf_net *brnf_net(const struct net *net)
+{
+	return net_generic(net, brnf_net_id);
+}
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -1068,6 +1075,26 @@ static struct ctl_table brnf_table[] = {
 	},
 	{ }
 };
+
+static int __net_init brnf_net_init(struct net *net)
+{
+	struct brnf_net *bn = brnf_net(net);
+
+	memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
+	bn->net = net;
+	return 0;
+}
+
+static void __net_exit brnf_net_exit(struct net *net)
+{
+}
+
+static struct pernet_operations __net_initdata brnf_net_ops = {
+	.init	= brnf_net_init,
+	.exit	= brnf_net_exit,
+	.id	= &brnf_net_id,
+	.size	= sizeof(struct brnf_net),
+};
 #endif
 
 int __init br_netfilter_init(void)
@@ -1076,13 +1103,12 @@ int __init br_netfilter_init(void)
 
 	ret = dst_entries_init(&fake_dst_ops);
 	if (ret < 0)
-		return ret;
+		goto err_dst;
 
 	ret = nf_register_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-	if (ret < 0) {
-		dst_entries_destroy(&fake_dst_ops);
-		return ret;
-	}
+	if (ret < 0)
+		goto err_nf;
+
 #ifdef CONFIG_SYSCTL
 	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
 	if (brnf_sysctl_header == NULL) {
@@ -1092,16 +1118,28 @@ int __init br_netfilter_init(void)
 		dst_entries_destroy(&fake_dst_ops);
 		return -ENOMEM;
 	}
+	ret = register_pernet_subsys(&brnf_net_ops);
+	if (ret < 0) {
+		unregister_net_sysctl_table(brnf_sysctl_header);
+		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		goto err_nf;
+	}
 #endif
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
+
+err_nf:
+	dst_entries_destroy(&fake_dst_ops);
+err_dst:
+	return ret;
 }
 
 void br_netfilter_fini(void)
 {
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 #ifdef CONFIG_SYSCTL
+	unregister_pernet_subsys(&brnf_net_ops);
 	unregister_net_sysctl_table(brnf_sysctl_header);
 #endif
+	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	dst_entries_destroy(&fake_dst_ops);
 }
-- 
1.7.5.4

