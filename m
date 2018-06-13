From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/9] netfilter: ctnetlink: avoid null pointer dereference
Date: Wed, 13 Jun 2018 12:56:58 +0200
Message-ID: <20180613105700.12894-8-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Dan Carpenter points out that deref occurs after NULL check, we should
re-fetch the pointer and check that instead.

Fixes: 2c205dd3981f7 ("netfilter: add struct nf_nat_hook and use it")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 39327a42879f..20a2e37c76d1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1446,7 +1446,8 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 		}
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		rcu_read_lock();
-		if (nat_hook->parse_nat_setup)
+		nat_hook = rcu_dereference(nf_nat_hook);
+		if (nat_hook)
 			return -EAGAIN;
 #endif
 		return -EOPNOTSUPP;
-- 
2.11.0
