From: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset nf-next] netfilter: ipset: use nfnl_mutex_is_locked
Date: Thu, 30 Nov 2017 21:07:32 +0100
Message-ID: <20171130200732.2814-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37170 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750849AbdK3UHj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 15:07:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check that we really hold nfnl mutex here instead of relying on correct
usage alone.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d5a43cad90f04..1f3c03b3bebf2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -57,7 +57,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
 
 /* When the nfnl mutex is held: */
 #define ip_set_dereference(p)		\
-	rcu_dereference_protected(p, 1)
+	rcu_dereference_protected(p, lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 #define ip_set(inst, id)		\
 	ip_set_dereference((inst)->ip_set_list)[id]
 
-- 
2.14.3

