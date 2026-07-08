Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB143ED101
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544077; cv=none; b=bI/R48gwO3iAs1/Y4ArDOhulvpve3aiFtJ9lG2cQ5LPqlplkq4GZfVQn7jBRkIwnkIbdKB6W1bPylyYDOKflTYJWY84vO2YEoPptXUeKOuMv3HT2WKcwPff0jhCYXtpNc3/2QzZq1LRauweKFQHwwYoF6qh1J3IwstdoTOn5rNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544077; c=relaxed/simple;
	bh=K41E6g0m+fII6bVTpp2miUntJRjDf5KNhqEOniqvHzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kV+rPI4mWsHI/fzwOlUzZJQzVqncH/iqeq9nQvdqDQgpwibnjYyvWAvTUOnKRK8ZX+SK/rF0KXYZEl0mjvJshv5UCyBbRzZKt9q3CqF7VzKqQHIy4Wsv4YuGCVfjbn/voHTUGKJ21ivxfYQl/Q28x3idHLXWqaeY/oI29qEN2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iG/mbXZn; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iG/mbXZn"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c125fbfbae0so22257566b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 13:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783544074; x=1784148874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4wpLh1Wx2k4+jwvP651bLUL6cNpgNwa+ZpxJAG9vl8E=;
        b=iG/mbXZncPQWBTYka8wjeeyR5a7mBr8RhdghSztVZISEkaEmZTR1GRTZhzYBqIDKWU
         kq27k2f52ZhAHoE2PE4fjzIJZZ9XZSpry/E/RSahAbx/6RS1KDgF2Psw5w3ztjO2ToDv
         enxv8VvRiTcndg7p3PD8LtalPH0MlKF0dZSGNXO4Hi6sjaxKeecpqhpTGyZLajXgXbs1
         uOCljjlRrcxnn6zq6NyYo5X1Alzw29BGVuIu4U8hHj+Xz3S9n4/1Ofma5gTu+/VH6VNN
         CeCer9J8LYvA8+G0mG3AxYvU4/ztMTWHtyWetH0hPGpFLJLq7pPQmCeGEawYKROQlSsP
         Yr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783544074; x=1784148874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4wpLh1Wx2k4+jwvP651bLUL6cNpgNwa+ZpxJAG9vl8E=;
        b=HdexEcmBukFXfN0BzqGlr/1twkwCK5qjR4YZk54QouYe3bCZ0yWboqoWdRB9Y3pky1
         sM2zb2+loPJn1XB0aw/28rvgzsim4wE53XZ4ifm53eSBONEnPKSprn5zUrky7+DjLpZE
         WIMYk3N9cph6V9yeP0LOo0wGirbL79azBKrSLfVTy2/yBgiyTaJ5uWH46zHhPOcJ/p56
         JwKc4aPwvrDyD0MtZhbZZFVIvVwO6y6t72twOkXMJloqL+LdA0buQYHw4fTnkz50wW1h
         TACATLrtzcP1lBw20mHVarectr2CEqbSrRZM1ANQaZVWZSP1Ak6nSVIoJcX/BGs6hYLK
         xuqQ==
X-Gm-Message-State: AOJu0YzdILJABH7dscmVmWGpznaHzImN6RTQnK1N97A5z9V96Fd8nn4P
	dj25chxeSFgtvMLjTvDlFzUFaRKoV2M1U4MSnMEJuhg+Mu8iDBOMFyj48VAsRBbL
X-Gm-Gg: AfdE7clnR8yGWmP5ncw4WJZtiU6O9/RM6VwULrF0F/FOF+wAKksiB5WPPlPZpyRTO5/
	t1k7Dom8cTfj+reZ60ifh49axl2/sewk74D4t144j0ezUxO199D4c8MFxH6897GWWlvIlrXQR9S
	wRGAh6+7luzeHnBeaTvj+69nvwih6DmYkT+9XJa74ta3WioAbhh4e9ZhwBHjfgAuNRsph56SRp7
	DGnIPUVfAOaX2uZPX8EY0GmlqO32wxlcMyJlHE384GfNOCVTIGRMvgc2Vb+BrrpwvpesBZfTJBD
	GGVcvpngGfG3w2skIM3BAt3BFdc0t+A8OZFUKeeUECiQdi+m3KpgWaDzCo3NgFXr8NMH/siFGVa
	nE3GcCHp+DyLjS4+fs6EaZxOS5bmDZaeYy6sqKg56iCWCcX+adBanE53p4QDqOk4boDbSWe6lyb
	OtUR8JldSzuQ==
