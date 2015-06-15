From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 09/15] netfilter: synproxy: adapt IPv4 and IPv6 targets to pernet hooks
Date: Mon, 15 Jun 2015 17:46:51 +0200
Message-ID: <1434383217-13732-10-git-send-email-pablo@netfilter.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36873 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbbFOPlv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:51 -0400
In-Reply-To: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since pernet hooks, we need to register the hook for each netnamespace space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_SYNPROXY.c  |   51 ++++++++++++++++++++++++++++++++---
 net/ipv6/netfilter/ip6t_SYNPROXY.c |   52 +++++++++++++++++++++++++++++++++---
 2 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index a57d3d1..f38276f 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -446,15 +446,58 @@ static struct nf_hook_ops ipv4_synproxy_ops[] __read_mostly = {
 	},
 };
 
-static int __init synproxy_tg4_init(void)
+struct synproxy_tg4_net {
+	struct nf_hook_ops *ipv4_synproxy_ops;
+};
+
+static int synproxy_tg4_net_id __read_mostly;
+
+static int synproxy_tg4_net_init(struct net *net)
 {
+	struct synproxy_tg4_net *sn = net_generic(net, synproxy_tg4_net_id);
 	int err;
 
-	err = nf_register_hooks(&init_net, ipv4_synproxy_ops,
+	sn->ipv4_synproxy_ops =
+		kmemdup(ipv4_synproxy_ops, sizeof(ipv4_synproxy_ops),
+			GFP_KERNEL);
+	if (sn->ipv4_synproxy_ops == NULL)
+		return -ENOMEM;
+
+	err = nf_register_hooks(net, sn->ipv4_synproxy_ops,
 				ARRAY_SIZE(ipv4_synproxy_ops));
 	if (err < 0)
 		goto err1;
 
+err1:
+	kfree(sn->ipv4_synproxy_ops);
+
+	return err;
+}
+
+static void synproxy_tg4_net_exit(struct net *net)
+{
+	struct synproxy_tg4_net *sn = net_generic(net, synproxy_tg4_net_id);
+
+	nf_unregister_hooks(sn->ipv4_synproxy_ops,
+			    ARRAY_SIZE(ipv4_synproxy_ops));
+	kfree(sn->ipv4_synproxy_ops);
+}
+
+static struct pernet_operations synproxy_tg4_net_ops = {
+	.init = synproxy_tg4_net_init,
+	.exit = synproxy_tg4_net_exit,
+	.id = &synproxy_tg4_net_id,
+	.size = sizeof(struct synproxy_tg4_net),
+};
+
+static int __init synproxy_tg4_init(void)
+{
+	int err;
+
+	err = register_pernet_subsys(&synproxy_tg4_net_ops);
+	if (err < 0)
+		goto err1;
+
 	err = xt_register_target(&synproxy_tg4_reg);
 	if (err < 0)
 		goto err2;
@@ -462,7 +505,7 @@ static int __init synproxy_tg4_init(void)
 	return 0;
 
 err2:
-	nf_unregister_hooks(ipv4_synproxy_ops, ARRAY_SIZE(ipv4_synproxy_ops));
+	unregister_pernet_subsys(&synproxy_tg4_net_ops);
 err1:
 	return err;
 }
@@ -470,7 +513,7 @@ err1:
 static void __exit synproxy_tg4_exit(void)
 {
 	xt_unregister_target(&synproxy_tg4_reg);
-	nf_unregister_hooks(ipv4_synproxy_ops, ARRAY_SIZE(ipv4_synproxy_ops));
+	unregister_pernet_subsys(&synproxy_tg4_net_ops);
 }
 
 module_init(synproxy_tg4_init);
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index ed5d4a6..57fbd44 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -469,15 +469,59 @@ static struct nf_hook_ops ipv6_synproxy_ops[] __read_mostly = {
 	},
 };
 
-static int __init synproxy_tg6_init(void)
+struct synproxy_tg6_net {
+	struct nf_hook_ops *ipv6_synproxy_ops;
+};
+
+static int synproxy_tg6_net_id __read_mostly;
+
+static int synproxy_tg6_net_init(struct net *net)
 {
+	struct synproxy_tg6_net *sn = net_generic(net, synproxy_tg6_net_id);
 	int err;
 
-	err = nf_register_hooks(&init_net, ipv6_synproxy_ops,
+	sn->ipv6_synproxy_ops =
+		kmemdup(ipv6_synproxy_ops, sizeof(ipv6_synproxy_ops),
+			GFP_KERNEL);
+	if (sn->ipv6_synproxy_ops == NULL)
+		return -ENOMEM;
+
+	err = nf_register_hooks(net, sn->ipv6_synproxy_ops,
 				ARRAY_SIZE(ipv6_synproxy_ops));
 	if (err < 0)
 		goto err1;
 
+	return 0;
+err1:
+	kfree(sn->ipv6_synproxy_ops);
+
+	return err;
+}
+
+static void synproxy_tg6_net_exit(struct net *net)
+{
+	struct synproxy_tg6_net *sn = net_generic(net, synproxy_tg6_net_id);
+
+	nf_unregister_hooks(sn->ipv6_synproxy_ops,
+			    ARRAY_SIZE(ipv6_synproxy_ops));
+	kfree(sn->ipv6_synproxy_ops);
+}
+
+static struct pernet_operations synproxy_tg6_net_ops = {
+	.init = synproxy_tg6_net_init,
+	.exit = synproxy_tg6_net_exit,
+	.id = &synproxy_tg6_net_id,
+	.size = sizeof(struct synproxy_tg6_net),
+};
+
+static int __init synproxy_tg6_init(void)
+{
+	int err;
+
+	err = register_pernet_subsys(&synproxy_tg6_net_ops);
+	if (err < 0)
+		goto err1;
+
 	err = xt_register_target(&synproxy_tg6_reg);
 	if (err < 0)
 		goto err2;
@@ -485,7 +529,7 @@ static int __init synproxy_tg6_init(void)
 	return 0;
 
 err2:
-	nf_unregister_hooks(ipv6_synproxy_ops, ARRAY_SIZE(ipv6_synproxy_ops));
+	unregister_pernet_subsys(&synproxy_tg6_net_ops);
 err1:
 	return err;
 }
@@ -493,7 +537,7 @@ err1:
 static void __exit synproxy_tg6_exit(void)
 {
 	xt_unregister_target(&synproxy_tg6_reg);
-	nf_unregister_hooks(ipv6_synproxy_ops, ARRAY_SIZE(ipv6_synproxy_ops));
+	unregister_pernet_subsys(&synproxy_tg6_net_ops);
 }
 
 module_init(synproxy_tg6_init);
-- 
1.7.10.4

