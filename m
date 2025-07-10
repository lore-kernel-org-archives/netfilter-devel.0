Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B059826B77D;
	Thu, 10 Jul 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752109650; cv=none; b=osbtWZhOFUNROAfT7nTarQqCZAWaEOwdknd1N5eWhuO0F/rQk2ybf6dN6gvEa2J+g9Bg3XPsqNRs3yVM5uaFyziRSg+3wKKoPLkPCPpQmTabWMtjIKyMeSJY1Du4n6SlsSxofiEsVdoLYD3pl73/pmG+WlHHi4/sbiJG6GSMR5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752109650; c=relaxed/simple;
	bh=WUv1MLhhZuwQWbHcj9S2YtTKkQBIsVHdjGDNa0rYQxY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IVZtANjmj6ThwUzxEIFARuDLUcciY7QZI0RUZd/vvkiP+QInZC8STTSOImD8lUPmiPcPLS/ITXnBk5JAZ7KEjM6KAgn7kBadlcB/zWofbmIB4yLEMWkeJn7eMA8ag5cy7SkesRqWBRi0SKbSVf8E7vwo5wbxz9s7vxqym9WzKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZEXdd1Oz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lZNuM8f5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZEXdd1Oz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lZNuM8f5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 41FED60264; Thu, 10 Jul 2025 03:07:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109647;
	bh=GKZdliCnw/Bfm/u7rgRx4qzG/5+ko+ccBjo/KQ/NQ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEXdd1Oz6YqL/PNF/rh39UgsH3PGRBUS6ta3yflJKJJICpaj+4asVBcxjNo5DXvER
	 KIc67zLsWny7oB/yPpLEk/HNwzo4/VKqPz6fN+d+eWOgns+jDhGkGR9e+1iD4umiuU
	 Fcxc66qikrPJh9pGV6goHvcNE+l2Zfpoe2CbLApJs8yQxS4Sg1EbWilTboBQaJ9ZpG
	 pAdN4FcFV0J9kNXW5zXukAFf6SfjV66QBz0o+jE5P2FUsOELibUR526CJwuH76xXlT
	 cpgedUfyK3fOE0JW7tH7QrvpmnndfVsXjYpQ1V8hEJR97S5mHLbF80KPR1iB5QuXH4
	 q3SxfrD4EniVw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 418EA60254;
	Thu, 10 Jul 2025 03:07:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109633;
	bh=GKZdliCnw/Bfm/u7rgRx4qzG/5+ko+ccBjo/KQ/NQ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZNuM8f50q4TW45Z+hgSgxvcJewOOrD6BULXQ8o/8ow7dEOcQ6CxJqQ4GlFnV1G+k
	 cbRGhR7MFWVWqwchA+f3+SqudPBZQulBT4UMwuPLwI0zNdSPb2k+e5oSxjQB0b6JO0
	 y9aUIHb8Z5ZnP7jzUPd4EO9mnQ4stecZW8gsGK84Mwk2TOnLMTy3S3KWaemYya5u3n
	 HlaOBemXcaP+3IbOzAQcj2xV5P2YpvvIWcNqrV9tgXhR9sR1uHUfWyfJOPAT3FUNPC
	 eXANCGSEPKiP3gk4gU0aBbzjpi8ADa0eadfMA/PxRyms0M7EfwTo5jl8EqN0JHQtiA
	 CzFxHZLPG+lVA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/4] netfilter: nf_tables: Reintroduce shortened deletion notifications
Date: Thu, 10 Jul 2025 03:07:05 +0200
Message-Id: <20250710010706.2861281-4-pablo@netfilter.org>
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

Restore commit 28339b21a365 ("netfilter: nf_tables: do not send complete
notification of deletions") and fix it:

- Avoid upfront modification of 'event' variable so the conditionals
  become effective.
- Always include NFTA_OBJ_TYPE attribute in object notifications, user
  space requires it for proper deserialisation.
- Catch DESTROY events, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 67 ++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1dfa12ce2b1..4ec117b31611 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1153,9 +1153,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -1165,6 +1165,12 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
+	if (event == NFT_MSG_DELTABLE ||
+	    event == NFT_MSG_DESTROYTABLE) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
 			 htonl(table->flags & NFT_TABLE_F_MASK)))
 		goto nla_put_failure;
@@ -2011,9 +2017,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -2023,6 +2029,13 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 			 NFTA_CHAIN_PAD))
 		goto nla_put_failure;
 
+	if (!hook_list &&
+	    (event == NFT_MSG_DELCHAIN ||
+	     event == NFT_MSG_DESTROYCHAIN)) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		struct nft_stats __percpu *stats;
@@ -4835,9 +4848,10 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	u32 seq = ctx->seq;
 	int i;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
-			   NFNETLINK_V0, nft_base_seq(ctx->net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, ctx->family, NFNETLINK_V0,
+			   nft_base_seq(ctx->net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -4849,6 +4863,12 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
 
+	if (event == NFT_MSG_DELSET ||
+	    event == NFT_MSG_DESTROYSET) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
 	if (set->flags != 0)
 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
 			goto nla_put_failure;
@@ -8323,20 +8343,26 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
+	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
-	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
+	if (event == NFT_MSG_DELOBJ ||
+	    event == NFT_MSG_DESTROYOBJ) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
+	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
 		goto nla_put_failure;
 
@@ -9362,9 +9388,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	struct nft_hook *hook;
 	struct nlmsghdr *nlh;
 
-	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+	nlh = nfnl_msg_put(skb, portid, seq,
+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -9374,6 +9400,13 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 			 NFTA_FLOWTABLE_PAD))
 		goto nla_put_failure;
 
+	if (!hook_list &&
+	    (event == NFT_MSG_DELFLOWTABLE ||
+	     event == NFT_MSG_DESTROYFLOWTABLE)) {
+		nlmsg_end(skb, nlh);
+		return 0;
+	}
+
 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data.flags)))
 		goto nla_put_failure;
-- 
2.30.2

