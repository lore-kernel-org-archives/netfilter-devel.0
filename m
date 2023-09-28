Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4808E732F7
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjI1Qw5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjI1Qwy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0C71B3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ctU64Xgr1fCsxBOhbdNN7jmazWrOJGp5UfjqZkbAE0I=; b=E8FHTIGA0OLcJuPlF7rPXaSElz
        dDHVDTLDRgtQGYV62NR39GFviDo7XBQEW8hrTmrl+lpJV/NozeSDqJuioNNhYwPz6aw143tBj56li
        zFdNBSRujfFxE/yRRWsJuyfbucQJRxBmkbpHOw+h0IaJvp9b2XPYDPJxRuDG2ov9h8KfEAgEhkMhz
        /NerJTWJEso+aVwqkxE/bdTKGBgsY1BNvyCUCPSi1WZVOCMW6/iLBZpooWNM+f5NJ279Av0t5kiLY
        GvDMzNT+0S/51ORpu3zEzX2MPuqd5w5hcJ6nF4mYU2SeZacF6MhgIU1ybrj3tIf/u1brwR4g53hNH
        THns00kg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFu-0004x2-RU; Thu, 28 Sep 2023 18:52:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 6/8] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Date:   Thu, 28 Sep 2023 18:52:42 +0200
Message-ID: <20230928165244.7168-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Objects' dump callbacks are not concurrency-safe per-se with reset bit
set. If two CPUs perform a reset at the same time, at least counter and
quota objects suffer from value underrun.

Prevent this by introducing dedicated locking callbacks for nfnetlink
and the asynchronous dump handling to serialize access.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Proper commit description
- commit_mutex instead of dedicated spinlock
---
 net/netfilter/nf_tables_api.c | 91 +++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eee149ea98b41..f154fcc341421 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7743,6 +7743,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -7759,12 +7772,18 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
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
@@ -7824,6 +7843,33 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
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
+{
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -7832,13 +7878,13 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
-	bool reset = false;
 	u32 objtype;
+	char *buf;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
+			.start = nf_tables_dumpreset_obj_start,
+			.dump = nf_tables_dumpreset_obj,
 			.done = nf_tables_dump_obj_done,
 			.module = THIS_MODULE,
 			.data = (void *)nla,
@@ -7864,28 +7910,23 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(obj);
 	}
 
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
-
-	if (reset) {
-		const struct nftables_pernet *nft_net;
-		char *buf;
-
-		nft_net = nft_pernet(net);
-		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-
-		audit_log_nfcfg(buf,
-				family,
-				obj->handle,
-				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_ATOMIC);
-		kfree(buf);
-	}
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
 
+	buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
+	audit_log_nfcfg(buf, family, obj->handle,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
+
 	return nfnetlink_unicast(skb2, net, portid);
 }
 
@@ -9147,7 +9188,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call		= nf_tables_getobj_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.41.0

