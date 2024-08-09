Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582AB194AEE
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2024 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723208867; cv=none; b=e6HcjD8W1TWqiKgc2GrzQg2F6GmjTZMljdqZ82UmmjEmBDdYySZeoTt6gdi66jh3bCDX7D3tYE4wGqJnuSERN1W+w/ks2d3EK6QtTg44Pi4F1OTU0IRWZJY1XDAxgruS/s798RGWfYYy82wjd0V8niSSjFYjxvL5egPwEet6pI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723208867; c=relaxed/simple;
	bh=x00/V0asLG7dozd/NFEVP16gPvEUSUQt2eVZLDhOvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGEake5ssPE8vOROiWNvIVgHOJvPeeQsKJfBCPh7WIscfDfz/LQIKNyXD2CoXDocU16veyKf5O3zaKxcYOM8SX1NPKQ/TE9v+jZWWkiEff8phNAvep0RHnh/WomS6Dfpqu5ccwfz17BfCMWApj234DIFsT7J67aAtmHPYLU15eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KQRmu7BU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KQRmu7BU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sN90vpSKbriAdkJaih6CREm/SH0LNPT+Q0HnbV2jlx4=; b=KQRmu7BUTeuFd8shRMD8huKUGb
	bs5Zc02QruIn84xWcD0w9C4Pzy0K9+SpDvcXa/9EGpUw5BCkXZCqGiXYhcCSjrba1ZxJHjFfTOpzv
	2Mxu6fp1ct14cFuhaiWQVh54mfq6PWPQyxq05s9kYhAtrfweImEqgwWgGHX1+UEjeNxqQbEktrJo1
	kCrAG6C4LJwaYAmHM3d8fUCSW/gjEHIn8Vqww0sjAbBLuO5Z1AEVBPB6DQAQAh6uG2F6m4UoUNYrc
	E/zZpwHF240GugxCy35wh0FXeQn8fupxuTUZKYKH8/KbCWHTrJ9aMIssYW/7IfZsbd6UEgeJEmmHf
	Uebl+33Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1scPLE-000000000DZ-1U9b;
	Fri, 09 Aug 2024 15:07:36 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH v4 3/3] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Date: Fri,  9 Aug 2024 15:07:32 +0200
Message-ID: <20240809130732.13128-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240809130732.13128-1-phil@nwl.cc>
References: <20240809130732.13128-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Objects' dump callbacks are not concurrency-safe per-se with reset bit
set. If two CPUs perform a reset at the same time, at least counter and
quota objects suffer from value underrun.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 72 ++++++++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c12c9cae784d..0a2f79346958 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8020,6 +8020,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_obj(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	mutex_lock(&nft_net->commit_mutex);
+	ret = nf_tables_dump_obj(skb, cb);
+	mutex_unlock(&nft_net->commit_mutex);
+
+	return ret;
+}
+
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -8036,12 +8049,18 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
+{
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_obj_start(cb);
+}
+
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -8100,18 +8119,43 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
+{
+	u32 portid = NETLINK_CB(skb).portid;
+	struct sk_buff *skb2;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	skb2 = nf_tables_getobj_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getobj_reset(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
 {
 	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
-	bool reset = false;
 	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
+			.start = nf_tables_dumpreset_obj_start,
+			.dump = nf_tables_dumpreset_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -8120,16 +8164,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
+	if (!try_module_get(THIS_MODULE))
+		return -EINVAL;
+	rcu_read_unlock();
+	mutex_lock(&nft_net->commit_mutex);
+	skb2 = nf_tables_getobj_single(portid, info, nla, true);
+	mutex_unlock(&nft_net->commit_mutex);
+	rcu_read_lock();
+	module_put(THIS_MODULE);
 
-	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
 
-	if (!reset)
-		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
 	buf = kasprintf(GFP_ATOMIC, "%.*s:%u",
 			nla_len(nla[NFTA_OBJ_TABLE]),
 			(char *)nla_data(nla[NFTA_OBJ_TABLE]),
@@ -9421,7 +9467,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call		= nf_tables_getobj_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.43.0

