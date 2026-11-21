Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795294540;
	b=N5ABcBesLSilc+vutJS0mF3fpzSQERYudm3EKBW0qJtUBFOp3UsdOzWrHi1An84X/ucn
	 /BU9S2U6DSJlG1sqiMEEfFH7F0EBCEsSJuOteyfop030DF0KnLylry8Hg8dgJML7ML08h
	 83fdONBAc6ehHX+O/5iL+/i+cqUksBjDjFywlh0H+LVAF65Wxel+hIcSn01ON+lM/Jsx7
	 MNFRBihELWXKNZYwnfUyTw/TAm771KL7ooDJ+WviUJitlZ0b2hnhWS3TSlRoky/EKKgqN
	 cDCOF+7uRPOK/hlEYDkWS2ljZuqvHxkmhoKmJ0uXa0f8UsELgfnfHQOPqo71UM+VCDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YkoQWj+nVqdpBJbc201QDlIJGBmU9D/3Vn5cmEJp2mc=;
	b=v9/PwqaZBOXUFAncF45n18qiU5rPKvZPFpsQ0O+4QaaddDDW6nAV7+gI0DDlMdoTAksU
	 B1cODKQ1dS+tmiWecZfKDLLdaluNVjce4q4VifdkhG6Y3Z4kNBuv63KoDWQFxtwFBNGT0
	 9XBc/k5PXDyc8FYduo9L7Z2pfJjHz9WPKSmVih2MzZ/YgDLVOQfo8TIaQQyTpcBx8bQsa
	 NDh5JplF5gPfmpAyTK4ZC6JG0ZaVYGq/qSKoKCc0N0znb23ctcu4TM1j92wy4+w8Z7dyb
	 sDmZB8Uw1qLDUg8k6SpjGri6y24ys0o5IiIOD1fuOVuPJlXhPX+V8lpppa/IzmZg7gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ZbVf1LK2;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06484606A336
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 20:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06484606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=ZbVf1LK2
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso348451966b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 12:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795294538; x=1795899338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YkoQWj+nVqdpBJbc201QDlIJGBmU9D/3Vn5cmEJp2mc=;
        b=ZbVf1LK2r/PNMG43udSDOTsCRG+/ll+yAqoNERbj5ZhbEnXk7JzF4CcbsCm9O+Jd5J
         n0YKYKywn63O1J92etT2oFQToUN3RJANfrP3u/7bqqe4VbYywFFdVjkQS2qc/Vx6807f
         ZLu8FEXTNdFdzayzzVRpqfupYzJxWpuv3/JnDFe+9OFXgWJj90yuy8s7JrTB7HKrVEnt
         Njv7zZpjI+5zIrYpkAHfh/JQ9lJ48z6K10HtyP1yItO4KlEfKRVWK4H/YORNTUkj2Ze2
         3aWphpSCw5rCIsS/jcLsRlwmWbcY4VaIfkQ2GdeTzjRiOjnx/MXmsaViSKtZVebCmT1/
         jFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795294538; x=1795899338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YkoQWj+nVqdpBJbc201QDlIJGBmU9D/3Vn5cmEJp2mc=;
        b=0tyVWSMFBM3RYId157qcbEntrab5/c597FK85nKh0ISx2cpRMDjj+rNW6BXatJ0l+y
         WunuyrkeCtF05GmA9R9+D8A9+r8YfU53xiOk2OAZ64O9zq+8zdf3eVO21qt3lroAf37F
         98VuOQdYibLd9OTOB41jgzulv/wwWVTq0zE4qa37559GcBJx+nlm3Tc1jnxg7DX0L7y4
         bYhzaCuQKJMMHXDpxCZC7GN+8yY9UWQLQwYz4Vcw5YUQvjrCGMxa5sg7c9kz9Ry41d89
         +6Mcvyl/mwHiNv+y7abZMUM72t7FPw86uvckLU/ZQMUIbjukC2OLtq4nnALw3/qNke3a
         3JFw==
X-Gm-Message-State: APuU4Z92vJCi2aqNVRVduXS2K/lAKFJ4y8+SFardhoOUGbsJG86mVqtR
	P1aou8Nxh+tp7+DiGGcxMhGMmfQS5e89E0XsXNNcTOnGl1BMHJPm5Lqtc2nPTNkYWiWgi3Jdlc6
	5SUZKWbAp
