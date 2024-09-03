Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9213A29D06
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371801; cv=none; b=EBTpsSzAVVgFJACKQYo0abYBc/NiUJhKrZWz/Y/FjGVoywGxO/uCVNEYjeRLorcq0TPFAcki7i+nPkh+FlxTnFScHhBDCDV/qivKPy0XTKYNR+S9pdLOBvwWQ1spsbF/EZgMXThz0gyem0FNgz0fxfOVjlHXP9MMRV6wYLO7afo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371801; c=relaxed/simple;
	bh=795af9qtsY69QylMO2AIOQvD19tQuhnupUue3QwJLX8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PLaY6T6qhJ3S4nqxT0LWCvSG+OIYo2HD8uLS43M4dgdSNGSoiPlU9N53IEWa7PxCr06AmXpy5I8D2ScfkNJwOr6hvKse+3YQ39oPWBPEPqiATghGN32SvOa3ude3Vf14JzqXdGUyilPQufTbvnT0CMMlp6UGX7RjztW4Np1lTs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nf-next,v3 6/9] netfilter: nf_tables: annotate data-races around element expiration
Date: Tue,  3 Sep 2024 15:56:32 +0200
Message-Id: <20240903135635.2086-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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
v3: no changes

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

