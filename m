From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8] netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats allocation
Date: Mon, 27 Oct 2014 22:38:02 +0100
Message-ID: <1414445887-5108-4-git-send-email-pablo@netfilter.org>
References: <1414445887-5108-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1414445887-5108-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

alloc_percpu returns NULL on failure, not a negative error code.

Fixes: ff3cd7b3c922 ("netfilter: nf_tables: refactor chain statistic routines")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65eb2a1..11ab4b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1328,10 +1328,10 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			basechain->stats = stats;
 		} else {
 			stats = netdev_alloc_pcpu_stats(struct nft_stats);
-			if (IS_ERR(stats)) {
+			if (stats == NULL) {
 				module_put(type->owner);
 				kfree(basechain);
-				return PTR_ERR(stats);
+				return -ENOMEM;
 			}
 			rcu_assign_pointer(basechain->stats, stats);
 		}
-- 
1.7.10.4
