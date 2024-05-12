Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F672B9D1;
	Sun, 12 May 2024 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530490; cv=none; b=KZO2+YVnDiTRoTq+XxaW0unTp4c5MvEvhOw7wUdhZMLTRgQLljuhF2m07CY6KGeYvkgy8l8hy1rTDzkpL+rRcoJ1/rwKx4RiXU36Nm82EN+1EXdQdZ5MAUaPTzjq2r88nCHD21RsIoJgcQD1H2HTh7UITU+hOLEJqFD5s2kEcH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530490; c=relaxed/simple;
	bh=DWkXEuvme9ikZHgele9+Sa5L/nbqmEQm5NdeK5JCzeg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OBISw+8Gyv71v40c/ClM0/O8YI2b+GSZcssP022QzAnE5D1X20Olw9J22AKTiB7V2ojmGwvomIt/cYzBtjAWKvz9Gx+l9KnbD3Ijm3PahoyMs7RJuODRnn552cqDWYZiu17hZ2oWuHzV3j58zYv+CXKGdi6nc471YRCyFmoQxHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 01/17] netfilter: nf_tables: skip transaction if update object is not implemented
Date: Sun, 12 May 2024 18:14:20 +0200
Message-Id: <20240512161436.168973-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Turn update into noop as a follow up for:

  9fedd894b4e1 ("netfilter: nf_tables: fix unexpected EOPNOTSUPP error")

instead of adding a transaction object which is simply discarded at a
later stage of the commit protocol.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 167074283ea9..a7f54eb68d9a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7776,6 +7776,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 		if (WARN_ON_ONCE(!type))
 			return -ENOENT;
 
+		if (!obj->ops->update)
+			return 0;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
@@ -9467,9 +9470,10 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	obj = nft_trans_obj(trans);
 	newobj = nft_trans_obj_newobj(trans);
 
-	if (obj->ops->update)
-		obj->ops->update(obj, newobj);
+	if (WARN_ON_ONCE(!obj->ops->update))
+		return;
 
+	obj->ops->update(obj, newobj);
 	nft_obj_destroy(&trans->ctx, newobj);
 }
 
-- 
2.30.2

