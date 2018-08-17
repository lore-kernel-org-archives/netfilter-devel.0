From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/15] netfilter: fix memory leaks on netlink_dump_start error
Date: Fri, 17 Aug 2018 21:38:41 +0200
Message-ID: <20180817193850.2796-7-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Shaochun Chen points out we leak dumper filter state allocations
stored in dump_control->data in case there is an error before netlink sets
cb_running (after which ->done will be called at some point).

In order to fix this, add .start functions and move allocations there.

Same pattern as used in commit 90fd131afc565159c9e0ea742f082b337e10f8c6
("netfilter: nf_tables: move dumper state allocation into ->start").

Reported-by: shaochun chen <cscnull@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 26 +++++++++++++++++---------
 net/netfilter/nfnetlink_acct.c       | 29 +++++++++++++----------------
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f981bfa8db72..036207ecaf16 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -846,6 +846,21 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[])
 #endif
 }
 
+static int ctnetlink_start(struct netlink_callback *cb)
+{
+	const struct nlattr * const *cda = cb->data;
+	struct ctnetlink_filter *filter = NULL;
+
+	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+		filter = ctnetlink_alloc_filter(cda);
+		if (IS_ERR(filter))
+			return PTR_ERR(filter);
+	}
+
+	cb->data = filter;
+	return 0;
+}
+
 static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 {
 	struct ctnetlink_filter *filter = data;
@@ -1290,19 +1305,12 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
+			.start = ctnetlink_start,
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
+			.data = (void *)cda,
 		};
 
-		if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-			struct ctnetlink_filter *filter;
-
-			filter = ctnetlink_alloc_filter(cda);
-			if (IS_ERR(filter))
-				return PTR_ERR(filter);
-
-			c.data = filter;
-		}
 		return netlink_dump_start(ctnl, skb, nlh, &c);
 	}
 
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index a0e5adf0b3b6..8fa8bf7c48e6 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -238,29 +238,33 @@ static const struct nla_policy filter_policy[NFACCT_FILTER_MAX + 1] = {
 	[NFACCT_FILTER_VALUE]	= { .type = NLA_U32 },
 };
 
-static struct nfacct_filter *
-nfacct_filter_alloc(const struct nlattr * const attr)
+static int nfnl_acct_start(struct netlink_callback *cb)
 {
-	struct nfacct_filter *filter;
+	const struct nlattr *const attr = cb->data;
 	struct nlattr *tb[NFACCT_FILTER_MAX + 1];
+	struct nfacct_filter *filter;
 	int err;
 
+	if (!attr)
+		return 0;
+
 	err = nla_parse_nested(tb, NFACCT_FILTER_MAX, attr, filter_policy,
 			       NULL);
 	if (err < 0)
-		return ERR_PTR(err);
+		return err;
 
 	if (!tb[NFACCT_FILTER_MASK] || !tb[NFACCT_FILTER_VALUE])
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
 	filter = kzalloc(sizeof(struct nfacct_filter), GFP_KERNEL);
 	if (!filter)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	filter->mask = ntohl(nla_get_be32(tb[NFACCT_FILTER_MASK]));
 	filter->value = ntohl(nla_get_be32(tb[NFACCT_FILTER_VALUE]));
+	cb->data = filter;
 
-	return filter;
+	return 0;
 }
 
 static int nfnl_acct_get(struct net *net, struct sock *nfnl,
@@ -275,18 +279,11 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
+			.start = nfnl_acct_start,
 			.done = nfnl_acct_done,
+			.data = (void *)tb[NFACCT_FILTER],
 		};
 
-		if (tb[NFACCT_FILTER]) {
-			struct nfacct_filter *filter;
-
-			filter = nfacct_filter_alloc(tb[NFACCT_FILTER]);
-			if (IS_ERR(filter))
-				return PTR_ERR(filter);
-
-			c.data = filter;
-		}
 		return netlink_dump_start(nfnl, skb, nlh, &c);
 	}
 
-- 
2.11.0
