Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9F15B0EF
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 13:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821834; cv=none; b=pxvgzTUNBSvTYM361BxBTt0yzjJ5OsBCzQNaMtXMy1EiS2jeQtVPdEQ8fycE2Xeuj98ko22ugbiTtexe7o7zJv5SFJk+jeasqYS+6LyQ4QPtF4JlK7GVqGDU0PZuSv55p8vPh8ipjlWKFzIr+JtOvJ7PntU+HdIzn1azTy2H/zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821834; c=relaxed/simple;
	bh=1ZjYmzX3ir0hNz1ScTM8bAHO/5u2JeM+fzK+cp2F8k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwDhRLGl7Huz11UsYlM3YDWQiVzi3Ssf062ZOiIrIBpdbzHz5pLqUXMn7KH1IdRT9tMICiPJd5qIR4B9Oa3LkFqz9n30HBsHI+eI0SfTnxU3DEf+MAzUSLsrYnyevj5FMBmKhgTqObaQFE/QGDP+QapCoGagJfpHtBwtYo95V8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ajv+psL+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ajv+psL+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fvMgPl5/POffdq1D1M9XZEc45qY1Z7KVMe7iFNm5XWo=; b=ajv+psL+SjwN1ZVIRfLpewQ6Ra
	RbxpXgiP4TDi5GP9P8+QsdbYfVKkoakOEA03Sp8BvyLcv60w+zXGwVvb/XaST+rikSTx4n7V6qYiH
	Q93187nIQLPLRLpJ0bzvyLMHlYLctdw75zOVjjAAiSnwqvEZs83jfm7x5WZM8+BEeF9XPkjN5y3kj
	dSXnU0FvabS3mahbFo6uvSx1qKbHwGQyJ5ILGtaZiiQNr2w2VEidijym4l0jvn26MVQJhOyUuq+gP
	GTw5HpOEUta++e/k2Xo94AiISScE6Q9qnFY03mmpsFoYw3Y8lV5LIOMad5oqhZtPfxKUsaOFlFND+
	xk2sD9FQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uQ4aj-000000004El-25pQ;
	Fri, 13 Jun 2025 15:37:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2 1/2] netfilter: nf_tables: Drop dead code from fill_*_info routines
Date: Fri, 13 Jun 2025 15:37:02 +0200
Message-ID: <20250613133703.9548-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250613133703.9548-1-phil@nwl.cc>
References: <20250613133703.9548-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.49.0

