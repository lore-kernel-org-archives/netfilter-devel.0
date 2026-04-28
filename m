Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FED3E1214;
	Tue, 28 Apr 2026 09:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370335; cv=none; b=pl5YnwCrJOLpdQEdNhh8TvRg5FJOJl9v2dTpv2fQs8E6KKPxvgq5/oHeGnZIvguoiLllFSqCvXjQ5cgM1Z1VVN0LoqTJAlkjt7hdhkr0thlKttf+EX26ZLWJ9U8ONEoAU70NWvxtqAU1SIiyqKKrl5dQPh2rga9rr1JvTBJAnlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370335; c=relaxed/simple;
	bh=/ISfDvQ6Ziwxxnw2RwrHn4iWRttkkq+owJBmFm8DZAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJAt3Mb2ufOzbE2vTPDmY5M0hmVA+YcUo+ko8wHwpeAjV+S1k4OZo62Qr9MCXXu1PNHgw/BVpkF3h2LbikuuCIfXilZaxa8Pd66kweyoLjKxwxW2oNRWGRw85KnyU6u0ramt9uSeRP72WwQjAGxH92ZtM/rsMqrTBNDYt/a8Qos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ARG0gjV3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ARG0gjV3"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6481A60251;
	Tue, 28 Apr 2026 11:58:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777370331;
	bh=aJXCJapzwqFT+lx7dDN5kZ7VyZWMoGu7cjrH+fjFC18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARG0gjV3FBG3MWKZJvqyCk3YUbid6ZRhgS+USUkf8HPNFe/yNKY2kc6awUy5EYelX
	 0InksQ/0qeH+6V6rwpJPdJt8e/w/ee8yOxfHtBcfG3Bhf0Uqc98mHFav2cap/xur9X
	 18AWBIXTPBuRAO9taxgmAmQ56wzNCJ8OuHUrGm0D7J4FDggm7yZ5C9ig+aZIoNJoA7
	 egPzYQUzaZddHGYeBeQ7W/KsyEMY5L+MqRu2JHXyify1zf7tTfmpKMwlXYJKb0qQ2G
	 Ys3Jk14tffgO4kyupBJ1yzNNRr6MBDyzpASdhWneafZQr2ZyePU/0/CLFZ7sGSoY2r
	 SJPlg4DxR0FxQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/8] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Tue, 28 Apr 2026 11:58:35 +0200
Message-ID: <20260428095840.51961-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428095840.51961-1-pablo@netfilter.org>
References: <20260428095840.51961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Publish new hooks in the list into the basechain/flowtable using
splice_list_rcu() to ensure netlink dump list traversal via rcu is safe
while concurrent ruleset update is going on.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 07e151245765..ae10116af923 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10838,8 +10838,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_chain_commit_update(nft_trans_container_chain(trans));
 				nf_tables_chain_notify(&ctx, NFT_MSG_NEWCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				list_splice(&nft_trans_chain_hooks(trans),
-					    &nft_trans_basechain(trans)->hook_list);
+				list_splice_rcu(&nft_trans_chain_hooks(trans),
+						&nft_trans_basechain(trans)->hook_list);
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(nft_trans_container_chain(trans));
@@ -10968,8 +10968,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
 							   NFT_MSG_NEWFLOWTABLE);
-				list_splice(&nft_trans_flowtable_hooks(trans),
-					    &nft_trans_flowtable(trans)->hook_list);
+				list_splice_rcu(&nft_trans_flowtable_hooks(trans),
+						&nft_trans_flowtable(trans)->hook_list);
 			} else {
 				nft_clear(net, nft_trans_flowtable(trans));
 				nf_tables_flowtable_notify(&ctx,
-- 
2.47.3