X-Gm-Gg: AZFdTZe6+y6PlVynj47EbFjX2x7hFkE2ATxWBa5PFguAl/Xwz0ImQ7u/tbxbXiJEE9C
	Z7nZSlLtJfQ/eUg1ftGfno28wUxLHsGRvOjKp0NYOEbcZ5/ZhY69d80cL+2ldKAHsrHBcLIcfoI
	0v+f3KjoDI6JjjUflTVqtgpTIy3GklPqyQOifnqhoMLnizSAhEKcbqKYKVPxTHJSVhCC6rhRI0b
	vydtWkU/AeXSX7EQ3g8iPYi7pC3eIPvy1xqe9inwT6vc0UFaoXs/8dnzv+VPb5DQ+amMciXYjg6
	yMSp8c/uhSiy5jWVKkhBh8pMqWASafEvxEU8dw6Jk/8IkYySu9wNChPjgRJwmkHOv/3SRryhZAr
	vQ6GsRtGBKgChylwIx+lofyYy2P8TLHNjgro+T2t3o4/ciE4u0G3dWr7SlW4WzbTctw8wwUptE3
	Nu25HlPY2fbpgJnC7izd5qZ2CwSlq2nOg8OzzsykAaQzgotcXkImL80wn177+4mUsISGuzEXCRx
	9vnP5ivzvoankLMO4aEk3eBXoUwpc2P7UrvV6/HT+6YfA7qZJYb/idEVt4Ad6fTbGrY1Y/yOd9J
	6kdZtDoWeHEszx+3U6oHcHvVG7E+DuWMhVDIi4Eg1bzgp5Np28xUgREYCtR2z/vifEDWpJMlmUT
	K4ouOYDM2b802AvCaavGI5oD5ecltv2AnN+qjuqxpEdngLqKR+SijAz64bAGyOJwaMy93SqE6k0
	aPxP92xVyqaehDANNvZKlFj85CAjm/grMGYqJCip6fm1erYNiOcZcuBVwBkNwt5hH9IQ7O2pIVU
	+CpeFQGPltr5VDqEZBRpec9cq5U654Uvl+w+Jnw6kTTZtZPMNiLxx+JLlyf0LvqnwDStm7YUVB7
	JUy14MvGEfr/ErPhSeGEPtJRcyypn1ajVjU39L2BYzNqBlLuhYTE11jr
X-Received: by 2002:a17:906:b342:b0:c4d:2895:e492 with SMTP id a640c23a62f3a-c513a829d7emr435523566b.21.1795294538314;
        Sat, 21 Nov 2026 12:55:38 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470dfa000000000000000a27.dip0.t-ipconnect.de. [2003:f2:470d:fa00::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513aea28f4sm237136666b.33.2026.11.21.12.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 12:55:37 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v11 2/3] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sat, 21 Nov 2026 21:55:34 +0100
Message-ID: <20261121205535.1888592-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261121205535.1888592-1-julius@bairaktaris.de>
References: <20261121205535.1888592-1-julius@bairaktaris.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

A direct xmit flow that reaches a bridge port keeps sending to that port
when the host moves to another port of the bridge, and packets from the
other side keep the flow from timing out.

The gc now checks the fdb entry after nf_flow_dst_check_gc(), through
nf_br_utils_hook, and tears the flow down when the entry points to
another port. An entry that aged out does not tear it down, because
offloaded packets do not refresh it.

One possibility to address this issue is to subscribe to
SWITCHDEV_FDB_DEL_TO_DEVICE event notifications, however, this requires
iterating over the whole flowtable whenever a fdb entry is removed.

The bridge port is found from out.ifidx through the vlan devices that
the forward path has below the port. The flow keeps the vid the forward
path looked the fdb entry up in: a vlan that leaves the port untagged
is in neither encap stack. struct flow_offload grows from 296 to 312
bytes on x86_64; its slab cache is cacheline aligned, so an object takes
320 bytes either way.

The flow is also torn down when the port no longer forwards in that
vid, where the bridge would no longer deliver either: the port left the
forwarding state, the vlan left the port, or vlan filtering was turned
on or off. With two bridges on the path, at most two fit in a forward
path, the gc goes up from the inner bridge through the vlan devices
between them to the port of the outer one and checks its entry as well.

Neigh xmit flows need no fdb check: a forward path that crosses a bridge
always makes the flow direct xmit, and a failed walk is not offloaded.

