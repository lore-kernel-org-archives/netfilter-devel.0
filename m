Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B15C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiDYNTB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiDYNTA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:19:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D37D17E0A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:15:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1niyZG-00045L-LQ; Mon, 25 Apr 2022 15:15:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/4] netfilter: nfnetlink: allow to detect if ctnetlink listeners exist
Date:   Mon, 25 Apr 2022 15:15:41 +0200
Message-Id: <20220425131544.27860-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425131544.27860-1-fw@strlen.de>
References: <20220425131544.27860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time, every new conntrack gets the 'event cache extension'
enabled for it.

This is because the 'net.netfilter.nf_conntrack_events' sysctl defaults
to 1.

Changing the default to 0 means that commands that rely on the event
notification extension, e.g. 'conntrack -E' or conntrackd, stop working.

We COULD detect if there is a listener by means of
'nfnetlink_has_listeners()' and only add the extension if this is true.

The downside is a dependency from conntrack module to nfnetlink module.

This adds a different way: inc/dec a counter whenever a ctnetlink group
is being (un)subscribed and toggle a flag in struct net.

Next patches will take advantage of this and will only add the event
extension if the flag is set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netns/conntrack.h |  1 +
 net/netfilter/nfnetlink.c     | 40 ++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index a71cfd4e2f21..0677cd3de034 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,6 +95,7 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+	bool ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7e2c8dd01408..ad3bbe34ca88 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -45,6 +45,7 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 static unsigned int nfnetlink_pernet_id __read_mostly;
 
 struct nfnl_net {
+	unsigned int ctnetlink_listeners;
 	struct sock *nfnl;
 };
 
@@ -654,7 +655,6 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 		netlink_rcv_skb(skb, nfnetlink_rcv_msg);
 }
 
-#ifdef CONFIG_MODULES
 static int nfnetlink_bind(struct net *net, int group)
 {
 	const struct nfnetlink_subsystem *ss;
@@ -670,9 +670,44 @@ static int nfnetlink_bind(struct net *net, int group)
 	rcu_read_unlock();
 	if (!ss)
 		request_module_nowait("nfnetlink-subsys-%d", type);
+
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (type == NFNL_SUBSYS_CTNETLINK) {
+		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+
+		if (WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == UINT_MAX)) {
+			nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+			return -EOVERFLOW;
+		}
+
+		nfnlnet->ctnetlink_listeners++;
+		if (nfnlnet->ctnetlink_listeners == 1)
+			WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+	}
+#endif
 	return 0;
 }
+
+static void nfnetlink_unbind(struct net *net, int group)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	int type = nfnl_group2type[group];
+
+	if (type == NFNL_SUBSYS_CTNETLINK) {
+		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+		WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0);
+		nfnlnet->ctnetlink_listeners--;
+		if (nfnlnet->ctnetlink_listeners == 0)
+			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
+	}
 #endif
+}
 
 static int __net_init nfnetlink_net_init(struct net *net)
 {
@@ -680,9 +715,8 @@ static int __net_init nfnetlink_net_init(struct net *net)
 	struct netlink_kernel_cfg cfg = {
 		.groups	= NFNLGRP_MAX,
 		.input	= nfnetlink_rcv,
-#ifdef CONFIG_MODULES
 		.bind	= nfnetlink_bind,
-#endif
+		.unbind	= nfnetlink_unbind,
 	};
 
 	nfnlnet->nfnl = netlink_kernel_create(net, NETLINK_NETFILTER, &cfg);
-- 
2.35.1

