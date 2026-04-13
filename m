Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D44395DAA
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Apr 2026 22:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776117886; cv=none; b=ZPkkr8bBCxrx4ceoJG345ho1vsFvgGrZGA0jKlJzkTNEhx0W3R3IFBW/gGilpbbYvTklNSjy6fSL6eE/n9YpLnw7fhg7M8KHWQr2mrsoKbn7yrCuG2pObuYiLVl7ECQ+pGUw2ssa3JKXJ9nNm71RtWaOCYmFq7wDCok06BcBFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776117886; c=relaxed/simple;
	bh=myGCAnQ947Q7XJHtlJIqRHZIv2PGEhV4vTB6DVijQFQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=C2KhBOC6zTFm9Qs3iAhKyCIzANDqNX2z3LYxfnYH0MbWWn2Hc3qyG3vAoxhOOHh7a9I/Uv4jD1FbF2gzYjViS3zaD5KlxwxeGB6K4UiQvBHA+BKW5oss6bRIHWdF9Kf8JqTbIheEVcG/fRaJN4JUEJvEQaaS1EpUwKjnanUhDDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cMGockMK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cMGockMK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8A9CD602B8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 00:04:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776117883;
	bh=RVw9Ez8m0vWE7ARxam1lDv1yAA5RTgkhocNTu5MgrDw=;
	h=From:To:Subject:Date:From;
	b=cMGockMK1K28zu23ZMBLkI8kaK7GmgNEzitaC6L3RGkmg4b16pL5U4eF5lANxKFkn
	 pnk44FvxgATmVJ3T32KcbP0co9d+7hf7GMPDBI5uHGkfaKx9P1wU6jLxYklk7Eu4co
	 mUCXhD/8tlSqfYJTBxpQdI3hi2KNy33EOPdf1eWz0G7aq99jxwJ35nF6b/FhChbqkm
	 1lEMr3FfMckUYAU724p6cGHITdg7tyGugd3HDT+jHcXn4mtOFS3E0DdL3M3fCE+yrQ
	 sMHtIvTGiIfYpDKDz1ASH1MsRYZIJMFZrDp8/S4kapdKuDE6gkacGNaaXFa3RZYyXC
	 CymXDdTLkO42Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Tue, 14 Apr 2026 00:04:38 +0200
Message-ID: <20260413220439.43268-1-pablo@netfilter.org>
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

