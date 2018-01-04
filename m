From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next v3] netfilter: nf_defrag: Skip defrag if NOTRACK is set
Date: Wed,  3 Jan 2018 21:24:47 -0700
Message-ID: <1515039887-25798-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbeADE2N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 23:28:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrack defrag is needed only if some module like CONNTRACK or NAT
explicitly requests it. For plain forwarding scenarios, defrag is
not needed and can be skipped if NOTRACK is set in a rule.

Since conntrack defrag is currently higher priority than raw table,
setting NOTRACK is not sufficient. We need to move raw to a higher
priority for iptables only.

This is achieved by introducing a module parameter which allows to
modify the priority. By default, the priority is NF_IP_PRI_RAW to
support legacy behavior.

v1->v2: Instead of modifying NF_IP_PRI_RAW itself, use a module
parameter to pass in the priority during module load as suggested
by Pablo. Also update commit text.

v2->v3: Implement similar functionality for IPv6 as well

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv4/netfilter/iptable_raw.c          | 14 +++++++++++++-
 net/ipv4/netfilter/nf_defrag_ipv4.c       |  2 +-
 net/ipv6/netfilter/ip6table_raw.c         | 14 +++++++++++++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  3 +++
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 2642ecd..607392b 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -12,7 +12,11 @@
 
 static int __net_init iptable_raw_table_init(struct net *net);
 
-static const struct xt_table packet_raw = {
+static int priority __read_mostly = NF_IP_PRI_RAW;
+MODULE_PARM_DESC(priority, "Priority of IPv4 raw table (NF_IP_PRI_RAW)");
+module_param(priority, int, 0000);
+
+static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -70,6 +74,14 @@ static int __init iptable_raw_init(void)
 {
 	int ret;
 
+	if (priority < NF_IP_PRI_CONNTRACK_DEFRAG &&
+	    priority > NF_IP_PRI_FIRST) {
+		packet_raw.priority = priority;
+
+		pr_info("iptable_raw: Using custom rule priority=%d\n",
+			packet_raw.priority);
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
index d4bc564..4114e7b 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -11,7 +11,11 @@
 
 static int __net_init ip6table_raw_table_init(struct net *net);
 
-static const struct xt_table packet_raw = {
+static int priority __read_mostly = NF_IP6_PRI_RAW;
+MODULE_PARM_DESC(priority, "Priority of IPv6 raw table (NF_IP6_PRI_RAW)");
+module_param(priority, int, 0000);
+
+static struct xt_table packet_raw = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
@@ -63,6 +67,14 @@ static int __init ip6table_raw_init(void)
 {
 	int ret;
 
+	if (priority < NF_IP6_PRI_CONNTRACK_DEFRAG &&
+	    priority > NF_IP6_PRI_FIRST) {
+		packet_raw.priority = priority;
+
+		pr_info("ip6table_raw: Using custom rule priority=%d\n",
+			packet_raw.priority);
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

