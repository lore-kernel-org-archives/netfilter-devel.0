Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268B87262D;
	Thu, 10 Jul 2025 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752108421; cv=none; b=G/xXfjs4iBS2mP5JO3oTf5cPnuZ+Z4Bp3UiUmIAE7VJa/BOFoTxOJ7NckmliOTOvj3rIzyOJMa9IUxcQJB3WJJcRlWQy9U36sA41WZcYNY0bH9iodA2ThgXo1LVoYvBJeDnCYwi/9nS4QXDsgvaaYDoZ4qkRKxwAJRTfPzf+r4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752108421; c=relaxed/simple;
	bh=AfN9kKPzTh6zpRwhraV+8HJN1AbuZRgWnqOvC8oHbr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ynmq2AmzYLGpeVLxAkDjLMoMk7s9yjtBO2ln4Xj7XN8V15L1r6x/4OznmsX2ip3Lgvc3chLMsKFUJURz6uD9N2dDIz/UIgGgfy3dAo1JXf2N5X3gb1Od5/EXXspUDPl5gc1u4D8Gb89Y4WYIQcOGqoHOh+HM9yFQ8XiZGrTLeXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gi4Y3XXo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DCjYcxLc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gi4Y3XXo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DCjYcxLc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6B4F760278; Thu, 10 Jul 2025 02:46:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108417;
	bh=utT2vFiUqfbtA27EyqsqOvZGp9lymE9EUZx5GT5pjDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi4Y3XXoEiv5lK0S9LXUpPrbltu+JUu883feNyqQtvp7/GEpxPlqhS8nCNSS1chOs
	 8Hog/BWAP90nE33zeJLeCT7cLDfiQ6WNO1DM4lVzrS16HxyebNZshMrHlilSEEou/r
	 k9maveTpNmQO71JDeCpu2uOAop1sKL4XsiwHKY00HwZP/ahkOSHJahd/cgYpOibpg4
	 CSwxVUyhD4o6bG+6l8Wxy8Vsg1ZO7oujlRgGIYpu/XLviogX9e0+vg4FIOk778H9EI
	 P8Er4ZPREXhbNvY6EC2VYD/BCABnDJ8mdqqWNSqO36EbzKXLSyWf06Luo2TM31hT/l
	 iSCqKWhSPWlig==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31C6B60272;
	Thu, 10 Jul 2025 02:46:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108405;
	bh=utT2vFiUqfbtA27EyqsqOvZGp9lymE9EUZx5GT5pjDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCjYcxLc9n05+GMunqGonjfJhvUY9Wp1+Bg9ZuYPq8PWDxSstiH4Oc212H9i+Jev0
	 elLNBPXpnZnrYXtM7iLCMl5f9YnQ32vRduQNG+h6/CSPmzXjMPBIbqiwP4ZTqC0wxj
	 Ku8ApMh+h+v3rPnHFB415LCd6OkpJop9WIrVuwx/yKSXaA7h9gcMAiF6XvqjvoEaME
	 Ocvf6RemQ9BV0XLorI96o8FEs5X4Q7FesDTNnCd4M3vCX/mynhWDXYbfmjQTFka08B
	 k7xlAZneh+8Q4l5fKX1xcRCdVE6o713KhTScyc+NyYC5tZ35HmZ2GaloFS2kGQcad1
	 LBtxD9kqcWaPw==
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
Date: Thu, 10 Jul 2025 02:46:37 +0200
Message-Id: <20250710004639.2849930-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250710004639.2849930-1-pablo@netfilter.org>
References: <20250710004639.2849930-1-pablo@netfilter.org>
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

