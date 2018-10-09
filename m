From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 1/3] ip_tunnel: add type field to struct ip_tunnel_info
Date: Wed, 10 Oct 2018 00:24:37 +0200
Message-ID: <20181009222439.29399-2-pablo@netfilter.org>
References: <20181009222439.29399-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181009222439.29399-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This new field allows you to restrict the metadata template for a given
tunnel driver. This is convenient in scenarios that combine different
tunneling drivers, eg. vxlan and erspan. This helps you deal with
possible incorrect configurations. Default value is TUNNEL_TYPE_UNSPEC,
to retain the existing behaviour. This also implicitly exposes what
drivers are currently supported in the TUNNEL_INFO_TX mode.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/geneve.c           |  3 ++-
 drivers/net/vxlan.c            | 13 +++++++------
 include/net/dst_metadata.h     |  1 +
 include/net/ip_tunnels.h       |  8 ++++++++
 include/uapi/linux/if_tunnel.h | 13 ++++++++++++-
 net/core/filter.c              |  1 +
 net/ipv4/ip_gre.c              |  2 ++
 net/ipv4/ip_tunnel.c           |  3 ++-
 net/ipv6/ip6_gre.c             |  2 ++
 net/ipv6/ip6_tunnel.c          |  6 ++++--
 net/openvswitch/flow_netlink.c |  1 +
 11 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 82eccc930c5c..e4fd2acb6732 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -920,7 +920,8 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (geneve->collect_md) {
 		info = skb_tunnel_info(skb);
-		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
+		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX) ||
+			     !ip_tunnel_type(info, TUNNEL_TYPE_GENEVE))) {
 			err = -EINVAL;
 			netdev_dbg(dev, "no tunnel metadata\n");
 			goto tx_error;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fb0cdbba8d76..c279c50816cf 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2296,14 +2296,15 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_reset_mac_header(skb);
 
 	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) {
-		if (info && info->mode & IP_TUNNEL_INFO_BRIDGE &&
-		    info->mode & IP_TUNNEL_INFO_TX) {
+		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX) ||
+			     !ip_tunnel_type(info, TUNNEL_TYPE_VXLAN))) {
+			kfree_skb(skb);
+			return NETDEV_TX_OK;
+		}
+		if (info->mode & IP_TUNNEL_INFO_BRIDGE) {
 			vni = tunnel_id_to_key32(info->key.tun_id);
 		} else {
-			if (info && info->mode & IP_TUNNEL_INFO_TX)
-				vxlan_xmit_one(skb, dev, vni, NULL, false);
-			else
-				kfree_skb(skb);
+			vxlan_xmit_one(skb, dev, vni, NULL, false);
 			return NETDEV_TX_OK;
 		}
 	}
diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 56cb3c38569a..fb3865b2f038 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -100,6 +100,7 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
 	if (!tun_dst)
 		return NULL;
 
