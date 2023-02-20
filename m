Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4932C05027
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Feb 2023 16:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBTQYP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Feb 2023 11:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjBTQYP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Feb 2023 11:24:15 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881051D90A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Feb 2023 08:24:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pU8xX-0001Nl-Av; Mon, 20 Feb 2023 17:24:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Bryce Kahle <bryce.kahle@datadoghq.com>
Subject: [PATCH nf] netfilter: ctnetlink: make event listener tracking global
Date:   Mon, 20 Feb 2023 17:24:00 +0100
Message-Id: <20230220162400.7234-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pernet tracking doesn't work correctly because other netns might have
set NETLINK_LISTEN_ALL_NSID on its event socket.

In this case its expected that events originating in other net
namespaces are also received.

Making pernet-tracking work while also honoring NETLINK_LISTEN_ALL_NSID
requires much more intrusive changes both in netlink and nfnetlink,
f.e. adding a 'setsockopt' callback that lets nfnetlink know that the
event socket entered (or left) ALL_NSID mode.

Move to global tracking instead: if there is an event socket anywhere
on the system, all net namespaces which have conntrack enabled and
use autobind mode will allocate the ecache extension.

netlink_has_listeners() returns false only if the given group has no
subscribers in any net namespace, the 'net' argument passed to
nfnetlink_has_listeners is only used to derive the protocol (nfnetlink),
it has no other effect.

For proper NETLINK_LISTEN_ALL_NSID-aware pernet tracking of event
listeners a new netlink_has_net_listeners() is also needed.

Fixes: 90d1daa45849 ("netfilter: conntrack: add nf_conntrack_events autodetect mode")
Reported-by: Bryce Kahle <bryce.kahle@datadoghq.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h           | 5 +++++
 include/net/netns/conntrack.h       | 1 -
 net/netfilter/core.c                | 3 +++
 net/netfilter/nf_conntrack_ecache.c | 2 +-
 net/netfilter/nfnetlink.c           | 9 +++++----
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d8817d381c14..bef8db9d6c08 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -488,4 +488,9 @@ extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
+/**
+ * Contains bitmask of ctnetlink event subscribers, if any.
+ * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
+ */
+extern u8 nf_ctnetlink_has_listener;
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e1290c159184..1f463b3957c7 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,7 +95,6 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	u8 ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5a6705a0e4ec..6e80f0f6149e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -669,6 +669,9 @@ const struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+u8 nf_ctnetlink_has_listener;
+EXPORT_SYMBOL_GPL(nf_ctnetlink_has_listener);
+
 const struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 8698b3424646..69948e1d6974 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -309,7 +309,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 			break;
 		return true;
 	case 2: /* autodetect: no event listener, don't allocate extension. */
-		if (!READ_ONCE(net->ct.ctnetlink_has_listener))
+		if (!READ_ONCE(nf_ctnetlink_has_listener))
 			return true;
 		fallthrough;
 	case 1:
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 6d18fb346868..81c7737c803a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -29,6 +29,7 @@
 
 #include <net/netlink.h>
 #include <net/netns/generic.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 
 MODULE_LICENSE("GPL");
@@ -685,12 +686,12 @@ static void nfnetlink_bind_event(struct net *net, unsigned int group)
 	group_bit = (1 << group);
 
 	spin_lock(&nfnl_grp_active_lock);
-	v = READ_ONCE(net->ct.ctnetlink_has_listener);
+	v = READ_ONCE(nf_ctnetlink_has_listener);
 	if ((v & group_bit) == 0) {
 		v |= group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 
 	spin_unlock(&nfnl_grp_active_lock);
@@ -744,12 +745,12 @@ static void nfnetlink_unbind(struct net *net, int group)
 
 	spin_lock(&nfnl_grp_active_lock);
 	if (!nfnetlink_has_listeners(net, group)) {
-		u8 v = READ_ONCE(net->ct.ctnetlink_has_listener);
+		u8 v = READ_ONCE(nf_ctnetlink_has_listener);
 
 		v &= ~group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 	spin_unlock(&nfnl_grp_active_lock);
 #endif
-- 
2.39.2

