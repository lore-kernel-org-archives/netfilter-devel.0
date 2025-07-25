Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B252A2F0058;
	Fri, 25 Jul 2025 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463055; cv=none; b=iET19LTIYhpVy6gIh/f3K677VK3p1J4LBUCdTbbj57jKGfjOKaGPoUfmr7Ys/0CEK6V7AyfkuiqkWZVaD4ZyPnlokZAXcZGVos4d1x4RbJ55/0nrPygkh7hh2TmdReWSeZVfWO/0AaZrTrqZJ0tgbPn+R9Z0v44ubUZLX45MqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463055; c=relaxed/simple;
	bh=XBsdVHUXwQkR8OduSe29Roah30jT5wfNtsjkta6yRiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=edCFiwDeg9q27RP1As1I5yd8wYv2r18gnR03/k0C7PoNWOAcGHU+lJ9/W6NOZjY+qlJO9KppEY49mNhJx2+GvJDYsSuFr8ecs+HI/3humVBWSsaN6UoE/5r41hwDDSWSjVtP+MZapPyypwLWMP0upC/guXY9AeBBGym90O+KIlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qc7+1tca; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oEEu9joT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qc7+1tca";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oEEu9joT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 59B9E6027B; Fri, 25 Jul 2025 19:04:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463052;
	bh=WKIB+T9euPbCXyug25MJH0Z8Fv6SXcbZxkD9Jqpt8yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qc7+1tcaM44auMFuCn/VnD/XGssWpO4V/HYxdXvGo6f9iZGogj3S25cspLHz8wogo
	 eG22gi4fM5/QVD2ZXHfviBGxu5kzR0NTCzAMfu3YKSQ56d7B4EvW/NjSYrxfIhb4Yc
	 Q1Z+zqcDj7/PctE18rb9Pw+lFUU7/CGq3TOeF6Ir1DAE9gqHYxx7naoZT89SnBbWG7
	 FONz1YzA/r9Gm36Q/KFOGVoIqurii9AFLS1cSfZH8sMMdPmzpaGVhnKFcmzC564Dqc
	 AMoRawHh6gHzPtjg/hImWd0/ZbSV/qZzWI0en8/SJw30l3utrxS74wpNYo2xZ63bo5
	 6HWR53+efE6Og==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7025A6026E;
	Fri, 25 Jul 2025 19:04:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463047;
	bh=WKIB+T9euPbCXyug25MJH0Z8Fv6SXcbZxkD9Jqpt8yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEEu9joTODhw8nOYwCKInc4sAbAKXv3zuX9ulihs54nDhktrOmXMR+mBmJu5nvPCk
	 zl6XicNIHP7lHU4w2h/coB6BW7/md82OkjrY75FnC55LAy27mL7pQ1GgS1lkKJ35Z+
	 l//a6sEbN63Ab6ZDYH01DO9leQEHUGumQ5OqpgVEvKWIS6PLCyqCN7B0yXNOWkZOqc
	 BhauUGDPrUQdPzHnEXAzCTO1ALo3C6z38fk8Umd6UxyOojgL7zesuXKR3qDgAz/7wb
	 a2KIbtj2/bYc7QvSk9q/tD5XcYvYgyiPvP5tdYYXx0+ksbIgz+CcBshzJrSywSxIGp
	 PR1q6eslZXD6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/19] netfilter: nfnetlink_hook: Dump flowtable info
Date: Fri, 25 Jul 2025 19:03:32 +0200
Message-Id: <20250725170340.21327-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

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
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 04795af6e586..13d0ed9d1895 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8895,11 +8895,12 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 
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
 
@@ -9727,12 +9728,13 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
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
2.30.2

