Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1173B47EE;
	Fri, 17 Apr 2026 09:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776418793; cv=none; b=EDZ0Lu6DLMqaIHdUmZiNVGyCKkq1MsXZbn8ro7CKdHVMX6Onf0Tnf+vstnydvQX9uD2vSOBVESImL3XDTXqBtO/gIF3D24HoZd4TJd+8IRTpmNLt65l5aeUOkXCMU6mWx0F6noqqsmstYiL9IgaMAZA9PHf+ynq8H2yJDtXs+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776418793; c=relaxed/simple;
	bh=wB4qv5YIfRTiInJT4o8qTb8PzG24AQJUidrfK4BhjrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P78o3BLj01iHO7N1NTRspaZ9HFsum9NmcNFNrkpTIZNSOwxpb3MJyGMG+IdxRTy4236jFH/0KK9yk6x+Px3sZhzuCBBGDEPaIp4xqJVDGtJb2SULNVMlu+6+7QzRuNYLkEw6BCvu09Tz79uhH8FiwnB5uftEkYVmeEOu/u0Io64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d6P+r4Yg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d6P+r4Yg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 44BCD6017A;
	Fri, 17 Apr 2026 11:39:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776418790;
	bh=Np6fHHXCxOUJCg+199qhW2D0jKUlZwiAjxuyC1lumCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6P+r4YgHB+uLpFJbUzTi+uln17Iqt2FhNeuGsU3HlVcNRCcGklATZH8p8AkMexD7
	 qTvaFCt1QGU1X2SpYGy0A/nMWXA6SAs2RyKGFXlBDD/16ODtTjoo+JTzRBwPfID58+
	 u5bIpQkLsopdBuQLIuvq/VRxPb2XcPZdU+mjYvT9oaDN11YR2Q4GSpuP/FIyiggCv2
	 A8AWPnzLea7/FRstZ2ovv1MwqHYI6pimk8g3ZeD0fZCrHBCu4BWxCu7NW29xK4n0hV
	 qsOZ+vbU5O0arlwWphwCQgrBFMETRqcczj+UAxcxsD3topRUWFszVIOfjiN/zT8VyY
	 L2mAut8+qsqtg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH nf,v6 3/4] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Fri, 17 Apr 2026 11:39:41 +0200
Message-ID: <20260417093942.373885-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417093942.373885-1-pablo@netfilter.org>
References: <20260417093942.373885-1-pablo@netfilter.org>
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
v3: just a rebase on top of net-next, net is still behind.

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

