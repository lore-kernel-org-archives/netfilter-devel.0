Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C44A3D4C
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 23:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792281541; cv=none; b=asvypqA5c2ntEez5qDhgb1EwO+1gLKVb7IJLpEGfU2yTmYT2APuluYHqkx9RxiPTDtHXEF559ZqNChZ7nXez3aIBb4slg0Rr3XT8ZEgw0sgxPEYhnFLMogfQClR5ADyhT8hKu3e8Jt0RPSDWMyXeJAs3BXZaJ9crKQyNFIq/hDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792281541; c=relaxed/simple;
	bh=Emh5b857CrjOqv3+Fdv07ite/xNuLPJBHS7D5WX++Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzBwXinkPwgbwTU7gBEMDHDaJ7Sn0ULtw/s+/hqxofvaJrPzUlWBk9OsHymh6k6NOG4ZirdHe0kqzWj40gXh6M1u4slgBL3W0U5VTMcjPUAwGg7+Uxc/FoLpsI5Am97EzLb2jOoVsU+x8yvW/SaxlTYvzCKK92y+rMD3o0spT5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=U00FlIn8; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="U00FlIn8"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c43373ae89aso14880766b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 16:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792281537; x=1792886337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NaeNiuLn1mpaVU6PFYuBQMrVRFDv7j5H7niheq3FrYc=;
        b=U00FlIn8eunj7Uh2AU1L5y4wzkDHvXcGucRnD+hZRtGnebjg1o9++mtBw0szyQD1DX
         VZvmR5fd4rO+VC20oVOET9+E31ZQ+sBTHxjK4WMBjAizdcfgFV5TZCeh3qWOGXaMEeUf
         IahQQx9MI6hfiIOMZ11zEo7vbw5oT2COv8zcs0yKqMwW1z9B3SJy0OuzhV3NdxA2BLa6
         DuYYm7M6C+CuxFQPgBrU8805zzVGPF5JGRvIVF46x7onYYi/gEnj5huW3XkbSLHeBKQR
         H/sXckNIyu93yJIZ2hHQ/61KoARCzFvn5Q2TsDsXzt9sQJqg8ZZnVtatS0WC+n+1K4iP
         8O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792281537; x=1792886337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NaeNiuLn1mpaVU6PFYuBQMrVRFDv7j5H7niheq3FrYc=;
        b=1AfiXRLMOpxAu/eeL8ETSsz//6W+G5avi8Ui6+Upg1DGYQ2cmDu/4GOhgnxK2l6K06
         1+1lCecaCcNs2glEpLgUj9RijvG0JrqNF3MI9jLWwiUdDqWtDRHA6NskdX/6XFCDboK5
         twC9OdyIv0Bw9FpjiTplwnSG6zPU+uwGBWkLNi0St+LE7uDVH7SHwC8yIVnloHQn47s0
         Ne+kS5tsVACJOcnfcH6P1QvnANzR6PonfbKs9m7H1bwNMzCvu/RZZ+zWes4ykrdyRHAx
         xCP8epSFw3oeTp0xz+9UHRrIDp1jBkQv2Rbnsxr//+F1+nqX718lsS/nstohDAmftnfY
         CGFg==
X-Gm-Message-State: AFq9FYIE9yHAgA/ujSQfDghjDYNmI/bg26F3KMzS5WIvRcbwTR2+54d9
	15RSXiqTxxbv3NC4/pYwt1mbu3IQUUUP418lFrcSHw3O2P33p2jEmPSkB+jaCZ4BzfDCJAgM6Px
	VumJSEhHy
X-Gm-Gg: AYBFou0u6V+GYtbq0l6P28O3PleOtzsnxVxHIE9VuYe/DDiJbVn7CoSLK4zk4oz0HB2
	mYnurT+8gqGt03nvaE+SaB9z9sTE1riyW3y8o471+dF6F7szbQz6G+3SUYkQgtMD7o3pofJql/H
	YUn5dcDk4edcstON7IKWR0xjSKmHwrV0O35bnSuwjWlRBgLmijTPoMUrEAnniC8C71VpVZAULdx
	MryQWgAWyBcOxyqsUavRMgs1M4XlabrA5Ut6tvdu2bOs9cp8j8l/T6uJSlrC3Y0mNTSPAQlmnQt
	yMuqAHYF4WkyIphYb9TO9p5ujknlDGtA8aPioAA629miStlLCjG0e9mvergkmRNuo+SKRdesI69
	yA6cF+6jut1x8QvLfva82U8210VT2Y1eVPZWUwG0lpuXxPNmazbEFUw2LMB6k/5p1j0ixbCAow+
	V9T0+OFI4PoA6a2igygrrardYMLsOJpsIHTtCkE6krY7sYs1UOpHODo2oVmeZLrkt5GPjFGbgb3
	f9ZzxomcQiq9Ma3ejet49N6Lbje2trBiM/LndwiWZLivyGyuS0r880Arj2U7pWKicU+Fw+N/EX+
	4NqhivpjmmvetOReAjc2RCHr2LnTwU8zBmhyZoSO6yjfcRBXe1yuVdXADMcWwYGxw0EoSbLyy0s
	+S3SgIFX18rAMcFG6F47v+nLWohdm+S1xTmi5tmNcc/h/W6FHQQ6KQ1NVdk0ZE/cXI1mVHNrZAa
	2k/SJG6HD3SHbob4dM4M3GFjnxMFaYNumT1tI1yuhfz12UgcVcRoh6p86CNQlDPmVcaI19
