Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794704175;
	b=phUNdqAVZz1tBV7FV1sNrvJh2tCYtYVv8phPocF9/M3SCJsRJF231f/SpaKhyz8mz96T
	 Bhzgwa7gRmCIv6soC+YvH1QLi3W/PS/PbzHv4RpZPwshPD50UB0lFdsJxIiHrZntFHeTr
	 mGOZiJxCyIhnu63/7sk9o4TQ37tc9iquyUfzCMKobSLaXoGX2pefjZnvzSUDe03yYtJN6
	 /8p9b1NPvukXOCnTz8DasGK96P9xgUaDDG9rV51hOs9mHe9ShCFtGgz0YchAJVyECcnQu
	 APliPB9XufID8YRN3wsq/wP7MZDrReTejQYG8OolCTVZMJJccmrRw7YtJNX79maVvsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794704175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=00i/qNA2SHcJy53eEwpOF1J0/DJiARoYT5A6DXsVVwY=;
	b=iY5T7qmm5j4mjqzlokxE7bsTiIaoONdynA3Sv1+Fo0iPCRd2wNqRh3imLZMmVVe3N/CX
	 ZB+fL+enBD+CY+fZnu4lIBD4Q26MjbliRUZb839SsjzAsvolW5ziJ4fCxYGEXg1R+sH2Z
	 ccjPH0G7DfN9EngA+tAHkDZ0WnGYGLLkES7EDJYKlasa7sepzx0M3F4qZSyMQwtdu3APY
	 N2MM7zA+QhCXvezwpV1qyBWGX/+ACAsJIccVetUafK52jnCi6rqAH0Ztc12kLOfrtX1YZ
	 9SIz7e/XJxtIqS5ObeyyNPDilAYY9aEVLcxfwTSxaiNwm/H9kyrAEHeoi5apPVZVr5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Xzf0e8Wq;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3C2606A32C
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:56:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD3C2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Xzf0e8Wq
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c50604721c8so413530166b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 16:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794704173; x=1795308973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=00i/qNA2SHcJy53eEwpOF1J0/DJiARoYT5A6DXsVVwY=;
        b=Xzf0e8WqPj3esFLxzBQdp3Y5N5tUStaMsVLsjQywqZH4n70NOYC14IWAhY8fIzyGO9
         OKRLSc6WNQbqWY4ZD5G+VJoua1RdK7KM2kGC1ATwjV69AGq6JACL1OJ9ODmI0rvQU7Dp
         ketJRvq8b5nyhomGWxIZqYROaVGuqMzaMTpywj60LlYLWn74bm9vyIhb9PIl74nh/aa7
         7FTMtPchJqyc9E+aX6LjTqzuEQ7SakwtUiLGL6q7EKPU46jam2PlT902BRF6EVBhs8KC
         y1lIILsUt7V+D6hzHRdenqhgrt7+gb5+ufLtDm8Wl6P3mTck9Tzwbuyr1+od1G99JDKy
         af9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794704173; x=1795308973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=00i/qNA2SHcJy53eEwpOF1J0/DJiARoYT5A6DXsVVwY=;
        b=s7vDTlkjFVojyXVBxdO1l8LxL/ewR2N2XK0e0dDjRc28+ML+QnI80+pXDIOATnIvg1
         CKa1vdWjjrPRDxzQE/hUZja7N1jJdHj7DZ6+5nci8OrSkWsl9Ne3ncQ1AQDKtLkfCKhk
         h9/t+twIKmn05Zqk+alt1FRTwkBQ3CdyYmRB7U18m/AbkNvWu7j61XRko33hq5UPUY2J
         3Kvla/k8icP7iQtix07ltZ5HQoJOKnlKdn7L7N0jy0mKWBbNtC0m8+65YXVWpzpPW8t+
         laAb4JmfnprvUffjuEt4pEUpWkzB6rRiZNJtuoG/YnCeLAFInpdEZ1w/PUd21gTWe4WQ
         vLFQ==
X-Gm-Message-State: APuU4Z/Fv/q7MqciWm2B0VNl+bYoGZ1pTnY3v+m/Awv5Uz6MxeEwjmkJ
	2HVGLQubNpLnqV9HO4iSx6E5tUUb4wGC/Z/KtPJn+snxwGU7sAz519IrjJ15mdajzhzYxElrjtu
	hl5ELEH4S
