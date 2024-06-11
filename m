Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335B94594C;
	Tue, 11 Jun 2024 22:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143411; cv=none; b=oTlRbLp41CCFzBK8aQS4eSqxjvKBYBGW22uGuTqtRu3u4y8SfvvX5Vg/EbbXyw4k5GVt+ZtMySM3KgoV3PJ8A3d6ola6Ds3QeGg3HyiuiR/MuhKlYM6YGneECuE3eGZ5pdEyNZHKblP8ehk2QilgihWfGCzTvNikr5ZcSm4mZSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143411; c=relaxed/simple;
	bh=e4Tz2z1xQQrfnYbVXk9VLvbPCDlDfZzGESORDBwJt4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bvfxyBSgloWq7K1SLzkCvaGG84RCCz06bRWRFVCVTTVPii9RexlNnttuCF30N+1rnSZmie/1uBxfOgvnntgKUp3xnbPX8jCw6OYFYhECkFtgawIM/Gg3yT/rPKOzxCr3zUENcSNkkjFST+ExpDkKn+kom+iisnDo29shUe3ju0I=
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
Subject: [PATCH net 1/3] netfilter: nft_inner: validate mandatory meta and payload
Date: Wed, 12 Jun 2024 00:03:21 +0200
Message-Id: <20240611220323.413713-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240611220323.413713-1-pablo@netfilter.org>
References: <20240611220323.413713-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Davide Ornaghi <d.ornaghi97@gmail.com>

Check for mandatory netlink attributes in payload and meta expression
when used embedded from the inner expression, otherwise NULL pointer
dereference is possible from userspace.

Fixes: a150d122b6bd ("netfilter: nft_meta: add inner match support")
Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c    | 3 +++
 net/netfilter/nft_payload.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index ba0d3683a45d..9139ce38ea7b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -839,6 +839,9 @@ static int nft_meta_inner_init(const struct nft_ctx *ctx,
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int len;
 
+	if (!tb[NFTA_META_KEY] || !tb[NFTA_META_DREG])
+		return -EINVAL;
+
 	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 0c43d748e23a..50429cbd42da 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -650,6 +650,10 @@ static int nft_payload_inner_init(const struct nft_ctx *ctx,
 	struct nft_payload *priv = nft_expr_priv(expr);
 	u32 base;
 
+	if (!tb[NFTA_PAYLOAD_BASE] || !tb[NFTA_PAYLOAD_OFFSET] ||
+	    !tb[NFTA_PAYLOAD_LEN] || !tb[NFTA_PAYLOAD_DREG])
+		return -EINVAL;
+
 	base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	switch (base) {
 	case NFT_PAYLOAD_TUN_HEADER:
-- 
2.30.2

