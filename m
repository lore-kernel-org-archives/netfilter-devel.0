From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2] netfilter: ebtables: make broute table work again
Date: Mon, 10 Jan 2011 17:20:09 +0100
Message-ID: <20110110162009.GD31228@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57823 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab1AJQUK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:20:10 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
1.7.2.2
