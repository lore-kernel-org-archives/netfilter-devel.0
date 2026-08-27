Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770EF4477F5
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 18:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854483; cv=none; b=KLYqGHZFQJ2DoGm+wsRRReLi8h/tsQCeWR2PfDcD4DHlQL/Ny+SXoi+RiqlR/S66RPRMcfCWkXRtt0W5NI+1lRg/W2CzNDBcfg8TUjPmXvxSS45uTN9fBybzeVYDCPG/P7gxvf542DxVCwESI3/0201SoQU+N9AL5fnKBBX6u+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854483; c=relaxed/simple;
	bh=i0gR5Hv5UbF2js2F/INTLjqPhWonT0kdLKNJy1rKkfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A8dSFUSxtX6QaTVhJ9Qpccn+0pN86zpp6mkaduTTBHTAjhBEfjeormdE07Gf6NQwgZgVxO8m41SVqsI108opb5PhUDe4TFdkdFbyA0OqPRWve6j2tT9sA6uhHl67VCsG8ujtC/xjsz1zNINFTOqWxjOWaJvclU7OpKSX3vGtobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EF49C602F5; Thu, 27 Aug 2026 20:14:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 nf] netfilter: disable br_netfilter in user namespaces
Date: Thu, 27 Aug 2026 20:14:31 +0200
Message-ID: <20260827181431.21720-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

br_netfilter has way too many bugs, schedule for removal and disable
the feature in user namespaces.

In particular, we get more and more gadgets to have bridge ports escape
rcu_read_lock() protection, then underlying device gets reconfigured
(macvlan or something else), then reinject into network stack causes
crash because net_device is assumed to still have bridge rx data
associated with it.

br_netfilter is an ancient kludge that emulates ip stack from within the
bridge and then calls into ipv4/ipv6 netfilter hooks to have bridged
frames processed via iptables/ip6tables by setting the 'call-iptables'
sysctls to 1. It is NOT related to ebtables or nftables 'bridge' family
at all.

Note that in addition to call-iptables, sysctls, the bridge itself exposes
call-iptables per port via netlink and sysfs ('BROPT_NF_CALL_IPTABLES')
toggles.

Those are still available, the brnet structure is scoped to br_netfilter;
exposing it bridge-wide is a big no-no.

This relies on brnf_device_event() no longer registering the base
br_netfilter hooks, so while BROPT_NF_CALL_IPTABLES can be set, it
has no effect because the hooks that evaluate this feature bit
are never registered.

brnf_init_net can no longer depend on CONFIG_SYSCTL, else such builds
never disable support in user namespaces.

v2: avoid silly UaF, compilers are too forgiving...

Cc: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_hooks.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 0a394e5f4391..e15355ff215a 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -54,6 +54,7 @@ static unsigned int brnf_net_id __read_mostly;
 
 struct brnf_net {
 	bool enabled;
+	bool in_userns;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header *ctl_hdr;
@@ -1100,7 +1101,7 @@ static int brnf_device_event(struct notifier_block *unused, unsigned long event,
 
 	net = dev_net(dev);
 	brnet = net_generic(net, brnf_net_id);
-	if (brnet->enabled)
+	if (brnet->enabled || brnet->in_userns)
 		return NOTIFY_OK;
 
 	ret = nf_register_net_hooks(net, br_nf_ops, ARRAY_SIZE(br_nf_ops));
@@ -1229,9 +1230,11 @@ static inline void br_netfilter_sysctl_default(struct brnf_net *brnf)
 	brnf->filter_pppoe_tagged = 0;
 	brnf->pass_vlan_indev = 0;
 }
+#endif
 
 static int br_netfilter_sysctl_init_net(struct net *net)
 {
+#ifdef CONFIG_SYSCTL
 	struct ctl_table *table = brnf_table;
 	struct brnf_net *brnet;
 
@@ -1259,25 +1262,39 @@ static int br_netfilter_sysctl_init_net(struct net *net)
 
 		return -ENOMEM;
 	}
-
+#endif
 	return 0;
 }
 
 static void br_netfilter_sysctl_exit_net(struct net *net,
 					 struct brnf_net *brnet)
 {
-	const struct ctl_table *table = brnet->ctl_hdr->ctl_table_arg;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header *header = brnet->ctl_hdr;
+	const struct ctl_table *table;
 
-	unregister_net_sysctl_table(brnet->ctl_hdr);
+	if (!header)
+		return;
+
+	table = header->ctl_table_arg;
+	unregister_net_sysctl_table(header);
 	if (!net_eq(net, &init_net))
 		kfree(table);
+#endif
 }
 
 static int __net_init brnf_init_net(struct net *net)
 {
+	if (net->user_ns != &init_user_ns) {
+		struct brnf_net *brnet = net_generic(net, brnf_net_id);
+
+		brnet->in_userns = true;
+		pr_warn_once("br_netfilter no longer supported in user namespaces\n");
+		return 0;
+	}
+
 	return br_netfilter_sysctl_init_net(net);
 }
-#endif
 
 static void __net_exit brnf_exit_net(struct net *net)
 {
@@ -1289,15 +1306,11 @@ static void __net_exit brnf_exit_net(struct net *net)
 		brnet->enabled = false;
 	}
 
-#ifdef CONFIG_SYSCTL
 	br_netfilter_sysctl_exit_net(net, brnet);
-#endif
 }
 
 static struct pernet_operations brnf_net_ops __read_mostly = {
-#ifdef CONFIG_SYSCTL
 	.init = brnf_init_net,
-#endif
 	.exit = brnf_exit_net,
 	.id   = &brnf_net_id,
 	.size = sizeof(struct brnf_net),
@@ -1318,7 +1331,7 @@ static int __init br_netfilter_init(void)
 	}
 
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
-	printk(KERN_NOTICE "Bridge firewalling registered\n");
+	pr_warn("br_netfilter is slated for removal in 2027.\n");
 	return 0;
 }
 
-- 
2.54.0

