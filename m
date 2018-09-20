From: dsahern@kernel.org
Subject: [PATCH net-next 3/3] netfilter: nft_fib: Convert nft_fib4_eval to new dev helper
Date: Thu, 20 Sep 2018 13:50:49 -0700
Message-ID: <20180920205049.15143-4-dsahern@kernel.org>
References: <20180920205049.15143-1-dsahern@kernel.org>
Cc: pablo@netfilter.org, fw@strlen.de, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920205049.15143-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Convert nft_fib4_eval to the new device checking helper and
remove the duplicate code.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index e50976e3c213..94eb25bc8d7e 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -76,10 +76,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi4_iif = LOOPBACK_IFINDEX,
 	};
 	const struct net_device *oif;
-	struct net_device *found;
-#ifdef CONFIG_IP_ROUTE_MULTIPATH
-	int i;
-#endif
+	const struct net_device *found;
 
 	/*
 	 * Do not set flowi4_oif, it restricts results (for example, asking
@@ -146,25 +143,13 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
        if (!oif) {
                found = FIB_RES_DEV(res);
-               goto ok;
-       }
-
-#ifdef CONFIG_IP_ROUTE_MULTIPATH
-	for (i = 0; i < res.fi->fib_nhs; i++) {
-		struct fib_nh *nh = &res.fi->fib_nh[i];
+	} else {
+		if (!fib_info_nh_uses_dev(res.fi, oif))
+			return;
 
-		if (nh->nh_dev == oif) {
-			found = nh->nh_dev;
-			goto ok;
-		}
+		found = oif;
 	}
-	return;
-#else
-	found = FIB_RES_DEV(res);
-	if (found != oif)
-		return;
-#endif
-ok:
+
 	switch (priv->result) {
 	case NFT_FIB_RESULT_OIF:
 		*dest = found->ifindex;
-- 
2.11.0