X-Gm-Gg: AYBFou0hatPA9rjxpD9vpqRnuoRwCYtABC6+1ybOgkKnb3yxhjyvMffbelN83RHJGss
	TPjWqwChVJaOaOW2fY2fMm5vvDRM0DXws+Z3ZqnJTT6mJHRL9IIhTHa+TDZphCAwvSIsMTMzQCS
	zPeouWhbue5OnW/DnpHgNqCdx91RACGJCgGj4cjqpw+aPhAgSauVilKD2JrN/JAtW9yZ1uoPAbj
	NpE2oocY7IBn3fiIeSNwkcaVYMa0p+hmCblQDD90p/Cs//yQCzShsKVgaeHPqOKYq7EUXw3vKsj
	XQah/UjYWMHM9R6j9zTIHeYokbSsaxJMVgg43cCAxNBD+/qZLS9pJuEtEpmpnZ6KFgo33cJVVo9
	ehVe43596J3i9Z8q8cQI/XkVARDB0ZNLoUmzz/1qM6zux1GGFkM+4fL8u1sQqFh6hLslDvw+nlw
	pXW9Cjuk2SS0XgfZva9FvfiKk1re/gPJbypseKK3OhYjVbFaWO/FGYOmlD7CYEBGBSSaIr+nC5I
	AyqBarnR34gZRCaafvRd5gKZkqH3P0/P29sXXNXJ0s8UqI4tk4tszMrlkiq/oICi9+eZfHl35U1
	k24rMl9aFxwPeAsdZk8u91jw881ilK7z5kNX6yVTk38z09K+D/V9rqXsY0PTAA7iv/YB8/h0ZNL
	9Wc3opZFtOy5xtiL5w/hBcnEQ0z4rJ38ZWzveuIUPzWQM6inOZQMcIjfWgvkjS860sWT996U3zI
	Wg/vbDW+moMny3DveXCkUywogLdbmYRRgYS2yxBfveGQfSbqljBNL3/1s1Byrv328OIDWRrsI4L
	9EFHHPbmH6Z7ZVhkxuU4EOELOCz1Jm/pGKfD1Jj8fUFLm/rDgy1j1ffwDoyBCdfq7MydKJ90rup
	4aTnIVy038PG3lzpyQEsAzfjDnkxWtPRC/yhtj1qUCGgrkjSXz02HGxO5JJ71tumpiLzjovF
X-Received: by 2002:a17:907:6e87:b0:c41:1750:59a2 with SMTP id a640c23a62f3a-c50963778efmr552479366b.12.1794704173114;
        Sat, 14 Nov 2026 16:56:13 -0800 (PST)
Received: from Desktop (p200300f2470a670069e45948b1a17361.dip0.t-ipconnect.de. [2003:f2:470a:6700:69e4:5948:b1a1:7361])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b921d4sm266313166b.83.2026.11.14.16.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:56:12 -0800 (PST)
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
Subject: [PATCH nf-next v10 2/3] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sun, 15 Nov 2026 01:55:54 +0100
Message-ID: <20261115005555.645727-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261115005555.645727-1-julius@bairaktaris.de>
References: <20261115005555.645727-1-julius@bairaktaris.de>
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

The gc now checks the fdb entry next to the dst check, through
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
v10: keep the vid of the fdb lookup in out.bridge_vid instead of the
bridge_vlan bit and the port pvid, which is the wrong vlan when the
bridge vlan leaves the port untagged and is not its pvid (Sashiko); tear
the flow down when the port no longer forwards in its vid; check the
outer of two stacked bridges as well
v9: https://lore.kernel.org/netfilter-devel/20261108155344.35845-2-julius@bairaktaris.de/

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
index 5b22d31cb1407..efb316167757b 100644
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
@@ -167,6 +181,8 @@ struct flow_offload_tuple {
 			u32		ifidx;
 			u8		h_source[ETH_ALEN];
 			u8		h_dest[ETH_ALEN];
+			u16		bridge_vid;
+			struct flow_offload_br_outer br_outer;
 		} out;
 		struct {
 			u32		iifidx;
@@ -235,7 +251,11 @@ struct nf_flow_route {
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
index 0000000000000..c9a7c94d301c8
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
index 2c73d2549eaec..6a6685e93b49f 100644
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
index 44c856c1e621c..92e9852c80c0c 100644
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
index 0d72dc8ae47a1..d99d7562f0e45 100644
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
@@ -139,6 +140,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
 		       ETH_ALEN);
 		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		flow_tuple->bridge_path = route->tuple[dir].out.bridge_path;
+		flow_tuple->out.bridge_vid = route->tuple[dir].out.bridge_vid;
+		flow_tuple->out.br_outer = route->tuple[dir].out.br_outer;
+		flow_tuple->port_vlans = route->tuple[dir].out.port_vlans;
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
@@ -572,6 +577,65 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	nf_ct_put(ct);
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
@@ -584,8 +648,8 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
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
index 841f099434d98..791d6f6f1f9f4 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -95,7 +95,11 @@ struct nft_forward_info {
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
 
@@ -106,8 +110,9 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
 			     unsigned char *ha, struct nft_flowtable *ft)
 {
+	struct flow_offload_br_outer *o = &info->br_outer;
 	const struct net_device_path *path;
-	int i;
+	int i, n;
 
 	memcpy(info->h_dest, ha, ETH_ALEN);
 
@@ -149,6 +154,8 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				info->encap[info->num_encaps].proto =
 					path->encap.proto;
 				info->num_encaps++;
+				if (info->bridge_path)
+					info->port_vlans++;
 			}
 			if (path->type == DEV_PATH_PPPOE) {
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
@@ -160,6 +167,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 			if (is_zero_ether_addr(info->h_source))
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
+			n = info->num_encaps;
 			switch (path->bridge.vlan_mode) {
 			case DEV_PATH_BR_VLAN_UNTAG_HW:
 				if (info->num_encaps == 0)
@@ -184,6 +192,19 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
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
@@ -262,6 +283,10 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
 		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
 		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.bridge_path = info.bridge_path;
+		route->tuple[dir].out.bridge_vid = info.bridge_vid;
+		route->tuple[dir].out.br_outer = info.br_outer;
+		route->tuple[dir].out.port_vlans = info.port_vlans;
 		route->tuple[dir].xmit_type = info.xmit_type;
 	}
 	route->tuple[dir].out.needs_gso_segment = info.needs_gso_segment;
-- 
2.53.0

