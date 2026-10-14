Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BD338F230
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792011785; cv=none; b=IqNBkoJIPV6hvVrtj0UL5T9Kl+pz9yMAb7fTvdUpxmtYfgI3WjmSGrQ3fMR08RxnUEXMcGpQGdob4A+bbmpXtLcdXVtXPDWLcTi3OZGHZ7eNxFgbgoZ3IM9ggX3UDfqHcJ2hcoKxUKxeHGlrE0xkMEi1ZXrXnUDaztd5Bm9esX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792011785; c=relaxed/simple;
	bh=n5Mv3zBw6Qc+lD48wliOytGgfxqQRbuVes5uTj3lUzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwxDsOjJ9F95nZ5baDA6sucyidZEvrbs0NxaUIzDcHyyCbMQJz8/YMyPGl4Ziq8OVt1PlQFkruRiHIAxCWZselYnbxrD4nffaxXLyzwA45ipsXByG9pGiwGpuRQadGrwBNH5itK0bRgspkjxepR5uUGcQ2v/G8+hHss9WSGNP+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Hf6yOzJx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Hf6yOzJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792011779;
	bh=F22UZ4XTM3O/BcX+jwsQV1q/ODj8mMH1mBlyuUZbZOs=;
	h=From:To:Cc:Subject:Date:From;
	b=Hf6yOzJxybpTfjwT4h8kxqoPWnj+Twhy1NqO5M7xpTGrs6i7ekRX1/gmzr7bi+Lah
	 aFpApemYIbcb18BxeOGLv/JKmOr/FIkmWH1Id2Oc5N2LB5fIPM90wy8gJBS6FIRjhk
	 jh06NsqjYoa+IC3+RGCzxT73rAoRLzegjQc+MGzd4MySMgyyws4ELCpFYJx0/2T0NX
	 thuHQ63CK2cgxtNF85SivXPEKIXCzPfkq+KzvOSnyd44RTnO21qWXcr6XR1NJ/MVva
	 vMCV8jI2QgdzxyD4VRgc0G2ts6/YBla8jgvFg1EN+N5iTX2bZGUXdkVka3xp4JOU4C
	 ijK7w1O+zPWag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8BC956005D;
	Wed, 14 Oct 2026 23:02:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: julius@bairaktaris.de,
	ericwouds@gmail.com,
	razor@blackwall.org
Subject: [PATCH nf-next] netfilter: flowtable: teardown flow reaching bridge port on fdb updates
Date: Wed, 14 Oct 2026 23:02:56 +0200
Message-ID: <20261014210256.1573072-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flowtable GC already checks if dst_entries are still valid, but such
check is lacking for fdb entries when the bypass reaches a bridge port.
This is an issue in roaming scenarios when the bridge is used.

Eric Woudstra describes the problem:

"When the host moves to another port of the same bridge, for example a
station roaming to another access point, the bridge updates its fdb
entry and the flow keeps sending to the old port. Packets from the other
end keep hitting the flow and refresh it, so it does not expire while
the sender retransmits. A hardware offloaded flow behaves the same, and
none of its packets reaches the software path."

One possibility to address this issue is to subscribe to
SWITCHDEV_FDB_DEL_TO_DEVICE event notifications, however, this requires
iterating over the whole flowtable whenever a fdb entry is removed.

This patch adds the infrastructure to check if the fdb entry is stale,
so the flowtable GC can collect tear it down to set up the flowtable
bypass again with a fresh fdb entry.

Reported-by: Eric Woudstra <ericwouds@gmail.com>
Reported-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
+Cc'ing bridge maintainer, since this adds a new file to net/bridge.

This is an alternative to:
[PATCH nf-next v5 2/3] netfilter: flowtable: teardown direct xmit flows when the fdb entry moves

 include/linux/netfilter.h             |  9 +++++
 include/net/netfilter/nf_flow_table.h |  4 +-
 net/bridge/Makefile                   |  2 +-
 net/bridge/br.c                       |  4 ++
 net/bridge/br_nf_utils.c              | 55 +++++++++++++++++++++++++++
 net/bridge/br_private.h               |  3 ++
 net/netfilter/core.c                  |  3 ++
 net/netfilter/nf_flow_table_core.c    | 51 ++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_path.c    |  5 ++-
 9 files changed, 131 insertions(+), 5 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc1414cd..18636a918a67 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -67,6 +67,15 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 #endif
 }
 
+struct net_bridge;
+
+struct nf_br_utils {
+	bool	(*fdb_valid_dst)(struct net *net, int ifindex,
+				 const unsigned char *addr, __u16 vid);
+};
+
+extern struct nf_br_utils __rcu *nf_br_utils_hook;
+
 int netfilter_init(void);
 
 struct sk_buff;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b611efaa3cd..8d4a97f9f9ec 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -152,6 +152,7 @@ struct flow_offload_tuple {
 					xmit_type:3,
 					encap_num:2,
 					needs_gso_segment:1,
+					bridge_path:1,
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -234,7 +235,8 @@ struct nf_flow_route {
 			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
-			u8			needs_gso_segment:1;
+			u8			needs_gso_segment:1,
+						bridge_path:1;
 		} out;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 1203dc19e15c..ccae18d075bb 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_BRIDGE) += bridge.o
 bridge-y	:= br.o br_device.o br_fdb.o br_forward.o br_if.o br_input.o \
 			br_ioctl.o br_stp.o br_stp_bpdu.o \
 			br_stp_if.o br_stp_timer.o br_netlink.o \
