From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/16] netfilter: xt_hashlimit: fix a possible memory leak in htable_create()
Date: Wed, 28 Nov 2018 11:17:34 +0100
Message-ID: <20181128101741.20924-10-pablo@netfilter.org>
References: <20181128101741.20924-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128101741.20924-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

In the htable_create(), hinfo is allocated by vmalloc()
So that if error occurred, hinfo should be freed.

Fixes: 11d5f15723c9 ("netfilter: xt_hashlimit: Create revision 2 to support higher pps rates")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 3e7d259e5d8d..1ad4017f9b73 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -295,9 +295,10 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 
 	/* copy match config into hashtable config */
 	ret = cfg_copy(&hinfo->cfg, (void *)cfg, 3);
-
-	if (ret)
+	if (ret) {
+		vfree(hinfo);
 		return ret;
+	}
 
 	hinfo->cfg.size = size;
 	if (hinfo->cfg.max == 0)
@@ -814,7 +815,6 @@ hashlimit_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	int ret;
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 1);
-
 	if (ret)
 		return ret;
 
@@ -830,7 +830,6 @@ hashlimit_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
 	int ret;
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 2);
-
 	if (ret)
 		return ret;
 
@@ -921,7 +920,6 @@ static int hashlimit_mt_check_v1(const struct xt_mtchk_param *par)
 		return ret;
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 1);
-
 	if (ret)
 		return ret;
 
@@ -940,7 +938,6 @@ static int hashlimit_mt_check_v2(const struct xt_mtchk_param *par)
 		return ret;
 
 	ret = cfg_copy(&cfg, (void *)&info->cfg, 2);
-
 	if (ret)
 		return ret;
 
-- 
2.11.0
