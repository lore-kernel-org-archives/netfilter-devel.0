Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113FD76046
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040654; cv=none; b=jUPu7CJGHhQgDGGYU3tpDT7ffYY+zWfhdX8oshIlEVAW0cf2pHDgPakjfWL6PS/NQcZuOyWH8nzO04XR7p04SB4jL8rIqIMz8W9NKEzvQPyiVHjmzSZhBTkXQYgJiXssyrTSPowirSRmk+8Ul/H+56zm/5SH4OZzBmcsJ8SwveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040654; c=relaxed/simple;
	bh=eYe+WQ078YgFnpD9LCjwC0mhBZSCO/LSyHajySq/3lA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ORs2PGRNGk6F+8heFB0L5h1tpbS4P8Q4hlZX349esr/u12y7heGrRLRhQI62KH3sUGpxDb3gRGsK7MqPPv+RxE1EkK7Cu7nkdq0AQOr0+Lydg5Xr/dZ4i9SKEzAvrWT2zFaNeT5ajcIxuiXxedXCj53mDReX2+mh6y2LxtNmnrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/8] netfilter: nf_tables: annotate data-races around element expiration
Date: Wed,  7 Aug 2024 16:23:54 +0200
Message-Id: <20240807142357.90493-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240807142357.90493-1-pablo@netfilter.org>
References: <20240807142357.90493-1-pablo@netfilter.org>
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
index 1bfdd16890fa..7a2f7417ed9e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -831,7 +831,7 @@ static inline bool __nft_set_elem_expired(const struct nft_set_ext *ext,
 					  u64 tstamp)
 {
 	return nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION) &&
-	       time_after_eq64(tstamp, *nft_set_ext_expiration(ext));
+	       time_after_eq64(tstamp, READ_ONCE(*nft_set_ext_expiration(ext)));
 }
 
 static inline bool nft_set_elem_expired(const struct nft_set_ext *ext)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 488c07eed296..2b75fbb5e86d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5824,7 +5824,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
 
-		expires = *nft_set_ext_expiration(ext);
+		expires = READ_ONCE(*nft_set_ext_expiration(ext));
 		if (time_before64(now, expires))
 			expires -= now;
 		else
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 489a9b34f1ec..67474fd002b2 100644
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

