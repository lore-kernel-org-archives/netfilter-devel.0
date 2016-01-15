From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next 1/3] netfilter: bridge: add nf_afinfo to enable queuing to userspace
Date: Fri, 15 Jan 2016 09:48:52 +0100
Message-ID: <1452847734-3766-2-git-send-email-stephane.ml.bryant@gmail.com>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36346 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcAOItH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 03:49:07 -0500
Received: by mail-wm0-f66.google.com with SMTP id l65so1699182wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 00:49:07 -0800 (PST)
In-Reply-To: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

This just adds and registers a nf_afinfo for the ethernet
bridge, which enables queuing to userspace for the AF_BRIDGE
family. No checksum computation is done.

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/bridge/br_netfilter_hooks.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 7ddbe7e..7f8f922 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -999,6 +999,46 @@ static struct ctl_table brnf_table[] = {
 };
 #endif
 
+static void nf_br_saveroute(const struct sk_buff *skb,
+			    struct nf_queue_entry *entry)
+{
+}
+
+static int nf_br_reroute(struct sk_buff *skb,
+			 const struct nf_queue_entry *entry)
+{
+	return 0;
+}
+
+__sum16 nf_br_checksum(struct sk_buff *skb, unsigned int hook,
+		       unsigned int dataoff, u_int8_t protocol)
+{
+	return 0;
+}
+
+static __sum16 nf_br_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				      unsigned int dataoff, unsigned int len,
+				      u_int8_t protocol)
+{
+	return 0;
+}
+
+static int nf_br_route(struct net *net, struct dst_entry **dst,
+		       struct flowi *fl, bool strict __always_unused)
+{
+	return 0;
+}
+
+static const struct nf_afinfo nf_br_afinfo = {
+	.family			= AF_BRIDGE,
+	.checksum		= nf_br_checksum,
+	.checksum_partial	= nf_br_checksum_partial,
+	.route			= nf_br_route,
+	.saveroute		= nf_br_saveroute,
+	.reroute		= nf_br_reroute,
+	.route_key_size		= 0,
+};
+
 static int __init br_netfilter_init(void)
 {
 	int ret;
@@ -1018,12 +1058,16 @@ static int __init br_netfilter_init(void)
 #endif
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
+
+	nf_register_afinfo(&nf_br_afinfo);
+
 	return 0;
 }
 
 static void __exit br_netfilter_fini(void)
 {
 	RCU_INIT_POINTER(nf_br_ops, NULL);
+	nf_unregister_afinfo(&nf_br_afinfo);
 	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(brnf_sysctl_header);
-- 
2.1.4

