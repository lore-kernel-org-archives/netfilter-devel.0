From: Shaochun Chen <cscnull@gmail.com>
Subject: [PATCH] netlink: fix memory leak of dump
Date: Sun, 22 Jul 2018 22:33:54 +0800
Message-ID: <20180722143354.23722-1-cscnull@gmail.com>
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        johannes.berg@intel.com, Jason@zx2c4.com, ktkhai@virtuozzo.com,
        lucien.xin@gmail.com, xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaochun Chen <cscnull@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

1) if netlink_dump_start start fail, the memory of c->data will leak.
so free manually after netlink_dump_start return error.

2) In netlink_dump_start, ignore the return of netlink_dump.
Because if cb_running is set to true, cb->dump will be call in anyway.
so if netlink_dump_start start successfully, just return -EINTR.

Signed-off-by: Shaochun Chen <cscnull@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c |  8 ++++--
 net/netfilter/nf_tables_api.c        | 41 ++++++++++++++++++++--------
 net/netfilter/nfnetlink_acct.c       |  8 ++++--
 net/netlink/af_netlink.c             |  5 +---
 4 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 20a2e37c76d1..31db758bdb7a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1243,17 +1243,19 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
 		};
+		struct ctnetlink_filter *filter = NULL;
 
 		if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-			struct ctnetlink_filter *filter;
-
 			filter = ctnetlink_alloc_filter(cda);
 			if (IS_ERR(filter))
 				return PTR_ERR(filter);
 
 			c.data = filter;
 		}
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		err = netlink_dump_start(ctnl, skb, nlh, &c);
+		if (err != -EINTR && filter)
+			kfree(filter);
+		return err;
 	}
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 896d4a36081d..4635a841f5f2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2287,10 +2287,9 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			.done = nf_tables_dump_rules_done,
 			.module = THIS_MODULE,
 		};
+		struct nft_rule_dump_ctx *ctx = NULL;
 
 		if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
-			struct nft_rule_dump_ctx *ctx;
-
 			ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
 			if (!ctx)
 				return -ENOMEM;
@@ -2315,7 +2314,13 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 			c.data = ctx;
 		}
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		err = nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		if (err != -EINTR && ctx) {
+			kfree(ctx->table);
+			kfree(ctx->chain);
+			kfree(ctx);
+		}
+		return err;
 	}
 
 	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask);
@@ -3201,7 +3206,10 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 		*ctx_dump = ctx;
 		c.data = ctx_dump;
 
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		err = nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		if (err != -EINTR)
+			kfree(ctx_dump);
+		return err;
 	}
 
 	/* Only accept unspec with dump */
@@ -4016,7 +4024,10 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 		dump_ctx->ctx = ctx;
 
 		c.data = dump_ctx;
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		err = nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		if (err != -EINTR)
+			kfree(dump_ctx);
+		return err;
 	}
 
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
@@ -5031,18 +5042,22 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 		};
+		struct nft_obj_filter *filter = NULL;
 
 		if (nla[NFTA_OBJ_TABLE] ||
 		    nla[NFTA_OBJ_TYPE]) {
-			struct nft_obj_filter *filter;
-
 			filter = nft_obj_filter_alloc(nla);
 			if (IS_ERR(filter))
 				return -ENOMEM;
 
 			c.data = filter;
 		}
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		err = nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		if (err != -EINTR && filter) {
+			kfree(filter->table);
+			kfree(filter);
+		}
+		return err;
 	}
 
 	if (!nla[NFTA_OBJ_NAME] ||
@@ -5704,17 +5719,21 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 			.done = nf_tables_dump_flowtable_done,
 			.module = THIS_MODULE,
 		};
+		struct nft_flowtable_filter *filter = NULL;
 
 		if (nla[NFTA_FLOWTABLE_TABLE]) {
-			struct nft_flowtable_filter *filter;
-
 			filter = nft_flowtable_filter_alloc(nla);
 			if (IS_ERR(filter))
 				return -ENOMEM;
 
 			c.data = filter;
 		}
-		return nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		err = nft_netlink_dump_start_rcu(nlsk, skb, nlh, &c);
+		if (err != -EINTR && filter) {
+			kfree(filter->table);
+			kfree(filter);
+		}
+		return err;
 	}
 
 	if (!nla[NFTA_FLOWTABLE_NAME])
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index a0e5adf0b3b6..aecdb9cc1c5d 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -277,17 +277,19 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 			.dump = nfnl_acct_dump,
 			.done = nfnl_acct_done,
 		};
+		struct nfacct_filter *filter = NULL;
 
 		if (tb[NFACCT_FILTER]) {
-			struct nfacct_filter *filter;
-
 			filter = nfacct_filter_alloc(tb[NFACCT_FILTER]);
 			if (IS_ERR(filter))
 				return PTR_ERR(filter);
 
 			c.data = filter;
 		}
-		return netlink_dump_start(nfnl, skb, nlh, &c);
+		ret = netlink_dump_start(nfnl, skb, nlh, &c);
+		if (ret != -EINTR && filter)
+			kfree(filter);
+		return ret;
 	}
 
 	if (!tb[NFACCT_NAME])
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 393573a99a5a..61450461378c 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2320,13 +2320,10 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 
 	mutex_unlock(nlk->cb_mutex);
 
-	ret = netlink_dump(sk);
+	netlink_dump(sk);
 
 	sock_put(sk);
 
-	if (ret)
-		return ret;
-
 	/* We successfully started a dump, by returning -EINTR we
 	 * signal not to send ACK even if it was requested.
 	 */
-- 
2.17.1
