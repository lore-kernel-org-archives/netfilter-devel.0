Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D50C16F27F;
	Mon, 12 Aug 2024 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458298; cv=none; b=C/dksr26022CXi2pj6m/55NOuBlj95kZPkKa0yYcvx9vYiFnL2SHkpKFA9vy8PD0muIJVQdd5A013u10lw2+X0IZhYbajhp65zogHyabTMuZtyd/dq5cnsmf64KFFgjJqHDJrICNZqi63K78zIXhiC+dN0ZkCTnB1mifaYdYHO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458298; c=relaxed/simple;
	bh=3F5i7p7TlD20eYtbNbyTpyN/18/P2PXAZAvhqfKsTCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XCWvYm8IrZAClTXLEmjl2aro4Z+vwTuDm+/ukAUbMnRW7XmQ8Ikv4fXgIh3VYCmlvcO4p+yTYNgJHdarjSXkqMttedsfwXbjpbJq/p5x2vGtRKFUzuEcJT8UW6bB+uD/ULXft131XFRVmOcoMtyNvfOjTDCOzESJqNoQgmV43W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15.x 3/5] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Mon, 12 Aug 2024 12:24:44 +0200
Message-Id: <20240812102446.369777-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102446.369777-1-pablo@netfilter.org>
References: <20240812102446.369777-1-pablo@netfilter.org>
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
index 04f4f75e74da..395bd8c1f5c3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3053,14 +3053,13 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
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

