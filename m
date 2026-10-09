Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034634E2F2A;
	Fri,  9 Oct 2026 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558181; cv=none; b=Py46gfSKpOBv2VoelI+DQSLp5sD8KZ+hCd3zNZPJ0CsTxJsKSxtCjjI4J4VdGaRYGlDHIGSaf/Ih3+Fu8O2Eo0YqW7USSgsp9BVybe0djRRH41aXDGZzgkOgj9qswtaltAPY9BK9dKEvXcHBFGQMI3jNHzAZ2tCbTWYYyqNOX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558181; c=relaxed/simple;
	bh=CKFy9RneaWo+MxLvPfi1gEFuTHVSDODhWnnSpr3hcNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fy9St/V+GItsNLvSn4HfJ2ukrDjLqHJ8NDcRp4ecgQtRq6w08AjJc7a2j+CxYMVpigw6V4N6KpuIOXz7KblTNBgtb0qDjqKctHAN5hU6s0id/r81oQMwQ0vlLJBRfs5hKfo7BkYZjJLT1BFNU/1Np8J4pPTyAH/BmUJirXiuyJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id C4A4341878;
	Fri, 09 Oct 2026 17:02:56 +0200 (CEST)
From: Gabriel Goller <g.goller@proxmox.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next] netfilter: bridge: refragment reassembled packets passed up
Date: Fri,  9 Oct 2026 17:02:38 +0200
Message-ID: <20261009150246.443127-1-g.goller@proxmox.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1791558173869

A bridge can have an upper device that is a port of another bridge,
e.g. a VLAN device on br0 that is enslaved to br1:

  eth0 -- br0 -- br0.241 (VLAN device) -- br1 -- eth1

br0 reassembles fragments in prerouting so conntrack sees the whole
packet. If br0 forwards the packet, postrouting splits it into the
original fragments again. If br0 passes it up instead, it stays whole.
br1 then cannot refragment it, because frag_max_size is kept in
skb->cb, which br1 clears on input. Packets larger than the MTU of
eth1 are dropped.

Refragment in local input as well, unless the packet is addressed to
the bridge itself, i.e. pkt_type is PACKET_HOST. That is the case if
the destination is the MAC address of the bridge or of the port the
frame arrived on. Other packets reach local input if they are
broadcast or multicast, sent to the MAC address of another port, or
sent to any address while the bridge is promiscuous. The bridge is
promiscuous if an upper device is a port of another bridge, has its
own MAC address (e.g. a macvlan device), or if a packet capture is
running.

Passing a packet up leaves the bridge just like forwarding, so handle
it the same way: reassemble only to track, then hand on the received
fragments. The layer above sees the same packets as without
conntrack, whatever kind of device it is, and nothing has to be
looked up per packet. Packets for the bridge itself are not bridged
again. They stay whole, so the inet stack can use their conntrack
entry without reassembling again. Fragments are passed up without
conntrack, as the layer above would otherwise skip reassembly and
tracking.

Changes for existing setups with bridge conntrack:

  - Upper devices with their own MAC address and local receivers of
    fragmented broadcast or multicast get fragments and reassemble
    them again. (not good, but also not very common)
  - Packet captures on the bridge see fragments, as without conntrack.
    (not sure if this is a big issue)
  - Packets that cannot be refragmented still stay whole: those whose
    fragments exceed the bridge MTU, IPv6 packets with fragments below
    IPV6_MIN_MTU, and packets that are no longer plain IP because VLAN
    ingress moved a tag of a foreign protocol into the payload.

A selftest covers bridge, VLAN, bridge and bridge, macvlan, bridge
topologies. Fragmented IPv4 and IPv6 pings across them fail in both
directions without the fix.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Gabriel Goller <g.goller@proxmox.com>
---

RFC: I'm not confident in this patch. Refragmenting on local input
affects every setup with something above a conntrack-enabled bridge,
not just stacked bridges, and may break things I haven't foreseen.

An alternative would be to keep frag_max_size with the packet in a
new skb extension, as br_netfilter does, and let br1 restore it. That
would avoid reassembling twice, but costs an extension id and an
allocation per packet passed up, and the extension has to be removed
on every path that does not use it.

 net/bridge/netfilter/nf_conntrack_bridge.c    |  66 ++++++++
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/bridge_conntrack_frag.sh    | 157 ++++++++++++++++++
 tools/testing/selftests/net/netfilter/config  |   1 +
 4 files changed, 225 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/bridge_conntrack_frag.sh

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b5444335b86f..d738ef5f6dc8 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -295,6 +295,41 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 	return nf_conntrack_in(skb, &bridge_state);
 }
 
