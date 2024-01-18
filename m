Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94312942A;
	Thu, 18 Jan 2024 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594663; cv=none; b=dDqNyCMhNVlZV7XNHlQ3/RxCZHL/Ucl8zxi17XkmPllAxJfU/TlWRs+wSgzn66ZvDt6l9jKItPAL19qhXlMDmkq+E6F7aV6QkZ04VUW/nxvXwP/0EaKlFRzj13RldYHL/VZhFKmlFczrwMDO/EfaXSS88vjmsH9k5y1/+5BVF4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594663; c=relaxed/simple;
	bh=10+mbyFzIQMLfraP8AqZ3UUcWireIRhnyTNXOUnzibg=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=XGd2T92RGKZIWlJ2uaHYdXC5SymNBpG2Cd+4rywF1SxbqRNNPuZppyhDJowaF5ufyESsocl9Hgd+Ccpd0oqEyAD/AQMzZdtCbe127fuvlhF+flHYalZYOfUfRTygj/AyfgG2p620dlPyCNlr/XCRicDCMURS0XJbTFTi9OOBW8w=
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
Subject: [PATCH net 03/13] netfilter: nf_tables: bail out if stateful expression provides no .clone
Date: Thu, 18 Jan 2024 17:17:16 +0100
Message-Id: <20240118161726.14838-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240118161726.14838-1-pablo@netfilter.org>
References: <20240118161726.14838-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All existing NFT_EXPR_STATEFUL provide a .clone interface, remove
fallback to copy content of stateful expression since this is never
exercised and bail out if .clone interface is not defined.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2548d7d56408..b3db97440db1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3274,14 +3274,13 @@ int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src)
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

