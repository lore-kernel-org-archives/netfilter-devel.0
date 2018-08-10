From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/8] netfilter: nft_osf: use NFT_OSF_MAXGENRELEN instead of IFNAMSIZ
Date: Fri, 10 Aug 2018 13:16:15 +0200
Message-ID: <20180810111622.3981-2-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

As no "genre" on pf.os exceed 16 bytes of length, we reduce
NFT_OSF_MAXGENRELEN parameter to 16 bytes and use it instead of IFNAMSIZ.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 1 +
 net/netfilter/nft_osf.c                  | 8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 357862d948de..94657c701f22 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -8,6 +8,7 @@
 #define NFT_SET_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_OBJ_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_USERDATA_MAXLEN	256
+#define NFT_OSF_MAXGENRELEN	16
 
 /**
  * enum nft_registers - nf_tables registers
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 9b2f3de7be4f..5af74b37f423 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -4,8 +4,6 @@
 #include <net/netfilter/nf_tables.h>
 #include <linux/netfilter/nfnetlink_osf.h>
 
-#define OSF_GENRE_SIZE		32
-
 struct nft_osf {
 	enum nft_registers	dreg:8;
 };
@@ -37,9 +35,9 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 	os_name = nf_osf_find(skb, nf_osf_fingers);
 	if (!os_name)
-		strncpy((char *)dest, "unknown", IFNAMSIZ);
+		strncpy((char *)dest, "unknown", NFT_OSF_MAXGENRELEN);
 	else
-		strncpy((char *)dest, os_name, IFNAMSIZ);
+		strncpy((char *)dest, os_name, NFT_OSF_MAXGENRELEN);
 }
 
 static int nft_osf_init(const struct nft_ctx *ctx,
@@ -51,7 +49,7 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 
 	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
 	err = nft_validate_register_store(ctx, priv->dreg, NULL,
-					  NFTA_DATA_VALUE, OSF_GENRE_SIZE);
+					  NFTA_DATA_VALUE, NFT_OSF_MAXGENRELEN);
 	if (err < 0)
 		return err;
 
-- 
2.11.0
