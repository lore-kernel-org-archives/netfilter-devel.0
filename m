From: Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH nf] netfilter: nf_tables: check for NULL in
 nf_tables_newchain pcpu stats allocation
Date: Tue, 21 Oct 2014 11:08:21 +0200
Message-ID: <20141021090821.GA31730@kria>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

alloc_percpu returns NULL on failure, not a negative error code.

Fixes: ff3cd7b3c922 ("netfilter: nf_tables: refactor chain statistic routines")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 556a0dfa4abc..eb123676e1ef 100644
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
2.1.2
