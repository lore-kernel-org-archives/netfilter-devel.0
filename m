Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9321F30C1E0;
	Mon,  5 May 2025 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488528; cv=none; b=Dql651J8IkHU8F5G+rA1N8xub70FkC7JxYFtrjqzRvjdqxX2nZcfi0SSIssMK12dPGYNyv8XQXFo1K9ytcFjgFjzWgcb/blF/3X4ay8qAcXLJYTiy2hlN+P+l+WuTZrHiWBAUruj2tuE08qHYnD7fUxFixOTXsAj8vkYW8B8Fro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488528; c=relaxed/simple;
	bh=ZH1ZzqA69lXuCKWl8Ws0pw2Vc0tcQ8gsneoCOXXbufc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=suTteaCpI+v9m244yqcoohM+9hWbZ6uZfdpog60f3wFvjSgISk2MWXCLdrJMX8LA1REeZ6Lnu7dAa3oFiIkNDBKAmKCz2a+kwSLR2xgeDNZ12KasSFjrI1ppaAWuEcu4NVu3uQe6jirMBSSfEaeYaZUXsNcArs02GLOseNRPugw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NcQOIkYN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nkzVsfmr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NcQOIkYN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nkzVsfmr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 11E4B6065E; Tue,  6 May 2025 01:42:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488525;
	bh=X6lkzL4xDqlKfS4sQJUKU3QpUlZ3xfXhNKhaCPkcJBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcQOIkYNsmfqPD+oz2AVPTkfHoOL5f8/mOUrH/6c06sUW/NDHlpbwvSy0dvCre4dO
	 9DmvfQgTKRfF25dYovYyHUyp+ifTOqPtQZCzYxdCOXoamEeEUyJyTRiS4jBkObNj/p
	 Mdh9CBWtkD0ZZ84ZaipAki/p+sRNN8P9xtOCitSbcHfFhT83XWqNLldkLa214+f64S
	 +WLsVphsw36KpBuoioYYwOYPaFMUIyfb+EbXMhSZn7ELjeaAyqbHXP7lRzG0XC7YgG
	 qivf3r36ftE01ErLe/6anRJ7vvAQo89yvWT11yafgGfCFbyAe9jiiFT1rWhWxPbdD9
	 sZcBZMVKzoQMw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2E94F6065C;
	Tue,  6 May 2025 01:41:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488518;
	bh=X6lkzL4xDqlKfS4sQJUKU3QpUlZ3xfXhNKhaCPkcJBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkzVsfmr/k/w2UXnLxgCbgosE4Z1f/GKFYJMpOzq6rHIflQIGSRvA1la18yf9FhPd
	 ZdMvWdkhx/Pw9HId0fxIiVxHRZL8i2tHedqEDNILb5MFfB/JU8u2rn3FMw3yGxOFTL
	 +duYONTYEVDN026G8g2bkOB7NxYkS1PXZ+IB5n7QWUHVNscSi5C77sYwyb0Ha8fDMS
	 BRd8kco4AloXCDb/GTqeS5af14RlRqMwMwhVVxBc4qKvbPLTO38pEforU8xF8e5ZnR
	 iivdHqBZGNGQTiRUBdfESbUQty3y3uQ8NeEwTf/k1D4qwLsIdh198KlCkS+077fC+P
	 7FkQoimTo3+3g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 3/7] netfilter: nft_quota: match correctly when the quota just depleted
Date: Tue,  6 May 2025 01:41:47 +0200
Message-Id: <20250505234151.228057-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>

The xt_quota compares skb length with remaining quota, but the nft_quota
compares it with consumed bytes.

The xt_quota can match consumed bytes up to quota at maximum. But the
nft_quota break match when consumed bytes equal to quota.

i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].

Fixes: 795595f68d6c ("netfilter: nft_quota: dump consumed quota")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 9b2d7463d3d3..df0798da2329 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -19,10 +19,16 @@ struct nft_quota {
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
-				 const struct sk_buff *skb)
+				 const struct sk_buff *skb,
+				 bool *report)
 {
-	return atomic64_add_return(skb->len, priv->consumed) >=
-	       atomic64_read(&priv->quota);
+	u64 consumed = atomic64_add_return(skb->len, priv->consumed);
+	u64 quota = atomic64_read(&priv->quota);
+
+	if (report)
+		*report = consumed >= quota;
+
+	return consumed > quota;
 }
 
 static inline bool nft_quota_invert(struct nft_quota *priv)
@@ -34,7 +40,7 @@ static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt->skb) ^ nft_quota_invert(priv))
+	if (nft_overquota(priv, pkt->skb, NULL) ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -51,13 +57,13 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
-	bool overquota;
+	bool overquota, report;
 
-	overquota = nft_overquota(priv, pkt->skb);
+	overquota = nft_overquota(priv, pkt->skb, &report);
 	if (overquota ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 
-	if (overquota &&
+	if (report &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
 		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
 			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);
-- 
2.30.2

