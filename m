From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 16/17] net/decnet: Move neighbor table to per-namespace
Date: Tue, 17 Jul 2018 05:06:50 -0700
Message-ID: <20180717120651.15748-17-dsahern@kernel.org>
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

Convert decnet neighbor table to per-namespace. Since there are no
other per-namespace parameters for decnet just add the reference to
struct net directly.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/net_namespace.h |  3 +++
 net/core/neighbour.c        | 26 ++++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index a71264d75d7f..77799ed7212e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -108,6 +108,9 @@ struct net {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct netns_ipv6	ipv6;
 #endif
+#if IS_ENABLED(CONFIG_DECNET)
+	struct neigh_table	*dn_tbl;
+#endif
 #if IS_ENABLED(CONFIG_IEEE802154_6LOWPAN)
 	struct netns_ieee802154_lowpan	ieee802154_lowpan;
 #endif
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 35c41c4876e5..1bb7fa14cb62 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1485,15 +1485,11 @@ EXPORT_SYMBOL(pneigh_enqueue);
 static inline struct neigh_parms *lookup_neigh_parms(struct neigh_table *tbl,
 						      struct net *net, int ifindex)
 {
-	struct net *def_net = &init_net;
 	struct neigh_parms *p;
 
-	if (tbl->family != AF_DECnet)
-		def_net = neigh_parms_net(p);
-
 	list_for_each_entry(p, &tbl->parms_list, list) {
 		if ((p->dev && p->dev->ifindex == ifindex && net_eq(neigh_parms_net(p), net)) ||
-		    (!p->dev && !ifindex && net_eq(net, def_net)))
+		    (!p->dev && !ifindex))
 			return p;
 	}
 
@@ -1622,9 +1618,11 @@ void neigh_table_init(struct net *net, struct neigh_table *tbl)
 		net->ipv6.nd_tbl = tbl;
 		break;
 #endif
+#if IS_ENABLED(CONFIG_DECNET)
 	case AF_DECnet:
-		neigh_tables[NEIGH_DN_TABLE] = tbl;
+		net->dn_tbl = tbl;
 		break;
+#endif
 	}
 }
 EXPORT_SYMBOL(neigh_table_init);
@@ -1642,9 +1640,11 @@ int neigh_table_clear(struct net *net, struct neigh_table *tbl)
 		net->ipv6.nd_tbl = NULL;
 		break;
 #endif
+#if IS_ENABLED(CONFIG_DECNET)
 	case AF_DECnet:
-		neigh_tables[NEIGH_DN_TABLE] = NULL;
+		net->dn_tbl = NULL;
 		break;
+#endif
 	}
 
 	/* It is not clean... Fix it to unload IPv6 module safely */
@@ -1684,9 +1684,11 @@ struct neigh_table *neigh_find_table(struct net *net, u8 family)
 		tbl = net->ipv6.nd_tbl;
 		break;
 #endif
+#if IS_ENABLED(CONFIG_DECNET)
 	case AF_DECnet:
-		tbl = neigh_tables[NEIGH_DN_TABLE];
+		tbl = net->dn_tbl;
 		break;
+#endif
 	}
 
 	return tbl;
@@ -2182,14 +2184,6 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	err = -ENOENT;
-	if (tbl->family == AF_DECnet) {
-		if ((tb[NDTA_THRESH1] || tb[NDTA_THRESH2] ||
-		     tb[NDTA_THRESH3] || tb[NDTA_GC_INTERVAL]) &&
-		    !net_eq(net, &init_net))
-			goto errout_tbl_lock;
-	}
-
 	if (tb[NDTA_THRESH1])
 		tbl->gc_thresh1 = nla_get_u32(tb[NDTA_THRESH1]);
 
-- 
2.11.0
