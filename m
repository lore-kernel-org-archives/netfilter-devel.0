From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 33/51] netfilter: x_tables: remove duplicate ip6t_get_target function call
Date: Mon,  7 May 2018 00:46:51 +0200
Message-ID: <20180506224709.29100-34-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

In the check_target, ip6t_get_target is called twice.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6_tables.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 65c9e1a58305..7097bbf95843 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -528,7 +528,6 @@ static int check_target(struct ip6t_entry *e, struct net *net, const char *name)
 		.family    = NFPROTO_IPV6,
 	};
 
-	t = ip6t_get_target(e);
 	return xt_check_target(&par, t->u.target_size - sizeof(*t),
 			       e->ipv6.proto,
 			       e->ipv6.invflags & IP6T_INV_PROTO);
-- 
2.11.0
