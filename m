Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304A323F429;
	Fri, 28 Nov 2025 00:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289450; cv=none; b=iln0W8TmGZPvECOAciIZKQYMo/9r6yjlg5p1Vw5lQS1L2sRTqHW8fsDhZ7me42NllCVitFqbEx5nP7u0i0abrsHVLJcHNZQ4cnc1TIy5aft5eXYKE2nC4MZUw6fxYKNdMS1SfNB4o6MlJ5z4Wb7kzCaloHIQmmZe3W50r8UjKSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289450; c=relaxed/simple;
	bh=ELe0R693xzMN9smM7fu6AhZz/WR2GtRcCkoco18QNFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz9/WVFvd9rcThMp8/5xkXVd/nXDSp5CLCfpdrfZi/vVxwEsKwdZk/xvtaBOoUgvmPhIuSNyvjanK9eItdqiOIznMkVDG6xh5I7ssXiCrK+WwcahSasnxA89DPbhF5xocCsKZBcPp2sDCqKZlXoEKRmACl2VuLDPuNwRtGdMuO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KIGhmBgE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KIGhmBgE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1DE0A60275;
	Fri, 28 Nov 2025 01:24:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289447;
	bh=KzwUpA09B3owc91ZPYYNzzGHsdinCHxD2np76bgDQjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIGhmBgEM0kL3HaTaIEQaHJFhUMGN17l6cGXzYPmTQ18WgE2hvKdZYnM3UhftPjSa
	 ffsWHqtXfG6nYrs1xgla/WLP63h3OgaPs5V+kbqCWqJpdWgORO57EFnBTLrt1wxnyk
	 ngCAi23an1bvs6vF+Bw4Oa6/ZJMzGPtgdGjIJ+kOCWpPbq56xQAch3gAi3hKPd5+1E
	 g1WtjY98ElbBgOb9lpSCzOMACAjUdwYPVtOX0qw/5XxmcdMyVpA+4pPoUz83qbunrE
	 b0vzAJgH4afjcIfJBGhFFg9ULZtHiY1IIJrOpDGmg6bNr1HjxgzcK2X4r5kzX1PJpi
	 Ku3mzroHK87lg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 14/17] netfilter: nft_connlimit: add support to object update operation
Date: Fri, 28 Nov 2025 00:23:41 +0000
Message-ID: <20251128002345.29378-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

This is useful to update the limit or flags without clearing the
connections tracked. Use READ_ONCE() on packetpath as it can be modified
on controlplane.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_connlimit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 714a59485935..657764774a2d 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -44,7 +44,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	count = READ_ONCE(priv->list->count);
 
-	if ((count > priv->limit) ^ priv->invert) {
+	if ((count > READ_ONCE(priv->limit)) ^ READ_ONCE(priv->invert)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -131,6 +131,16 @@ static int nft_connlimit_obj_init(const struct nft_ctx *ctx,
 	return nft_connlimit_do_init(ctx, tb, priv);
 }
 
+static void nft_connlimit_obj_update(struct nft_object *obj,
+				     struct nft_object *newobj)
+{
+	struct nft_connlimit *newpriv = nft_obj_data(newobj);
+	struct nft_connlimit *priv = nft_obj_data(obj);
+
+	WRITE_ONCE(priv->limit, newpriv->limit);
+	WRITE_ONCE(priv->invert, newpriv->invert);
+}
+
 static void nft_connlimit_obj_destroy(const struct nft_ctx *ctx,
 				      struct nft_object *obj)
 {
@@ -160,6 +170,7 @@ static const struct nft_object_ops nft_connlimit_obj_ops = {
 	.init		= nft_connlimit_obj_init,
 	.destroy	= nft_connlimit_obj_destroy,
 	.dump		= nft_connlimit_obj_dump,
+	.update		= nft_connlimit_obj_update,
 };
 
 static struct nft_object_type nft_connlimit_obj_type __read_mostly = {
-- 
2.47.3

