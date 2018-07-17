From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 01/17] net/ipv4: rename ipv4_neigh_lookup to ipv4_dst_neigh_lookup
Date: Tue, 17 Jul 2018 05:06:35 -0700
Message-ID: <20180717120651.15748-2-dsahern@kernel.org>
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

Consistency with ipv6 name for similar function and allows
ipv4_neigh_lookup to be reused for the wrapper to the arp table.
---
 net/ipv4/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1df6e97106d7..74e1df60ab7f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -153,7 +153,7 @@ static u32 *ipv4_cow_metrics(struct dst_entry *dst, unsigned long old)
 	return NULL;
 }
 
-static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
+static struct neighbour *ipv4_dst_neigh_lookup(const struct dst_entry *dst,
 					   struct sk_buff *skb,
 					   const void *daddr);
 static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr);
@@ -170,7 +170,7 @@ static struct dst_ops ipv4_dst_ops = {
 	.update_pmtu =		ip_rt_update_pmtu,
 	.redirect =		ip_do_redirect,
 	.local_out =		__ip_local_out,
-	.neigh_lookup =		ipv4_neigh_lookup,
+	.neigh_lookup =		ipv4_dst_neigh_lookup,
 	.confirm_neigh =	ipv4_confirm_neigh,
 };
 
@@ -430,7 +430,7 @@ void rt_cache_flush(struct net *net)
 	rt_genid_bump_ipv4(net);
 }
 
-static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
+static struct neighbour *ipv4_dst_neigh_lookup(const struct dst_entry *dst,
 					   struct sk_buff *skb,
 					   const void *daddr)
 {
@@ -2537,7 +2537,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
 	.update_pmtu		=	ipv4_rt_blackhole_update_pmtu,
 	.redirect		=	ipv4_rt_blackhole_redirect,
 	.cow_metrics		=	ipv4_rt_blackhole_cow_metrics,
-	.neigh_lookup		=	ipv4_neigh_lookup,
+	.neigh_lookup		=	ipv4_dst_neigh_lookup,
 };
 
 struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_orig)
-- 
2.11.0