X-Received: by 2002:a17:906:99c4:b0:c3e:e677:5608 with SMTP id a640c23a62f3a-c419da40b84mr241993366b.12.1792281536712;
        Sat, 17 Oct 2026 16:58:56 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f24741261000ca3161c2b9b67f.dip0.t-ipconnect.de. [2003:f2:4741:2610:ca:3161:c2b9:b67f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c408e328780sm216534166b.6.2026.10.17.16.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 16:58:55 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	idosch@nvidia.com,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v8 1/2] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sun, 18 Oct 2026 01:58:47 +0200
Message-ID: <20261017235849.1066624-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017235849.1066624-1-julius@bairaktaris.de>
References: <20261017235849.1066624-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A direct xmit flow that reaches a bridge port keeps sending to that port
when the host moves to another port of the bridge, and packets from the
other side keep the flow from timing out.

The gc now checks the fdb entry next to the dst check, through
nf_br_utils_hook, and tears the flow down when the entry points to
another port. An entry that aged out does not tear it down, because
offloaded packets do not refresh it.

The bridge port is found from out.ifidx through the vlan devices that
the forward path has below the port. The vid is the bridge vlan in the
encap stack, or the pvid of the port for an untagged port of a
vlan_filtering bridge.

Reported-by: Eric Woudstra <ericwouds@gmail.com>
Link: https://lore.kernel.org/netfilter-devel/20250925182623.114045-1-ericwouds@gmail.com/
Co-developed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
Assisted-by covers my changes on top of Pablo's patch.

 include/linux/netfilter.h             |  7 +++++
 include/net/netfilter/nf_flow_table.h |  8 ++++-
 net/bridge/Makefile                   |  2 ++
 net/bridge/br.c                       |  2 ++
 net/bridge/br_nf_utils.c              | 38 ++++++++++++++++++++++
 net/bridge/br_private.h               | 13 ++++++++
 net/netfilter/core.c                  |  3 ++
 net/netfilter/nf_flow_table_core.c    | 45 +++++++++++++++++++++++++--
 net/netfilter/nf_flow_table_path.c    | 19 +++++++++--
 9 files changed, 132 insertions(+), 5 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc1414cd3..be85d8f68b452 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -67,6 +67,13 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 #endif
 }
 
