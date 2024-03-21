Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E64181;
	Thu, 21 Mar 2024 00:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710979609; cv=none; b=m2GXw8h7qYXrN8hey2A8wMNH9JjKO9/acbvCTXD73ft455ZW1p9MQUuwla9NLuGLImjM8z2AliuPxETRJrdl4Wsx3cCbDm/92sOnz+8WNsl2NT3uGEGGR+ujaPVeTeCJ8SDVOtO1r2sHn9LaFKSeFHuLShEl2vBa061uvAfmNZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710979609; c=relaxed/simple;
	bh=F9YHcCxjrLSORTOGYcveR3LZxbLdh6ZamF/xWmv+IPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UFz9nNiSB/BF/CgSrB4DhU7Ei4qSqQl9eTjn6sx6bwhkuWTPxV3mS7HwaMgbym+k8jT9tZjvPkv2lK+5s7ycCMY0AkFMw+k40++PrKt+Ja79wDRUe1LCP7JLv3h20oI3wtUsiffLvZ1nrrJby6G2ZppjfzWOpZ9rAn8hhmIoxm4=
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
Subject: [PATCH net 3/3] netfilter: nf_tables: Fix a memory leak in nf_tables_updchain
Date: Thu, 21 Mar 2024 01:06:35 +0100
Message-Id: <20240321000635.31865-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240321000635.31865-1-pablo@netfilter.org>
References: <20240321000635.31865-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quan Tian <tianquan23@gmail.com>

If nft_netdev_register_hooks() fails, the memory associated with
nft_stats is not freed, causing a memory leak.

This patch fixes it by moving nft_stats_alloc() down after
nft_netdev_register_hooks() succeeds.

Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 net/netfilter/nf_tables_api.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 984c1c83ee38..5fa3d3540c93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2631,19 +2631,6 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 	}
 
-	if (nla[NFTA_CHAIN_COUNTERS]) {
-		if (!nft_is_base_chain(chain)) {
-			err = -EOPNOTSUPP;
-			goto err_hooks;
-		}
-
-		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats)) {
-			err = PTR_ERR(stats);
-			goto err_hooks;
-		}
-	}
-
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
@@ -2658,6 +2645,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	}
 
 	unregister = true;
+
+	if (nla[NFTA_CHAIN_COUNTERS]) {
+		if (!nft_is_base_chain(chain)) {
+			err = -EOPNOTSUPP;
+			goto err_hooks;
+		}
+
+		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
+		if (IS_ERR(stats)) {
+			err = PTR_ERR(stats);
+			goto err_hooks;
+		}
+	}
+
 	err = -ENOMEM;
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWCHAIN,
 				sizeof(struct nft_trans_chain));
-- 
2.30.2

