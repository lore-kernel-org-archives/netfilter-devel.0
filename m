Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4778F1EB48;
	Thu, 28 Mar 2024 03:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595944; cv=none; b=rLmhsrDSSdJBx82zw0x8LLbtuaiTOvjRe494LsCPQeap1mYsdV9HgESmuiLMlRPHySrR5KfZ7wqIsEiXVBpsPsmvlkxFcMM4HL6F3LeHCVO9LyiT1k0e0czsggIpcP/fgTQq8+e8XczsY0bO6DKtYZNYGcKupSxbXTdQdjQ4j3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595944; c=relaxed/simple;
	bh=9/laNarAMcwdPmjBYXN3/oWkuMl2n4PLzp/notv0Auc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gbX+MXunzLeaW92KWVo/HDVDdDrnMl5y/r1f+gOqvd8IJX/m5kYyHF5/YsMZ1nz/Q3TAzhjVThgtsQAURzif+jQo2lHVZ3eSVja6/MVSX74mHEPPxbXptizzb9S0W3Cj9G/i/rodClP/lrhdnReGGCriiwpT2IX5wr/uPXZQeAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 1/4] netfilter: nf_tables: reject destroy command to remove basechain hooks
Date: Thu, 28 Mar 2024 04:18:52 +0100
Message-Id: <20240328031855.2063-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240328031855.2063-1-pablo@netfilter.org>
References: <20240328031855.2063-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report EOPNOTSUPP if NFT_MSG_DESTROYCHAIN is used to delete hooks in an
existing netdev basechain, thus, only NFT_MSG_DELCHAIN is allowed.

Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa3d3540c93..a1a8030e16a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2944,7 +2944,8 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (nla[NFTA_CHAIN_HOOK]) {
-		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
+		if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN ||
+		    chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			return -EOPNOTSUPP;
 
 		if (nft_is_base_chain(chain)) {
-- 
2.30.2

