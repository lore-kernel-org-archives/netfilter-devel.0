Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED604D98E9
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2026 11:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780660045; cv=none; b=LkxQU+IjXSeoa87+cTizfvmCqk+9reyNP1d8Sewu0pexRe7f6NN2HJqg7QcTmv8hNpxoOyriXVo88S263wD/3zfRRMOtm2JdhLJ2Yb7v9wJ+zyxxMQIhY6BPUDeQNmxzn0BdbwNVg7KPc9Vw4jb7to/3Md2Ho1bvQQ4F/WpQeMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780660045; c=relaxed/simple;
	bh=nxadXzNo3BTpPHVPs90Z9t5gyVVwnMTxf4Eoo5S+rl0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bNTGXz+kBcdR5OZHA9mdVXBYONYm8INb195exb16h0Ib8n7/77lDOw2n+nM60i/ZPRohgjJsxBeD0jAKtw08phMDR2jSW5o/8c+LWITMqAyxCwQkbp+iTe62wjanG+8j8SIK4RsnDxkgckbyIr61wWqpvv/oJil162ugFzHtTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADD6060425; Fri, 05 Jun 2026 13:47:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH 1/1] netfilter: nf_tables_offload: drop device refcount on error
Date: Fri,  5 Jun 2026 13:47:12 +0200
Message-ID: <20260605114715.11297-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported by sashiko:
If nft_flow_action_entry_next() returns NULL, dev reference leaks.

Fixes: c6f85577584b ("netfilter: nf_tables_offload: add nft_flow_action_entry_next() and use it")
Reported-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_dup_netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index 3b0a70e154cd..3d88ef927f31 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -74,16 +74,18 @@ int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 	struct flow_action_entry *entry;
 	struct net_device *dev;
 
-	/* nft_flow_rule_destroy() releases the reference on this device. */
 	dev = dev_get_by_index(ctx->net, oif);
 	if (!dev)
 		return -EOPNOTSUPP;
 
 	entry = nft_flow_action_entry_next(ctx, flow);
-	if (!entry)
+	if (!entry) {
+		dev_put(dev);
 		return -E2BIG;
+	}
 
 	entry->id = id;
+	/* nft_flow_rule_destroy() releases the reference on this device. */
 	entry->dev = dev;
 
 	return 0;
-- 
2.53.0

