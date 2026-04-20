Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40A52C027A
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776665975; cv=none; b=Nh5NLRQPavNsX8FyV+YOhKIGmuy6Hc7CoeqHXff6tsHnT3g1CqNtzxTfTZawIDcAeuPEinVs4pelOX7ENulrUs9M0JgcDfPbF8CeI7NcARMdoZZQRbL6lXPenyCydtQUmS9I/vCWdySpSjC9VdiSlKwmgsV+32YplGxtuLCsDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776665975; c=relaxed/simple;
	bh=/ISfDvQ6Ziwxxnw2RwrHn4iWRttkkq+owJBmFm8DZAw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmIhWzLna6K9P+/BC6B3TKNUHTY4SPp+llkTEgNVtyINFf2PGwDXbXz6H80p9Y+9A0QfTM21nHqwV8iNoflmqboaxBLlsQTITqSmg9fu0P83geneoAXUapvcXp0ifyP5Z4dfjFnZEca+fL8HJaiU120az3s95LkZ4UrP/6NULVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p+LKtXLl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p+LKtXLl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E767602B2
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 08:19:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776665972;
	bh=aJXCJapzwqFT+lx7dDN5kZ7VyZWMoGu7cjrH+fjFC18=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p+LKtXLlg9rm+V6sQwEQfYHyV5Ff1cRPXxMsfyG2E2gXFcFVmGumcXgOURY36RyjY
	 m4s93SCnsjYjzJHeXuFEg5HFLIw0SdBSR/iF2wT50qDTRf6eD6ZNWnexz5dgC80a2g
	 HA8dc01bBBpieY3Hg4YzC4i1QunmW6j+aFZkPCBxcIYJVTtywKm2XolIQQcO38Fsop
	 X5x7PbcpvEDloAx8rzqVozcj4XD+WzI2hkqptxIecrg9EJXnWhEY1QJGelkiYWrTw2
	 W7Q+rJ6Ke34ZL74ZtPmUj0f2M4nydo+ih4nB2346FmmJaBaiakQAdPvlp4cIpUUVoT
	 LszOQJWG6sZPg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 3/4] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Mon, 20 Apr 2026 08:19:23 +0200
Message-ID: <20260420061924.69302-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420061924.69302-1-pablo@netfilter.org>
References: <20260420061924.69302-1-pablo@netfilter.org>
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

