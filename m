Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DAA320EA31;
	Wed,  6 Nov 2024 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936807; cv=none; b=r86puge58nwPeLBgt3qHi50eub+MZVrsa4qb60NMe55VNukuhMu2PLv9z7ADRzUT7EIJK74S3zJDXBqBDDiC6g8jN7X6UXMp3NFymQM8mOd2tWxiFEDPE+9ly8YxbiQnjuFpnDSHYLW90Z6I8YqlxDFvWkFe/n7/eNukhoiY3Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936807; c=relaxed/simple;
	bh=OfBWn8HDCwt1SlJlN3BvfpDNoylz21tgqsWLEyfCJys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MQzauo6vNeppU0PdYUjwK+rK8BkxAlWT0oRV8l62vv+o9gIX9TaPjcbQlRUADGVq54Le+v5mm0VUPLA3pzNugw9WobpxHPO9OlfTHXsPXrS47Zu/tXmpuRq/61vu2iHPBtsG7ovIUgx3aArC7VrLic+B5BfzACRmDXEEmHE5eZQ=
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
	fw@strlen.de
Subject: [PATCH net-next 09/11] netfilter: nf_tables: avoid false-positive lockdep splats with basechain hook
Date: Thu,  7 Nov 2024 00:46:23 +0100
Message-Id: <20241106234625.168468-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Like previous patches: iteration is ok if the list cannot be altered in
parallel.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9e367e134691..3b5154f2dd79 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1824,7 +1824,8 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	return -ENOSPC;
 }
 
-static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
+static int nft_dump_basechain_hook(struct sk_buff *skb,
+				   const struct net *net, int family,
 				   const struct nft_base_chain *basechain,
 				   const struct list_head *hook_list)
 {
@@ -1849,7 +1850,8 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 		if (!hook_list)
 			hook_list = &basechain->hook_list;
 
-		list_for_each_entry_rcu(hook, hook_list, list) {
+		list_for_each_entry_rcu(hook, hook_list, list,
+					lockdep_commit_lock_is_held(net)) {
 			if (!first)
 				first = hook;
 
@@ -1900,7 +1902,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
 
-		if (nft_dump_basechain_hook(skb, family, basechain, hook_list))
+		if (nft_dump_basechain_hook(skb, net, family, basechain, hook_list))
 			goto nla_put_failure;
 
 		if (nla_put_be32(skb, NFTA_CHAIN_POLICY,
-- 
2.30.2

