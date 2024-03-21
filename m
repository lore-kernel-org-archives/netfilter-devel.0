Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301DA653
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710980939; cv=none; b=C1zVlFtlpujFv5kZcSmjLYSyfqtlZtoz5KeBQIKuS3cnEJJe+rfSoYycm/pGmWrUvTUk+opDPAZNzazv+pf92fHVfDHNb0d9XJ3qiD/nebz24ihh3hlJyGZBbKvjIGydleUNprO8sljTKs0wFxI3ubg+Gi3P9C3ERuJ2LQTThXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710980939; c=relaxed/simple;
	bh=9/laNarAMcwdPmjBYXN3/oWkuMl2n4PLzp/notv0Auc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=gFoPZI/j7BfMomrp3fUXf1d/i67DZNZF0aV7KwI30QTsv6a9hA5DSNLfJQLTd3pRv56T8hZRuW2As0chbDhfxSSF+MEWkWQ+xdXIT39QhPBARdBSUSV8Vb9bRUcOMyYPWGb7E1ej0YFZakfmQ2qdtlxMF7t10GHyuhw7vVg1QSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/3] netfilter: nf_tables: reject destroy command to remove basechain hooks
Date: Thu, 21 Mar 2024 01:28:51 +0100
Message-Id: <20240321002853.34347-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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

