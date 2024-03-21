Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A33158200;
	Thu, 21 Mar 2024 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711020088; cv=none; b=T4xTFssLIG3Vmd/vx/2kucM7vELXixqkxCQjzgbYZNjgepFMmdyNNpw2uIfkyhAvjtkoD0iFYYQslxzerV8L0F5nWMQTyKy6/uo8lNK0IBKMR1JAT0b3nsNvhDFJbVEIc1DCzky0sZmAKBzrle/L+35VNqpngsck/0adAYi8KF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711020088; c=relaxed/simple;
	bh=cTcmO4w/kTveverO/D/2h609HziKzF1FbmTRMfKDrrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BCwWA/EDrIFq6mZrqDtPmkwqKHkD5lTgbv3JXJi5KwmPGgTxXbwS6GCWjR5N6C+QDJmH/usAgWcJyd7SZxkE3MU9UG8/9v6k4ATE/SrCHDtEWnrGLeSL+5ZR9qoraZpo+Hejlm9spjdpvPkLXe6xcgNB+PRHFjsdqAvU8+M3afU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 2/3] netfilter: nf_tables: do not compare internal table flags on updates
Date: Thu, 21 Mar 2024 12:21:16 +0100
Message-Id: <20240321112117.36737-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240321112117.36737-1-pablo@netfilter.org>
References: <20240321112117.36737-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore skipping transaction if table update does not modify flags.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e93f905e60b6..984c1c83ee38 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1213,7 +1213,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (flags & ~NFT_TABLE_F_MASK)
 		return -EOPNOTSUPP;
 
-	if (flags == ctx->table->flags)
+	if (flags == (ctx->table->flags & NFT_TABLE_F_MASK))
 		return 0;
 
 	if ((nft_table_has_owner(ctx->table) &&
-- 
2.30.2

