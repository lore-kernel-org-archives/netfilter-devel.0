Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F59C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 11:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41849613DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 11:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhEULlD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 07:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhEULk6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 07:40:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7455CC061763
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 04:39:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3V6-0005W9-U0; Fri, 21 May 2021 13:39:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: nf_tables: allow to dump all registered base hooks
Date:   Fri, 21 May 2021 13:39:19 +0200
Message-Id: <20210521113922.20798-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521113922.20798-1-fw@strlen.de>
References: <20210521113922.20798-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This dumps the active hook pipeline to userspace.

Userspace needs to pass the address family and the hook point.

For the netdev family/ingress hook, a device name must be
provided as well.

This allows 'nft' to display the priority of each hook.

Example:
family ip hook prerouting {
        -0000000300
        -0000000150
        -0000000100
}

... so this shows 3 active hooks with -300/-150/-100.

With manual work this is enough to figure out which hooks these are.

Followup patch will include the hook and module name (if any).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_queue.c                 |   4 +-
 net/netfilter/nf_tables_api.c            | 216 +++++++++++++++++++++++
 3 files changed, 219 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 19715e2679d1..5810e41eff33 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -124,6 +124,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETNFHOOKS,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bbd1209694b8..224238b20825 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -259,7 +259,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static struct nf_hook_entries *nf_hook_entries_head(const struct net *net, u8 pf, u8 hooknum)
