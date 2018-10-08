From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush
Date: Tue,  9 Oct 2018 01:01:01 +0200
Message-ID: <20181008230125.2330-8-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

The same connection mark can be set on flows belonging to different
address families. This commit adds support for filtering on the L3
protocol when flushing connection track entries. If no protocol is
specified, then all L3 protocols match.

In order to avoid code duplication and a redundant check, the protocol
comparison in ctnetlink_dump_table() has been removed. Instead, a filter
is created if the GET-message triggering the dump contains an address
family. ctnetlink_filter_match() is then used to compare the L3
protocols.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 50 ++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 036207ecaf16..f8c74f31aa36 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -821,6 +821,7 @@ static int ctnetlink_done(struct netlink_callback *cb)
 }
 
 struct ctnetlink_filter {
+	u8 family;
 	struct {
 		u_int32_t val;
 		u_int32_t mask;
@@ -828,31 +829,32 @@ struct ctnetlink_filter {
 };
 
 static struct ctnetlink_filter *
-ctnetlink_alloc_filter(const struct nlattr * const cda[])
+ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
-#ifdef CONFIG_NF_CONNTRACK_MARK
 	struct ctnetlink_filter *filter;
 
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (filter == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	filter->family = family;
+
+#ifdef CONFIG_NF_CONNTRACK_MARK
 	filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
 	filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-
-	return filter;
-#else
-	return ERR_PTR(-EOPNOTSUPP);
 #endif
+	return filter;
 }
 
 static int ctnetlink_start(struct netlink_callback *cb)
 {
 	const struct nlattr * const *cda = cb->data;
 	struct ctnetlink_filter *filter = NULL;
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	u8 family = nfmsg->nfgen_family;
 
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-		filter = ctnetlink_alloc_filter(cda);
+	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
 	}
@@ -866,13 +868,24 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	struct ctnetlink_filter *filter = data;
 
 	if (filter == NULL)
-		return 1;
+		goto out;
+
+	/* Match entries of a given L3 protocol number.
+	 * If it is not specified, ie. l3proto == 0,
+	 * then match everything.
+	 */
+	if (filter->family && nf_ct_l3num(ct) != filter->family)
+		goto ignore_entry;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) == filter->mark.val)
-		return 1;
+	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+		goto ignore_entry;
 #endif
 
+out:
+	return 1;
+
+ignore_entry:
 	return 0;
 }
 
@@ -883,8 +896,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
-	u_int8_t l3proto = nfmsg->nfgen_family;
 	struct nf_conn *nf_ct_evict[8];
 	int res, i;
 	spinlock_t *lockp;
@@ -923,11 +934,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!net_eq(net, nf_ct_net(ct)))
 				continue;
 
-			/* Dump entries of a given L3 protocol number.
-			 * If it is not specified, ie. l3proto == 0,
-			 * then dump everything. */
-			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				continue;
 			if (cb->args[1]) {
 				if (ct != last)
 					continue;
@@ -1213,12 +1219,12 @@ static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
 
 static int ctnetlink_flush_conntrack(struct net *net,
 				     const struct nlattr * const cda[],
-				     u32 portid, int report)
+				     u32 portid, int report, u8 family)
 {
 	struct ctnetlink_filter *filter = NULL;
 
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
-		filter = ctnetlink_alloc_filter(cda);
+	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
 	}
@@ -1257,7 +1263,7 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	else {
 		return ctnetlink_flush_conntrack(net, cda,
 						 NETLINK_CB(skb).portid,
-						 nlmsg_report(nlh));
+						 nlmsg_report(nlh), u3);
 	}
 
 	if (err < 0)
-- 
2.11.0
