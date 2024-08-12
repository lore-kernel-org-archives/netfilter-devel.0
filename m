Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BB416DED4;
	Mon, 12 Aug 2024 10:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458213; cv=none; b=qnWbUaFW3VUv5BJqHEpJfCqOeUlIP95xSNJOo8H/sB5wUfpaKPGD1hV2CbM+WxBs/AHj1O47xtIdpN2uIm2xnvdubqzIfD7Er1UVCQpbb9kYRlFayxwIJhIhmFUhuLFx5X4wpnz7GAm1DSNHcZGhvbSa6zJ3V3wwPe11revTucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458213; c=relaxed/simple;
	bh=Hm2W9ZPpyomXoFWnwG8tK2gBddhSsMQjKgsO9lRuNAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bWWI7QMMR/K90UMOLaxoEnspVebLxPpVgzRhi6J9MvL1bykZU8J+gND2pXwFotUOEUWHLP1di4xwVoV9n6aXRttE5zpf6Xol9W2OGLtsvpgUArX2qAuzHuA8mc8q+TWzqwHluX2p9RX9Thyp6HTV26Ph/qCm2R6gt7wl7AOMsxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1.x 1/3] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Mon, 12 Aug 2024 12:23:18 +0200
Message-Id: <20240812102320.359247-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102320.359247-1-pablo@netfilter.org>
References: <20240812102320.359247-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 3c13725f43dcf43ad8a9bcd6a9f12add19a8f93e upstream.

All existing NFT_EXPR_STATEFUL provide a .clone interface, remove
fallback to copy content of stateful expression since this is never
exercised and bail out if .clone interface is not defined.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d18b698139ca..85d7250a29a2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3123,14 +3123,13 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
 {
 	int err;
 
-	if (src->ops->clone) {
-		dst->ops = src->ops;
-		err = src->ops->clone(dst, src);
-		if (err < 0)
-			return err;
-	} else {
-		memcpy(dst, src, src->ops->size);
-	}
+	if (WARN_ON_ONCE(!src->ops->clone))
+		return -EINVAL;
+
+	dst->ops = src->ops;
+	err = src->ops->clone(dst, src);
+	if (err < 0)
+		return err;
 
 	__module_get(src->ops->type->owner);
 
-- 
2.30.2

