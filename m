Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063F33B6DB
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774384893; cv=none; b=l6DbsuLMS6agxZrQs5+IEoSAvwTacMTRFBc5ogtWFeI0niuQmJxvIkzCki7PKalUeyvg/ekNWBhdqqhrAs1BZ7Vwnc6CdgblX0celQN3WbNxmui6PZOdIAM9xbjpUdInNxaOmRflNLhjzi2JGoObWBa+ViJbf/lk3byhVp3drXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774384893; c=relaxed/simple;
	bh=OMzMv0TSgnhZtLvwhP+BHffFyvt+TSPyAeE/6RqIn8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYia12zNEIAJ5uLmFcXYORNrB3km/9W2kp6DEqEqAbBiFf87emwxcYoGDfNXtmltxaKvv91d/D5AOxvM65Hn0mR9ZE7ueHOvsUFINdGetF8d71y6A1kfpTvGG6MoLG7D3okc5WnVcuJ78V9VuQHewxoxFa7+3Vta2MrFg1vrdFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iAKtSEfZ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iAKtSEfZ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-486507134e4so21093265e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 13:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774384887; x=1774989687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0C5qZvIKcbCB9gIop4y1SIVtOCb4Lm6XlWELeubUrQ=;
        b=iAKtSEfZS2/Or6UT5n+zWYVaGk0wFOcjtJF3ZUI3b0H13o8I5B9nQsADOUJ2dxc30U
         mUeRNaV4Acp0+Ng/8Q6vjIiBk81zBdsg3ag9LhtHsK/mQzYrxEO+C2lKTgzVcSf0Vsos
         s9lSr+qtoKWRT/M2yzQQ0Ra4eVSoz2MpfLGatyDKotQ06ZSRAimZrDk0xQK2Z2jWVWZv
         RQKQE5L+LVJNpTT9dqY5FgQ1HRrtb+6LgN5PmdERvArgYlJhNvxswkDYB0iADDq4pssf
         csStCGtImcViBTAauFGJKYR+By+VWli50k2+/J1T2FJGtcIgu9VDAuAxNYJsGR08KAbP
         f2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774384887; x=1774989687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D0C5qZvIKcbCB9gIop4y1SIVtOCb4Lm6XlWELeubUrQ=;
        b=su+53+IhZLH+2OBtzAftElv7ggxSRTsL0VUoemAiuS+vXQfudfPApaOOv6YDNDxTkA
         NTZRliv9eUHWhVFBIarOsvAXNFyFzGmLnM/up1CPw/iTAKnbfMx5QsFzFoGV7q8gT/ui
         rkfNbdm0cR02Iq1lErJdAdyidU1Win3APTQihV7N6+2jkhKw8igWP7Z48DfJWONwKhjr
         0YjYJ9DQE7NiTjP5QpaqFpx1QihfWewn+J0CuXGI5tE3BCu8QRu7PpV+RhuTCc/HM+LK
         qTOPVGthY9cUyPQSUrqpGqxeZrYj3hv4ibm52uYTv8PtUGHfm086d1Y+FYcG4LkyJAv1
         wSlA==
X-Gm-Message-State: AOJu0Yz4Q3K6vwmFfjdU6p8OHaddZhrCmznJKMS9hEsdHUZ9YEjGjZnt
	O9GjB4JuVL6NYDUv/Zngsw+aMq08/+ci1vnw5spHoQ4DPwHFo/LAfqKgojb9b0vRPwxoCw==
X-Gm-Gg: ATEYQzzzwSmx0cVGKR77yxFu0TMAyK+bptpZo+1LFHDF8+hFx2+IqvQ246MvTtnxwyA
	9U4fKr8R5c6o5mf8jTE5EgWNcgJgVCgKUD+rwx+ayfPqYjPOcvZNvw1HCWRx9ESMRTa4EyNr6nt
	R1PfBVkP3HUnqG5gxA2UApQ/2AXYHdAi6jB6PUL8OmZQ0ucChNHu/qVqa6h9iyT9tDzifep+NrN
	lDaIZIJ/OdoJLJb0ZTRvPe2Ic5yCmSCJMo11V5thiOz1VWa+Vn/IVXa9BmkHn5uEYaZztq6qWL8
	qD68CSAhrM2urnEGgz8/RD+2msF1XxmQrSjhhIDgr3Tk4jtKqa1+WOTc7f7G0v/PjzwO60YVts4
	jcSevzIB1LObvBjWr5gFCAJd7XhSr5f2eAbxFfBsKNajMu53yepLkdIkebQYear02fOrdZ5eq/g
	COXIcYH8smFM7bvbHiTwH6
X-Received: by 2002:a05:600c:4685:b0:486:5f71:5829 with SMTP id 5b1f17b1804b1-48715fc3870mr17265075e9.5.1774384886440;
        Tue, 24 Mar 2026 13:41:26 -0700 (PDT)