+static unsigned int
+nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
+		    int (*output)(struct net *, struct sock *sk,
+				  const struct nf_bridge_frag_data *data,
+				  struct sk_buff *));
+static int nf_ct_bridge_refrag_in(struct net *net, struct sock *sk,
+				  const struct nf_bridge_frag_data *data,
+				  struct sk_buff *skb);
+
+/* Prerouting reassembled the packet for tracking. Unless it is for the bridge
+ * itself, an upper device may bridge it again without frag_max_size and drop
+ * it, so pass up the original fragments. Keep the packet whole if
+ * refragmenting would drop it.
+ */
+static bool nf_ct_bridge_refrag_up(const struct sk_buff *skb)
+{
+	u16 frag_max_size = BR_INPUT_SKB_CB(skb)->frag_max_size;
+
+	if (skb->pkt_type == PACKET_HOST || !frag_max_size ||
+	    frag_max_size > skb->dev->mtu)
+		return false;
+
+	/* VLAN ingress may have moved a tag of a foreign protocol into the
+	 * payload since prerouting, so the packet is no longer plain IP.
+	 */
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return true;
+	case htons(ETH_P_IPV6):
+		return frag_max_size >= IPV6_MIN_MTU;
+	default:
+		return false;
+	}
+}
+
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 				    const struct nf_hook_state *state)
 {
@@ -302,6 +337,14 @@ static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 	struct nf_conntrack *nfct = skb_nfct(skb);
 	struct nf_conn *ct;
 
+	if (nf_ct_bridge_refrag_up(skb)) {
+		/* Fragments carrying conntrack would make the layer above skip
+		 * reassembly and tracking.
+		 */
+		nf_reset_ct(skb);
+		return nf_ct_bridge_refrag(skb, state, nf_ct_bridge_refrag_in);
+	}
+
 	if (promisc) {
 		nf_reset_ct(skb);
 		return NF_ACCEPT;
@@ -387,6 +430,29 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	return 0;
 }
 
+static int nf_ct_bridge_refrag_in(struct net *net, struct sock *sk,
+				  const struct nf_bridge_frag_data *data,
+				  struct sk_buff *skb)
+{
+	int err;
+
+	err = nf_ct_bridge_frag_restore(skb, data);
+	if (err < 0)
+		return err;
+
+	/* The fast path reuses the reassembled head as the first fragment. Its
+	 * ignore_df from defrag would let IPv6 forwarding refragment it.
+	 */
+	skb->ignore_df = 0;
+
+	/* Unlike the transmit path, receive keeps the Ethernet header pulled. */
+	skb_set_mac_header(skb, -ETH_HLEN);
+	br_drop_fake_rtable(skb);
+	netif_receive_skb(skb);
+
+	return 0;
+}
+
 static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
 				    const struct nf_bridge_frag_data *data,
 				    struct sk_buff *skb)
diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index df3c20c90f5d..d3bc881deaf7 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS := \
 	br_netfilter.sh \
 	br_netfilter_queue.sh \
 	bridge_brouter.sh \
+	bridge_conntrack_frag.sh \
 	conntrack_clash.sh \
 	conntrack_dump_flush.sh \
 	conntrack_icmp_related.sh \
