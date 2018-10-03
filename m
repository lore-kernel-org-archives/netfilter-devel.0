From: Lance Roy <ldr709@gmail.com>
Subject: [PATCH 14/16] netfilter: Replace spin_is_locked() with lockdep
Date: Tue,  2 Oct 2018 22:39:00 -0700
Message-ID: <20181003053902.6910-15-ldr709@gmail.com>
References: <20181003053902.6910-1-ldr709@gmail.com>
Reply-To: Lance Roy <ldr709@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Lance Roy <ldr709@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003053902.6910-1-ldr709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
2.19.0
