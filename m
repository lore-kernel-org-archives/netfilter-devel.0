From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/12 net-next,v7] ethtool: add ethtool_rx_flow_spec to flow_rule structure translator
Date: Sat,  2 Feb 2019 12:50:51 +0100
Message-ID: <20190202115054.4880-10-pablo@netfilter.org>
References: <20190202115054.4880-1-pablo@netfilter.org>
Cc: davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com,
        netfilter-devel@vger.kernel.org, cphealy@gmail.co
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190202115054.4880-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds a function to translate the ethtool_rx_flow_spec
structure to the flow_rule representation.

This allows us to reuse code from the driver side given that both flower
and ethtool_rx_flow interfaces use the same representation.

This patch also includes support for the flow type flags FLOW_EXT,
FLOW_MAC_EXT and FLOW_RSS.

The ethtool_rx_flow_spec_input wrapper structure is used to convey the
rss_context field, that is away from the ethtool_rx_flow_spec structure,
and the ethtool_rx_flow_spec structure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v7: rebase on top of net-next.

 include/linux/ethtool.h |  15 +++
 net/core/ethtool.c      | 241 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 256 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index afd9596ce636..19a8de5326fb 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -400,4 +400,19 @@ struct ethtool_ops {
 	void	(*get_ethtool_phy_stats)(struct net_device *,
 					 struct ethtool_stats *, u64 *);
 };
+
+struct ethtool_rx_flow_rule {
+	struct flow_rule	*rule;
+	unsigned long		priv[0];
+};
+
+struct ethtool_rx_flow_spec_input {
+	const struct ethtool_rx_flow_spec	*fs;
+	u32					rss_ctx;
+};
+
+struct ethtool_rx_flow_rule *
+ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input);
+void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *rule);
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 45c0a6e3d6ad..0fbf39239b29 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -29,6 +29,7 @@
 #include <linux/net.h>
 #include <net/devlink.h>
 #include <net/xdp_sock.h>
