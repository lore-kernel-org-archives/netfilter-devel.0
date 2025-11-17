Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82BC3254A7;
	Mon, 17 Nov 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763414964; cv=none; b=uosrGNTyKXYZrp3Nfm8udBzmjqo8h+pMzuXwukwaYo76h9c2oBM2mbJHEGarDHsFC2ELw/cRhIQTTd1VyRcYEtVksI1l3iAo+G/esSaKyWhGaquzIDgxnTTvhG2mI2zbMqvEC8YQaSW1rVWEj8+E0zbpMJo1tNxyFVLb1Qr2tro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763414964; c=relaxed/simple;
	bh=W+ezDQcxUvUoXjAEbb/MpLHBfesJhS4/NvZTabVynoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC1NRtQQCGYO8Jb9UAYK7c13fhDKZ3N0BawyjftnaZv57a91CqZnIW7ckJXoTEX7Jpdy4Dxpa9YiTZ1erpfMScMAURo92NtCHhARxbtl9MEqUsSnx437F6Y1N8eOb+z97q4yFsfZ4tG1LxbSWpsBc8+OvmNKW109Mrwymnt2fuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HddBvtE2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HddBvtE2"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E38E560310;
	Mon, 17 Nov 2025 22:29:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763414954;
	bh=bgAqoX6d31RXV6DZDhtZsb+pfQap6DwcLnEx0R/BPto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HddBvtE2+wyGbBMLHv/bKHr1kKYvpFrCA48KigwYba2vJKq47oHCqvFeF0nBa/I6/
	 DxT6ALDd4qkBf9VOEoncg7OgOKamDQTmbWGmfDVShaTEZi4EuC/pGwp+1oucrj+ir5
	 l5/WUxNvEOneHTah6+5INWqQF1OycU4XMlB1jqXYwrVLl3dkwfoscsAK3q1wAcjm7Z
	 tP5jw8GJ+Bp5jsDn8qdMdIzIFiuWDEAoAoUWeq3FENtF42VMHnooyeWoTVoUIc7u4a
	 c4ksxXgO77161rX/meIvcCMLOKGp5hI9ukNeKlLtvakEPHehyd9w51SLx8MeQXgBvQ
	 IvBs1VZGDGeVg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.12 1/2] Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"
Date: Mon, 17 Nov 2025 21:28:58 +0000
Message-ID: <20251117212859.858321-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117212859.858321-1-pablo@netfilter.org>
References: <20251117212859.858321-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a partial revert of commit dbe85d3115c7e6b5124c8b028f4f602856ea51dd.

This update breaks old nftables userspace because monitor parser cannot
handle this shortened deletion, this patch was added as a Stable-dep:,
let's revert it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 36 ++---------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3028d388b293..2f3684dcbef8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1032,12 +1032,6 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELTABLE ||
-	    event == NFT_MSG_DESTROYTABLE) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
 			 htonl(table->flags & NFT_TABLE_F_MASK)))
 		goto nla_put_failure;
@@ -1893,13 +1887,6 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
-	    (event == NFT_MSG_DELCHAIN ||
-	     event == NFT_MSG_DESTROYCHAIN)) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
@@ -4685,12 +4672,6 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELSET ||
-	    event == NFT_MSG_DESTROYSET) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -8021,18 +8002,12 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
-	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
-	if (event == NFT_MSG_DELOBJ ||
-	    event == NFT_MSG_DESTROYOBJ) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
-	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
+	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
+	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
 		goto nla_put_failure;
 
@@ -9048,13 +9023,6 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
-	if (!hook_list &&
-	    (event == NFT_MSG_DELFLOWTABLE ||
-	     event == NFT_MSG_DESTROYFLOWTABLE)) {
-		nlmsg_end(skb, nlh);
-		return 0;
-	}
-
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
-- 
2.47.3