Received: from azaki-desk1.. ([41.234.201.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48716658352sm3686825e9.13.2026.03.24.13.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 13:41:25 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	pablo@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v2 1/2] netfilter: flowtable: update netdev stats with HW_OFFLOAD flows
Date: Tue, 24 Mar 2026 14:40:15 -0600
Message-ID: <20260324204016.2089193-2-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260324204016.2089193-1-anzaki@gmail.com>
References: <20260324204016.2089193-1-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some drivers (notably DSA) delegate the nft flowtable HW_OFFLOAD flows
to a parent driver. While the parent driver is able to report the
offloaded traffic stats directly from the HW, the delegating driver
does not report the stats. This fails SNMP-based monitoring tools that
rely on netdev stats to report the network traffic.

Add a new struct pcpu_sw_netstats "fstats" to net_device that gets
allocated only if the new flag "flow_offload_via_parent" is set by the
driver. The new stats are lazily allocated by the nft flow offloading
code when the first flow is offloaded. The stats are updated periodically
in flow_offload_work_stats() and also once in flow_offload_work_del()
before the flow is deleted. For this, flow_offload_work_del() had to
be moved below flow_offload_tuple_stats().

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
---
 include/linux/netdevice.h             | 45 ++++++++++++
 net/core/dev.c                        |  8 +++
 net/netfilter/nf_flow_table_offload.c | 98 +++++++++++++++++++++++++--
 3 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 67e25f6d15a4..647758f78213 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1840,6 +1840,11 @@ enum netdev_reg_state {
  *	@stats:		Statistics struct, which was left as a legacy, use
  *			rtnl_link_stats64 instead
  *
+ *	@fstats:	HW offloaded flow statistics: RX/TX packets,
+ *			RX/TX bytes. Lazily allocated by the flow offload
+ *			path on the first offloaded flow for devices that
+ *			set @flow_offload_via_parent. Freed by free_netdev().
+ *
  *	@core_stats:	core networking counters,
  *			do not use this in drivers
  *	@carrier_up_count:	Number of times the carrier has been up
@@ -2048,6 +2053,12 @@ enum netdev_reg_state {
  *	@change_proto_down: device supports setting carrier via IFLA_PROTO_DOWN
  *	@netns_immutable: interface can't change network namespaces
  *	@fcoe_mtu:	device supports maximum FCoE MTU, 2158 bytes
+ *	@flow_offload_via_parent: device delegates nft flowtable hardware
+ *				  offload to a parent/conduit device (e.g. DSA
+ *				  user ports delegate to their conduit MAC).
+ *				  The parent's HW count the offloaded traffic
+ *				  but this device's sw netstats path does not.
+ *				  @fstats is allocated to fill that gap.
  *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
@@ -2233,6 +2244,7 @@ struct net_device {
 
 	struct net_device_stats	stats; /* not used by modern drivers */
 
+	struct pcpu_sw_netstats __percpu *fstats;
 	struct net_device_core_stats __percpu *core_stats;
 
 	/* Stats to monitor link on/off, flapping */
@@ -2463,6 +2475,7 @@ struct net_device {
 	unsigned long		change_proto_down:1;
 	unsigned long		netns_immutable:1;
 	unsigned long		fcoe_mtu:1;
+	unsigned long		flow_offload_via_parent:1;
 
 	struct list_head	net_notifier_list;
 
@@ -2992,6 +3005,38 @@ struct pcpu_lstats {
 
 void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes);
 
+static inline void dev_fstats_rx_add(struct net_device *dev,
+				     unsigned int packets,
+				     unsigned int len)
+{
+	struct pcpu_sw_netstats *fstats;
+
+	if (!dev->fstats)
+		return;
+
+	fstats = this_cpu_ptr(dev->fstats);
+	u64_stats_update_begin(&fstats->syncp);
+	u64_stats_add(&fstats->rx_bytes, len);
+	u64_stats_add(&fstats->rx_packets, packets);
+	u64_stats_update_end(&fstats->syncp);
+}
+
+static inline void dev_fstats_tx_add(struct net_device *dev,
+				     unsigned int packets,
+				     unsigned int len)
+{
+	struct pcpu_sw_netstats *fstats;
+
+	if (!dev->fstats)
+		return;
+
+	fstats = this_cpu_ptr(dev->fstats);
+	u64_stats_update_begin(&fstats->syncp);
+	u64_stats_add(&fstats->tx_bytes, len);
+	u64_stats_add(&fstats->tx_packets, packets);
+	u64_stats_update_end(&fstats->syncp);
+}
+
 static inline void dev_sw_netstats_rx_add(struct net_device *dev, unsigned int len)
 {
 	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
diff --git a/net/core/dev.c b/net/core/dev.c
index f48dc299e4b2..07fb315ad42c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11865,6 +11865,7 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	const struct net_device_core_stats __percpu *p;
+	const struct pcpu_sw_netstats __percpu *fstats;
 
 	/*
 	 * IPv{4,6} and udp tunnels share common stat helpers and use
@@ -11893,6 +11894,11 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 		netdev_stats_to_stats64(storage, &dev->stats);
 	}
 
+	/* This READ_ONCE() pairs with cmpxchg in flow_offload_fstats_ensure() */
+	fstats = READ_ONCE(dev->fstats);
+	if (fstats)
+		dev_fetch_sw_netstats(storage, fstats);
+
 	/* This READ_ONCE() pairs with the write in netdev_core_stats_alloc() */
 	p = READ_ONCE(dev->core_stats);
 	if (p) {
@@ -12212,6 +12218,8 @@ void free_netdev(struct net_device *dev)
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
 #endif
+	free_percpu(dev->fstats);
+	dev->fstats = NULL;
 	free_percpu(dev->core_stats);
 	dev->core_stats = NULL;
 	free_percpu(dev->xdp_bulkq);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b2e4fb6fa011..fc1e67a79904 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -925,13 +925,80 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	nf_flow_offload_destroy(flow_rule);
 }
 
-static void flow_offload_work_del(struct flow_offload_work *offload)
+static bool flow_offload_fstats_ensure(struct net_device *dev)
 {
-	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+	struct pcpu_sw_netstats __percpu *p;
+
+	if (!dev->flow_offload_via_parent)
+		return false;
+
+	/* Pairs with cmpxchg() below. */
+	if (likely(READ_ONCE(dev->fstats)))
+		return true;
+
+	p = __netdev_alloc_pcpu_stats(struct pcpu_sw_netstats, GFP_ATOMIC);
+	if (!p)
+		return false;
+
+	if (cmpxchg(&dev->fstats, NULL, p))
+		free_percpu(p);	/* lost the race, discard and use winner's */
+
+	return true;
+}
+
+static u32 flow_offload_egress_ifidx(const struct flow_offload_tuple *tuple)
+{
+	switch (tuple->xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		return tuple->ifidx;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		return tuple->out.ifidx;
+	default:
+		return 0;
+	}
+}
+
+static void flow_offload_netdev_update(struct flow_offload_work *offload,
+				       struct flow_stats *stats)
+{
+	const struct flow_offload_tuple *tuple;
+	struct net_device *indev, *outdev;
+	struct net *net;
+
+	rcu_read_lock();
+	net = read_pnet(&offload->flowtable->net);
+	if (stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts) {
+		tuple = &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple;
+		indev = dev_get_by_index_rcu(net, tuple->iifidx);
+		if (indev && flow_offload_fstats_ensure(indev))
+			dev_fstats_rx_add(indev,
+					  stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts,
+					  stats[FLOW_OFFLOAD_DIR_ORIGINAL].bytes);
+
+		outdev = dev_get_by_index_rcu(net,
+					      flow_offload_egress_ifidx(tuple));
+		if (outdev && flow_offload_fstats_ensure(outdev))
+			dev_fstats_tx_add(outdev,
+					  stats[FLOW_OFFLOAD_DIR_ORIGINAL].pkts,
+					  stats[FLOW_OFFLOAD_DIR_ORIGINAL].bytes);
+	}
+
+	if (stats[FLOW_OFFLOAD_DIR_REPLY].pkts) {
+		tuple = &offload->flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple;
+		indev = dev_get_by_index_rcu(net, tuple->iifidx);
+		if (indev && flow_offload_fstats_ensure(indev))
+			dev_fstats_rx_add(indev,
+					  stats[FLOW_OFFLOAD_DIR_REPLY].pkts,
+					  stats[FLOW_OFFLOAD_DIR_REPLY].bytes);
+
+		outdev = dev_get_by_index_rcu(net,
+					      flow_offload_egress_ifidx(tuple));
+		if (outdev && flow_offload_fstats_ensure(outdev))
+			dev_fstats_tx_add(outdev,
+					  stats[FLOW_OFFLOAD_DIR_REPLY].pkts,
+					  stats[FLOW_OFFLOAD_DIR_REPLY].bytes);
+	}
+	rcu_read_unlock();
 }
 
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
@@ -968,6 +1035,25 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 				       FLOW_OFFLOAD_DIR_REPLY,
 				       stats[1].pkts, stats[1].bytes);
 	}
+
+	flow_offload_netdev_update(offload, stats);
+}
+
+static void flow_offload_work_del(struct flow_offload_work *offload)
+{
+	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
+
+	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
+					 &stats[1]);
+	flow_offload_netdev_update(offload, stats);
+
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
 static void flow_offload_work_handler(struct work_struct *work)
-- 
2.43.0

