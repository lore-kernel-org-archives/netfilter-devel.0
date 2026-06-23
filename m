Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7640F3C5DA1;
	Tue, 23 Jun 2026 22:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252972; cv=none; b=QXxJO52hbMgW2KpQ7rWTKhuEamPcEVUcArP3jcgRJAKAkXLyU9IbxZau1QejWIQ7DDKrevdNapCbr4hNA0A3Dv/a6fZlxqhpVM8eUPCS4p/1VGuM7MpVCRLquKtA2Thrd4AeCNfJDLdfLkUqpO3TRWn/UI+wKNEb8CpHvSYuFTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252972; c=relaxed/simple;
	bh=J6P+u+7MgfcSrbwUnmeSyucjL8/8qGFurSZ/PRIoyZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL8Eo7YvO47BkdrK6HeG3M6aXRJdGHLyGM2QpXUtivJnGZcj6XxBQ9eORAuY6iSsFBi3X8M3v7v01F7pHVbOG+4KlWEdzFpVB1qPwnd2iAG9CsjVNfjblnQpw+7Qgh+ZhBSY7jPvpfwFqypHi9wcn5MomSTYJykOPNKpUOhMuIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XiMG3BeE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XiMG3BeE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6121060588;
	Wed, 24 Jun 2026 00:16:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782252969;
	bh=mXGikmyIXAlYw6RpAUAMKdOgOY4BOMCTM004dM2AmXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiMG3BeE6/sQnkB93yLeOvbOgxTdOx9pngxI1WPPuwMKzSr+8dV43RSa+SKGdycN8
	 M7C1P0cfX1MwqbiekeuU3prf/wwckG3GjiBMUvMEvx4k20+RJvDHpAYczl9jmahJ4k
	 7SL8sMVRWJzmz+IpkKIpEfWvXfWdXLi66aENhP1vnWaW7d8nUvxY/lEjFkShXusj6+
	 Eh/5v3jZRK1YVSqDGA+VDFUyECRhFlX0+QWYQPS+42UCux1lxRMCqMBbobl/4BbbKQ
	 4MI5fFy8UWTUaLVM7b/6f18FLJ1T+jCxdiaqU3pcc9H4I9yasxXqc9W/Tqg2So+0zo
	 rVKZsDUtmluSw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 13/14] netfilter: nft_ct: expectation timeouts are passed in milliseconds
Date: Wed, 24 Jun 2026 00:15:46 +0200
Message-ID: <20260623221548.701545-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623221548.701545-1-pablo@netfilter.org>
References: <20260623221548.701545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Userspace passes '5000' in case user asks for 5 seconds.

Allowing for sub-second expectation lifetimes makes sense to me. so
fix up the kernel side instead of munging nft to send a value rounded
up to next second.

Also note that this violates nft convention of passing integers in
network byte order, but we can't change this anymore.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 958054dd2e2e..03a88c77e0f0 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1215,11 +1215,23 @@ struct nft_ct_expect_obj {
 	u32		timeout;
 };
 
+static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
+{
+	unsigned long jiffies_val = msecs_to_jiffies(nla_get_u32(attr));
+
+	if (jiffies_val > UINT_MAX)
+		return -ERANGE;
+
+	*val = jiffies_val;
+	return 0;
+}
+
 static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
 {
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	int err;
 
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
@@ -1254,8 +1266,11 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	err = nft_ct_expect_timeout_get(tb[NFTA_CT_EXPECT_TIMEOUT], &priv->timeout);
+	if (err)
+		return err;
+
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
-	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
@@ -1275,7 +1290,7 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
 	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
-	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
+	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, jiffies_to_msecs(priv->timeout)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
 		return -1;
 
@@ -1325,7 +1340,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          &ct->tuplehash[!dir].tuple.src.u3,
 		          &ct->tuplehash[!dir].tuple.dst.u3,
 		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout += priv->timeout * HZ;
+	exp->timeout += priv->timeout;
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
-- 
2.47.3

