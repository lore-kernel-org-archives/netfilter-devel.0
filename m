Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1D6C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Mar 2022 13:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbiCWNX6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 09:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244251AbiCWNX5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 09:23:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45BD7CDFD
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2022 06:22:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nX0wU-00013w-EU; Wed, 23 Mar 2022 14:22:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 01/16] nfnetlink: handle already-released nl socket
Date:   Wed, 23 Mar 2022 14:21:59 +0100
Message-Id: <20220323132214.6700-2-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220323132214.6700-1-fw@strlen.de>
References: <20220323132214.6700-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time upper layer, e.g. nf_conntrack_event, has to make sure that
its pernet exit handler runs before the nfnetlink one, otherwise we get a
crash if kernel tries to send a conntrack event after the nfnetlink netns
exit handler did close the socket already.

In order to move nf_conntrack_ecache to global (not pernet) netns event
pointer again the nfnetlink apis need to survive attempts to send a netlink
message after the socket has been destroyed in nfnetlink netns exit
function.

Set the pernet socket to null in the pre_exit handler and close it in the
exit_batch handler via a 'stash' pointer.

All functions now check nlsk for NULL before using it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 62 +++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..6105dc9b8f8e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -46,6 +46,7 @@ static unsigned int nfnetlink_pernet_id __read_mostly;
 
 struct nfnl_net {
 	struct sock *nfnl;
+	struct sock *nfnl_stash;
 };
 
 static struct {
@@ -160,37 +161,56 @@ nfnetlink_find_client(u16 type, const struct nfnetlink_subsystem *ss)
 	return &ss->cb[cb_id];
 }
 
-int nfnetlink_has_listeners(struct net *net, unsigned int group)
+static struct sock *nfnl_pernet_sk(struct net *net)
 {
 	struct nfnl_net *nfnlnet = nfnl_pernet(net);
 
-	return netlink_has_listeners(nfnlnet->nfnl, group);
+	return READ_ONCE(nfnlnet->nfnl);
+}
+
+int nfnetlink_has_listeners(struct net *net, unsigned int group)
+{
+	struct sock *nlsk = nfnl_pernet_sk(net);
+
+	return nlsk ? netlink_has_listeners(nlsk, group) : 0;
 }
 EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 
 int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags)
 {
-	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	struct sock *nlsk = nfnl_pernet_sk(net);
+
+	if (nlsk)
+		return nlmsg_notify(nlsk, skb, portid, group, echo, flags);
 
-	return nlmsg_notify(nfnlnet->nfnl, skb, portid, group, echo, flags);
+	/* nlsk already gone? This happens when .pre_exit was already called,
+	 * return 0, we can't retry.
+	 */
+	kfree_skb(skb);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error)
 {
-	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	struct sock *nlsk = nfnl_pernet_sk(net);
 
-	return netlink_set_err(nfnlnet->nfnl, portid, group, error);
+	return nlsk ? netlink_set_err(nlsk, portid, group, error) : 0;
 }
 EXPORT_SYMBOL_GPL(nfnetlink_set_err);
 
 int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 {
-	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	struct sock *nlsk = nfnl_pernet_sk(net);
 	int err;
 
-	err = nlmsg_unicast(nfnlnet->nfnl, skb, portid);
+	if (!nlsk) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	err = nlmsg_unicast(nlsk, skb, portid);
 	if (err == -EAGAIN)
 		err = -ENOBUFS;
 
@@ -201,9 +221,12 @@ EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 void nfnetlink_broadcast(struct net *net, struct sk_buff *skb, __u32 portid,
 			 __u32 group, gfp_t allocation)
 {
-	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	struct sock *nlsk = nfnl_pernet_sk(net);
 
-	netlink_broadcast(nfnlnet->nfnl, skb, portid, group, allocation);
+	if (nlsk)
+		netlink_broadcast(nlsk, skb, portid, group, allocation);
+	else
+		kfree_skb(skb);
 }
 EXPORT_SYMBOL_GPL(nfnetlink_broadcast);
 
@@ -247,7 +270,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	{
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
-		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+		struct sock *nlsk = nfnl_pernet_sk(net);
 		u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 		struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 		struct nlattr *attr = (void *)nlh + min_len;
@@ -255,7 +278,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		__u8 subsys_id = NFNL_SUBSYS_ID(type);
 		struct nfnl_info info = {
 			.net	= net,
-			.sk	= nfnlnet->nfnl,
+			.sk	= nlsk,
 			.nlh	= nlh,
 			.nfmsg	= nlmsg_data(nlh),
 			.extack	= extack,
@@ -484,14 +507,14 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		{
 			int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
-			struct nfnl_net *nfnlnet = nfnl_pernet(net);
+			struct sock *nlsk = nfnl_pernet_sk(net);
 			struct nlattr *cda[NFNL_MAX_ATTR_COUNT + 1];
 			struct nlattr *attr = (void *)nlh + min_len;
 			u8 cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 			int attrlen = nlh->nlmsg_len - min_len;
 			struct nfnl_info info = {
 				.net	= net,
-				.sk	= nfnlnet->nfnl,
+				.sk	= nlsk,
 				.nlh	= nlh,
 				.nfmsg	= nlmsg_data(nlh),
 				.extack	= &extack,
@@ -699,12 +722,21 @@ static void __net_exit nfnetlink_net_exit_batch(struct list_head *net_exit_list)
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nfnlnet = nfnl_pernet(net);
 
-		netlink_kernel_release(nfnlnet->nfnl);
+		netlink_kernel_release(nfnlnet->nfnl_stash);
 	}
 }
 
+static void __net_exit nfnetlink_net_pre_exit(struct net *net)
+{
+	struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+	nfnlnet->nfnl_stash = nfnlnet->nfnl;
+	WRITE_ONCE(nfnlnet->nfnl, NULL);
+}
+
 static struct pernet_operations nfnetlink_net_ops = {
 	.init		= nfnetlink_net_init,
+	.pre_exit	= nfnetlink_net_pre_exit,
 	.exit_batch	= nfnetlink_net_exit_batch,
 	.id		= &nfnetlink_pernet_id,
 	.size		= sizeof(struct nfnl_net),
-- 
2.34.1