+	tun_dst->u.tun_info.type = TUNNEL_TYPE_UNSPEC;
 	tun_dst->u.tun_info.options_len = 0;
 	tun_dst->u.tun_info.mode = 0;
 	return tun_dst;
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index b0d022ff6ea1..34d748ca8b30 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -67,6 +67,7 @@ struct ip_tunnel_key {
 			      options_len) * BITS_PER_BYTE) - 1, 0)
 
 struct ip_tunnel_info {
+	enum tunnel_type	type;
 	struct ip_tunnel_key	key;
 #ifdef CONFIG_DST_CACHE
 	struct dst_cache	dst_cache;
@@ -75,6 +76,13 @@ struct ip_tunnel_info {
 	u8			mode;
 };
 
+static inline bool ip_tunnel_type(const struct ip_tunnel_info *tun_info,
+				  enum tunnel_type type)
+{
+	return tun_info->type == TUNNEL_TYPE_UNSPEC ||
+	       tun_info->type == type;
+}
+
 /* 6rd prefix/relay information */
 #ifdef CONFIG_IPV6_SIT_6RD
 struct ip_tunnel_6rd_parm {
diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
index 1b3d148c4560..1659b81fbae6 100644
--- a/include/uapi/linux/if_tunnel.h
+++ b/include/uapi/linux/if_tunnel.h
@@ -158,6 +158,17 @@ enum {
 	IFLA_VTI_FWMARK,
 	__IFLA_VTI_MAX,
 };
-
 #define IFLA_VTI_MAX	(__IFLA_VTI_MAX - 1)
+
+enum tunnel_type {
+	TUNNEL_TYPE_UNSPEC   = 0,
+	TUNNEL_TYPE_GRE,
+	TUNNEL_TYPE_VXLAN,
+	TUNNEL_TYPE_GENEVE,
+	TUNNEL_TYPE_ERSPAN,
+	TUNNEL_TYPE_IPIP,
+	TUNNEL_TYPE_IPIP6,
+	TUNNEL_TYPE_IP6IP6,
+};
+
 #endif /* _UAPI_IF_TUNNEL_H_ */
diff --git a/net/core/filter.c b/net/core/filter.c
index 4bbc6567fcb8..2e75e1b014df 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3654,6 +3654,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 	info = &md->u.tun_info;
 	memset(info, 0, sizeof(*info));
 	info->mode = IP_TUNNEL_INFO_TX;
+	info->type = TUNNEL_TYPE_UNSPEC;
 
 	info->key.tun_flags = TUNNEL_KEY | TUNNEL_CSUM | TUNNEL_NOCACHE;
 	if (flags & BPF_F_DONT_FRAGMENT)
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 38befe829caf..ab5de3901bc3 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -534,6 +534,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
+		     !ip_tunnel_type(tun_info, TUNNEL_TYPE_GRE) ||
 		     ip_tunnel_info_af(tun_info) != AF_INET))
 		goto err_free_skb;
 
@@ -585,6 +586,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
+		     !ip_tunnel_type(tun_info, TUNNEL_TYPE_ERSPAN) ||
 		     ip_tunnel_info_af(tun_info) != AF_INET))
 		goto err_free_skb;
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 284a22154b4e..b62b424183b4 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -562,7 +562,8 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev, u8 proto)
 
 	tun_info = skb_tunnel_info(skb);
 	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-		     ip_tunnel_info_af(tun_info) != AF_INET))
+		     ip_tunnel_info_af(tun_info) != AF_INET) ||
+		     !ip_tunnel_type(tun_info, TUNNEL_TYPE_IPIP))
 		goto tx_error;
 	key = &tun_info->key;
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 515adbdba1d2..7ff469652e6f 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -732,6 +732,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info ||
 			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
+			     !ip_tunnel_type(tun_info, TUNNEL_TYPE_GRE) ||
 			     ip_tunnel_info_af(tun_info) != AF_INET6))
 			return -EINVAL;
 
@@ -960,6 +961,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info ||
 			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
+			     !ip_tunnel_type(tun_info, TUNNEL_TYPE_ERSPAN) ||
 			     ip_tunnel_info_af(tun_info) != AF_INET6))
 			return -EINVAL;
 
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a0b6932c3afd..819abbcd2ebe 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1259,7 +1259,8 @@ ip4ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-			     ip_tunnel_info_af(tun_info) != AF_INET6))
+			     ip_tunnel_info_af(tun_info) != AF_INET6) ||
+			     !ip_tunnel_type(tun_info, TUNNEL_TYPE_IPIP6))
 			return -1;
 		key = &tun_info->key;
 		memset(&fl6, 0, sizeof(fl6));
@@ -1335,7 +1336,8 @@ ip6ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tun_info = skb_tunnel_info(skb);
 		if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
-			     ip_tunnel_info_af(tun_info) != AF_INET6))
+			     ip_tunnel_info_af(tun_info) != AF_INET6 ||
+			     !ip_tunnel_type(tun_info, TUNNEL_TYPE_IP6IP6)))
 			return -1;
 		key = &tun_info->key;
 		memset(&fl6, 0, sizeof(fl6));
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index a70097ecf33c..29623ad54611 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2602,6 +2602,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
 	ovs_tun->tun_dst = tun_dst;
 
 	tun_info = &tun_dst->u.tun_info;
+	tun_info->type = TUNNEL_TYPE_UNSPEC;
 	tun_info->mode = IP_TUNNEL_INFO_TX;
 	if (key.tun_proto == AF_INET6)
 		tun_info->mode |= IP_TUNNEL_INFO_IPV6;
-- 
2.11.0