+static struct nf_hook_entries *nf_queue_hook_entries_head(const struct net *net, u8 pf, u8 hooknum)
 {
 	switch (pf) {
 #ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
@@ -292,7 +292,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	net = entry->state.net;
 	pf = entry->state.pf;
 
-	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
+	hooks = nf_queue_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
 	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d63d2d8f769c..2bfa80e93658 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7911,6 +7911,216 @@ static int nf_tables_getgen(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
+static const struct nf_hook_entries *
+nf_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *dev)
+{
+	const struct nf_hook_entries *hook_head = NULL;
+	struct net_device *netdev;
+
+	switch (pf) {
+	case NFPROTO_IPV4:
+		if (hook >= ARRAY_SIZE(net->nf.hooks_ipv4))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
+		break;
+	case NFPROTO_IPV6:
+		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
+		if (hook >= ARRAY_SIZE(net->nf.hooks_ipv6))
+			return ERR_PTR(-EINVAL);
+		break;
+	case NFPROTO_ARP:
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
+		if (hook >= ARRAY_SIZE(net->nf.hooks_arp))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
+#endif
+		break;
+	case NFPROTO_BRIDGE:
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+		if (hook >= ARRAY_SIZE(net->nf.hooks_bridge))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
+#endif
+		break;
+#if IS_ENABLED(CONFIG_DECNET)
+	case NFPROTO_DECNET:
+		if (hook >= ARRAY_SIZE(net->nf.hooks_decnet))
+			return ERR_PTR(-EINVAL);
+		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
+		break;
+#endif
+#ifdef CONFIG_NETFILTER_INGRESS
+	case NFPROTO_NETDEV:
+		if (hook != NF_NETDEV_INGRESS)
+			return ERR_PTR(-EOPNOTSUPP);
+
+		if (!dev)
+			return ERR_PTR(-ENODEV);
+
+		netdev = dev_get_by_name_rcu(net, dev);
+		if (!netdev)
+			return ERR_PTR(-ENODEV);
+
+		return rcu_dereference(netdev->nf_hooks_ingress);
+#endif
+	default:
+		return ERR_PTR(-EPROTONOSUPPORT);
+	}
+
+	return hook_head;
+}
+
+struct nft_dump_hooks_data {
+	char devname[IFNAMSIZ];
+	unsigned long headv;
+	unsigned int seq;
+	u8 hook;
+};
+
+static int nf_tables_dump_one_hook(struct sk_buff *nlskb,
+				   const struct nft_dump_hooks_data *ctx,
+				   const struct nf_hook_ops *ops)
+{
+	unsigned int portid = NETLINK_CB(nlskb).portid;
+	struct net *net = sock_net(nlskb->sk);
+	struct nlmsghdr *nlh;
+	int ret;
+
+	nlh = nfnl_msg_put(nlskb, portid, ctx->seq, NFT_MSG_GETNFHOOKS,
+			   NLM_F_MULTI, ops->pf, NFNETLINK_V0, nft_base_seq(net));
+	if (!nlh)
+		goto nla_put_failure;
+
+	ret = nla_put_be32(nlskb, NFTA_HOOK_HOOKNUM, htonl(ops->hooknum));
+	if (ret)
+		goto nla_put_failure;
+
+	ret = nla_put_be32(nlskb, NFTA_HOOK_PRIORITY, htonl(ops->priority));
+	if (ret)
+		goto nla_put_failure;
+
+	nlmsg_end(nlskb, nlh);
+	return 0;
+nla_put_failure:
+	nlmsg_trim(nlskb, nlh);
+	return ret;
+}
+
+static int nf_tables_dump_basehooks(struct sk_buff *nlskb,
+				    struct netlink_callback *cb)
+{
+	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	struct nft_dump_hooks_data *ctx = cb->data;
+	int err, family = nfmsg->nfgen_family;
+	struct net *net = sock_net(nlskb->sk);
+	struct nf_hook_ops * const *ops;
+	const struct nf_hook_entries *e;
+	unsigned int i = cb->args[0];
+
+	rcu_read_lock();
+	cb->seq = ctx->seq;
+
+	e = nf_hook_entries_head(family, ctx->hook, net, ctx->devname);
+	if (!e)
+		goto done;
+
+	if (IS_ERR(e)) {
+		ctx->seq++;
+		goto done;
+	}
+
+	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
+		ctx->seq++;
+
+	ops = nf_hook_entries_get_hook_ops(e);
+
+	for (; i < e->num_hook_entries; i++) {
+		err = nf_tables_dump_one_hook(nlskb, ctx, ops[i]);
+		if (err)
+			break;
+	}
+
+done:
+	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
+	rcu_read_unlock();
+	cb->args[0] = i;
+	return nlskb->len;
+}
+
+static int nf_tables_dump_basehooks_start(struct netlink_callback *cb)
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+	const struct nlattr * const *nla = cb->data;
+	struct nft_dump_hooks_data *ctx = NULL;
+	struct net *net = sock_net(cb->skb->sk);
+	u8 family = nfmsg->nfgen_family;
+	char name[IFNAMSIZ] = "";
+	const void *head;
+	u32 hooknum;
+
+	hooknum = ntohl(nla_get_be32(nla[NFTA_HOOK_HOOKNUM]));
+	if (hooknum > 255)
+		return -EINVAL;
+
+	if (family == NFPROTO_NETDEV) {
+		if (!nla[NFTA_HOOK_DEV])
+			return -EINVAL;
+
+		nla_strscpy(name, nla[NFTA_HOOK_DEV], sizeof(name));
+	}
+
+	rcu_read_lock();
+	/* Not dereferenced; for consistency check only */
+	head = nf_hook_entries_head(family, hooknum, net, name);
+	rcu_read_unlock();
+
+	if (head && IS_ERR(head))
+		return PTR_ERR(head);
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->headv = (unsigned long)head;
+
+	ctx->hook = hooknum;
+	strscpy(ctx->devname, name, sizeof(ctx->devname));
+	cb->data = ctx;
+	cb->seq = 1;
+	return 0;
+}
+
+static int nf_tables_dump_basehooks_stop(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+	return 0;
+}
+
+static int nft_get_basehooks(struct sk_buff *skb,
+			     const struct nfnl_info *info,
+			     const struct nlattr * const nla[])
+{
+	if (!nla[NFTA_HOOK_HOOKNUM])
+		return -EINVAL;
+
+	if (ntohl(nla_get_be32(nla[NFTA_HOOK_HOOKNUM])) > 255)
+		return -EINVAL;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_basehooks_start,
+			.done = nf_tables_dump_basehooks_stop,
+			.dump = nf_tables_dump_basehooks,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call		= nf_tables_newtable,
@@ -8048,6 +8258,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
+	[NFT_MSG_GETNFHOOKS] = {
+		.call		= nft_get_basehooks,
+		.type		= NFNL_CB_RCU,
+		.attr_count	= NFTA_HOOK_MAX,
+		.policy		= nft_hook_policy,
+	},
 };
 
 static int nf_tables_validate(struct net *net)
-- 
2.26.3