X-Received: by 2002:a17:907:5c3:b0:c15:db89:f0a0 with SMTP id a640c23a62f3a-c15db89f6dcmr93362966b.50.1783544073568;
        Wed, 08 Jul 2026 13:54:33 -0700 (PDT)
Received: from azaki-desk1.. ([156.216.98.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15de6c565fsm63355066b.2.2026.07.08.13.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 13:54:33 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on FIB route changes
Date: Wed,  8 Jul 2026 14:54:04 -0600
Message-ID: <20260708205404.911832-1-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hardware-offloaded flows bypass the CPU and, unlike the software
datapath, dst_check() does not invalidate them when a route changes.
For ephemeral flows, this is usually not a problem as the flow expire on
its own and the driver clears the entry in the HW. However, for persistent
flows forwarded through the device, the HW is never informed that the
route has expired.

For tables marked with NF_FLOWTABLE_HW_OFFLOAD, listen to the per-net FIB
notifier chain and tear down the affected flows so they are re-evaluated by
the SW forwarding path.

A lockless list is used to reduce the work items overhead in case of a
route change storm allowing many FIB events to be processed by one work
item.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
---
 include/net/netfilter/nf_flow_table.h |   3 +
 net/netfilter/nf_flow_table_core.c    | 202 ++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7b23b245a5a8..7c36255f5a4f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -84,6 +84,9 @@ struct nf_flowtable {
 	struct flow_block		flow_block;
 	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
+	struct notifier_block		fib_nb;
+	struct work_struct		fib_work;
+	struct llist_head		fib_events;
 };
 
 static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 99c5b9d671a0..2c912056921a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -5,8 +5,12 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/llist.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
+#include <net/fib_notifier.h>
+#include <net/ip_fib.h>
+#include <net/ip6_fib.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -695,11 +699,179 @@ void nf_flow_dnat_port(const struct flow_offload *flow, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
 
+struct nf_flow_fib_match {
+	struct llist_node	*events;
+};
+
+struct nf_flow_fib_event {
+	struct llist_node	node;
+	u8			family;
+	u8			prefix_len;
+	union {
+		__be32		ip4;
+		struct in6_addr	ip6;
+	} addr;
+};
+
+static bool nf_flow_fib_tuple_match(const struct flow_offload_tuple *tuple,
+				    const struct nf_flow_fib_event *ev)
+{
+	if (tuple->l3proto != ev->family)
+		return false;
+
+	switch (ev->family) {
+	case NFPROTO_IPV4: {
+		__be32 mask = ev->prefix_len ?
+			htonl(~0u << (32 - ev->prefix_len)) : 0;
+		return (tuple->dst_v4.s_addr & mask) == (ev->addr.ip4 & mask);
+	}
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		return ipv6_prefix_equal(&tuple->dst_v6, &ev->addr.ip6,
+					 ev->prefix_len);
+#endif
+	default:
+		return false;
+	}
+}
+
+static bool nf_flow_fib_flow_match(const struct flow_offload *flow,
+				   const struct nf_flow_fib_match *m)
+{
+	const struct flow_offload_tuple *orig, *reply;
+	const struct nf_flow_fib_event *ev;
+	struct llist_node *node;
+
+	orig  = &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
+	reply = &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple;
+
+	for (node = m->events; node; node = node->next) {
+		ev = llist_entry(node, struct nf_flow_fib_event, node);
+		if (nf_flow_fib_tuple_match(orig, ev) ||
+		    nf_flow_fib_tuple_match(reply, ev))
+			return true;
+	}
+
+	return false;
+}
+
+static void nf_flow_offload_fib_cb(struct nf_flowtable *flow_table,
+				   struct flow_offload *flow, void *data)
+{
+	const struct nf_flow_fib_match *m = data;
+
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		return;
+
+	if (nf_flow_fib_flow_match(flow, m))
+		flow_offload_teardown(flow);
+}
+
+static void nf_flow_table_fib_work(struct work_struct *work)
+{
+	struct nf_flowtable *flow_table =
+		container_of(work, struct nf_flowtable, fib_work);
+	struct nf_flow_fib_event *ev, *next;
+	struct nf_flow_fib_match m = {};
+	struct llist_node *events;
+
+	events = llist_del_all(&flow_table->fib_events);
+	if (!events)
+		return;
+
+	m.events = events;
+	nf_flow_table_iterate(flow_table, nf_flow_offload_fib_cb, &m);
+
+	llist_for_each_entry_safe(ev, next, events, node)
+		kfree(ev);
+}
+
+static bool nf_flowtable_fib_family_match(const struct nf_flowtable *flowtable,
+					  u8 event_family)
+{
+	switch (flowtable->type->family) {
+	case NFPROTO_IPV4:
+		return event_family == NFPROTO_IPV4;
+	case NFPROTO_IPV6:
+		return event_family == NFPROTO_IPV6;
+	case NFPROTO_INET:
+		return event_family == NFPROTO_IPV4 ||
+		       event_family == NFPROTO_IPV6;
+	default:
+		return false;
+	}
+}
+
+/* Called with rcu_read_lock() */
+static int nf_flow_table_fib_event(struct notifier_block *nb,
+				   unsigned long event, void *ptr)
+{
+	struct nf_flowtable *flow_table =
+		container_of(nb, struct nf_flowtable, fib_nb);
+	struct fib_notifier_info *info = ptr;
+	struct nf_flow_fib_event *ev;
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+	case FIB_EVENT_ENTRY_APPEND:
+	case FIB_EVENT_ENTRY_DEL:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	/* Skip events for an address family this table cannot hold. */
+	if (!nf_flowtable_fib_family_match(flow_table, info->family))
+		return NOTIFY_DONE;
+
+	ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
+	if (!ev)
+		return NOTIFY_DONE;
+
+	switch (info->family) {
+	case NFPROTO_IPV4:
+		struct fib_entry_notifier_info *fen;
+
+		fen = container_of(info, struct fib_entry_notifier_info, info);
+		ev->family     = NFPROTO_IPV4;
+		ev->addr.ip4   = htonl(fen->dst);
+		ev->prefix_len = fen->dst_len;
+		break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		struct fib6_entry_notifier_info *fen6;
+
+		fen6 = container_of(info, struct fib6_entry_notifier_info, info);
+		if (!fen6->rt)
+			goto err;
+
+		ev->family     = NFPROTO_IPV6;
+		ev->addr.ip6   = fen6->rt->fib6_dst.addr;
+		ev->prefix_len = fen6->rt->fib6_dst.plen;
+		break;
+#endif
+	default:
+		goto err;
+	}
+
+	llist_add(&ev->node, &flow_table->fib_events);
+	queue_work(system_power_efficient_wq, &flow_table->fib_work);
+	return NOTIFY_DONE;
+
+err:
+	kfree(ev);
+	return NOTIFY_DONE;
+}
+
 int nf_flow_table_init(struct nf_flowtable *flowtable)
 {
+	struct net *net = read_pnet(&flowtable->net);
 	int err;
 
 	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
+	INIT_WORK(&flowtable->fib_work, nf_flow_table_fib_work);
+	init_llist_head(&flowtable->fib_events);
 	flow_block_init(&flowtable->flow_block);
 	init_rwsem(&flowtable->flow_block_lock);
 
@@ -711,11 +883,24 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 	queue_delayed_work(system_power_efficient_wq,
 			   &flowtable->gc_work, HZ);
 
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flowtable->fib_nb.notifier_call = nf_flow_table_fib_event;
+		err = register_fib_notifier(net, &flowtable->fib_nb,
+					    NULL, NULL);
+		if (err < 0)
+			goto err_fib;
+	}
+
 	mutex_lock(&flowtable_lock);
 	list_add(&flowtable->list, &flowtables);
 	mutex_unlock(&flowtable_lock);
 
 	return 0;
+
+err_fib:
+	cancel_delayed_work_sync(&flowtable->gc_work);
+	rhashtable_destroy(&flowtable->rhashtable);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_init);
 
@@ -754,8 +939,25 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static void nf_flow_table_fib_drain(struct nf_flowtable *flow_table)
+{
+	struct nf_flow_fib_event *ev, *next;
+	struct llist_node *events;
+
+	events = llist_del_all(&flow_table->fib_events);
+	llist_for_each_entry_safe(ev, next, events, node)
+		kfree(ev);
+}
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
+	if (nf_flowtable_hw_offload(flow_table)) {
+		unregister_fib_notifier(read_pnet(&flow_table->net),
+					&flow_table->fib_nb);
+		cancel_work_sync(&flow_table->fib_work);
+		nf_flow_table_fib_drain(flow_table);
+	}
+
 	mutex_lock(&flowtable_lock);
 	list_del(&flow_table->list);
 	mutex_unlock(&flowtable_lock);
-- 
2.43.0

