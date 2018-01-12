From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: nf_defrag: Fix compiler errors
Date: Thu, 11 Jan 2018 23:04:32 -0700
Message-ID: <1515737073-32344-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43420 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeALGEu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 01:04:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since packet_raw is now no longer const and referenced in __init,
make it __refdata. Also, reference conntrack state only if
conntrack is enabled.

These are fixes for errors reported by kbuild test robot.

Fixes: 902d6a4c2a4f411 ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv4/netfilter/iptable_raw.c          | 2 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c       | 6 +++++-
 net/ipv6/netfilter/ip6table_raw.c         | 2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c | 2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index d5a1200..3892f20 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -17,7 +17,7 @@
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
 
-static struct xt_table packet_raw = {
+static struct xt_table packet_raw __refdata = {
 	.name = "raw",
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index cbd987f..6a9fa7e 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -78,9 +78,13 @@ static unsigned int ipv4_conntrack_defrag(void *priv,
 	if (skb_nfct(skb) && !nf_ct_is_template((struct nf_conn *)skb_nfct(skb)))
 		return NF_ACCEPT;
 #endif
+
+	if (skb->_nfct == IP_CT_UNTRACKED)
+		return NF_ACCEPT;
 #endif
+
 	/* Gather fragments. */
-	if (skb->_nfct != IP_CT_UNTRACKED && ip_is_fragment(ip_hdr(skb))) {
+	if (ip_is_fragment(ip_hdr(skb))) {
 		enum ip_defrag_users user =
 			nf_ct_defrag_user(state->hook, skb);
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 3df7383..a881a55 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -16,7 +16,7 @@
 MODULE_PARM_DESC(raw_before_defrag, "Enable raw table before defrag");
 module_param(raw_before_defrag, bool, 0000);
 
-static struct xt_table packet_raw = {
+static struct xt_table packet_raw __refdata = {
 	.name = "raw",
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 87b503a..c87b483 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -63,10 +63,10 @@ static unsigned int ipv6_defrag(void *priv,
 	/* Previously seen (loopback)?	*/
 	if (skb_nfct(skb) && !nf_ct_is_template((struct nf_conn *)skb_nfct(skb)))
 		return NF_ACCEPT;
-#endif
 
 	if (skb->_nfct == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
+#endif
 
 	err = nf_ct_frag6_gather(state->net, skb,
 				 nf_ct6_defrag_user(state->hook, skb));
-- 
1.9.1

