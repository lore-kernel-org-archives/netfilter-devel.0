Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6761AF0AB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713482; cv=none; b=Atwh+mSe+P34yV1czLrG2zfras56M9Z9urjeBb87AOtS/OxQ9kFlPH6wYz1TgJ1dbmpDXEzfTbIlAZdydRxNIIFgXjsvzFAEn0moGvTopdWU/1v+ua+BSDm8sWk0ffYhgb+6InOra6D/f5uWXHZJx190x8j/CCTtqd1RAUC9gNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713482; c=relaxed/simple;
	bh=OYW2rbxVqkRXC9f7wIfH7w3sTZqlkxAVl8uyDydlt9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8CtEdODq4h7/y/sy6Q+p+5cIPFeTqp5KDifz22drjNpifK6OhQke5KKNPivQ8b5uZNiEw5TFp4lr9WHAsOgsygdgnoKzCXQYIHUdQrQjyGl9rXM3eN6K5g7kPgMTOp/IgV2RDOTentxmdmueg1jaR53ZsdZwFN3zzrWYCvD0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7tdW-0003dR-M8; Mon, 04 Nov 2024 10:44:38 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 7/7] netfilter: nf_tables: must hold rcu read lock while iterating object type list
Date: Mon,  4 Nov 2024 10:41:19 +0100
Message-ID: <20241104094126.16917-8-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241104094126.16917-1-fw@strlen.de>
References: <20241104094126.16917-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update of stateful object triggers:
WARNING: suspicious RCU usage
net/netfilter/nf_tables_api.c:7759 RCU-list traversed in non-reader section!!

other info that might help us debug this:
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/3060:
 #0: ffff88810f0578c8 (&nft_net->commit_mutex){+.+.}-{4:4}, [..]

... but this list is not protected by the transaction mutex but the
nfnl nftables subsystem mutex.

Switch to nft_obj_type_get which will acquire rcu read lock,
bump refcount, and returns the result.

v3: Dan Carpenter points out nft_obj_type_get returns error pointer, not
NULL, on error.

Fixes: dad3bdeef45f ("netfilter: nf_tables: fix memory leak during stateful obj update").
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de8e48a5c62d..b7a817e483aa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7809,9 +7809,7 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err = -ENOMEM;
 
-	if (!try_module_get(type->owner))
-		return -ENOENT;
-
+	/* caller must have obtained type->owner reference. */
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
@@ -7879,15 +7877,16 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		type = __nft_obj_type_get(objtype, family);
-		if (WARN_ON_ONCE(!type))
-			return -ENOENT;
-
 		if (!obj->ops->update)
 			return 0;
 
+		type = nft_obj_type_get(net, objtype, family);
+		if (WARN_ON_ONCE(IS_ERR(type)))
+			return PTR_ERR(type);
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
+		/* type->owner reference is put when transaction object is released. */
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
 	}
 
-- 
2.45.2

