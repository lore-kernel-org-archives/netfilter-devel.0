Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA82F7F0F;
	Sun, 18 Oct 2026 00:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285012; cv=none; b=OcrgrGy8forRbrlU6pKzxtpFcNiYjZGVRRG9EBeYKLCYRLZocO9gBNXyG86EsGRl4U2Td2nW5T4r3HFaCYdiMau2HWtGD1UgZmczm8MLDCbs0RO+3EsC25JPkaoLq/xQEcmLcB98bQRhVuWoGwG9wLVJNhWsZQrsxxqhGWrNnOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285012; c=relaxed/simple;
	bh=RaHOoftn4uL54J6lM1QLM5AKLVbWo8sRMqmdFNql+vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTDx4O5Jddy8C08K9/QDgEPr/4kr6zPvFuszHqSVQIu18xUbyQKt8LbJqUWoa0mfZ4uBN0Q9+rVXCQufb4dgPRdWglnvXjzUMHKAnqRTvMYq/ciJcqB2p+a5RUf7KYBJVibntKwjBZB0qkcpQStrynpzdaicYVtcNCmyiVCUXoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZN7jboDK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZN7jboDK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285008;
	bh=nY8Ge8LIbgZMa5CP4CSN2FfE9o/M8QmNqof3KDHOj+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN7jboDK93CwGwajaoYV/Wxxbg7ES6UZSe094PutwqqyoJcZVeB7LUkYoUPfYGIPB
	 TF0Oi+2331WMP6OdLPxLiXysBEhp6RpdVuaUQaj1EpetyoDV9S7AnSAI5pg4+nTGo2
	 a3RlPWBBan3K25/4CU2DqsW1Atn797eIG5W3EDAuiZrxmNz9gGok8xHDYuX27gyoSd
	 eYuKCjNc4SjesFQzQ6XOnVIvRQjmWFTkHwHD10YqlIjBbe7ZRhfXmg6wmmB1+Je8BW
	 CYhPI7n7Cx9vGFTRrFZpp9oFa4ouvUTaJAwwBOVvT9HZcfZ14b9eQfPSxUWk9Mnk7t
	 gDfMjEojnVrjQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AD80F6005F;
	Sun, 18 Oct 2026 02:56:47 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 01/15] netfilter: disable br_netfilter in user namespaces
Date: Sun, 18 Oct 2026 02:56:24 +0200
Message-ID: <20261018005638.1776148-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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

Note that in addition to call-iptables, sysctls, the bridge also exposes
call-iptables per bridge device via netlink and sysfs
('BROPT_NF_CALL_IPTABLES') toggles.

Those are still available, the brnet structure is scoped to br_netfilter;
exposing it bridge-wide is a big no-no.

This relies on brnf_device_event() no longer registering the base
br_netfilter hooks, so while BROPT_NF_CALL_IPTABLES can be set, it
has no effect because the hooks that evaluate this feature bit
are never registered.

brnf_init_net can no longer depend on CONFIG_SYSCTL, else such builds
never disable support in user namespaces.

Cc: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/bridge.rst |  5 +++--
 net/bridge/br_netfilter_hooks.c     | 33 ++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/bridge.rst b/Documentation/networking/bridge.rst
index c1e6ea52c9e5..dded1a6edd60 100644
--- a/Documentation/networking/bridge.rst
+++ b/Documentation/networking/bridge.rst
@@ -277,8 +277,9 @@ Netfilter
 =========
 
 The bridge netfilter module is a legacy feature that allows to filter bridged
-packets with iptables and ip6tables. Its use is discouraged. Users should
-consider using nftables for packet filtering.
+packets with iptables and ip6tables. This feature is scheduled for removal and
+not available in user namespaces. Consider using nftables for packet filtering
+instead.
 
 The older ebtables tool is more feature-limited compared to nftables, but
 just like nftables it doesn't need this module either to function.
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
2.47.3

