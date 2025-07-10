Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150878F4E;
	Thu, 10 Jul 2025 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752108423; cv=none; b=nqvDSBUVVGoCAzqD3bb+1N2tdQXPLoadoBjlL1TjXgXAMM3Dcq738UNbPoASD3FsWsS/cJPnLnmI7PUg9eycequIdaBO2d7xdSuJBoh94JQBQkGx+nNy54r23rv8W15qwuu41nNjE9Fgw1aOjuJACcZDRIs/RyYQ5wji47XgJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752108423; c=relaxed/simple;
	bh=J/uvfM236/4CAbw0m3Cbk9lEuctnBW4DYFKrGFJYSq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tuIjWMmACbw/9JgOZrzorstObskXBHdOoHhR63tDgDA6aLpGGOVnn9u5FP7TdaZ35p/nNo3pxuXKDT4OrfOOUq1FU6D2FOV4dPNe7xewhOqHtVEBJGh/75xZY/HmKj22Mp7i14oSEUwwF5ECIrvF+bw7JhwcC+hm0uKLaeLKLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iXduyPYn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tZzwX3hW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iXduyPYn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tZzwX3hW"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AF7F660275; Thu, 10 Jul 2025 02:46:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108419;
	bh=6ClycVJtXBYGyKMFEqcrqitGjNtcSSBrIG1ObhhIM7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXduyPYn5/+46VyMLeO9FCl20opJuu/B576QQjGQnCrVEFCmZvuMu4pKnJ5mfHAy6
	 WrztAPQEhD8mM8RbDWr/WvFMAOvLiNus8YvB8w9QfCwidxQlDFVC0tYfjTd+dLaAmg
	 MaAfjVVYV1EQTnU5/3xiCidzSwhqcARCRaqDECJqK1vmWMfdGYjHcPaNRBEwRyy0R5
	 VgPoi50uLUzmB+sqZW3eua+/jFIhwg6w9+9KpfqkmTAEymCeR70i9x2kgC0l0sGoqi
	 /3EA6wMwVw/Yse/LNIbwrXeXyRzM7O9i1UpA/z9NFTI1LvLiPQhPRMOKtlXitu3gYA
	 qE0cPoTloozoQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1300760276;
	Thu, 10 Jul 2025 02:46:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108406;
	bh=6ClycVJtXBYGyKMFEqcrqitGjNtcSSBrIG1ObhhIM7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZzwX3hWR/G8YV2uFHfGZZgVvpEiRvhmSQv/e3qIlB3KMW7ZV9IX0S8d2UPf1wQu3
	 sd4I25cSLKzvSHM/gMs3ClJjAw4M6imk8yLLtN8gywi2GuGvPZFVxBvdAyaBLSzb0o
	 FVVOANdsjoSRRBc6NqgD6UN0voZsscEeH50RmZ8DtwF3mDiJS+A6/CXuFdmvno/srE
	 w3AX0LbLBXLW3hDaow3Ty5SCsi93R+cyZUEfs/zS5Em61/AFHbejdYcSHbdzqnqp4/
	 0slijGexthwCWcNlQrk8uMZCbTX4iGfLU6SNolKLKhbessGz1EkvgX2qhACuSmQ+gC
	 mU8tvtFjqGxMg==
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
Date: Thu, 10 Jul 2025 02:46:38 +0200
Message-Id: <20250710004639.2849930-4-pablo@netfilter.org>
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

Restore commit 28339b21a365 ("netfilter: nf_tables: do not send complete
notification of deletions") and fix it:

- Avoid upfront modification of 'event' variable so the conditionals
  become effective.
- Always include NFTA_OBJ_TYPE attribute in object notifications, user
  space requires it for proper deserialisation.
- Catch DESTROY events, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
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

