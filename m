Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA53FA5C3;
	Fri, 24 Apr 2026 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057551; cv=none; b=Tyb83myCP2BW+ofAo3Hk5jxUGa9EYBzcc0ThJEplX8sN5To7DfCo5UlBOjVJVCpMS2iEdTEmG4cbTplsc1Det8JNl4LmpMbla+ZBrWpmidb1uziygngJQWdGQhLt+833yc9LMIWuRyJY2cdhHCKoYq8WLDuqkgCPGvl7c0Frric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057551; c=relaxed/simple;
	bh=/ISfDvQ6Ziwxxnw2RwrHn4iWRttkkq+owJBmFm8DZAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKjXdXI7ssUmhH9mJKCukQ3zzrOXcE7i4SIjc6Xv1UanQsI3c8E5yVvkQIV2rIhjPELZhSfFGyfPlWp1+LWLaWQfHB/tMHTgh6eYW0nYdw3dLB99lPBW8R3r4V5B0WS+X2CtWCMgfyPxm57LcrLmcCe17nJ2E9at+escLaGPbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Nz43cFf+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Nz43cFf+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E95B460285;
	Fri, 24 Apr 2026 21:05:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777057548;
	bh=aJXCJapzwqFT+lx7dDN5kZ7VyZWMoGu7cjrH+fjFC18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz43cFf+iRZdTGB3PQtWyAqYioU13wALPBKEjwM4YRrUGc9j7UFmjQ0HyHbpWk5ze
	 BVHIIOINQYW5ldCTtKE4HPxjmu3/oDzqe4StLzmJBwV9LqCUkuVpCmBGZcbt/fi3zJ
	 +xnWapZF0ppSuEjXj6wUAS4wW3rJOH5MLqdqwHxfD5UcWzNv5j5gFXYCiyuVLIpdSi
	 5vHMUOX7XW8e6gQ7Vxdt58RYcjWRRg7dXgbhkTy5CXgy7Fxd3snANk9o/uVcIvfNCH
	 nzfQC0uWa+h0h01jNRxSmP1hpEkqWXDzMGlweXENyZFsWf7Uul/zoEZqds1za8GWSG
	 DXkRz2J+r9/gw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/11] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Fri, 24 Apr 2026 21:05:06 +0200
Message-ID: <20260424190513.32823-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260424190513.32823-1-pablo@netfilter.org>
References: <20260424190513.32823-1-pablo@netfilter.org>
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

