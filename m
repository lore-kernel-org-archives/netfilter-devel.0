From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 09/15] br_netfilter: pernet_operations brnf_net_ops without
 per-netns sysctl registration
Date: Sat, 10 May 2014 01:28:08 +0400
Message-ID: <536D4868.9020707@parallels.com>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:14784 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513AbaEIV34 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:29:56 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

pernet_operations was added,
rollback in br_netfilter_init was reworked

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |   60 ++++++++++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index e3ab72f8..460917c 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -35,6 +35,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/route.h>
+#include <net/netns/generic.h>
 
 #include <asm/uaccess.h>
 #include "br_private.h"
@@ -47,6 +48,7 @@
 #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) = ip_hdr(skb)->daddr)
 #define dnat_took_place(skb)	 (skb_origaddr(skb) != ip_hdr(skb)->daddr)
 
+int brnf_net_id __read_mostly;
 static struct brnf_net init_brnf_net = {
 #ifdef CONFIG_SYSCTL
 	.hdr			= NULL,
@@ -59,6 +61,11 @@ static struct brnf_net init_brnf_net = {
 	.pass_vlan_indev	= 0,
 };
 
+static inline struct brnf_net *brnf_net(const struct net *net)
+{
+	return net_generic(net, brnf_net_id);
+}
+
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 #endif
@@ -1058,38 +1065,73 @@ static struct ctl_table brnf_table[] = {
 };
 #endif
 
+#define brnf_sysctl_net_register(x)	(0)
+#define brnf_sysctl_net_unregister(x)
+
+static int __net_init brnf_net_init(struct net *net)
+{
+	struct brnf_net *bn = brnf_net(net);
+
+	memcpy(bn, &init_brnf_net, sizeof(struct brnf_net));
+	bn->net = net;
+
+	return brnf_sysctl_net_register(bn);
+}
+
+static void __net_exit brnf_net_exit(struct net *net)
+{
+	brnf_sysctl_net_unregister(brnf_net(net));
+}
+
+static struct pernet_operations __net_initdata brnf_net_ops = {
+	.init	= brnf_net_init,
+	.exit	= brnf_net_exit,
+	.id	= &brnf_net_id,
+	.size	= sizeof(struct brnf_net),
+};
+
 int __init br_netfilter_init(void)
 {
 	int ret;
 
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
+	ret = register_pernet_subsys(&brnf_net_ops);
+	if (ret < 0)
+		goto err_pernet;
 #ifdef CONFIG_SYSCTL
 	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
-		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-		dst_entries_destroy(&fake_dst_ops);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		unregister_pernet_subsys(&brnf_net_ops);
+		goto err_pernet;
 	}
 #endif
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
+
+err_pernet:
+	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
+err_nf:
+	dst_entries_destroy(&fake_dst_ops);
+err_dst:
+	return ret;
 }
 
 void br_netfilter_fini(void)
 {
-	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(brnf_sysctl_header);
 #endif
+	unregister_pernet_subsys(&brnf_net_ops);
+	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 	dst_entries_destroy(&fake_dst_ops);
 }
-- 
1.7.5.4

