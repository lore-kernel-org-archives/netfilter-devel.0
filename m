Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCFE1E2303
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281525; cv=none; b=hRSlOdkaGTLQ0SXd5Ngh/UEjZUCEKjHp2dF47U4DNKptKLl4kcNDt09CMg/q/3GPQiAo2+w4I/+wkFGt0920HiT56yB/P25BElVIFWlXLuiH8EF/nxl1RjpNaSlXEtJY0RMUzGHBd5oG2DCuFT/dnn4y0elzmxRm5oUKKWCdKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281525; c=relaxed/simple;
	bh=5x5fWA6I+1qRC/vPvnJBV8LfdILyhe9P0TtJ60z1QBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW8z8pluBKayMu85va55F0rEKAwLsyLn8gy8VMVA8yCB5wJXBRxW0LEw3O521JfNJcEykcJOtJeK1q38o1s+Zli5+mc0W3rMLQcLSZaz0teMj94lNYL5b2P3m/HSBiWqTsDYz4jBXZgjuL5sxTXMWhZU12fdkO58YUcaxVYn6CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t65GT-0000mB-Dq; Wed, 30 Oct 2024 10:45:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 5/7] netfilter: nf_tables: avoid false-positive lockdep splats with basechain hook
Date: Wed, 30 Oct 2024 10:40:42 +0100
Message-ID: <20241030094053.13118-6-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241030094053.13118-1-fw@strlen.de>
References: <20241030094053.13118-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like previous patches: iteration is ok if the list cannot be altered in
parallel.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: fix typo in commit message.

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
2.45.2

