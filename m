From: pablo@netfilter.org
Subject: [PATCH 3/3] netfilter: ebtables: make broute table work again
Date: Wed, 12 Jan 2011 00:26:18 +0100
Message-ID: <1294788378-11475-4-git-send-email-pablo@netfilter.org>
References: <1294788378-11475-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41307 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab1AKX2B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:28:01 -0500
In-Reply-To: <1294788378-11475-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

broute table init hook sets up the "br_should_route_hook" pointer,
which then gets called from br_input.

commit a386f99025f13b32502fe5dedf223c20d7283826
(bridge: add proper RCU annotation to should_route_hook)
introduced a typedef, and then changed this to:

br_should_route_hook_t *rhook;
[..]
rhook = rcu_dereference(br_should_route_hook);
if (*rhook(skb))

problem is that "br_should_route_hook" contains the address of the function,
so calling *rhook() results in kernel panic.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/if_bridge.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f7e73c3..dd3f201 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -103,7 +103,7 @@ struct __fdb_entry {
 
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
 
-typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
+typedef int br_should_route_hook_t(struct sk_buff *skb);
 extern br_should_route_hook_t __rcu *br_should_route_hook;
 
 #endif
-- 
1.7.2.3

