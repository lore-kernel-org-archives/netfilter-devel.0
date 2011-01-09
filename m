From: Florian Westphal <fw@strlen.de>
Subject: [PATCH][resend] netfilter: ebtables: make broute table work again
Date: Sun,  9 Jan 2011 22:48:49 +0100
Message-ID: <1294609729-13039-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42956 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab1AIVx7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:53:59 -0500
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

Can't simply use "if (rhook(skb)", because br_should_route_hook_t *rhook
is not a function.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Eric, does this patch look sane to you?

 Pablo, only the if_bridge.h change is needed.
 If you do not like the br_input.c change, feel
 free to remove it when applying.

 Thanks!

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
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 6f6d8e1..1d677bf 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -178,7 +178,7 @@ forward:
 	case BR_STATE_FORWARDING:
 		rhook = rcu_dereference(br_should_route_hook);
 		if (rhook) {
-			if ((*rhook)(skb))
+			if (rhook(skb))
 				return skb;
 			dest = eth_hdr(skb)->h_dest;
 		}
-- 
1.7.2.2

