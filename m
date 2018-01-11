From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next v4] netfilter: nf_defrag: Skip defrag if NOTRACK is set
Date: Wed, 10 Jan 2018 20:51:57 -0700
Message-ID: <1515642717-5994-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753377AbeAKDwO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 22:52:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrack defrag is needed only if some module like CONNTRACK or NAT
explicitly requests it. For plain forwarding scenarios, defrag is
not needed and can be skipped if NOTRACK is set in a rule.

Since conntrack defrag is currently higher priority than raw table,
setting NOTRACK is not sufficient. We need to move raw to a higher
priority for iptables only.

This is achieved by introducing a module parameter "raw_before_defrag"
which allows to change the priority of raw table to place it before
defrag. By default, the parameter is disabled and the priority of raw
table is NF_IP_PRI_RAW to support legacy behavior. If the module
parameter is enabled, then the priority of the raw table is set to
NF_IP_PRI_RAW_BEFORE_DEFRAG.

v1->v2: Instead of modifying NF_IP_PRI_RAW itself, use a module
parameter to pass in the priority during module load as suggested
by Pablo. Also update commit text.

v2->v3: Implement similar functionality for IPv6 as well

v3->v4: Add NF_IP_PRI_RAW_BEFORE_DEFRAG in uapi and make the module
load priority into an on/off knob. Add the module name to the print.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/uapi/linux/netfilter_ipv4.h       |  1 +
 include/uapi/linux/netfilter_ipv6.h       |  1 +
 net/ipv4/netfilter/iptable_raw.c          | 13 ++++++++++++-
 net/ipv4/netfilter/nf_defrag_ipv4.c       |  2 +-
 net/ipv6/netfilter/ip6table_raw.c         | 13 ++++++++++++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  3 +++
 6 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4.h b/include/uapi/linux/netfilter_ipv4.h
index e6b1a84..c3b0607 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -57,6 +57,7 @@
 
 enum nf_ip_hook_priorities {
 	NF_IP_PRI_FIRST = INT_MIN,
+	NF_IP_PRI_RAW_BEFORE_DEFRAG = -450,
 	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
 	NF_IP_PRI_RAW = -300,
 	NF_IP_PRI_SELINUX_FIRST = -225,
diff --git a/include/uapi/linux/netfilter_ipv6.h b/include/uapi/linux/netfilter_ipv6.h
index 2f97246..dc624fd 100644
--- a/include/uapi/linux/netfilter_ipv6.h
+++ b/include/uapi/linux/netfilter_ipv6.h
@@ -62,6 +62,7 @@
 
 enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_FIRST = INT_MIN,
+	NF_IP6_PRI_RAW_BEFORE_DEFRAG = -450,
 	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
 	NF_IP6_PRI_RAW = -300,
 	NF_IP6_PRI_SELINUX_FIRST = -225,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 2642ecd..d5a1200 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/slab.h>
@@ -12,7 +13,11 @@
 
 static int __net_init iptable_raw_table_init(struct net *net);
 
-static const struct xt_table packet_raw = {
+static bool raw_before_defrag __read_mostly;
+MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
+module_param(raw_before_defrag, bool, 0000);
+
+static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -70,6 +75,12 @@ static int __init iptable_raw_init(void)
 {
 	int ret;
 
+	if (raw_before_defrag) {
+		packet_raw.priority = NF_IP_PRI_RAW_BEFORE_DEFRAG;
+
+		pr_info("Enabling raw table before defrag\n");
+	}
+
 	rawtable_ops = xt_hook_ops_alloc(&packet_raw, iptable_raw_hook);
 	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 37fe1616..cbd987f 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -80,7 +80,7 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 #endif
 #endif
 	/* Gather fragments. */
-	if (ip_is_fragment(ip_hdr(skb))) {
+	if (skb->_nfct != IP_CT_UNTRACKED && ip_is_fragment(ip_hdr(skb))) {
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(state->hook, skb);
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index d4bc564..3df7383 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2003 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/slab.h>
@@ -11,7 +12,11 @@
 
 static int __net_init ip6table_raw_table_init(struct net *net);
 
-static const struct xt_table packet_raw = {
+static bool raw_before_defrag __read_mostly;
+MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
+module_param(raw_before_defrag, bool, 0000);
+
+static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -63,6 +68,12 @@ static int __init ip6table_raw_init(void)
 {
 	int ret;
 
+	if (raw_before_defrag) {
+		packet_raw.priority = NF_IP6_PRI_RAW_BEFORE_DEFRAG;
+
+		pr_info("Enabling raw table before defrag\n");
+	}
+
 	/* Register hooks */
 	rawtable_ops = xt_hook_ops_alloc(&packet_raw, ip6table_raw_hook);
 	if (IS_ERR(rawtable_ops))
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index b326da5..87b503a 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -65,6 +65,9 @@ static unsigned int ipv6_defrag(void *priv,
 		return NF_ACCEPT;
 #endif
 
+	if (skb->_nfct == IP_CT_UNTRACKED)
+		return NF_ACCEPT;
+
 	err = nf_ct_frag6_gather(state->net, skb,
 				 nf_ct6_defrag_user(state->hook, skb));
 	/* queued */
-- 
1.9.1

