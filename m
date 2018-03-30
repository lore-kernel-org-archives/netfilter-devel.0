From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/47] netfilter: ebtables: Add string filter
Date: Fri, 30 Mar 2018 13:44:57 +0200
Message-ID: <20180330114509.18738-6-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Bernie Harris <bernie.harris@alliedtelesis.co.nz>

This patch is part of a proposal to add a string filter to
ebtables, which would be similar to the string filter in
iptables. Like iptables, the ebtables filter uses the xt_string
module.

Signed-off-by: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_string.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 423293ee57c2..be1feddadcf0 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -21,6 +21,7 @@ MODULE_DESCRIPTION("Xtables: string-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
+MODULE_ALIAS("ebt_string");
 
 static bool
 string_mt(const struct sk_buff *skb, struct xt_action_param *par)
-- 
2.11.0
