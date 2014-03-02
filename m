From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] ip_set: remove extraneous log message
Date: Sun,  2 Mar 2014 22:07:04 +0100
Message-ID: <1393794424-1887-1-git-send-email-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This code path is hit everytime a new network namespace is created,
which means it runs everytime I start Chromium, resulting in needless
noise in my logs. This message doesn't add very much at all, and isn't
triggered at the correct place anyway, so this patch simply removes it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/netfilter/ipset/ip_set_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index de770ec..283f197 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1945,7 +1945,6 @@ ip_set_net_init(struct net *net)
 		return -ENOMEM;
 	inst->is_deleted = 0;
 	rcu_assign_pointer(inst->ip_set_list, list);
-	pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
-- 
1.8.5.4
