From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/10] netfilter: Replace spin_is_locked() with lockdep
Date: Sat, 20 Oct 2018 11:43:08 +0200
Message-ID: <20181020094317.16011-2-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Lance Roy <ldr709@gmail.com>

lockdep_assert_held() is better suited to checking locking requirements,
since it won't get confused when someone else holds the lock. This is
also a step towards possibly removing spin_is_locked().

Signed-off-by: Lance Roy <ldr709@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
Cc: <netdev@vger.kernel.org>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8a33dac4e805..e287da68d5fa 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -15,7 +15,7 @@
 
 #define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
 #define ipset_dereference_protected(p, set) \
-	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
+	__ipset_dereference_protected(p, lockdep_is_held(&(set)->lock))
 
 #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
 
-- 
2.11.0
