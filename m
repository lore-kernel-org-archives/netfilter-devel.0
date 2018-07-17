From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 17/17] net/neighbor: Remove neigh_tables and NEIGH enum
Date: Tue, 17 Jul 2018 05:06:51 -0700
Message-ID: <20180717120651.15748-18-dsahern@kernel.org>
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

No longer used.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/neighbour.h | 8 --------
 net/core/neighbour.c    | 2 --
 2 files changed, 10 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index e968db1b7742..72002a24e72e 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -222,14 +222,6 @@ struct neigh_table {
 	struct pneigh_entry	**phash_buckets;
 };
 
-enum {
-	NEIGH_ARP_TABLE = 0,
-	NEIGH_ND_TABLE = 1,
-	NEIGH_DN_TABLE = 2,
-	NEIGH_NR_TABLES,
-	NEIGH_LINK_TABLE = NEIGH_NR_TABLES /* Pseudo table for neigh_xmit */
-};
-
 struct neigh_table *neigh_find_table(struct net *net, u8 family);
 
 static inline int neigh_parms_family(struct neigh_parms *p)
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 1bb7fa14cb62..7c3d4cb811d3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1559,8 +1559,6 @@ static void neigh_parms_destroy(struct neigh_parms *parms)
 
 static struct lock_class_key neigh_table_proxy_queue_class;
 
-static struct neigh_table *neigh_tables[NEIGH_NR_TABLES] __read_mostly;
-
 void neigh_table_init(struct net *net, struct neigh_table *tbl)
 {
 	unsigned long now = jiffies;
-- 
2.11.0
