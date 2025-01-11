Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06861CFBC;
	Sat, 11 Jan 2025 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736636890; cv=none; b=uSocqzRBwuHwOY8TJqxcs8AR925B2/oXP75YfZSqZE0VlsW+sxXpbKOGTsOmf9d/c344iQwU+11Ro9ehSrvlu5DgE+JIPQIBUOvwGBhqwDWEC4/gfWct6++43i6Z7RhAS8AwI8rtup76gf69xLkS9+ag4JWcSfY1lM52o82wb70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736636890; c=relaxed/simple;
	bh=92EaKkeevPv19MH0eBUuD5KCmOqEQ8K6HwML4uHUX1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DsoUfGIqHs1J3YWCr8/AVTVJGlnfb18NharXIMiaSwwdjUMipO0m5FCWonOtdktZZ4UM1X5ayeAgo/jdEE6vgQpVRu7yb99oHUny8jhk57qcsf9KgaTxMSEGRmGG7G3WbQ6K5dM3EyXM1Uu+Y42azxajHqlhfIJ+Clx02GVnu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net-next 1/4] netfilter: nf_tables: remove the genmask parameter
Date: Sun, 12 Jan 2025 00:07:57 +0100
Message-Id: <20250111230800.67349-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250111230800.67349-1-pablo@netfilter.org>
References: <20250111230800.67349-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: tuqiang <tu.qiang35@zte.com.cn>

The genmask parameter is not used within the nf_tables_addchain function
 body. It should be removed to simplify the function parameter list.

Signed-off-by: tuqiang <tu.qiang35@zte.com.cn>
Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0b9f1e8dfe49..f7ca7165e66e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2598,9 +2598,8 @@ int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 
 static u64 chain_id;
 
-static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
-			      u8 policy, u32 flags,
-			      struct netlink_ext_ack *extack)
+static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 policy,
+			      u32 flags, struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_table *table = ctx->table;
@@ -3038,7 +3037,7 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 					  extack);
 	}
 
-	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
+	return nf_tables_addchain(&ctx, family, policy, flags, extack);
 }
 
 static int nft_delchain_hook(struct nft_ctx *ctx,
-- 
2.30.2

