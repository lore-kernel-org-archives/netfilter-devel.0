Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07358405C2
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jan 2024 12:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: validate .maxattr at expression registration
Date: Mon,  8 Jan 2024 13:19:09 +0100
Message-Id: <20240108121909.150107-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nft_expr_info allows to store up to NFT_EXPR_MAXATTR (16)
attributes when parsing netlink attributes.

Rise a warning in case there is ever a nft expression whose .maxattr
goes beyond this number of expressions, in such case, struct nft_expr_info
needs to be updated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a926f10db125..95eefb6d7827 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2968,6 +2968,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (WARN_ON_ONCE(type->maxattr > NFT_EXPR_MAXATTR))
+		return -ENOMEM;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
-- 
2.30.2

