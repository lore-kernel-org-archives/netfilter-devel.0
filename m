Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD29F7E2
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2024 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710980941; cv=none; b=AXlUX9COKFCkuPGosxejf4meQHw6VeW4NSuD9UPT+jzT5Hocvmo1/POJMU/paJkMWM//xGRDmS4FOYkBibk5NAU5Qv9Upykua55D4rHs1YtIYQayMF6AdT9RVrYM/2L1AD1kIk0XcGZBb6zqRYfX7XVPmp6qvgYx6XM4IvoNA9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710980941; c=relaxed/simple;
	bh=xnq6PTA782IrkdjaAPoz+sqXtpLSoiYM5pB3COSET54=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZvRDXgh/tIV7GQace6VtwUpvHvIEXqlbc4g94Soxe1ca50W+P4wfOGSY4CiO69mwenaLraPQYxfLKwyfN5snA0F6inYvCdF+fL/49pEID/v+S625dKjWtiKb1bibgTeR1aVSdGSU+1JJrS2zot3sayEQN0YQtSO8KjKDxDCZwRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 3/3] netfilter: nf_tables: skip netdev hook unregistration if table is dormant
Date: Thu, 21 Mar 2024 01:28:53 +0100
Message-Id: <20240321002853.34347-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240321002853.34347-1-pablo@netfilter.org>
References: <20240321002853.34347-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip hook unregistration when adding or deleting devices from an
existing netdev basechain. Otherwise, commit/abort path try to
unregister hooks which not enabled.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Fixes: 7d937b107108 ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 086d85fffeb1..fd86f2720c9e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10212,9 +10212,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			if (nft_trans_chain_update(trans)) {
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
 						       &nft_trans_chain_hooks(trans));
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+					nft_netdev_unregister_hooks(net,
+								    &nft_trans_chain_hooks(trans),
+								    true);
+				}
 			} else {
 				nft_chain_del(trans->ctx.chain);
 				nf_tables_chain_notify(&trans->ctx, NFT_MSG_DELCHAIN,
@@ -10490,9 +10492,11 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				nft_netdev_unregister_hooks(net,
-							    &nft_trans_chain_hooks(trans),
-							    true);
+				if (!(trans->ctx.table->flags & NFT_TABLE_F_DORMANT)) {
+					nft_netdev_unregister_hooks(net,
+								    &nft_trans_chain_hooks(trans),
+								    true);
+				}
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.30.2