+struct nf_br_utils {
+	bool (*fdb_valid_dst)(const struct net_device *dev,
+			      const unsigned char *addr, u16 vid);
+};
+
+extern const struct nf_br_utils __rcu *nf_br_utils_hook;
+
 int netfilter_init(void);
 
 struct sk_buff;
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b611efaa3cd1..6865b542eb3be 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -152,6 +152,9 @@ struct flow_offload_tuple {
 					xmit_type:3,
 					encap_num:2,
 					needs_gso_segment:1,
+					bridge_path:1,
+					bridge_vlan:1,
+					port_vlans:2,
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -234,7 +237,10 @@ struct nf_flow_route {
 			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
-			u8			needs_gso_segment:1;
+			u8			needs_gso_segment:1,
+						bridge_path:1,
+						bridge_vlan:1,
+						port_vlans:2;
 		} out;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 1203dc19e15c9..fc53c332246de 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -14,6 +14,8 @@ bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
 
 bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
 
+bridge-$(subst m,y,$(CONFIG_NF_FLOW_TABLE)) += br_nf_utils.o
+
 br_netfilter-y := br_netfilter_hooks.o
 br_netfilter-$(subst m,y,$(CONFIG_IPV6)) += br_netfilter_ipv6.o
 obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
diff --git a/net/bridge/br.c b/net/bridge/br.c
index d9a39ff98868d..c0618ef6dac5c 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -458,6 +458,7 @@ static int __init br_init(void)
 		goto err_out6;
 
 	brioctl_set(br_ioctl_stub);
+	br_nf_utils_init();
 
 #if IS_MODULE(CONFIG_BRIDGE_NETFILTER)
 	pr_info("bridge: filtering via arp/ip/ip6tables is no longer available "
@@ -486,6 +487,7 @@ static int __init br_init(void)
 
 static void __exit br_deinit(void)
 {
+	br_nf_utils_fini();
 	stp_proto_unregister(&br_stp_proto);
 	br_netlink_fini();
 	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
diff --git a/net/bridge/br_nf_utils.c b/net/bridge/br_nf_utils.c
new file mode 100644
index 0000000000000..300bce6c1b0b8
--- /dev/null
+++ b/net/bridge/br_nf_utils.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/netdevice.h>
+#include <linux/netfilter.h>
+
+#include "br_private.h"
+
+static bool nf_br_fdb_valid_dst(const struct net_device *dev,
+				const unsigned char *addr, u16 vid)
+{
+	const struct net_bridge_fdb_entry *f;
+	const struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (!p)
+		return false;
+
+	if (!vid && br_opt_get(p->br, BROPT_VLAN_ENABLED))
+		vid = br_get_pvid(nbp_vlan_group_rcu(p));
+
+	/* Offloaded packets do not refresh the entry, it can age out. */
+	f = br_fdb_find_rcu(p->br, addr, vid);
+
+	return !f || br_fdb_dst_port(f) == p;
+}
+
+static const struct nf_br_utils nf_br_utils = {
+	.fdb_valid_dst	= nf_br_fdb_valid_dst,
+};
+
+void br_nf_utils_init(void)
+{
+	rcu_assign_pointer(nf_br_utils_hook, &nf_br_utils);
+}
+
+void br_nf_utils_fini(void)
+{
+	RCU_INIT_POINTER(nf_br_utils_hook, NULL);
+}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 05921192ebda1..22c9e17d76175 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2164,6 +2164,19 @@ struct nf_br_ops {
 };
 extern const struct nf_br_ops __rcu *nf_br_ops;
 
+#if IS_ENABLED(CONFIG_NF_FLOW_TABLE)
+void br_nf_utils_init(void);
+void br_nf_utils_fini(void);
+#else
+static inline void br_nf_utils_init(void)
+{
+}
+
+static inline void br_nf_utils_fini(void)
+{
+}
+#endif
+
 /* br_netfilter.c */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 int br_nf_core_init(void);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 940dea2663e95..914f0934f6da3 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -814,6 +814,9 @@ static struct pernet_operations netfilter_net_ops = {
 	.exit = netfilter_net_exit,
 };
 
+const struct nf_br_utils __rcu *nf_br_utils_hook;
+EXPORT_SYMBOL_GPL(nf_br_utils_hook);
+
 int __init netfilter_init(void)
 {
 	int ret;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 0d72dc8ae47a1..113580adf10d3 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -5,6 +5,7 @@
 #include <linux/netfilter.h>
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
+#include <linux/if_vlan.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
@@ -139,6 +140,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->bridge_path = route->tuple[dir].out.bridge_path;
+		flow_tuple->bridge_vlan = route->tuple[dir].out.bridge_vlan;
+		flow_tuple->port_vlans = route->tuple[dir].out.port_vlans;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -572,6 +576,43 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
 }
 
+static bool nf_flow_dst_valid(struct nf_flowtable *flow_table,
+			      struct flow_offload *flow, int dir)
+{
+	struct flow_offload_tuple *other = &flow->tuplehash[!dir].tuple;
+	struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct net *net = read_pnet(&flow_table->net);
+	const struct nf_br_utils *br_utils;
+	struct net_device *dev;
+	bool valid = true;
+	u16 vid = 0;
+	int i;
+
+	if (!nf_flow_dst_check(tuple))
+		return false;
+
+	if (!tuple->bridge_path)
+		return true;
+
+	rcu_read_lock();
+	br_utils = rcu_dereference(nf_br_utils_hook);
+	if (!br_utils)
+		goto out;
+
+	dev = dev_get_by_index_rcu(net, tuple->out.ifidx);
+	for (i = 0; dev && i < tuple->port_vlans; i++)
+		dev = __vlan_find_dev_deep_rcu(dev, other->encap[i].proto,
+					       other->encap[i].id);
+	if (tuple->bridge_vlan)
+		vid = other->encap[i].id;
+
+	valid = dev && br_utils->fdb_valid_dst(dev, tuple->out.h_dest, vid);
+out:
+	rcu_read_unlock();
+
+	return valid;
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -584,8 +625,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
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
index d90013685bf12..779d1fc0ed994 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -95,7 +95,10 @@ struct nft_forward_info {
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
-	bool needs_gso_segment;
+	u8 needs_gso_segment:1,
+	   bridge_path:1,
+	   bridge_vlan:1,
+	   port_vlans:2;
 	enum flow_offload_xmit_type xmit_type;
 };
 
@@ -107,7 +110,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			     unsigned char *ha, struct nft_flowtable *ft)
 {
 	const struct net_device_path *path;
-	int i;
+	int i, n;
 
 	memcpy(info->h_dest, ha, ETH_ALEN);
 
@@ -148,6 +151,8 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->encap[info->num_encaps].proto =
 					path->encap.proto;
 				info->num_encaps++;
+				if (info->bridge_path)
+					info->port_vlans++;
 			}
 			if (path->type == DEV_PATH_PPPOE) {
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
@@ -183,6 +188,13 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			info->bridge_path = 1;
+			n = info->num_encaps;
+			info->bridge_vlan = path->bridge.vlan_id && n &&
+					    info->encap[n - 1].id ==
+					    path->bridge.vlan_id &&
+					    info->encap[n - 1].proto ==
+					    path->bridge.vlan_proto;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -260,6 +272,9 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.bridge_path = info.bridge_path;
+		route->tuple[dir].out.bridge_vlan = info.bridge_vlan;
+		route->tuple[dir].out.port_vlans = info.port_vlans;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.53.0

