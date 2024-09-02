Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5727A4CE13
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 23:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319062; cv=none; b=GldJYvQWAFRJNRV4DbzMiykMFssjvp/SEzD7eixVjGis7OkCnw64uBHFpTfh+hfA+mAzvN6RxgQWUTnesktRaMsmGGbFFFmqUE83iBpQMHOFzuLrYrgnWu8Li6CRVKhcVK97lKT/i2lteeuL/dSkaDOlbC4cO1jkHsorvar4a+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319062; c=relaxed/simple;
	bh=xR3hGjp5EVPaLPDC9YkaPbWh6npcIDaic0hP9GdOonA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D3vKTPenD1L0X2p15MsVr0fJBtL0duQuoa1q2+ACVZw49wiZK8KSCc/UlhvF6Yafq55S8WqNL8KejsIFtBEEJxRuc6UM569XyxdCo7r944/m750QSai183lhuTjQCXA/+7ZWEpcpmULg85l6HHp9WvUjKA/Vnoytwyw06fs72FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH nf-next,v2 6/9] netfilter: nf_tables: annotate data-races around element expiration
Date: Tue,  3 Sep 2024 01:17:23 +0200
Message-Id: <20240902231726.171964-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240902231726.171964-1-pablo@netfilter.org>
References: <20240902231726.171964-1-pablo@netfilter.org>
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
v2: no changes.

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
index f183a82cc3c1..ee7f8c12918b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5821,7 +5821,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
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

