Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5E5C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiBXQpt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiBXQps (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:45:48 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0A2159282
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:45:18 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nNHEy-0005ez-MR; Thu, 24 Feb 2022 17:45:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 6/7] netfilter: conntrack: include ecache dying list in dumps
Date:   Thu, 24 Feb 2022 17:44:45 +0100
Message-Id: <20220224164446.23208-7-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224164446.23208-1-fw@strlen.de>
References: <20220224164446.23208-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The new pernet dying list includes conntrack entries that await
delivery of the 'destroy' event via ctnetlink.

The old percpu dying list will be removed soon.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_ecache.h |  2 ++
 net/netfilter/nf_conntrack_ecache.c         | 10 ++++++
 net/netfilter/nf_conntrack_netlink.c        | 38 +++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index c63a8fc3225e..54051e663ff4 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -161,6 +161,8 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state);
 void nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
 
+struct nf_conntrack_net_ecache *nf_conn_pernet_ecache(const struct net *net);
+
 static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net)
 {
 	return net->ct.ecache_dwork_pending;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index be111218899d..ce3ebd420585 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -38,6 +38,16 @@ enum retry_state {
 	STATE_DONE,
 };
 
+struct nf_conntrack_net_ecache *nf_conn_pernet_ecache(const struct net *net)
+{
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
+
+	return &cnet->ecache;
+}
+#if IS_MODULE(CONFIG_NF_CT_NETLINK)
+EXPORT_SYMBOL_GPL(nf_conn_pernet_ecache);
+#endif
+
 static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 {
 	unsigned long stop = jiffies + ECACHE_MAX_JIFFIES;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 940bd13a7fca..44cad50ef67f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -62,6 +62,7 @@ struct ctnetlink_list_dump_ctx {
 	struct nf_conn *last;
 	unsigned int cpu;
 	bool done;
+	bool retrans_done;
 };
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -1802,6 +1803,43 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 static int
 ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
+	struct nf_conntrack_net_ecache *ecache_net;
+	const struct net *net = sock_net(skb->sk);
+	struct nf_conn *last = ctx->last;
+	struct nf_conntrack_tuple_hash *h;
+	struct hlist_nulls_node *n;
+
+	if (ctx->retrans_done)
+		return ctnetlink_dump_list(skb, cb, true);
+
+	ctx->last = NULL;
+	ecache_net = nf_conn_pernet_ecache(net);
+	spin_lock_bh(&ecache_net->dying_lock);
+
+	hlist_nulls_for_each_entry(h, n, &ecache_net->dying_list, hnnode) {
+		struct nf_conn *ct;
+		int res;
+
+		ct = nf_ct_tuplehash_to_ctrack(h);
+		if (last && last != ct)
+			continue;
+
+		res = ctnetlink_dump_one_entry(skb, cb, ct, true);
+		if (res < 0) {
+			spin_unlock_bh(&ecache_net->dying_lock);
+			nf_ct_put(last);
+			return skb->len;
+		}
+
+		nf_ct_put(last);
+		last = NULL;
+	}
+
+	ctx->retrans_done = true;
+	spin_unlock_bh(&ecache_net->dying_lock);
+	nf_ct_put(last);
+
 	return ctnetlink_dump_list(skb, cb, true);
 }
 
-- 
2.34.1