-			br_netlink_tunnel.o br_arp_nd_proxy.o
+			br_netlink_tunnel.o br_arp_nd_proxy.o br_nf_utils.o
 
 bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index a5e5b2db110e..5c1d340f9bd9 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -446,6 +446,8 @@ static int __init br_init(void)
 	if (err)
 		goto err_out2;
 
+	br_nf_utils_init();
+
 	err = register_netdevice_notifier(&br_device_notifier);
 	if (err)
 		goto err_out3;
@@ -479,6 +481,7 @@ static int __init br_init(void)
 err_out4:
 	unregister_netdevice_notifier(&br_device_notifier);
 err_out3:
+	br_nf_utils_fini();
 	br_nf_core_fini();
 err_out2:
 	unregister_pernet_subsys(&br_net_ops);
@@ -501,6 +504,7 @@ static void __exit br_deinit(void)
 
 	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 
+	br_nf_utils_fini();
 	br_nf_core_fini();
 	br_fdb_fini();
 }
diff --git a/net/bridge/br_nf_utils.c b/net/bridge/br_nf_utils.c
new file mode 100644
index 000000000000..5cb7ca4cdaa8
--- /dev/null
+++ b/net/bridge/br_nf_utils.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/netfilter.h>
+
+#include "br_private.h"
+
+static bool nf_br_fdb_valid_dst(struct net *net, int ifindex,
+				const unsigned char *addr, __u16 vid)
+{
+	const struct net_bridge_port *dst;
+	struct net_device *dev, *upper;
+	struct net_bridge_fdb_entry *f;
+	struct net_bridge *br;
+
+	rcu_read_lock();
+	dev = dev_get_by_index_rcu(net, ifindex);
+	if (!dev || !netif_is_bridge_port(dev))
+		goto out;
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		goto out;
+
+	br = netdev_priv(upper);
+
+	f = br_fdb_find_rcu(br, addr, vid);
+	if (!f)
+		goto out;
+
+	dst = READ_ONCE(f->dst);
+	if (dst && dst->dev->ifindex == ifindex) {
+		rcu_read_unlock();
+		return true;
+	}
+out:
+	rcu_read_unlock();
+
+	return false;
+}
+
+static struct nf_br_utils nf_br_utils = {
+	.fdb_valid_dst	= nf_br_fdb_valid_dst,
+};
+
+void __init br_nf_utils_init(void)
+{
+	RCU_INIT_POINTER(nf_br_utils_hook, &nf_br_utils);
+}
+
+void br_nf_utils_fini(void)
+{
+	rcu_assign_pointer(nf_br_utils_hook, NULL);
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b01997ea9508..73d201c75f72 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2013,6 +2013,9 @@ struct nf_br_ops {
 };
 extern const struct nf_br_ops __rcu *nf_br_ops;
 
+void br_nf_utils_init(void);
+void br_nf_utils_fini(void);
+
 /* br_netfilter.c */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 int br_nf_core_init(void);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 675a1034b340..91b0b3f77472 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -798,6 +798,9 @@ static struct pernet_operations netfilter_net_ops = {
 	.exit = netfilter_net_exit,
 };
 
+struct nf_br_utils __rcu *nf_br_utils_hook;
+EXPORT_SYMBOL_GPL(nf_br_utils_hook);
+
 int __init netfilter_init(void)
 {
 	int ret;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 36bbc7be2f74..04612fc4d490 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -127,6 +127,8 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
+		flow_tuple->bridge_path = route->tuple[dir].out.bridge_path;
+
 		if (route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
@@ -572,6 +574,51 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+static bool nf_flow_dst_valid(struct nf_flowtable *flow_table,
+			      struct flow_offload *flow, int dir)
+{
+	struct flow_offload_tuple *this_tuple = &flow->tuplehash[dir].tuple;
+	struct net *net = read_pnet(&flow_table->net);
+	struct flow_offload_tuple *other_tuple;
+	struct nf_br_utils *br_utils;
+	__u16 vid = 0;
+	bool valid;
+
+	switch (this_tuple->xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		valid = nf_flow_dst_check(this_tuple);
+		break;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		if (!this_tuple->bridge_path) {
+			valid = true;
+			break;
+		}
+		other_tuple = &flow->tuplehash[!dir].tuple;
+
+		rcu_read_lock();
+		br_utils = rcu_dereference(nf_br_utils_hook);
+		if (!br_utils) {
+			rcu_read_unlock();
+			valid = true;
+			break;
+		}
+
+		if (other_tuple->encap[0].proto == htons(ETH_P_8021Q) ||
+		    other_tuple->encap[0].proto == htons(ETH_P_8021AD))
+			vid = other_tuple->encap[0].id;
+
+		valid = br_utils->fdb_valid_dst(net, this_tuple->out.ifidx,
+						this_tuple->out.h_dest, vid);
+		rcu_read_unlock();
+		break;
+	default:
+		valid = true;
+		break;
+	}
+
+	return valid;
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -584,8 +631,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	    !nf_flow_dst_check(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple) ||
+	    !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
+	    !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_REPLY) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index d90013685bf1..06b3be7b8f6a 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -95,7 +95,8 @@ struct nft_forward_info {
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
-	bool needs_gso_segment;
+	u8 needs_gso_segment:1,
+	   bridge_path:1;
 	enum flow_offload_xmit_type xmit_type;
 };
 
@@ -183,6 +184,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_path = 1;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -260,6 +262,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.bridge_path = info.bridge_path;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.47.3

