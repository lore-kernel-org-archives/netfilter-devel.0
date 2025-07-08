Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D24C28137E
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979859; cv=none; b=UvZSQgbStfKEpEqQ9f3zNj6HeIQ163rZomMDB8F8nlgqAu1k7NviUN6mzjNK/ksO5sSzG6+MUAnKs2Kbqox1k/n+2dF2qCw7SMJTj9TKgBr3FPnmXKlnb4gEfI7tlELL78I5fAvx07Qwx1Egf09pgH0HQGGXnLKNqElBfb0+c14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979859; c=relaxed/simple;
	bh=SWNcuSSVUkBzOfp7ddU85EgEM+2GpP7zOK8yac+NS/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZfq0Eul4daA9lAq46nZx0DXfuBP4GRcOZSJZh7BMAZjiUThZ0lSqaqmPt81+syMFGwI+Gp1BM+/1TYIhg71Q2SEd+O4tnMkO1ngEFz09bAgMyIWc8099RpMHa3MfYyQ0kfbaq5KctJlBlTIj23ADpqoK5qIf4f72pfeX6pH/tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ULQjS/H4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ULQjS/H4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TKFy/JLjWQTnnQS3cdq/U1T32AjJVjUMmoS9q3epzB4=; b=ULQjS/H4Ff9Kdygn8CO8vjouqd
	oG90xkz3BcDpu8FOHscoCzKnZbjINlgufek0Cw8g/43KBc/q1+IRAsu1yLfwtnOGyTJ3ggVTFrYIp
	8VCFVuUMERsngYFcX5QDkuRs7i2q5MPykjpG07OCxXMr0C6PuCNp3I6nL8CzZnGBJeEYNpQZH0H+K
	vy0n+vShmDu2LSB37IeYOqeA8Z22RyHf5r2nM9P53KE/YzhYLTR3XttQIp+w598yn8wY2WmWzc8Ep
	aTc27+JPIOBDv4pU9QrLCsHMnjw1R3AJ1V9MMgRKWulUM0uRQin6Smw+aYbGWTss6KUCY3mMq1me0
	PW50vMPQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uZ7zU-000000002oA-0UDR;
	Tue, 08 Jul 2025 15:04:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/2] netfilter: nfnetlink hook: Dump flowtable info
Date: Tue,  8 Jul 2025 15:04:02 +0200
Message-ID: <20250708130402.16291-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250708130402.16291-1-phil@nwl.cc>
References: <20250708130402.16291-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce NFNL_HOOK_TYPE_NFT_FLOWTABLE to distinguish flowtable hooks
from base chain ones. Nested attributes are shared with the old NFTABLES
hook info type since they fit apart from their misleading name.

Old nftables in user space will ignore this new hook type and thus
continue to print flowtable hooks just like before, e.g.:

| family netdev {
| 	hook ingress device test0 {
| 		 0000000000 nf_flow_offload_ip_hook [nf_flow_table]
| 	}
| }

With this patch in place and support for the new hook info type, output
becomes more useful:

| family netdev {
| 	hook ingress device test0 {
| 		 0000000000 flowtable ip mytable myft [nf_flow_table]
| 	}
| }

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter.h                     |  1 +
 include/uapi/linux/netfilter/nfnetlink_hook.h |  2 ++
 net/netfilter/nf_tables_api.c                 | 24 +++++++------
 net/netfilter/nfnetlink_hook.c                | 35 +++++++++++++++++++
 4 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 5f896fcc074d..efbbfa770d66 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -92,6 +92,7 @@ enum nf_hook_ops_type {
 	NF_HOOK_OP_UNDEFINED,
 	NF_HOOK_OP_NF_TABLES,
 	NF_HOOK_OP_BPF,
+	NF_HOOK_OP_NFT_FT,
 };
 
 struct nf_hook_ops {
diff --git a/include/uapi/linux/netfilter/nfnetlink_hook.h b/include/uapi/linux/netfilter/nfnetlink_hook.h
index 84a561a74b98..1a2c4d6424b5 100644
--- a/include/uapi/linux/netfilter/nfnetlink_hook.h
+++ b/include/uapi/linux/netfilter/nfnetlink_hook.h
@@ -61,10 +61,12 @@ enum nfnl_hook_chain_desc_attributes {
  *
  * @NFNL_HOOK_TYPE_NFTABLES: nf_tables base chain
  * @NFNL_HOOK_TYPE_BPF: bpf program
+ * @NFNL_HOOK_TYPE_NFT_FLOWTABLE: nf_tables flowtable
  */
 enum nfnl_hook_chaintype {
 	NFNL_HOOK_TYPE_NFTABLES = 0x1,
 	NFNL_HOOK_TYPE_BPF,
+	NFNL_HOOK_TYPE_NFT_FLOWTABLE,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0fc9b4d49164..725584022726 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8917,11 +8917,12 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
 	list_for_each_entry(hook, &flowtable_hook->list, list) {
 		list_for_each_entry(ops, &hook->ops_list, list) {
-			ops->pf		= NFPROTO_NETDEV;
-			ops->hooknum	= flowtable_hook->num;
-			ops->priority	= flowtable_hook->priority;
-			ops->priv	= &flowtable->data;
-			ops->hook	= flowtable->data.type->hook;
+			ops->pf			= NFPROTO_NETDEV;
+			ops->hooknum		= flowtable_hook->num;
+			ops->priority		= flowtable_hook->priority;
+			ops->priv		= &flowtable->data;
+			ops->hook		= flowtable->data.type->hook;
+			ops->hook_ops_type	= NF_HOOK_OP_NFT_FT;
 		}
 	}
 
@@ -9907,12 +9908,13 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			if (!ops)
 				return 1;
 
-			ops->pf		= NFPROTO_NETDEV;
-			ops->hooknum	= flowtable->hooknum;
-			ops->priority	= flowtable->data.priority;
-			ops->priv	= &flowtable->data;
-			ops->hook	= flowtable->data.type->hook;
-			ops->dev	= dev;
+			ops->pf			= NFPROTO_NETDEV;
+			ops->hooknum		= flowtable->hooknum;
+			ops->priority		= flowtable->data.priority;
+			ops->priv		= &flowtable->data;
+			ops->hook		= flowtable->data.type->hook;
+			ops->hook_ops_type	= NF_HOOK_OP_NFT_FT;
+			ops->dev		= dev;
 			if (nft_register_flowtable_ops(dev_net(dev),
 						       flowtable, ops)) {
 				kfree(ops);
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index cd4056527ede..92d869317cba 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -156,6 +156,38 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 	return 0;
 }
 
+static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
+				     const struct nfnl_dump_hook_data *ctx,
+				     unsigned int seq,
+				     struct nf_flowtable *nf_ft)
+{
+	struct nft_flowtable *ft =
+		container_of(nf_ft, struct nft_flowtable, data);
+	struct net *net = sock_net(nlskb->sk);
+	struct nlattr *nest;
+	int ret = 0;
+
+	if (WARN_ON_ONCE(!nf_ft))
+		return 0;
+
+	if (!nft_is_active(net, ft))
+		return 0;
+
+	nest = nfnl_start_info_type(nlskb, NFNL_HOOK_TYPE_NFT_FLOWTABLE);
+	if (!nest)
+		return -EMSGSIZE;
+
+	ret = nfnl_hook_put_nft_info_desc(nlskb, ft->table->name,
+					  ft->name, ft->table->family);
+	if (ret) {
+		nla_nest_cancel(nlskb, nest);
+		return ret;
+	}
+
+	nla_nest_end(nlskb, nest);
+	return 0;
+}
+
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
 			      const struct nf_hook_ops *ops,
@@ -223,6 +255,9 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	case NF_HOOK_OP_BPF:
 		ret = nfnl_hook_put_bpf_prog_info(nlskb, ctx, seq, ops->priv);
 		break;
+	case NF_HOOK_OP_NFT_FT:
+		ret = nfnl_hook_put_nft_ft_info(nlskb, ctx, seq, ops->priv);
+		break;
 	case NF_HOOK_OP_UNDEFINED:
 		break;
 	default:
-- 
2.49.0

