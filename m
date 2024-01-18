Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93F129425;
	Thu, 18 Jan 2024 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594663; cv=none; b=IKeMT1PmZSnxZEYcQExENc8vYgU4Z+jdq2/Gj4BRKxDdYsk/tmjpgg4FCS10uMmO0dp2FWUmMUcSkvBkhitfygSNOE2TOHpECFuHsmwoFonPH9JI6Sw+lcyrH67TIoRQdHS7tBYiyTIIa75ZbzuKKGfNlIQUSmds1+GC9Ig4XGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594663; c=relaxed/simple;
	bh=cYoXsCg14s9ICiRzUl7bdS1q6wH+NywmJ29OUQF7T0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=XJsiJ44wIzbt2fpa1wqoQE9pmCT1V0qp4rcL+0wT3vt14GOkSzc4EvzYSFlviRPbWr9gMazy9xPo3Cf//zQELrggxKCYjpjdnckeUjW8RuLSOHoQnlouzelwRuTNgqvtAeEalWWrJp755FoMuo9EZY6r8GsbBEA35qn2OFm5vbc=
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
Subject: [PATCH net 04/13] netfilter: nft_limit: do not ignore unsupported flags
Date: Thu, 18 Jan 2024 17:17:17 +0100
Message-Id: <20240118161726.14838-5-pablo@netfilter.org>
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

Bail out if userspace provides unsupported flags, otherwise future
extensions to the limit expression will be silently ignored by the
kernel.

Fixes: c7862a5f0de5 ("netfilter: nft_limit: allow to invert matching criteria")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 145dc62c6247..79039afde34e 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -58,6 +58,7 @@ static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
+	bool invert = false;
 	u64 unit, tokens;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
@@ -90,19 +91,23 @@ static int nft_limit_init(struct nft_limit_priv *priv,
 				 priv->rate);
 	}
 
+	if (tb[NFTA_LIMIT_FLAGS]) {
+		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
+
+		if (flags & ~NFT_LIMIT_F_INV)
+			return -EOPNOTSUPP;
+
+		if (flags & NFT_LIMIT_F_INV)
+			invert = true;
+	}
+
 	priv->limit = kmalloc(sizeof(*priv->limit), GFP_KERNEL_ACCOUNT);
 	if (!priv->limit)
 		return -ENOMEM;
 
 	priv->limit->tokens = tokens;
 	priv->tokens_max = priv->limit->tokens;
-
-	if (tb[NFTA_LIMIT_FLAGS]) {
-		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
-
-		if (flags & NFT_LIMIT_F_INV)
-			priv->invert = true;
-	}
+	priv->invert = invert;
 	priv->limit->last = ktime_get_ns();
 	spin_lock_init(&priv->limit->lock);
 
-- 
2.30.2

