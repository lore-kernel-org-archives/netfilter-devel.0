From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 7/8] netfilter: bridge: register hooks only when bridge interface is added
Date: Fri,  2 Oct 2015 13:49:16 +0200
Message-ID: <1443786557-21315-8-git-send-email-fw@strlen.de>
References: <1443786557-21315-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50313 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbbJBLtb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 07:49:31 -0400
In-Reply-To: <1443786557-21315-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This moves the last 'common' hooks to a 'register only when needed'
scheme.

We use a device notifier to register all the 'call-iptables'
netfilter hooks only when a bridge gets added.

This means that if the initial namespace uses a bridge, newly created
network namespaces no longer 'inherit' the PRE_ROUTING ipt_sabotage hook,
instead it will only be registered in that network namespace if a bridge
is added within that namespace.

After this patch, only a handful of netfilter modules still use
global hooks:
- PF_BRIDGE hooks
- CLUSTER match (deprecated)
- ipvs hooks
- SYNPROXY

As long as these modules are not loaded/used, a new network namespace
has empty hook list and NF_HOOK() will boil down to single list_empty
test even if initial namespace does packet filtering, conntrack, etc.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_hooks.c | 68 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 13f0367..d299014 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -37,6 +37,7 @@
 #include <net/addrconf.h>
 #include <net/route.h>
 #include <net/netfilter/br_netfilter.h>
+#include <net/netns/generic.h>
 
 #include <asm/uaccess.h>
 #include "br_private.h"
@@ -44,6 +45,12 @@
 #include <linux/sysctl.h>
 #endif
 
+static int brnf_net_id __read_mostly;
+
+struct brnf_net {
+	bool enabled;
+};
+
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
@@ -958,6 +965,53 @@ static struct nf_hook_ops br_nf_ops[] __read_mostly = {
 	},
 };
 
+static int brnf_device_event(struct notifier_block *unused, unsigned long event,
+			     void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct brnf_net *brnet;
+	struct net *net;
+	int ret;
+
+	if (event != NETDEV_REGISTER || !(dev->priv_flags & IFF_EBRIDGE))
+		return NOTIFY_DONE;
+
+	ASSERT_RTNL();
+
+	net = dev_net(dev);
+	brnet = net_generic(net, brnf_net_id);
+	if (brnet->enabled)
+		return NOTIFY_OK;
+
+	ret = nf_register_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	if (ret)
+		return NOTIFY_BAD;
+
+	brnet->enabled = true;
+	return NOTIFY_OK;
+}
+
+static void __net_exit brnf_exit_net(struct net *net)
+{
+	struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+	if (!brnet->enabled)
+		return;
+
+	nf_unregister_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	brnet->enabled = false;
+}
+
+static struct pernet_operations brnf_net_ops __read_mostly = {
+	.exit = brnf_exit_net,
+	.id   = &brnf_net_id,
+	.size = sizeof(struct brnf_net),
+};
+
+static struct notifier_block brnf_notifier __read_mostly = {
+	.notifier_call = brnf_device_event,
+};
+
 #ifdef CONFIG_SYSCTL
 static
 int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
@@ -1023,16 +1077,23 @@ static int __init br_netfilter_init(void)
 {
 	int ret;
 
-	ret = nf_register_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	ret = register_pernet_subsys(&brnf_net_ops);
 	if (ret < 0)
 		return ret;
 
+	ret = register_netdevice_notifier(&brnf_notifier);
+	if (ret < 0) {
+		unregister_pernet_subsys(&brnf_net_ops);
+		return ret;
+	}
+
 #ifdef CONFIG_SYSCTL
 	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
-		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+		unregister_netdevice_notifier(&brnf_notifier);
+		unregister_pernet_subsys(&brnf_net_ops);
 		return -ENOMEM;
 	}
 #endif
@@ -1044,7 +1105,8 @@ static int __init br_netfilter_init(void)
 static void __exit br_netfilter_fini(void)
 {
 	RCU_INIT_POINTER(nf_br_ops, NULL);
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+	unregister_netdevice_notifier(&brnf_notifier);
+	unregister_pernet_subsys(&brnf_net_ops);
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(brnf_sysctl_header);
 #endif
-- 
2.0.5

