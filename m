Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE45CC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791AE6109E
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhCaUK4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbhCaUKi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:10:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFC5C0613D7
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 13:10:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRhAe-00059d-GV; Wed, 31 Mar 2021 22:10:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 02/11] netfilter: nfnetlink: use net_generic infra
Date:   Wed, 31 Mar 2021 22:10:05 +0200
Message-Id: <20210331201014.23293-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210331201014.23293-1-fw@strlen.de>
References: <20210331201014.23293-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to place it in struct net, nfnetlink is a module and usage
doesn't occur in fastpath.

Also remove rcu usage:

Not a single reader of net->nfnl uses rcu accessors.

When exit_batch callbacks are executed the net namespace is already dead
so no calls to these functions are possible anymore (else we'd get NULL
deref crash too).

If the module is removed, then modules that call any of those functions
have been removed too so no calls to nfnl functions are possible either.

The nfnl and nfl_stash pointers in struct net are no longer used, they
will be removed in a followup patch to minimize changes to struct net
(causes rebuild for entire network stack).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 62 +++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 06e106b3ed85..06f5886f652e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -28,6 +28,7 @@
 #include <linux/sched/signal.h>
 
 #include <net/netlink.h>
+#include <net/netns/generic.h>
 #include <linux/netfilter/nfnetlink.h>
 
 MODULE_LICENSE("GPL");
@@ -41,6 +42,12 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 
 #define NFNL_MAX_ATTR_COUNT	32
 
+static unsigned int nfnetlink_pernet_id __read_mostly;
+
+struct nfnl_net {
+	struct sock *nfnl;
+};
+
 static struct {
 	struct mutex				mutex;
 	const struct nfnetlink_subsystem __rcu	*subsys;
@@ -75,6 +82,11 @@ static const int nfnl_group2type[NFNLGRP_MAX+1] = {
 	[NFNLGRP_NFTRACE]		= NFNL_SUBSYS_NFTABLES,
 };
 
+static struct nfnl_net *nfnl_pernet(struct net *net)
+{
+	return net_generic(net, nfnetlink_pernet_id);
+}
+
 void nfnl_lock(__u8 subsys_id)
 {
 	mutex_lock(&table[subsys_id].mutex);
@@ -149,28 +161,35 @@ nfnetlink_find_client(u16 type, const struct nfnetlink_subsystem *ss)
 
 int nfnetlink_has_listeners(struct net *net, unsigned int group)
 {
-	return netlink_has_listeners(net->nfnl, group);
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+	return netlink_has_listeners(nfnlnet->nfnl, group);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 
 int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags)
 {
-	return nlmsg_notify(net->nfnl, skb, portid, group, echo, flags);
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+	return nlmsg_notify(nfnlnet->nfnl, skb, portid, group, echo, flags);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error)
 {
-	return netlink_set_err(net->nfnl, portid, group, error);
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+	return netlink_set_err(nfnlnet->nfnl, portid, group, error);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_set_err);
 
 int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 {
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
 	int err;
 
-	err = nlmsg_unicast(net->nfnl, skb, portid);
+	err = nlmsg_unicast(nfnlnet->nfnl, skb, portid);
 	if (err == -EAGAIN)
 		err = -ENOBUFS;
 
@@ -181,7 +200,9 @@ EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
 			 __u32 group, gfp_t allocation)
 {
-	netlink_broadcast(net->nfnl, skb, portid, group, allocation);
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+	netlink_broadcast(nfnlnet->nfnl, skb, portid, group, allocation);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_broadcast);
 
@@ -201,6 +222,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	type = nlh->nlmsg_type;
 replay:
 	rcu_read_lock();
+
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
 #ifdef CONFIG_MODULES
@@ -224,6 +246,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	{
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
+		struct nfnl_net *nfnlnet = nfnl_pernet(net);
 		u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 		struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 		struct nlattr *attr = (void *)nlh + min_len;
@@ -245,7 +268,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 
 		if (nc->call_rcu) {
-			err = nc->call_rcu(net, net->nfnl, skb, nlh,
+			err = nc->call_rcu(net, nfnlnet->nfnl, skb, nlh,
 					   (const struct nlattr **)cda,
 					   extack);
 			rcu_read_unlock();
@@ -256,7 +279,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			    nfnetlink_find_client(type, ss) != nc)
 				err = -EAGAIN;
 			else if (nc->call)
-				err = nc->call(net, net->nfnl, skb, nlh,
+				err = nc->call(net, nfnlnet->nfnl, skb, nlh,
 					       (const struct nlattr **)cda,
 					       extack);
 			else
@@ -460,7 +483,9 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				goto ack;
 
 			if (nc->call_batch) {
-				err = nc->call_batch(net, net->nfnl, skb, nlh,
+				struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+				err = nc->call_batch(net, nfnlnet->nfnl, skb, nlh,
 						     (const struct nlattr **)cda,
 						     &extack);
 			}
@@ -629,7 +654,7 @@ static int nfnetlink_bind(struct net *net, int group)
 
 static int __net_init nfnetlink_net_init(struct net *net)
 {
-	struct sock *nfnl;
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
 	struct netlink_kernel_cfg cfg = {
 		.groups	= NFNLGRP_MAX,
 		.input	= nfnetlink_rcv,
@@ -638,28 +663,29 @@ static int __net_init nfnetlink_net_init(struct net *net)
 #endif
 	};
 
-	nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
-	if (!nfnl)
+	nfnlnet->nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
+	if (!nfnlnet->nfnl)
 		return -ENOMEM;
-	net->nfnl_stash = nfnl;
-	rcu_assign_pointer(net->nfnl, nfnl);
 	return 0;
 }
 
 static void __net_exit nfnetlink_net_exit_batch(struct list_head *net_exit_list)
 {
+	struct nfnl_net *nfnlnet;
 	struct net *net;
 
-	list_for_each_entry(net, net_exit_list, exit_list)
-		RCU_INIT_POINTER(net->nfnl, NULL);
-	synchronize_net();
-	list_for_each_entry(net, net_exit_list, exit_list)
-		netlink_kernel_release(net->nfnl_stash);
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		nfnlnet = nfnl_pernet(net);
+
+		netlink_kernel_release(nfnlnet->nfnl);
+	}
 }
 
 static struct pernet_operations nfnetlink_net_ops = {
 	.init		= nfnetlink_net_init,
 	.exit_batch	= nfnetlink_net_exit_batch,
+	.id		= &nfnetlink_pernet_id,
+	.size		= sizeof(struct nfnl_net),
 };
 
 static int __init nfnetlink_init(void)
-- 
2.26.3

