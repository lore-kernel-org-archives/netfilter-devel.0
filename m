Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ED93CEBB7;
	Thu, 16 Apr 2026 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345319; cv=none; b=CtjgqATuS2KMWoUtYEgQxrcRMqi8rYQWfqjx7du0GEYUs9mTMt4AcyV5mPX0DX/5rttJB0kAGFA6HgbXjMka9OvMog1XtXH23W4i/S3iLwqDlIeSru5KT3UB1Zk7Pvg6RxNhDb+Gb5vZCvUvLPozW+8OX+JNfJTrHtRaRmYtWF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345319; c=relaxed/simple;
	bh=2efQzCiXJ2Wli7t6Ka/6/L85zMRoJKZJe6aw1Fet5zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqOgdRFn7LYzmYby7u8RwTEiENDPwVbDSE46GqnscZZgUeFvNXK9zx4pZeRFYhZHsjMGTE1+x6FONPzLi0Djcu+WQJqlWXtUwFRpmtvr2QzpH06d43JhBWC0cPpnrlsX7CVi9jq4389bmQWg66bZjRlK+4JWDhDgfAuCA9HceMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fyQd5E7A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fyQd5E7A"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C3D3960262;
	Thu, 16 Apr 2026 15:15:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345316;
	bh=7UGc+WvpSbrw5BeuDggd8MZE8BV2R6UfQGJ2bjLPyRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyQd5E7A0pF/xC+Ck6UCpFefucdrp0sIxMZijVAk+AFRy7aPj5rXQYHSJtKqS2Q2D
	 AL3ejfBhtdO8Sn/BDPdjgxkgJ296Rj/Z7aS7wRMfbSuzFh94f0CRpmFCYKJLsNQuNF
	 og9ADkcQmgl4VQuj60Oue3rvAsLqgjf4xM+Rg560SadGGqHV9BjdqtMQCySAyPApvN
	 Z6tTOCSu9mVTNT4BekoabGlp3SD2PhwCbk++c5qXQWXZNaul5KL3DlHcoBuNDb0Ent
	 iEQYrt0tbdp5MczIOBUtugBy73MUwnkPCBqcuqsTmYcVdvf44iTDSKXA4RjzrhEgBZ
	 TT3cqFY46Stiw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/11] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Thu, 16 Apr 2026 15:14:53 +0200
Message-ID: <20260416131453.308611-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
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
index 090d4d688a33..8c0706d6d887 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10904,8 +10904,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -11034,8 +11034,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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

