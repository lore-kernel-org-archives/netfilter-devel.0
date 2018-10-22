From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] netfilter: xt_nat: fix DNAT target for shifted portmap ranges
Date: Mon, 22 Oct 2018 22:07:22 +0200
Message-ID: <20181022200724.25806-7-pablo@netfilter.org>
References: <20181022200724.25806-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181022200724.25806-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The commit 2eb0f624b709 ("netfilter: add NAT support for shifted
portmap ranges") did not set the checkentry/destroy callbacks for
the newly added DNAT target. As a result, rulesets using only
such nat targets are not effective, as the relevant conntrack hooks
are not enabled.
The above affect also nft_compat rulesets.
Fix the issue adding the missing initializers.

Fixes: 2eb0f624b709 ("netfilter: add NAT support for shifted portmap ranges")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_nat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 8af9707f8789..ac91170fc8c8 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -216,6 +216,8 @@ static struct xt_target xt_nat_target_reg[] __read_mostly = {
 	{
 		.name		= "DNAT",
 		.revision	= 2,
+		.checkentry	= xt_nat_checkentry,
+		.destroy	= xt_nat_destroy,
 		.target		= xt_dnat_target_v2,
 		.targetsize	= sizeof(struct nf_nat_range2),
 		.table		= "nat",
-- 
2.11.0
