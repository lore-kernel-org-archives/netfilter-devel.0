From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/31] netfilter: nat: remove unnecessary rcu_read_lock in nf_nat_redirect_ipv{4/6}
Date: Tue,  9 Oct 2018 01:01:07 +0200
Message-ID: <20181008230125.2330-14-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

nf_nat_redirect_ipv4() and nf_nat_redirect_ipv6() are only called by
netfilter hook point. so that rcu_read_lock and rcu_read_unlock() are
unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_redirect.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index adee04af8d43..78a9e6454ff3 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -52,13 +52,11 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 
 		newdst = 0;
 
-		rcu_read_lock();
 		indev = __in_dev_get_rcu(skb->dev);
 		if (indev && indev->ifa_list) {
 			ifa = indev->ifa_list;
 			newdst = ifa->ifa_local;
 		}
-		rcu_read_unlock();
 
 		if (!newdst)
 			return NF_DROP;
@@ -97,7 +95,6 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		struct inet6_ifaddr *ifa;
 		bool addr = false;
 
-		rcu_read_lock();
 		idev = __in6_dev_get(skb->dev);
 		if (idev != NULL) {
 			read_lock_bh(&idev->lock);
@@ -108,7 +105,6 @@ nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 			}
 			read_unlock_bh(&idev->lock);
 		}
-		rcu_read_unlock();
 
 		if (!addr)
 			return NF_DROP;
-- 
2.11.0
