From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: avoid arp/bridge WARN_ON if arp/ebtables not supported
Date: Mon,  8 Jan 2018 13:31:52 +0100
Message-ID: <20180108123152.11499-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38974 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756727AbeAHMmA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jan 2018 07:42:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to retain the 'case' statement, otherwise, if e.g. arp tables
isn't supported first NF_HOOK(NFPROTO_ARP, ... will produce a bogus
WARN_ON().

Fixes: 8de98f05836 ("netfilter: don't allocate space for arp/bridge hooks unless needed")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 84987186aa26..85a1a0b32c66 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -214,16 +214,16 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	case NFPROTO_IPV6:
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
-#ifdef CONFIG_NETFILTER_FAMILY_ARP
 	case NFPROTO_ARP:
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
-		break;
 #endif
-#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+		break;
 	case NFPROTO_BRIDGE:
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
-		break;
 #endif
+		break;
 #if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
-- 
2.13.6

