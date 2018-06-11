From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/15] netfilter: xt_set: Check hook mask correctly
Date: Mon, 11 Jun 2018 11:22:25 +0200
Message-ID: <20180611092233.3219-8-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Serhey Popovych <serhe.popovych@gmail.com>

Inserting rule before one with SET target we get error with warning in
dmesg(1) output:

  # iptables -A FORWARD -t mangle -j SET --map-set test src --map-prio
  # iptables -I FORWARD 1 -t mangle -j ACCEPT
  iptables: Invalid argument. Run `dmesg' for more information.
  # dmesg |tail -n1
  [268578.026643] mapping of prio or/and queue is allowed only from \
  OUTPUT/FORWARD/POSTROUTING chains

Rather than checking for supported hook bits for SET target check for
unsupported one as done in all rest of matches and targets.

Signed-off-by: Serhey Popovych <serhe.popovych@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 6f4c5217d835..07af7dbf7a30 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -470,7 +470,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 		}
 		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
 		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
-		     !(par->hook_mask & (1 << NF_INET_FORWARD |
+		     (par->hook_mask & ~(1 << NF_INET_FORWARD |
 					 1 << NF_INET_LOCAL_OUT |
 					 1 << NF_INET_POST_ROUTING))) {
 			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
-- 
2.11.0
