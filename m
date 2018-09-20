From: dsahern@kernel.org
Subject: [PATCH net-next 1/3] net/ipv4: Move device validation to helper
Date: Thu, 20 Sep 2018 13:50:47 -0700
Message-ID: <20180920205049.15143-2-dsahern@kernel.org>
References: <20180920205049.15143-1-dsahern@kernel.org>
Cc: pablo@netfilter.org, fw@strlen.de, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920205049.15143-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the device matching check in __fib_validate_source to a helper and
export it for use by netfilter modules. Code move only; no functional
change intended.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h    |  1 +
 net/ipv4/fib_frontend.c | 44 +++++++++++++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 69c91d1934c1..f7c109e37298 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -373,6 +373,7 @@ static inline bool fib4_rules_early_flow_dissect(struct net *net,
 extern const struct nla_policy rtm_ipv4_policy[];
 void ip_fib_init(void);
 __be32 fib_compute_spec_dst(struct sk_buff *skb);
+bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev);
 int fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 			u8 tos, int oif, struct net_device *dev,
 			struct in_device *idev, u32 *itag);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 2998b0e47d4b..222b968de94c 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -315,6 +315,32 @@ __be32 fib_compute_spec_dst(struct sk_buff *skb)
 	return inet_select_addr(dev, ip_hdr(skb)->saddr, scope);
 }
 
+bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
+{
+	bool dev_match = false;
+	int ret;
+
+#ifdef CONFIG_IP_ROUTE_MULTIPATH
+	for (ret = 0; ret < fi->fib_nhs; ret++) {
+		struct fib_nh *nh = &fi->fib_nh[ret];
+
+		if (nh->nh_dev == dev) {
+			dev_match = true;
+			break;
+		} else if (l3mdev_master_ifindex_rcu(nh->nh_dev) == dev->ifindex) {
+			dev_match = true;
+			break;
+		}
+	}
+#else
+	if (fi->fib_nh[0].nh_dev == dev)
+		dev_match = true;
+#endif
+
+	return dev_match;
+}
+EXPORT_SYMBOL_GPL(fib_info_nh_uses_dev);
+
 /* Given (packet source, input interface) and optional (dst, oif, tos):
  * - (main) check, that source is valid i.e. not broadcast or our local
  *   address.
@@ -361,24 +387,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	    (res.type != RTN_LOCAL || !IN_DEV_ACCEPT_LOCAL(idev)))
 		goto e_inval;
 	fib_combine_itag(itag, &res);
-	dev_match = false;
-
-#ifdef CONFIG_IP_ROUTE_MULTIPATH
-	for (ret = 0; ret < res.fi->fib_nhs; ret++) {
-		struct fib_nh *nh = &res.fi->fib_nh[ret];
 
-		if (nh->nh_dev == dev) {
-			dev_match = true;
-			break;
-		} else if (l3mdev_master_ifindex_rcu(nh->nh_dev) == dev->ifindex) {
-			dev_match = true;
-			break;
-		}
-	}
-#else
-	if (FIB_RES_DEV(res) == dev)
-		dev_match = true;
-#endif
+	dev_match = fib_info_nh_uses_dev(res.fi, dev);
 	if (dev_match) {
 		ret = FIB_RES_NH(res).nh_scope >= RT_SCOPE_HOST;
 		return ret;
-- 
2.11.0
