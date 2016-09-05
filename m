From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/29] netfilter: physdev: add missed blank
Date: Mon,  5 Sep 2016 12:58:17 +0200
Message-ID: <1473073124-5015-3-git-send-email-pablo@netfilter.org>
References: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1473073124-5015-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_physdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index e5f1898..bb33598 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -107,8 +107,8 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
 	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
-		pr_info("using --physdev-out and --physdev-is-out are only"
-			"supported in the FORWARD and POSTROUTING chains with"
+		pr_info("using --physdev-out and --physdev-is-out are only "
+			"supported in the FORWARD and POSTROUTING chains with "
 			"bridged traffic.\n");
 		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
 			return -EINVAL;
-- 
2.1.4
