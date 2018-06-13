From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: xt_connmark: fix list corruption on rmmod
Date: Wed, 13 Jun 2018 12:56:59 +0200
Message-ID: <20180613105700.12894-9-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This needs to use xt_unregister_targets, else new revision is left
on the list which then causes list to point to a target struct that has been free'd.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 94df000abb92..29c38aa7f726 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -211,7 +211,7 @@ static int __init connmark_mt_init(void)
 static void __exit connmark_mt_exit(void)
 {
 	xt_unregister_match(&connmark_mt_reg);
-	xt_unregister_target(connmark_tg_reg);
+	xt_unregister_targets(connmark_tg_reg, ARRAY_SIZE(connmark_tg_reg));
 }
 
 module_init(connmark_mt_init);
-- 
2.11.0
