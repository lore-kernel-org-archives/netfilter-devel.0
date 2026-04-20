Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC153AA1BD
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776711163; cv=none; b=Oh1G4jX4wthZUNXIDzLg6p/mccE9SRWb2yAGxgDjvdVRudRzGS9I80+SiIdo1Da6/yABoXKLjCWSpcVF0MfH56X9f1GbKglMCsrvOI3ewz0q9sXrcqs73909LE4Z3DBmtbB3Vf/rzsB4yRvUJEFxpoNt9V9zS06U8p2AVeYGd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776711163; c=relaxed/simple;
	bh=kM5ljjru9azDYxrq9lS9Y73ZLXvtcJN4spjc7MGxsFw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYjEotf68osm8LaHX57Ffofj8ghb9BjuBYy5kBtxQuvjuGTVQZB9pl+s62+f0zVhlr4Xejets4OpgeFseFqtZzLakxT1vm4aJEYvPipSC5uSEA1QLPd2a19IMsfBNrKirmt6If6YXKHSaf0uWbmlNDQpY0sFYp3sp+mmyp7TWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lLj7amZ0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lLj7amZ0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 081CB6026C
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 20:52:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776711160;
	bh=g54BDxik/nnUdQdKUD/4/SZg7GzZrMDx0H8opYzOmiY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lLj7amZ07kBuX8O/8QWfYoL15XbZWxUYkKYJWTLSEq/LUvKcRkVP7kCOj4iwXFrUg
	 wjeaEax261vPcTq32zhlRaRJfwpza7IJdYoAol8pFayg4YG6rZM/SiF8RyMjtrVS3a
	 vMBIURiML41LHQftG9OavsFD8MmfIu2TFt4nJPCub5CwD7RUUM+W/CMknoTsLzpSNP
	 4RxcImF5JPHIsIuX/wB73z37ZrlWffR/3+9nHSx2TayTTAiOaJ+7UzNHY4iTKm6Qja
	 BbsjmwJcauWaPc1cwhR4g2InOtNAkJjs9qIaxLfRYx+ahnIbZC01ip89zUi7Ac21Sh
	 PJF9iiy4bwOhg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v8 3/4] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Mon, 20 Apr 2026 20:52:33 +0200
Message-ID: <20260420185234.23488-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420185234.23488-1-pablo@netfilter.org>
References: <20260420185234.23488-1-pablo@netfilter.org>
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
v8: no changes

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