+#include <net/flow_offload.h>
 
 /*
  * Some useful ethtool_ops methods that're device independent.
@@ -2820,3 +2821,243 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 
 	return rc;
 }
+
+struct ethtool_rx_flow_key {
+	struct flow_dissector_key_basic			basic;
+	union {
+		struct flow_dissector_key_ipv4_addrs	ipv4;
+		struct flow_dissector_key_ipv6_addrs	ipv6;
+	};
+	struct flow_dissector_key_ports			tp;
+	struct flow_dissector_key_ip			ip;
+	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_eth_addrs		eth_addrs;
+} __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
+
+struct ethtool_rx_flow_match {
+	struct flow_dissector		dissector;
+	struct ethtool_rx_flow_key	key;
+	struct ethtool_rx_flow_key	mask;
+};
+
+struct ethtool_rx_flow_rule *
+ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
+{
+	const struct ethtool_rx_flow_spec *fs = input->fs;
+	static struct in6_addr zero_addr = {};
+	struct ethtool_rx_flow_match *match;
+	struct ethtool_rx_flow_rule *flow;
+	struct flow_action_entry *act;
+
+	flow = kzalloc(sizeof(struct ethtool_rx_flow_rule) +
+		       sizeof(struct ethtool_rx_flow_match), GFP_KERNEL);
+	if (!flow)
+		return ERR_PTR(-ENOMEM);
+
+	/* ethtool_rx supports only one single action per rule. */
+	flow->rule = flow_rule_alloc(1);
+	if (!flow->rule) {
+		kfree(flow);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	match = (struct ethtool_rx_flow_match *)flow->priv;
+	flow->rule->match.dissector	= &match->dissector;
+	flow->rule->match.mask		= &match->mask;
+	flow->rule->match.key		= &match->key;
+
+	match->mask.basic.n_proto = htons(0xffff);
+
+	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW: {
+		const struct ethtool_tcpip4_spec *v4_spec, *v4_m_spec;
+
+		match->key.basic.n_proto = htons(ETH_P_IP);
+
+		v4_spec = &fs->h_u.tcp_ip4_spec;
+		v4_m_spec = &fs->m_u.tcp_ip4_spec;
+
+		if (v4_m_spec->ip4src) {
+			match->key.ipv4.src = v4_spec->ip4src;
+			match->mask.ipv4.src = v4_m_spec->ip4src;
+		}
+		if (v4_m_spec->ip4dst) {
+			match->key.ipv4.dst = v4_spec->ip4dst;
+			match->mask.ipv4.dst = v4_m_spec->ip4dst;
+		}
+		if (v4_m_spec->ip4src ||
+		    v4_m_spec->ip4dst) {
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV4_ADDRS] =
+				offsetof(struct ethtool_rx_flow_key, ipv4);
+		}
+		if (v4_m_spec->psrc) {
+			match->key.tp.src = v4_spec->psrc;
+			match->mask.tp.src = v4_m_spec->psrc;
+		}
+		if (v4_m_spec->pdst) {
+			match->key.tp.dst = v4_spec->pdst;
+			match->mask.tp.dst = v4_m_spec->pdst;
+		}
+		if (v4_m_spec->psrc ||
+		    v4_m_spec->pdst) {
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_PORTS);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_PORTS] =
+				offsetof(struct ethtool_rx_flow_key, tp);
+		}
+		if (v4_m_spec->tos) {
+			match->key.ip.tos = v4_spec->tos;
+			match->mask.ip.tos = v4_m_spec->tos;
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_IP);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_IP] =
+				offsetof(struct ethtool_rx_flow_key, ip);
+		}
+		}
+		break;
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW: {
+		const struct ethtool_tcpip6_spec *v6_spec, *v6_m_spec;
+
+		match->key.basic.n_proto = htons(ETH_P_IPV6);
+
+		v6_spec = &fs->h_u.tcp_ip6_spec;
+		v6_m_spec = &fs->m_u.tcp_ip6_spec;
+		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
+			memcpy(&match->key.ipv6.src, v6_spec->ip6src,
+			       sizeof(match->key.ipv6.src));
+			memcpy(&match->mask.ipv6.src, v6_m_spec->ip6src,
+			       sizeof(match->mask.ipv6.src));
+		}
+		if (memcmp(v6_m_spec->ip6dst, &zero_addr, sizeof(zero_addr))) {
+			memcpy(&match->key.ipv6.dst, v6_spec->ip6dst,
+			       sizeof(match->key.ipv6.dst));
+			memcpy(&match->mask.ipv6.dst, v6_m_spec->ip6dst,
+			       sizeof(match->mask.ipv6.dst));
+		}
+		if (memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr)) ||
+		    memcmp(v6_m_spec->ip6src, &zero_addr, sizeof(zero_addr))) {
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_IPV6_ADDRS] =
+				offsetof(struct ethtool_rx_flow_key, ipv6);
+		}
+		if (v6_m_spec->psrc) {
+			match->key.tp.src = v6_spec->psrc;
+			match->mask.tp.src = v6_m_spec->psrc;
+		}
+		if (v6_m_spec->pdst) {
+			match->key.tp.dst = v6_spec->pdst;
+			match->mask.tp.dst = v6_m_spec->pdst;
+		}
+		if (v6_m_spec->psrc ||
+		    v6_m_spec->pdst) {
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_PORTS);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_PORTS] =
+				offsetof(struct ethtool_rx_flow_key, tp);
+		}
+		if (v6_m_spec->tclass) {
+			match->key.ip.tos = v6_spec->tclass;
+			match->mask.ip.tos = v6_m_spec->tclass;
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_IP);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_IP] =
+				offsetof(struct ethtool_rx_flow_key, ip);
+		}
+		}
+		break;
+	default:
+		ethtool_rx_flow_rule_destroy(flow);
+		return ERR_PTR(-EINVAL);
+	}
+
+	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		match->key.basic.ip_proto = IPPROTO_TCP;
+		break;
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		match->key.basic.ip_proto = IPPROTO_UDP;
+		break;
+	}
+	match->mask.basic.ip_proto = 0xff;
+
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_BASIC);
+	match->dissector.offset[FLOW_DISSECTOR_KEY_BASIC] =
+		offsetof(struct ethtool_rx_flow_key, basic);
+
+	if (fs->flow_type & FLOW_EXT) {
+		const struct ethtool_flow_ext *ext_h_spec = &fs->h_ext;
+		const struct ethtool_flow_ext *ext_m_spec = &fs->m_ext;
+
+		if (ext_m_spec->vlan_etype &&
+		    ext_m_spec->vlan_tci) {
+			match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
+			match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;
+
+			match->key.vlan.vlan_id =
+				ntohs(ext_h_spec->vlan_tci) & 0x0fff;
+			match->mask.vlan.vlan_id =
+				ntohs(ext_m_spec->vlan_tci) & 0x0fff;
+
+			match->key.vlan.vlan_priority =
+				(ntohs(ext_h_spec->vlan_tci) & 0xe000) >> 13;
+			match->mask.vlan.vlan_priority =
+				(ntohs(ext_m_spec->vlan_tci) & 0xe000) >> 13;
+
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_VLAN);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
+				offsetof(struct ethtool_rx_flow_key, vlan);
+		}
+	}
+	if (fs->flow_type & FLOW_MAC_EXT) {
+		const struct ethtool_flow_ext *ext_h_spec = &fs->h_ext;
+		const struct ethtool_flow_ext *ext_m_spec = &fs->m_ext;
+
+		if (ext_m_spec->h_dest) {
+			memcpy(match->key.eth_addrs.dst, ext_h_spec->h_dest,
+			       ETH_ALEN);
+			memcpy(match->mask.eth_addrs.dst, ext_m_spec->h_dest,
+			       ETH_ALEN);
+
+			match->dissector.used_keys |=
+				BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS);
+			match->dissector.offset[FLOW_DISSECTOR_KEY_ETH_ADDRS] =
+				offsetof(struct ethtool_rx_flow_key, eth_addrs);
+		}
+	}
+
+	act = &flow->rule->action.entries[0];
+	switch (fs->ring_cookie) {
+	case RX_CLS_FLOW_DISC:
+		act->id = FLOW_ACTION_DROP;
+		break;
+	case RX_CLS_FLOW_WAKE:
+		act->id = FLOW_ACTION_WAKE;
+		break;
+	default:
+		act->id = FLOW_ACTION_QUEUE;
+		if (fs->flow_type & FLOW_RSS)
+			act->queue.ctx = input->rss_ctx;
+
+		act->queue.vf = ethtool_get_flow_spec_ring_vf(fs->ring_cookie);
+		act->queue.index = ethtool_get_flow_spec_ring(fs->ring_cookie);
+		break;
+	}
+
+	return flow;
+}
+EXPORT_SYMBOL(ethtool_rx_flow_rule_create);
+
+void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *flow)
+{
+	kfree(flow->rule);
+	kfree(flow);
+}
+EXPORT_SYMBOL(ethtool_rx_flow_rule_destroy);
-- 
2.11.0
