Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2DC3A75B7
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776273044; cv=none; b=ROgenMN6OBy5DjXyGVHRQyT28TyixX33EkWexSOGGwwn9jVH6Nf625lT/nE5H4I/rCGWMVYjHTCEUnh8R8mzKYj1SHssfAeaDx4AbdAfARNppcZogQuCF5FOXw2hOUOjoeIi5sSD62gs/iSHmhx0o1COtSIV9LYMbFIrQn5VeCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776273044; c=relaxed/simple;
	bh=lmmms9F9hKXxtQq5/IgvrDrITmDAEB1Ql3EbXZ/zR38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oz7WqJehFdHh4x+PzPej7BzED84GhdJd3LlEfC6G5kIQdHO0QJNEmeku8Jn03YJcbuYpdo0TyUWVnoyg0uSWC8K1tFviNB4DifupqlgcueOkEETfe5rSlJNx3eSqlsDLIygndMik9o0Rd9LiCqaup3RxiXQTBNNsCgn2o0DPAIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mevvlUpg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mevvlUpg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E0347600B5;
	Wed, 15 Apr 2026 19:10:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776273042;
	bh=mmJ932xZG47Mi9yqqlqrKBNTWPzT/ghXoz8AY2TrW+Q=;
	h=From:To:Cc:Subject:Date:From;
	b=mevvlUpgxVeNBWVOA7ux3nZBCz46czTQETZy3Rfe5SU6owI++FoGazNlgVrsRXybT
	 MPN9ZXqSMM3smALtKHeijlN6y9E+oH/4CxI7sW7oPJ8i7AWz7FYYs7qyCg1yD52aBh
	 6OK9I9ObK157ZRzJhbbfKcOEjR9HrELu0vI0MRyAX97kSXP9lttS3WccYXZH0e7NUP
	 4v9EdhWq7KdfSkP+gIsgo+8TokODmcQcCoq723r4E+KQwUHVI02ZcTESfwPNItXqfV
	 m2jmPQbbRbn1ykP/qBE2ZZnbV/q9+OMcoq3hDNR/1QslkaKK/zgTlioIq2a0+Qvnhv
	 e9ZoCuWg+FGMw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2 2/3] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Wed, 15 Apr 2026 19:10:37 +0200
Message-ID: <20260415171038.41442-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
v2: no changes, requires list_splice_rcu() in v2

 net/netfilter/nf_tables_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c42247a176c..4d7c2794c87d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10912,8 +10912,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -11042,8 +11042,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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

