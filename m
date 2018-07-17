From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 13/17] net/neighbor: Convert internal functions away from neigh_tables
Date: Tue, 17 Jul 2018 05:06:47 -0700
Message-ID: <20180717120651.15748-14-dsahern@kernel.org>
References: <20180717120651.15748-1-dsahern@kernel.org>
Cc: nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Convert uses of neigh_tables array to neigh_find_table. Maintain existing
family order using a new table_families array. A later patch removes the
neigh_tables array in favor of per-namespace accesses.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/core/neighbour.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b60087d7c0bc..afb2ee985dd1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -62,6 +62,19 @@ static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
 static const struct seq_operations neigh_stat_seq_ops;
 #endif
 
+/* used for table dumps to maintain the legacy order of
+ * ipv4, ipv6, decnet
+ */
+static int table_families[] = {
+	AF_INET,
+#if IS_ENABLED(CONFIG_IPV6)
+	AF_INET6,
+#endif
+#if IS_ENABLED(CONFIG_DECNET)
+	AF_DECnet,
+#endif
+};
+
 /*
    Neighbour hash table buckets are protected with rwlock tbl->lock.
 
@@ -2046,8 +2059,8 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ndtmsg = nlmsg_data(nlh);
 
-	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
-		tbl = neigh_tables[tidx];
+	for (tidx = 0; tidx < ARRAY_SIZE(table_families); tidx++) {
+		tbl = neigh_find_table(net, table_families[tidx]);
 		if (!tbl)
 			continue;
 		if (ndtmsg->ndtm_family && tbl->family != ndtmsg->ndtm_family)
@@ -2195,10 +2208,10 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 
 	family = ((struct rtgenmsg *) nlmsg_data(cb->nlh))->rtgen_family;
 
-	for (tidx = 0; tidx < NEIGH_NR_TABLES; tidx++) {
+	for (tidx = 0; tidx < ARRAY_SIZE(table_families); tidx++) {
 		struct neigh_parms *p;
 
-		tbl = neigh_tables[tidx];
+		tbl = neigh_find_table(net, table_families[tidx]);
 		if (!tbl)
 			continue;
 
@@ -2453,6 +2466,7 @@ static int pneigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 
 static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct net *net = sock_net(skb->sk);
 	struct neigh_table *tbl;
 	int t, family, s_t;
 	int proxy = 0;
@@ -2469,9 +2483,8 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 
 	s_t = cb->args[0];
 
-	for (t = 0; t < NEIGH_NR_TABLES; t++) {
-		tbl = neigh_tables[t];
-
+	for (t = 0; t < ARRAY_SIZE(table_families); t++) {
+		tbl = neigh_find_table(net, table_families[t]);
 		if (!tbl)
 			continue;
 		if (t < s_t || (family && tbl->family != family))
-- 
2.11.0
