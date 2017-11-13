From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: add BUILD_BUG_ON asserts for hook array sizes
Date: Mon, 13 Nov 2017 17:41:05 +0100
Message-ID: <20171113164107.11259-3-fw@strlen.de>
References: <20171113164107.11259-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48584 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753802AbdKMQla (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:41:30 -0500
In-Reply-To: <20171113164107.11259-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check that the array hooks are not accessed out-of-bounds.
Next patch will then reduce their sizes to reflect the number
of hooks implemented for each family.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 80aa9a0b3d10..2e9896d42f96 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -197,18 +197,23 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	rcu_read_lock();
 	switch (pf) {
 	case NFPROTO_IPV4:
+		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_ipv4));
 		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
 		break;
 	case NFPROTO_IPV6:
+		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_ipv6));
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
 	case NFPROTO_ARP:
+		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_arp));
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 		break;
 	case NFPROTO_BRIDGE:
+		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_bridge));
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
 		break;
 	case NFPROTO_DECNET:
+		BUILD_BUG_ON(hook >= ARRAY_SIZE(net->nf.hooks_decnet));
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
 		break;
 	default:
-- 
2.13.6

