Received: from mail-ej2-f7.google.com (mail-ej2-f7.google.com [74.125.228.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85C3B5306
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 07:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370750; cv=none; b=Fv2i83nipWfWPv3xJxpKDeaS5momYW7lD08aI9/VQDdFjM3KomZMyTJKKjAsz9lhILj5K2y2sFjiLipeIA0hiL55elZEU+THReLPduPjvPjSj6QOCFW3CZUeZmKHkQLfCCVCok5ZlFNABuZhk/rLcjrCRY3XmsDtW9Hf86qUQAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370750; c=relaxed/simple;
	bh=kcwq5jHdZeuG41N7rWWFHxJH5chucBn8To4fJjolDnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOwrvE/Ffbiz0nhnLhsOR2RqHBoBGmHBv7dYqTJVcmWVueRfGALYpzHPvMtqXbClAJUHshrzQ3OA3fWrXKmKta893wCfNXIr1EtWDl+MynKzlAy9bDToHfiWchrbIJTgkypaWyu0vPO8vPp+TlE0L4ktBALUuk6zg0/9FicHK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=T3uslyHt; arc=none smtp.client-ip=74.125.228.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="T3uslyHt"
Received: by mail-ej2-f7.google.com with SMTP id a640c23a62f3a-c28e3998eb7so183527066b.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2026 00:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789370746; x=1789975546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ceo0ED4s78P+Qpn8F5qpHashyiiY84+5gnXgT5bbA0k=;
        b=T3uslyHt3XUUtpNtAyXaMybiwoa1hxwKIahH7GoIv6dQD55C9rcFGHOsqvRAIoIQcr
         RLkKuD8j3HA/VmXHlCdZVvbLvpwi6R2guR/vwOIBrrgX6pqNChoGoQWUQ/yPwIPg5rx0
         YLpITx0VL6pAKhXL1LDLkAY28RpB1zvLnDoZo4vdqd6huxLcFkh/PawjmpO2DDPVCDKV
         cyUH2gbfPpXkz46M6oJgxBvNwCARMjPB0CPFtYM71ebUhCqYJeclNmQ/lVuTwUeJjjHM
         IvEczwQJwLXXvfYBfRjTDrD+vMjqMuwBW1iqxwSy/WTP8BzJ34AZxUc1a3qHhQnLqg2Z
         ggVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789370746; x=1789975546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ceo0ED4s78P+Qpn8F5qpHashyiiY84+5gnXgT5bbA0k=;
        b=G4dA++KC4Eti36OB19qzO89cXCjsRuqsDiYob1jK1INf1lqVBDW8NY6OHZG6p7k1eK
         7ePrM8/nAPoVLho6KmhpbirUvuEKZ17WyhXAv8MJcAd7SgLC5ivdp7eOyToP9Kpl8ZxK
         tTfo/oYNZhD52vkJwi94HvXtkVJu268K8WvIILAX58rSn+ISOEV4rmmdPfb0TJlCcKZz
         yQZ4zX73ehJW/UKwswt2Ur/lByWyyEP4MrI0TEPFD4R+r60IrLpoAmGeGmM41El5fIYM
         mr3XLAY5Ai1VbfltjESHWODB3UVZ5UWmgYMHmcrzXS1izYt9iCY6+caFL69cJSi/d5Li
         I1Lw==
X-Gm-Message-State: AFuF++nR9W2f+u0FGw584/ovT1/IkCHufcrTDUjOHAV6TSpe2E6tqyLi
	YZAdPUoHTArgOOU+GrBDTmNtmZMZKO3OG9mQCVqHSPkLgG+rJ+E8Cy0ZtcpSLIqKHsQUd1ZVXiz
	NEpb6cXD0WwHyq5QZ
X-Gm-Gg: AYBFou09orIF5YNq1Agx+33xXy+K4jDadMaibqfI3cwoDRAwz74uvxuCF5DDCOguc9f
	Rw5Ib3ozjeE3a11wl2HXJa5bVRoGGD09sHLXSZ+M7Hyt+IRiN3Ofjdj0tJc13BBw3YjIYKeCgNN
	D/V7rANA0FOOmqU2UYDl5H7A6jkgLezKyh+B3XraguuILguuSSOUf03y9uhIKzHu5QUbEKN2Z0d
	nxgN9NTcc+L1tiycKgNscM1lMQ+GgG5bGvhDO6tU4AbYi+9TyGyr/ByZfI2TSEmywco98X7BSmq
	a6EENDOAULsD0Ad29AMxYJCjsru2s466lIaKHVIzkYpXWO5AgDNflsZim+CL+lnamC+mM35yVH9
	hWVRsmJYbJWiYe4gQQdXreaLUBJSoSGofqf/xPOwKO6/QcC0DgGl7GOaJHJ+APzhRgG4uO4wZhD
	so5KW4Qnl2sHS3DWEr//Q/K6AXExyp3sNz3mIRe6QvPcAtqlcBhNSTalUOzhnwkpJpnwknI7Exj
	nA6id8dqUZr3q+GFSEKMtofPMxZTeSKZoqcJohp2KIVmhBCrTRvFNzAc3REA8JBDyFcRgVw421r
	34ZiDd7gh0jTcoNP++j52vTc38dzqzfwULFBDAy+77phI8plV4zP1q/1TuTrMXpZL+2LiBLNm6m
	TvCMa1R2sOECXGI+jHh7h32amhZoRVZTaEiBl8abHv48VK5PlUNWB+NZCI89nbm6FjxdYyTr1TN
	uQjpIT4DkA
X-Received: by 2002:a17:907:7b85:b0:c28:fb3f:fe20 with SMTP id a640c23a62f3a-c29b86f99d5mr89355866b.30.1789370746064;
        Mon, 14 Sep 2026 00:25:46 -0700 (PDT)
Received: from Desktop.fritz.box ([185.152.145.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2965c4e8a1sm382835666b.6.2026.09.14.00.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 00:25:45 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	razor@blackwall.org,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v5 2/3] netfilter: flowtable: teardown direct xmit flows when the fdb entry moves
Date: Mon, 14 Sep 2026 09:25:40 +0200
Message-ID: <20260914072541.897040-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914072541.897040-1-julius@bairaktaris.de>
References: <20260914072541.897040-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

A direct xmit flow stores the bridge port and the destination address that
the bridge fdb resolved when the flow was created. When the host moves to
another port of the same bridge, for example a station roaming to another
access point, the bridge updates its fdb entry and the flow keeps sending
to the old port. Packets from the other end keep hitting the flow and
refresh it, so it does not expire while the sender retransmits. A hardware
offloaded flow behaves the same, and none of its packets reaches the
software path.

Before the bridge moves an fdb entry to another port it notifies
SWITCHDEV_FDB_DEL_TO_DEVICE for the old port. Tear down every direct xmit
flow whose bridge port, vid and destination address match on that
notification. The bridge port is stored in the tuple for this: the out
interface is the lowest device of the path and differs from the port when
the port is a vlan device. The notifier runs in atomic context, so the
flows are walked from a workqueue.

The same notification is sent when an entry ages out or is flushed; a flow
torn down that way is offloaded again once the bridge relearns the host.
When the work item cannot be allocated the flow ages out as before, the
same as dsa_user_fdb_event() drops the hardware fdb update in that case.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Co-developed-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: LLM
---
 include/net/netfilter/nf_flow_table.h |   2 +
 net/netfilter/nf_flow_table_core.c    | 108 ++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c    |   6 ++
 3 files changed, 116 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cadd5f82be8e..412044dd3a83 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,7 @@ struct flow_offload_tuple {
 		};
 		struct {
 			u32		ifidx;
+			u32		bridge_ifidx;
 			u16		bridge_vid;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
@@ -233,6 +234,7 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 			u32			hw_ifindex;
+			u32			bridge_ifindex;
 			u16			bridge_vid;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b308fb627640..e6e55a1cadaf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -4,7 +4,9 @@
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
+#include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <net/switchdev.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
@@ -139,6 +141,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->out.bridge_ifidx =
+			route->tuple[dir].out.bridge_ifindex;
 		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
@@ -761,6 +765,94 @@ void nf_flow_table_cleanup(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
 
+static struct workqueue_struct *nf_flow_fdb_del_wq;
+
+struct nf_flow_fdb_del_work {
+	struct work_struct	work;
+	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+	u16			vid;
+	u8			addr[ETH_ALEN];
+	bool			found;
+};
+
+static bool nf_flow_tuple_fdb_match(const struct flow_offload_tuple *tuple,
+				    const struct nf_flow_fdb_del_work *fw)
+{
+	return tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
+	       tuple->out.bridge_ifidx == fw->dev->ifindex &&
+	       tuple->out.bridge_vid == fw->vid &&
+	       ether_addr_equal(tuple->out.h_dest, fw->addr);
+}
+
+static void nf_flow_table_do_fdb_del(struct nf_flowtable *flow_table,
+				     struct flow_offload *flow, void *data)
+{
+	struct nf_flow_fdb_del_work *fw = data;
+
+	if (nf_flow_tuple_fdb_match(&flow->tuplehash[0].tuple, fw) ||
+	    nf_flow_tuple_fdb_match(&flow->tuplehash[1].tuple, fw)) {
+		flow_offload_teardown(flow);
+		fw->found = true;
+	}
+}
+
+static void nf_flow_table_fdb_del_work(struct work_struct *work)
+{
+	struct nf_flow_fdb_del_work *fw;
+	struct nf_flowtable *flowtable;
+
+	fw = container_of(work, struct nf_flow_fdb_del_work, work);
+
+	mutex_lock(&flowtable_lock);
+	list_for_each_entry(flowtable, &flowtables, list) {
+		if (!net_eq(read_pnet(&flowtable->net), dev_net(fw->dev)))
+			continue;
+
+		fw->found = false;
+		nf_flow_table_iterate(flowtable, nf_flow_table_do_fdb_del, fw);
+		if (fw->found)
+			mod_delayed_work(system_power_efficient_wq,
+					 &flowtable->gc_work, 0);
+	}
+	mutex_unlock(&flowtable_lock);
+
+	netdev_put(fw->dev, &fw->dev_tracker);
+	kfree(fw);
+}
+
+/* The bridge notifies the old port before it moves an fdb entry. Flows
+ * sending directly to that port are torn down. Skipping the teardown on
+ * allocation failure leaves the flow to age out, the same as a missed fdb
+ * update does for a switchdev driver.
+ */
+static int nf_flow_table_switchdev_event(struct notifier_block *nb,
+					 unsigned long event, void *ptr)
+{
+	struct switchdev_notifier_fdb_info *fdb_info = ptr;
+	struct nf_flow_fdb_del_work *fw;
+
+	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE || fdb_info->is_local)
+		return NOTIFY_DONE;
+
+	fw = kzalloc_obj(*fw, GFP_ATOMIC);
+	if (!fw)
+		return NOTIFY_DONE;
+
+	INIT_WORK(&fw->work, nf_flow_table_fdb_del_work);
+	fw->dev = fdb_info->info.dev;
+	netdev_hold(fw->dev, &fw->dev_tracker, GFP_ATOMIC);
+	fw->vid = fdb_info->vid;
+	ether_addr_copy(fw->addr, fdb_info->addr);
+	queue_work(nf_flow_fdb_del_wq, &fw->work);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nf_flow_table_switchdev_nb = {
+	.notifier_call = nf_flow_table_switchdev_event,
+};
+
 void nf_flow_table_free(struct nf_flowtable *flow_table)
 {
 	mutex_lock(&flowtable_lock);
@@ -838,6 +930,16 @@ static int __init nf_flow_table_module_init(void)
 	if (ret)
 		goto out_offload;
 
+	nf_flow_fdb_del_wq = alloc_workqueue("nf_flow_fdb_del", WQ_UNBOUND, 0);
+	if (!nf_flow_fdb_del_wq) {
+		ret = -ENOMEM;
+		goto out_wq;
+	}
+
+	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	if (ret)
+		goto out_switchdev;
+
 	ret = nf_flow_register_bpf();
 	if (ret)
 		goto out_bpf;
@@ -845,6 +947,10 @@ static int __init nf_flow_table_module_init(void)
 	return 0;
 
 out_bpf:
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+out_switchdev:
+	destroy_workqueue(nf_flow_fdb_del_wq);
+out_wq:
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
@@ -855,6 +961,8 @@ static int __init nf_flow_table_module_init(void)
 
 static void __exit nf_flow_table_module_exit(void)
 {
+	unregister_switchdev_notifier(&nf_flow_table_switchdev_nb);
+	destroy_workqueue(nf_flow_fdb_del_wq);
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
 	kmem_cache_destroy(flow_offload_cachep);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 53629e9b2273..231eeef50f73 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -88,6 +88,7 @@ struct nft_forward_info {
 		__be16	proto;
 	} encap[NF_FLOW_TABLE_ENCAP_MAX];
 	u8 num_encaps;
+	u32 bridge_ifidx;
 	u16 bridge_vid;
 	struct flow_offload_tunnel tun;
 	struct dst_entry *tun_dst;
@@ -181,6 +182,10 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			/* dev_fill_forward_path() adds the bridge port after
+			 * the bridge.
+			 */
+			info->bridge_ifidx = stack->path[i + 1].dev->ifindex;
 			info->bridge_vid = path->bridge.vlan_id;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
@@ -259,6 +264,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.bridge_ifindex = info.bridge_ifidx;
 		route->tuple[dir].out.bridge_vid = info.bridge_vid;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
-- 
2.53.0

