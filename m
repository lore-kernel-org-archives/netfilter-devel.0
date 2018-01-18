From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] netfilter: return booleans instead of integers
Date: Thu, 18 Jan 2018 17:25:12 -0600
Message-ID: <20180118232512.GA22242@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Return statements in functions returning bool should use
true/false instead of 1/0.

These issues were detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 net/netfilter/nf_conncount.c | 2 +-
 net/netfilter/xt_hashlimit.c | 2 +-
 net/netfilter/xt_ipcomp.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index a955182..6d65389 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -71,7 +71,7 @@ static inline bool already_closed(const struct nf_conn *conn)
 		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
 		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
 	else
-		return 0;
+		return false;
 }
 
 static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5da8746..ec51d9a 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -353,7 +353,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 static bool select_all(const struct xt_hashlimit_htable *ht,
 		       const struct dsthash_ent *he)
 {
-	return 1;
+	return true;
 }
 
 static bool select_gc(const struct xt_hashlimit_htable *ht,
diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 000e703..7ca64a5 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -58,7 +58,7 @@ static bool comp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		pr_debug("Dropping evil IPComp tinygram.\n");
 		par->hotdrop = true;
-		return 0;
+		return false;
 	}
 
 	return spi_match(compinfo->spis[0], compinfo->spis[1],
-- 
2.7.4
