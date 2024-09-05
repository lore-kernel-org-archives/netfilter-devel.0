Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2B61BD008;
	Thu,  5 Sep 2024 23:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578984; cv=none; b=KtxTmfzY4mNTAqf830jv8L2RcHHKRvlROMyBuX3NQycoqFCU9AkeO64jXZ/8P0Y8U1J9pyzzKznkmetMWrA9Xfb/PSJ0BJ5fc1G2gKWTjcVG+magR/LprgM9J2SyzRkUQsUV4/00cIRv9vg6bbF8yzWP3LitOhYnolUXspOdTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578984; c=relaxed/simple;
	bh=qXDRc5xOBeiZUAyHf7ogHvpICj3mNuTe8AvgWopzBdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TKczNRFICIlBwWbFEc6ja+HT148V6A3pDhJYI0dfEMT02BBf/s8HOryMPtQGlg3/tsuNNPyT2eDRsi+oRjpUzwrGhGYj15YaXKXlEAgaXtz/kMaZ+qf8TlPQc6W9YSxVobLRglqLG4iPUMQGhfOcPGonm2xWy423C6JsCITrFas=
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
Subject: [PATCH net-next 13/16] netfilter: nf_tables: annotate data-races around element expiration
Date: Fri,  6 Sep 2024 01:29:17 +0200
Message-Id: <20240905232920.5481-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

element expiration can be read-write locklessly, it can be written by
dynset and read from netlink dump, add annotation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 net/netfilter/nf_tables_api.c     | 2 +-
 net/netfilter/nft_dynset.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c302b396e1a7..1528af3fe26f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -835,7 +835,7 @@ static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
 	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_after_eq64(tstamp, *nft_set_ext_expiration(ext));
+	       time_after_eq64(tstamp, READ_ONCE(*nft_set_ext_expiration(ext)));
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 571aa30918e9..77dce3d61ae6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5827,7 +5827,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
 
-		expires = *nft_set_ext_expiration(ext);
+		expires = READ_ONCE(*nft_set_ext_expiration(ext));
 		if (time_before64(now, expires))
 			expires -= now;
 		else
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 5812fd880b79..ca4b52e68295 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -96,7 +96,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : READ_ONCE(set->timeout);
-			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
+			WRITE_ONCE(*nft_set_ext_expiration(ext), get_jiffies_64() + timeout);
 		}
 
 		nft_set_elem_update_expr(ext, regs, pkt);
-- 
2.30.2

