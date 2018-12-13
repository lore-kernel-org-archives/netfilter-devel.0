From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] netfilter: ipset: do not call ipset_nest_end after nla_nest_cancel
Date: Thu, 13 Dec 2018 02:06:29 +0100
Message-ID: <20181213010631.9753-4-pablo@netfilter.org>
References: <20181213010631.9753-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213010631.9753-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

In the error handling block, nla_nest_cancel(skb, atd) is called to
cancel the nest operation. But then, ipset_nest_end(skb, atd) is
unexpected called to end the nest operation. This patch calls the
ipset_nest_end only on the branch that nla_nest_cancel is not called.

Fixes: 45040978c899 ("netfilter: ipset: Fix set:list type crash when flush/dump set in parallel")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 4eef55da0878..8da228da53ae 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -531,8 +531,8 @@ list_set_list(const struct ip_set *set,
 		ret = -EMSGSIZE;
 	} else {
 		cb->args[IPSET_CB_ARG0] = i;
+		ipset_nest_end(skb, atd);
 	}
-	ipset_nest_end(skb, atd);
 out:
 	rcu_read_unlock();
 	return ret;
-- 
2.11.0