Reported-by: Eric Woudstra <ericwouds@gmail.com>
Link: https://lore.kernel.org/netfilter-devel/20250925182623.114045-1-ericwouds@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[julius@bairaktaris.de: find the bridge port below the vlan devices of the
 path, keep the vid of the fdb lookup, keep a flow whose entry aged out,
 check that the port forwards the vid, check both bridges of a stacked
 path, follow struct net_bridge_dst, build br_nf_utils.o only with the
 flowtable]
Link: https://lore.kernel.org/netfilter-devel/20261014210256.1573072-1-pablo@netfilter.org/
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v11: rebased onto Pablo's xmit series: the gc checks the fdb entry
after his nf_flow_dst_check_gc(), which replaces nf_flow_dst_check()
there, and his patch now sets out.h_dest for every xmit type
v10: https://lore.kernel.org/netfilter-devel/20261115005555.645727-3-julius@bairaktaris.de/

 include/linux/netfilter.h             |  7 +++
 include/net/netfilter/nf_flow_table.h | 22 ++++++++-
 net/bridge/Makefile                   |  2 +
 net/bridge/br.c                       |  2 +
 net/bridge/br_nf_utils.c              | 35 ++++++++++++++
 net/bridge/br_private.h               | 13 +++++
 net/netfilter/core.c                  |  3 ++
 net/netfilter/nf_flow_table_core.c    | 68 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_path.c    | 29 +++++++++++-
 9 files changed, 176 insertions(+), 5 deletions(-)
 create mode 100644 net/bridge/br_nf_utils.c

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e99afc1414cd..be85d8f68b45 100644
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
index 143bcfce3678..206296483fe1 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -121,6 +121,18 @@ struct flow_offload_tunnel {
 	u8	encap_proto;
 };
 
