Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7BADF49;
	Thu, 10 Jul 2025 01:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752109647; cv=none; b=spJimjLICBX4LPgmbT06bbb4ilVzqzfzIoHbq/w14dYwfG8p4A8BmttJeWTAl7w1q4vf9ZUU6b9fvvdy3SJvylkTlzHiHjp9wbU1W8/VPQztcZ2q8cV9/y3+A8Rqt/DaqrzxBngaQGpgsZ+1Mf3lsbg2XwFkdBqDCWntZFADEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752109647; c=relaxed/simple;
	bh=JHYZYK2T/Pwtqe9NdSSnPH9HA1Syfb/WcX9MuvYcfFg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rR+3EA8r9JRMEF9lkUnbNssg8M436RCM/ncjMF7yBMDL80Jil/a0kVIgwMnLUF/igLpCaRCAy6/w+6/ZzG04Ih3ZlI+tSNAix8LxHZFuBBM6haiDmGpUPbwc0cgG9VWHmXlLxC41UQlXYjR/J1saP9NhtV4qeqEx+7cvhpUDpmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DEyY1pja; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bMzMqftr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DEyY1pja";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bMzMqftr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DD3176026C; Thu, 10 Jul 2025 03:07:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109644;
	bh=VpCqQ3uvGxwEm2gELzxV9uRacnzmwEuH9yMSmmQl+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEyY1pja/BdhyO+1cJUbOct+ttLnofuCSg46fjZfgIGc59ZxZ/05Mak42UKWMESG0
	 ub+08qpUK8uCo28QrHzEO7YlDY5p8EMVSEEu1bBNlxq2X7BoR2dWsoqoUZDEHYp+oe
	 aa8efpg+Km9MOJzibf5mQDv4FUnp7aAX9CK7jYf8G7GICNDC+132LFeL3un/KVf8m+
	 I2TeNrhsrQVTlC0dT1zzLzbDXEtIAAhh1DhgAYktwcxHDO2crKFQr0o9or5M+n7ty0
	 2XgnGAOhI04KuVjeXVGd6DWdvxjF1I5koV2+Shhep3/Kz0qOYccwnJRLJl5LJZIl6k
	 dbOL6a94B5xaQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4904260262;
	Thu, 10 Jul 2025 03:07:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109632;
	bh=VpCqQ3uvGxwEm2gELzxV9uRacnzmwEuH9yMSmmQl+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMzMqftryDeVjqGKWe7bvEunLf83hK/bAPT8id8KXH3fbWOizIuTY0v2DjZK6ZM23
	 74KtbaqhA6lrUro4j0evZhCXkcKGgJGIZkmYoOzAF92sVrW7yiZgagH0SkRu5ASsCt
	 Qnfs9JsnCcMYuPB0meSNH3VoxB+4BdpleiuDly9z4/tzbxKdYAt7ZZ6dlb6LKEh7+6
	 V5wvznHCrA4f/Q48WdnsLi4xo9vPbW0A8OtPeO3f03SYZ6iktlrNAlLzzBwSogM964
	 +n+jd43aVbXb5gHC5AID7HpBUKwV3B1LJ/CljcDcbEL9ch2YPvQ9K1khdKmTpk+4ok
	 aXugWyOwjCREw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 2/4] netfilter: nf_tables: Drop dead code from fill_*_info routines
Date: Thu, 10 Jul 2025 03:07:04 +0200
Message-Id: <20250710010706.2861281-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250710010706.2861281-1-pablo@netfilter.org>
References: <20250710010706.2861281-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

This practically reverts commit 28339b21a365 ("netfilter: nf_tables: do
not send complete notification of deletions"): The feature was never
effective, due to prior modification of 'event' variable the conditional
early return never happened.

User space also relies upon the current behaviour, so better reintroduce
the shortened deletion notifications once it is fixed.

Fixes: 28339b21a365 ("netfilter: nf_tables: do not send complete notification of deletions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24c71ecb2179..e1dfa12ce2b1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1165,11 +1165,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELTABLE) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
 			 htonl(table->flags & NFT_TABLE_F_MASK)))
 		goto nla_put_failure;
@@ -2028,11 +2023,6 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELCHAIN && !hook_list) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
@@ -4859,11 +4849,6 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELSET) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -8350,11 +8335,6 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELOBJ) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
@@ -9394,11 +9374,6 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELFLOWTABLE && !hook_list) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
-- 
2.30.2

