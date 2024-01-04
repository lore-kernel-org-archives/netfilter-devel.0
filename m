Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 261C5219E5
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2024 12:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: pass flags to set backend selection routine
Date: Thu,  4 Jan 2024 13:26:09 +0100
Message-Id: <20240104122609.144351-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to refetch the flag from the netlink attribute, pass the
existing flags variable which already provide validated flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ea4cd02adbcf..a926f10db125 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4223,23 +4223,18 @@ static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 flags)
  * given, in that case the amount of memory per element is used.
  */
 static const struct nft_set_ops *
-nft_select_set_ops(const struct nft_ctx *ctx,
-		   const struct nlattr * const nla[],
+nft_select_set_ops(const struct nft_ctx *ctx, u32 flags,
 		   const struct nft_set_desc *desc)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nft_set_ops *ops, *bops;
 	struct nft_set_estimate est, best;
 	const struct nft_set_type *type;
-	u32 flags = 0;
 	int i;
 
 	lockdep_assert_held(&nft_net->commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
 
-	if (nla[NFTA_SET_FLAGS] != NULL)
-		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
-
 	bops	    = NULL;
 	best.size   = ~0;
 	best.lookup = ~0;
@@ -5114,7 +5109,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -ENOENT;
 
-	ops = nft_select_set_ops(&ctx, nla, &desc);
+	ops = nft_select_set_ops(&ctx, flags, &desc);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
-- 
2.30.2

