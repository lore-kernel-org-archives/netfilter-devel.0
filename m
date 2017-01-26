From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/14] netfilter: nf_tables: bump set->ndeact on set flush
Date: Thu, 26 Jan 2017 17:38:07 +0100
Message-ID: <1485448687-6072-15-git-send-email-pablo@netfilter.org>
References: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add missing set->ndeact update on each deactivated element from the set
flush path. Otherwise, sets with fixed size break after flush since
accounting breaks.

 # nft add set x y { type ipv4_addr\; size 2\; }
 # nft add element x y { 1.1.1.1 }
 # nft add element x y { 1.1.1.2 }
 # nft flush set x y
 # nft add element x y { 1.1.1.1 }
 <cmdline>:1:1-28: Error: Could not process rule: Too many open files in system

Fixes: 8411b6442e59 ("netfilter: nf_tables: support for set flushing")
Reported-by: Elise Lennion <elise.lennion@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5bd0068320fb..1b913760f205 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3906,6 +3906,7 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 		err = -ENOENT;
 		goto err1;
 	}
+	set->ndeact++;
 
 	nft_trans_elem_set(trans) = set;
 	nft_trans_elem(trans) = *elem;
-- 
2.1.4