+/* The outer of two bridges on the path: its vid, and how to reach its port
+ * from the inner bridge.
+ */
+struct flow_offload_br_outer {
+	u16				vid;
+	u8				present:1,
+					link_vlans:2,
+					link_untag:1,
+					link_8021ad:1,
+					inner_tag:1;
+};
+
 struct flow_offload_tuple {
 	union {
 		struct in_addr		src_v4;
@@ -153,6 +165,8 @@ struct flow_offload_tuple {
 					xmit_type:3,
 					encap_num:2,
 					needs_gso_segment:1,
+					bridge_path:1,
+					port_vlans:2,
 					tun_num:2,
 					in_vlan_ingress:2;
 	u16				mtu;
@@ -164,6 +178,8 @@ struct flow_offload_tuple {
 			u32		ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
+			u16		bridge_vid;
+			struct flow_offload_br_outer br_outer;
 		} out;
 		struct {
 			u32		iifidx;
@@ -232,7 +248,11 @@ struct nf_flow_route {
 			u32			hw_ifindex;
 			u8			h_source[ETH_ALEN];
 			u8			h_dest[ETH_ALEN];
-			u8			needs_gso_segment:1;
+			u16			bridge_vid;
+			struct flow_offload_br_outer br_outer;
+			u8			needs_gso_segment:1,
+						bridge_path:1,
+						port_vlans:2;
 		} out;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 1203dc19e15c..fc53c332246d 100644
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
index d9a39ff98868..c0618ef6dac5 100644
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
index 000000000000..c9a7c94d301c
--- /dev/null
+++ b/net/bridge/br_nf_utils.c
@@ -0,0 +1,35 @@
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
+	if (!p || !br_port_forwards(p, vid))
+		return false;
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
index 2c73d2549eae..6a6685e93b49 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2166,6 +2166,19 @@ struct nf_br_ops {
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
index 44c856c1e621..92e9852c80c0 100644
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
index 283a6fc215e5..64d0b3a916dd 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -6,6 +6,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/nf_tables.h>
@@ -140,6 +141,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->bridge_path = route->tuple[dir].out.bridge_path;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
+		flow_tuple->out.br_outer = route->tuple[dir].out.br_outer;
+		flow_tuple->port_vlans = route->tuple[dir].out.port_vlans;
 		break;
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
@@ -636,6 +641,65 @@ static inline bool nf_flow_dst_check_gc(struct flow_offload *flow, int dir)
 	return ret;
 }
 
+static bool nf_flow_dst_valid(struct nf_flowtable *flow_table,
+			      struct flow_offload *flow, int dir)
+{
+	struct flow_offload_tuple *other = &flow->tuplehash[!dir].tuple;
+	struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+	struct net *net = read_pnet(&flow_table->net);
+	const struct flow_offload_br_outer *outer = &tuple->out.br_outer;
+	const struct nf_br_utils *br_utils;
+	struct net_device *dev;
+	bool valid = true;
+	__be16 proto;
+	int i, n;
+
+	if (!nf_flow_dst_check_gc(flow, dir))
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
+
+	valid = dev && br_utils->fdb_valid_dst(dev, tuple->out.h_dest,
+					       tuple->out.bridge_vid);
+	if (!valid || !outer->present)
+		goto out;
+
+	/* Up from the inner bridge through the vlan devices to the port of
+	 * the outer one. A link vlan the inner bridge untags is not in the
+	 * encap stack, its vid is the inner bridge vid.
+	 */
+	dev = netdev_master_upper_dev_get_rcu(dev);
+	if (dev && outer->link_untag) {
+		proto = outer->link_8021ad ? htons(ETH_P_8021AD) :
+					     htons(ETH_P_8021Q);
+		dev = __vlan_find_dev_deep_rcu(dev, proto,
+					       tuple->out.bridge_vid);
+	}
+	i += outer->inner_tag;
+	n = i + outer->link_vlans - outer->link_untag;
+	for (; dev && i < n; i++)
+		dev = __vlan_find_dev_deep_rcu(dev, other->encap[i].proto,
+					       other->encap[i].id);
+
+	valid = dev && br_utils->fdb_valid_dst(dev, tuple->out.h_dest,
+					       outer->vid);
+out:
+	rcu_read_unlock();
+
+	return valid;
+}
+
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
@@ -648,8 +712,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    !nf_flow_dst_check_gc(flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
-	    !nf_flow_dst_check_gc(flow, FLOW_OFFLOAD_DIR_REPLY) ||
+	    !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_ORIGINAL) ||
+	    !nf_flow_dst_valid(flow_table, flow, FLOW_OFFLOAD_DIR_REPLY) ||
 	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
 		teardown = true;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 8db396ddbd00..a18fce90b3b2 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -101,7 +101,11 @@ struct nft_forward_info {
 	u8 ingress_vlans;
 	u8 h_source[ETH_ALEN];
 	u8 h_dest[ETH_ALEN];
-	bool needs_gso_segment;
+	u16 bridge_vid;
+	struct flow_offload_br_outer br_outer;
+	u8 needs_gso_segment:1,
+	   bridge_path:1,
+	   port_vlans:2;
 	enum flow_offload_xmit_type xmit_type;
 };
 
@@ -112,8 +116,9 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
 			     unsigned char *ha, struct nft_flowtable *ft)
 {
+	struct flow_offload_br_outer *o = &info->br_outer;
 	const struct net_device_path *path;
-	int i;
+	int i, n;
 
 	memcpy(info->h_dest, ha, ETH_ALEN);
 
@@ -160,6 +165,8 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->encap[info->num_encaps].proto =
 					path->encap.proto;
 				info->num_encaps++;
+				if (info->bridge_path)
+					info->port_vlans++;
 			}
 			if (path->type == DEV_PATH_PPPOE) {
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
@@ -171,6 +178,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
+			n = info->num_encaps;
 			switch (path->bridge.vlan_mode) {
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				if (info->num_encaps == 0)
@@ -195,6 +203,19 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
 			}
+			if (info->bridge_path) {
+				o->present = 1;
+				o->vid = info->bridge_vid;
+				o->link_vlans = info->port_vlans;
+				o->link_untag = path->bridge.vlan_mode ==
+						DEV_PATH_BR_VLAN_UNTAG;
+				o->link_8021ad = path->bridge.vlan_proto ==
+						 htons(ETH_P_8021AD);
+				o->inner_tag = info->num_encaps > n;
+			}
+			info->bridge_path = 1;
+			info->bridge_vid = path->bridge.vlan_id;
+			info->port_vlans = 0;
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		default:
@@ -274,6 +295,10 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
+		route->tuple[dir].out.bridge_path = info.bridge_path;
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
+		route->tuple[dir].out.br_outer = info.br_outer;
+		route->tuple[dir].out.port_vlans = info.port_vlans;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.53.0

