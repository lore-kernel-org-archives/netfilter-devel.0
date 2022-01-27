Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684C3C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 16:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243630AbiA0Q2p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 11:28:45 -0500
Received: from mail.netfilter.org ([217.70.188.207]:39092 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiA0Q2p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 11:28:45 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7F07960693;
        Thu, 27 Jan 2022 17:25:39 +0100 (CET)
Date:   Thu, 27 Jan 2022 17:28:39 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Fix response to unprivileged users
Message-ID: <YfLINxzIDlCwej1X@salvia>
References: <20220120101653.28280-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bYLCUCy61W6Ceuaw"
Content-Disposition: inline
In-Reply-To: <20220120101653.28280-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--bYLCUCy61W6Ceuaw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Phil,

On Thu, Jan 20, 2022 at 11:16:53AM +0100, Phil Sutter wrote:
> Expected behaviour in both variants is:
> 
> * Print help without error, append extension help if -m and/or -j
>   options are present
> * Indicate lack of permissions in an error message for anything else
> 
> With iptables-nft, this was broken basically from day 1. Shared use of
> do_parse() then somewhat broke legacy: it started complaining about
> inability to create a lock file.
> 
> Fix this by making iptables-nft assume extension revision 0 is present
> if permissions don't allow to verify. This is consistent with legacy.
> 
> Second part is to exit directly after printing help - this avoids having
> to make the following code "nop-aware" to prevent privileged actions.

On top of this patch, it should be possible to allow for some
nfnetlink command to be used from unpriviledged process.

I'm attaching a sketch patch, it skips module autoload which is should
not be triggered by an unpriviledged process.

This should allow for better help with -m/-j if the module is present.

--bYLCUCy61W6Ceuaw
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 241e005f290a..1e10bf19af93 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -28,6 +28,7 @@ struct nfnl_callback {
 	const struct nla_policy	*policy;
 	enum nfnl_callback_type	type;
 	__u16			attr_count;
+	bool			unpriviledged;
 };
 
 enum nfnl_abort_action {
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..0f450c8a43ac 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -211,21 +211,24 @@ EXPORT_SYMBOL_GPL(nfnetlink_broadcast);
 static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
+	const struct nfnetlink_subsystem *ss;
 	struct net *net = sock_net(skb->sk);
 	const struct nfnl_callback *nc;
-	const struct nfnetlink_subsystem *ss;
+	bool cap_net_admin;
 	int type, err;
 
 	/* All the messages must at least contain nfgenmsg */
 	if (nlmsg_len(nlh) < sizeof(struct nfgenmsg))
 		return 0;
 
+	cap_net_admin = netlink_net_capable(skb, CAP_NET_ADMIN);
+
 	type = nlh->nlmsg_type;
 replay:
 	rcu_read_lock();
 
 	ss = nfnetlink_get_subsys(type);
-	if (!ss) {
+	if (!ss && cap_net_admin) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
 		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
@@ -245,6 +248,11 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
+	if (cap_net_admin && !nc->unpriviledged) {
+		rcu_read_unlock();
+		return -EPERM;
+	}
+
 	{
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		struct nfnl_net *nfnlnet = nfnl_pernet(net);
@@ -607,6 +615,11 @@ static void nfnetlink_rcv_skb_batch(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u32 gen_id = 0;
 	u16 res_id;
 
+	if (!netlink_net_capable(skb, CAP_NET_ADMIN)) {
+		netlink_ack(skb, nlh, -EPERM, NULL);
+		return;
+	}
+
 	msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 	if (msglen > skb->len)
 		msglen = skb->len;
@@ -643,11 +656,6 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 	    skb->len < nlh->nlmsg_len)
 		return;
 
-	if (!netlink_net_capable(skb, CAP_NET_ADMIN)) {
-		netlink_ack(skb, nlh, -EPERM, NULL);
-		return;
-	}
-
 	if (nlh->nlmsg_type == NFNL_MSG_BATCH_BEGIN)
 		nfnetlink_rcv_skb_batch(skb, nlh);
 	else
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f69cc73c5813..a3a23707fcb3 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -677,10 +677,13 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		return -EINVAL;
 
 	rcu_read_unlock();
-	try_then_request_module(xt_find_revision(family, name, rev, target, &ret),
-				fmt, name);
-	if (ret < 0)
-		goto out_put;
+	if (netlink_net_capable(skb, CAP_NET_ADMIN)) {
+		try_then_request_module(xt_find_revision(family, name, rev,
+							 target, &ret),
+					fmt, name);
+		if (ret < 0)
+			goto out_put;
+	}
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (skb2 == NULL) {
@@ -718,7 +721,8 @@ static const struct nfnl_callback nfnl_nft_compat_cb[NFNL_MSG_COMPAT_MAX] = {
 		.call		= nfnl_compat_get_rcu,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_COMPAT_MAX,
-		.policy		= nfnl_compat_policy_get
+		.policy		= nfnl_compat_policy_get,
+		.unpriviledged	= true,
 	},
 };
 

--bYLCUCy61W6Ceuaw--
