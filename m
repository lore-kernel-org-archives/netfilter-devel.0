From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] Handle the routing changes in the MASQUERADE target
Date: Tue, 13 Nov 2012 21:17:37 +0100
Message-ID: <1352837857-22087-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:45082 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab2KMURk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:17:40 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id ADE9D4D4005
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f8fa+BGd9fFY for <netfilter-devel@vger.kernel.org>;
	Tue, 13 Nov 2012 21:17:38 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 8B4354D4012
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Nov 2012 21:17:38 +0100 (CET)
In-Reply-To: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the routing changes, MASQUERADE should delete the conntrack
entries where the source NATed address changes due to the routing
change. As a first approximation, delete all entries which are
marked with the new "--route-dependent" flag of the MASQUERADE
target.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h |    4 ++
 include/uapi/linux/netfilter/nf_nat.h              |    1 +
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   40 ++++++++++++++++++++
 3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 1644cdd..1c698b5 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -87,6 +87,10 @@ enum ip_conntrack_status {
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Conntrack must be deleted when routing changed (NAT) */
+	IPS_ROUTING_DEPENDENT_BIT = 14,
+	IPS_ROUTING_DEPENDENT = (1 << IPS_ROUTING_DEPENDENT_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
index bf0cc37..a0dfac7 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -8,6 +8,7 @@
 #define NF_NAT_RANGE_PROTO_SPECIFIED	2
 #define NF_NAT_RANGE_PROTO_RANDOM	4
 #define NF_NAT_RANGE_PERSISTENT		8
+#define NF_NAT_ROUTING_DEPENDENT	16
 
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 5d5d4d1..ecf3063 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -19,6 +19,7 @@
 #include <net/ip.h>
 #include <net/checksum.h>
 #include <net/route.h>
+#include <net/ip_fib.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat.h>
@@ -88,6 +89,9 @@ masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	newrange.min_proto   = mr->range[0].min;
 	newrange.max_proto   = mr->range[0].max;
 
+	if (mr->range[0].flags & NF_NAT_ROUTING_DEPENDENT)
+		set_bit(IPS_ROUTING_DEPENDENT, &ct->status);
+
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
 }
@@ -132,6 +136,35 @@ static int masq_inet_event(struct notifier_block *this,
 	return masq_device_event(this, event, dev);
 }
 
+static int
+route_cmp(struct nf_conn *i, const struct fib_info *fi)
+{
+	const struct nf_conn_nat *nat = nfct_nat(i);
+
+	if (!nat)
+		return 0;
+	if (nf_ct_l3num(i) != NFPROTO_IPV4)
+		return 0;
+	if (!test_bit(IPS_ROUTING_DEPENDENT, &ct->status))
+		return 0;
+
+	/* We should check whether the SNAT address changed. */
+	return 1;
+}
+
+static int masq_route_event(struct notifier_block *this,
+			    unsigned long event,
+			    void *ptr)
+{
+	if (event == NETDEV_ROUTE_CHANGED) {
+		/* Routing changed, delete marked entries */
+		nf_ct_iterate_cleanup(net, route_cmp,
+				      (const struct fib_info)ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static struct notifier_block masq_dev_notifier = {
 	.notifier_call	= masq_device_event,
 };
@@ -140,6 +173,10 @@ static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
 
+static struct notifier_block masq_route_notifier = {
+	.notifier_call	= masq_route_event,
+};
+
 static struct xt_target masquerade_tg_reg __read_mostly = {
 	.name		= "MASQUERADE",
 	.family		= NFPROTO_IPV4,
@@ -162,6 +199,8 @@ static int __init masquerade_tg_init(void)
 		register_netdevice_notifier(&masq_dev_notifier);
 		/* Register IP address change reports */
 		register_inetaddr_notifier(&masq_inet_notifier);
+		/* Register route change reports */
+		register_iproute_notifier(&masq_route_notifier);
 	}
 
 	return ret;
@@ -172,6 +211,7 @@ static void __exit masquerade_tg_exit(void)
 	xt_unregister_target(&masquerade_tg_reg);
 	unregister_netdevice_notifier(&masq_dev_notifier);
 	unregister_inetaddr_notifier(&masq_inet_notifier);
+	unregister_iproute_notifier(&masq_route_notifier);
 }
 
 module_init(masquerade_tg_init);
-- 
1.7.0.4