diff --git a/tools/testing/selftests/net/netfilter/bridge_conntrack_frag.sh b/tools/testing/selftests/net/netfilter/bridge_conntrack_frag.sh
new file mode 100755
index 000000000000..04402f0f9fdf
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/bridge_conntrack_frag.sh
@@ -0,0 +1,157 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Proxmox Server Solutions GmbH, Gabriel Goller <g.goller@proxmox.com>
+#
+# Bridge conntrack reassembles fragments. Packets passed up a bridge must be
+# refragmented, or a stacked bridge drops them if they exceed its egress MTU:
+#
+# vlan:    sender                   bridge                       receiver
+#          eth0.241 -- eth0 <-> veth0 -- br0 -- br0.241 -- br1 -- veth1 <-> eth0
+#
+# macvlan: sender             bridge                             receiver
+#          eth0 <-> veth0 -- br0 -- mv0 (passthru) -- br1 -- veth1 <-> eth0
+#
+# br0 is promiscuous because its upper device is a bridge port.
+
+source lib.sh
+
+checktool "nft --version" "run test without nft"
+
+ret=0
+
+trap cleanup_all_ns EXIT
+
+add_dev()
+{
+	if ! ip "$@"; then
+		# Do not hide failures of an earlier topology.
+		[ "$ret" -eq 0 ] || exit "$ret"
+		echo "SKIP: Cannot create required network device"
+		exit $ksft_skip
+	fi
+}
+
+setup_topology()
+{
+	local upper=$1 knob
+
+	setup_ns sender nsbr receiver || exit $ksft_skip
+
+	add_dev link add veth0 netns "$nsbr" type veth peer name eth0 netns "$sender"
+	add_dev link add veth1 netns "$nsbr" type veth peer name eth0 netns "$receiver"
+	add_dev -net "$nsbr" link add br0 type bridge
+	add_dev -net "$nsbr" link add br1 type bridge
+
+	case "$upper" in
+	vlan)
+		add_dev -net "$nsbr" link add link br0 name br0.241 type vlan id 241
+		add_dev -net "$sender" link add link eth0 name eth0.241 type vlan id 241
+		upper_dev=br0.241
+		sender_dev=eth0.241
+		;;
+	macvlan)
+		add_dev -net "$nsbr" link add link br0 name mv0 type macvlan mode passthru
+		upper_dev=mv0
+		sender_dev=eth0
+		;;
+	esac
+
+	# br1 could otherwise take over br0's address from its upper device port,
+	# and traffic to br1 would no longer reach br0 via promiscuous delivery.
+	ip -net "$nsbr" link set br1 address 02:00:00:00:00:20
+
+	# br_netfilter would call the inet hooks on bridged traffic.
+	for knob in bridge-nf-call-iptables bridge-nf-call-ip6tables; do
+		ip netns exec "$nsbr" sysctl -qw "net.bridge.$knob=0" 2>/dev/null
+	done
+
+	ip -net "$nsbr" link set veth0 master br0
+	ip -net "$nsbr" link set "$upper_dev" master br1
+	ip -net "$nsbr" link set veth1 master br1
+
+	for dev in veth0 veth1 br0 "$upper_dev" br1; do
+		ip -net "$nsbr" link set "$dev" up
+	done
+	ip -net "$sender" link set eth0 up
+	ip -net "$sender" link set "$sender_dev" up
+	ip -net "$receiver" link set eth0 up
+
+	ip -net "$sender" addr add 192.0.2.1/24 dev "$sender_dev"
+	ip -net "$receiver" addr add 192.0.2.2/24 dev eth0
+	ip -net "$nsbr" addr add 192.0.2.3/24 dev br1
+	ip -net "$sender" addr add 2001:db8:1::1/64 dev "$sender_dev" nodad
+	ip -net "$receiver" addr add 2001:db8:1::2/64 dev eth0 nodad
+	ip -net "$nsbr" addr add 2001:db8:1::3/64 dev br1 nodad
+}
+
+check_ping()
+{
+	local ns=$1 dst=$2 desc=$3
+
+	if ip netns exec "$ns" ping -q -c 2 -i 0.1 -w 3 -M dont -s 4000 "$dst" \
+		>/dev/null 2>&1; then
+		echo "PASS: $phase $desc"
+	else
+		echo "FAIL: $phase $desc"
+		ret=1
+	fi
+}
+
+check_paths()
+{
+	local prefix
+
+	for prefix in 192.0.2. 2001:db8:1::; do
+		check_ping "$sender" "${prefix}2" "sender -> receiver ${prefix}2"
+		check_ping "$receiver" "${prefix}1" "receiver -> sender ${prefix}1"
+		check_ping "$sender" "${prefix}3" "sender -> bridge host ${prefix}3"
+	done
+}
+
+run_test()
+{
+	local upper=$1 family
+
+	setup_topology "$upper"
+
+	phase="$upper without conntrack:"
+	check_paths
+	# A broken setup must not be hidden by a later skip.
+	[ "$ret" -eq 0 ] || exit "$ret"
+
+	# The ct expression enables the bridge conntrack hooks. Count oversized
+	# packets at br0 input to make sure they were reassembled there.
+	if ! ip netns exec "$nsbr" nft -f - <<'NFT'
+table bridge br_frag {
+	counter tracked4 { }
+	counter tracked6 { }
+	chain input {
+		type filter hook input priority 0; policy accept;
+		iifname "veth0" ct state new,established meta length > 1500 \
+			ip saddr 192.0.2.1 counter name tracked4
+		iifname "veth0" ct state new,established meta length > 1500 \
+			ip6 saddr 2001:db8:1::1 counter name tracked6
+	}
+}
+NFT
+	then
+		echo "SKIP: Bridge conntrack is not available"
+		exit $ksft_skip
+	fi
+
+	phase="$upper with conntrack:"
+	check_paths
+
+	for family in 4 6; do
+		if ! ip netns exec "$nsbr" nft list counter bridge br_frag "tracked$family" |
+			grep -q 'packets [1-9]'; then
+			echo "FAIL: $phase no reassembled IPv$family packets at br0 input"
+			ret=1
+		fi
+	done
+}
+
+run_test vlan
+run_test macvlan
+
+exit "$ret"
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 629b2b29ed1a..91985320c292 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -62,6 +62,7 @@ CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_VRF=y
 CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CONNTRACK_BRIDGE=m
 CONFIG_NF_CONNTRACK_EVENTS=y
 CONFIG_NF_CONNTRACK_FTP=m
 CONFIG_NF_CONNTRACK_MARK=y
-- 
2.47.3


