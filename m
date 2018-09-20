From: dsahern@kernel.org
Subject: [PATCH net-next 2/3] netfilter: rpfilter: Convert rpfilter_lookup_reverse to new dev helper
Date: Thu, 20 Sep 2018 13:50:48 -0700
Message-ID: <20180920205049.15143-3-dsahern@kernel.org>
References: <20180920205049.15143-1-dsahern@kernel.org>
Cc: pablo@netfilter.org, fw@strlen.de, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920205049.15143-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Convert rpfilter_lookup_reverse to the new device checking helper
and remove the duplicate code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 12843c9ef142..0b10d8812828 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -36,7 +36,6 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 				const struct net_device *dev, u8 flags)
 {
 	struct fib_result res;
-	bool dev_match;
 	int ret __maybe_unused;
 
 	if (fib_lookup(net, fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
@@ -46,21 +45,7 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 		if (res.type != RTN_LOCAL || !(flags & XT_RPFILTER_ACCEPT_LOCAL))
 			return false;
 	}
-	dev_match = false;
-#ifdef CONFIG_IP_ROUTE_MULTIPATH
-	for (ret = 0; ret < res.fi->fib_nhs; ret++) {
-		struct fib_nh *nh = &res.fi->fib_nh[ret];
-
-		if (nh->nh_dev == dev) {
-			dev_match = true;
-			break;
-		}
-	}
-#else
-	if (FIB_RES_DEV(res) == dev)
-		dev_match = true;
-#endif
-	return dev_match || flags & XT_RPFILTER_LOOSE;
+	return fib_info_nh_uses_dev(res.fi, dev) || flags & XT_RPFILTER_LOOSE;
 }
 
 static bool
-- 
2.11.0
