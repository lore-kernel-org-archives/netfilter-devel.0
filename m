From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 02/17] net/neigh: export neigh_find_table
Date: Tue, 17 Jul 2018 05:06:36 -0700
Message-ID: <20180717120651.15748-3-dsahern@kernel.org>
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

neighbor code already has an API for access to neighbor caches by
address family. Export it for use by networking code. Add the
namespace as an input arg and make family a u8 versus an int (all
existing callers pass ndm_family which is a u8).

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/neighbour.h | 2 ++
 net/core/neighbour.c    | 7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 6c1eecd56a4d..5bc4d79b4b3a 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -229,6 +229,8 @@ enum {
 	NEIGH_LINK_TABLE = NEIGH_NR_TABLES /* Pseudo table for neigh_xmit */
 };
 
+struct neigh_table *neigh_find_table(struct net *net, u8 family);
+
 static inline int neigh_parms_family(struct neigh_parms *p)
 {
 	return p->tbl->family;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index cbe85d8d4cc2..e8630f9de24a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1625,7 +1625,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 }
 EXPORT_SYMBOL(neigh_table_clear);
 
-static struct neigh_table *neigh_find_table(int family)
+struct neigh_table *neigh_find_table(struct net *net, u8 family)
 {
 	struct neigh_table *tbl = NULL;
 
@@ -1643,6 +1643,7 @@ static struct neigh_table *neigh_find_table(int family)
 
 	return tbl;
 }
+EXPORT_SYMBOL(neigh_find_table);
 
 static int neigh_delete(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
@@ -1672,7 +1673,7 @@ static int neigh_delete(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	tbl = neigh_find_table(ndm->ndm_family);
+	tbl = neigh_find_table(net, ndm->ndm_family);
 	if (tbl == NULL)
 		return -EAFNOSUPPORT;
 
@@ -1740,7 +1741,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto out;
 	}
 
-	tbl = neigh_find_table(ndm->ndm_family);
+	tbl = neigh_find_table(net, ndm->ndm_family);
 	if (tbl == NULL)
 		return -EAFNOSUPPORT;
 
-- 
2.11.0
