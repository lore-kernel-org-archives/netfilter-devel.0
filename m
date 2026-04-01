Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382563F0AA4;
	Wed,  1 Apr 2026 10:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039817; cv=none; b=VBOU3SyHRSEcMGMDVd7MVufmKSJFMmH6Ms+mVeXZ7MaUHDupaJyXLWymLIsw8ln6SVGOCbiBdfVMtqsAtJmhzLfj9dD4Em6e2xMNMWr5eTzVog6B8SO9x4xzoHjwg0mteurF57TCl01kvtobWu4spkssKcn7Rs4Y14H6AxiTlXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039817; c=relaxed/simple;
	bh=Ly0+ybsf9bttzQKzkkYyToSBfQKQGI1s18AkdlzzLhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogpX7iM+CKQT/9J1nE52xSs7vDk87cRiRhH2i9RRbFB+iLFw3IOhvSLU61DiM7n1ryNtvMO/ShnU+9kBMoMwsetUBHcigLnidv6GlyG55vtvFhWhRRvx0bmXcCuCv6XpmGz656Kq5yoDGszwh9o38Y4J+MpC6J4bbbmkyoKAcPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uncZahRQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uncZahRQ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 67E0E60273;
	Wed,  1 Apr 2026 12:36:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039812;
	bh=071g83a2y/yve2jkW8y8DNUNXirWNGafJkMfmg7yiF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uncZahRQKk7PfUSeBC1g/EoBWeCNsYcwtoYLQutoCUUWScdeqtW1woKCLS3PlZwSr
	 olj143qfW3+3QfT+ufpDRUHSgokC6ibby+6sS8KY0/ir4vpAYnemp4IK62eplyGDzn
	 QRfG0MNT2HgXSk30epXzBsoDprNsv3//1ZA0plhq3yofuw/4ozJU2eXMZFEPJ6vGkl
	 RNA+8+CYO2L55tL9W4IRR7n91RSsOC3+7aPVumbjcLXCKjDY7CXWkl2+Ftl4pE2gmV
	 ydoy2psbz5oHEK+k7QnsZhg4+EUUqWv/iqVn0Mj2fYGt53SSGfF8WP4KmsFj82KrhJ
	 VNKQAB6fZRodw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/10] netfilter: flowtable: strictly check for maximum number of actions
Date: Wed,  1 Apr 2026 12:36:37 +0200
Message-ID: <20260401103646.1015423-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The maximum number of flowtable hardware offload actions in IPv6 is:

* ethernet mangling (4 payload actions, 2 for each ethernet address)
* SNAT (4 payload actions)
* DNAT (4 payload actions)
* Double VLAN (4 vlan actions, 2 for popping vlan, and 2 for pushing)
  for QinQ.
* Redirect (1 action)

Which makes 17, while the maximum is 16. But act_ct supports for tunnels
actions too. Note that payload action operates at 32-bit word level, so
mangling an IPv6 address takes 4 payload actions.

Update flow_action_entry_next() calls to check for the maximum number of
supported actions.

While at it, rise the maximum number of actions per flow from 16 to 24
so this works fine with IPv6 setups.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 196 +++++++++++++++++---------
 1 file changed, 130 insertions(+), 66 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9b677e116487..93d0aa7f8fcc 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -14,6 +14,8 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+#define NF_FLOW_RULE_ACTION_MAX	24
+
 static struct workqueue_struct *nf_flow_offload_add_wq;
 static struct workqueue_struct *nf_flow_offload_del_wq;
 static struct workqueue_struct *nf_flow_offload_stats_wq;
@@ -216,7 +218,12 @@ static void flow_offload_mangle(struct flow_action_entry *entry,
 static inline struct flow_action_entry *
 flow_action_entry_next(struct nf_flow_rule *flow_rule)
 {
-	int i = flow_rule->rule->action.num_entries++;
+	int i;
+
+	if (unlikely(flow_rule->rule->action.num_entries >= NF_FLOW_RULE_ACTION_MAX))
+		return NULL;
+
+	i = flow_rule->rule->action.num_entries++;
 
 	return &flow_rule->rule->action.entries[i];
 }
@@ -234,6 +241,9 @@ static int flow_offload_eth_src(struct net *net,
 	u32 mask, val;
 	u16 val16;
 
+	if (!entry0 || !entry1)
+		return -E2BIG;
+
 	this_tuple = &flow->tuplehash[dir].tuple;
 
 	switch (this_tuple->xmit_type) {
@@ -284,6 +294,9 @@ static int flow_offload_eth_dst(struct net *net,
 	u8 nud_state;
 	u16 val16;
 
+	if (!entry0 || !entry1)
+		return -E2BIG;
+
 	this_tuple = &flow->tuplehash[dir].tuple;
 
 	switch (this_tuple->xmit_type) {
@@ -325,16 +338,19 @@ static int flow_offload_eth_dst(struct net *net,
 	return 0;
 }
 
-static void flow_offload_ipv4_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v4.s_addr;
@@ -345,23 +361,27 @@ static void flow_offload_ipv4_snat(struct net *net,
 		offset = offsetof(struct iphdr, daddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
 			    &addr, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv4_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask = ~htonl(0xffffffff);
 	__be32 addr;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v4.s_addr;
@@ -372,14 +392,15 @@ static void flow_offload_ipv4_dnat(struct net *net,
 		offset = offsetof(struct iphdr, saddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
 			    &addr, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
+static int flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     unsigned int offset,
 				     const __be32 *addr, const __be32 *mask)
 {
@@ -388,15 +409,20 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 
 	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
 		entry = flow_action_entry_next(flow_rule);
+		if (!entry)
+			return -E2BIG;
+
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
 				    offset + i * sizeof(u32), &addr[i], mask);
 	}
+
+	return 0;
 }
 
-static void flow_offload_ipv6_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv6_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
 	const __be32 *addr;
@@ -412,16 +438,16 @@ static void flow_offload_ipv6_snat(struct net *net,
 		offset = offsetof(struct ipv6hdr, daddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
+	return flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
-static void flow_offload_ipv6_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv6_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
 	const __be32 *addr;
@@ -437,10 +463,10 @@ static void flow_offload_ipv6_dnat(struct net *net,
 		offset = offsetof(struct ipv6hdr, saddr);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
+	return flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
 static int flow_offload_l4proto(const struct flow_offload *flow)
@@ -462,15 +488,18 @@ static int flow_offload_l4proto(const struct flow_offload *flow)
 	return type;
 }
 
-static void flow_offload_port_snat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_port_snat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask, port;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
@@ -485,22 +514,26 @@ static void flow_offload_port_snat(struct net *net,
 		mask = ~htonl(0xffff);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
+	return 0;
 }
 
-static void flow_offload_port_dnat(struct net *net,
-				   const struct flow_offload *flow,
-				   enum flow_offload_tuple_dir dir,
-				   struct nf_flow_rule *flow_rule)
+static int flow_offload_port_dnat(struct net *net,
+				  const struct flow_offload *flow,
+				  enum flow_offload_tuple_dir dir,
+				  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 	u32 mask, port;
 	u32 offset;
 
+	if (!entry)
+		return -E2BIG;
+
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_port);
@@ -515,20 +548,24 @@ static void flow_offload_port_dnat(struct net *net,
 		mask = ~htonl(0xffff0000);
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
 			    &port, &mask);
+	return 0;
 }
 
-static void flow_offload_ipv4_checksum(struct net *net,
-				       const struct flow_offload *flow,
-				       struct nf_flow_rule *flow_rule)
+static int flow_offload_ipv4_checksum(struct net *net,
+				      const struct flow_offload *flow,
+				      struct nf_flow_rule *flow_rule)
 {
 	u8 protonum = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.l4proto;
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
 
+	if (!entry)
+		return -E2BIG;
+
 	entry->id = FLOW_ACTION_CSUM;
 	entry->csum_flags = TCA_CSUM_UPDATE_FLAG_IPV4HDR;
 
@@ -540,12 +577,14 @@ static void flow_offload_ipv4_checksum(struct net *net,
 		entry->csum_flags |= TCA_CSUM_UPDATE_FLAG_UDP;
 		break;
 	}
+
+	return 0;
 }
 
-static void flow_offload_redirect(struct net *net,
-				  const struct flow_offload *flow,
-				  enum flow_offload_tuple_dir dir,
-				  struct nf_flow_rule *flow_rule)
+static int flow_offload_redirect(struct net *net,
+				 const struct flow_offload *flow,
+				 enum flow_offload_tuple_dir dir,
+				 struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *this_tuple, *other_tuple;
 	struct flow_action_entry *entry;
@@ -563,21 +602,28 @@ static void flow_offload_redirect(struct net *net,
 		ifindex = other_tuple->iifidx;
 		break;
 	default:
-		return;
+		return -EOPNOTSUPP;
 	}
 
 	dev = dev_get_by_index(net, ifindex);
 	if (!dev)
-		return;
+		return -ENODEV;
 
 	entry = flow_action_entry_next(flow_rule);
+	if (!entry) {
+		dev_put(dev);
+		return -E2BIG;
+	}
+
 	entry->id = FLOW_ACTION_REDIRECT;
 	entry->dev = dev;
+
+	return 0;
 }
 
-static void flow_offload_encap_tunnel(const struct flow_offload *flow,
-				      enum flow_offload_tuple_dir dir,
-				      struct nf_flow_rule *flow_rule)
+static int flow_offload_encap_tunnel(const struct flow_offload *flow,
+				     enum flow_offload_tuple_dir dir,
+				     struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *this_tuple;
 	struct flow_action_entry *entry;
@@ -585,7 +631,7 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 
 	this_tuple = &flow->tuplehash[dir].tuple;
 	if (this_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
-		return;
+		return 0;
 
 	dst = this_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
@@ -594,15 +640,19 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 		tun_info = lwt_tun_info(dst->lwtstate);
 		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -E2BIG;
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
 			entry->tunnel = tun_info;
 		}
 	}
+
+	return 0;
 }
 
-static void flow_offload_decap_tunnel(const struct flow_offload *flow,
-				      enum flow_offload_tuple_dir dir,
-				      struct nf_flow_rule *flow_rule)
+static int flow_offload_decap_tunnel(const struct flow_offload *flow,
+				     enum flow_offload_tuple_dir dir,
+				     struct nf_flow_rule *flow_rule)
 {
 	const struct flow_offload_tuple *other_tuple;
 	struct flow_action_entry *entry;
@@ -610,7 +660,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 
 	other_tuple = &flow->tuplehash[!dir].tuple;
 	if (other_tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT)
-		return;
+		return 0;
 
 	dst = other_tuple->dst_cache;
 	if (dst && dst->lwtstate) {
@@ -619,9 +669,13 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 		tun_info = lwt_tun_info(dst->lwtstate);
 		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -E2BIG;
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		}
 	}
+
+	return 0;
 }
 
 static int
@@ -633,8 +687,9 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	const struct flow_offload_tuple *tuple;
 	int i;
 
-	flow_offload_decap_tunnel(flow, dir, flow_rule);
-	flow_offload_encap_tunnel(flow, dir, flow_rule);
+	if (flow_offload_decap_tunnel(flow, dir, flow_rule) < 0 ||
+	    flow_offload_encap_tunnel(flow, dir, flow_rule) < 0)
+		return -1;
 
 	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
@@ -650,6 +705,8 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 
 		if (tuple->encap[i].proto == htons(ETH_P_8021Q)) {
 			entry = flow_action_entry_next(flow_rule);
+			if (!entry)
+				return -1;
 			entry->id = FLOW_ACTION_VLAN_POP;
 		}
 	}
@@ -663,6 +720,8 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 			continue;
 
 		entry = flow_action_entry_next(flow_rule);
+		if (!entry)
+			return -1;
 
 		switch (other_tuple->encap[i].proto) {
 		case htons(ETH_P_PPP_SES):
@@ -688,18 +747,22 @@ int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 		return -1;
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
-		flow_offload_ipv4_snat(net, flow, dir, flow_rule);
-		flow_offload_port_snat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv4_snat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
-		flow_offload_ipv4_dnat(net, flow, dir, flow_rule);
-		flow_offload_port_dnat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv4_dnat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_dnat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) ||
 	    test_bit(NF_FLOW_DNAT, &flow->flags))
-		flow_offload_ipv4_checksum(net, flow, flow_rule);
+		if (flow_offload_ipv4_checksum(net, flow, flow_rule) < 0)
+			return -1;
 
-	flow_offload_redirect(net, flow, dir, flow_rule);
+	if (flow_offload_redirect(net, flow, dir, flow_rule) < 0)
+		return -1;
 
 	return 0;
 }
@@ -713,22 +776,23 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 		return -1;
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags)) {
-		flow_offload_ipv6_snat(net, flow, dir, flow_rule);
-		flow_offload_port_snat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv6_snat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_snat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 	if (test_bit(NF_FLOW_DNAT, &flow->flags)) {
-		flow_offload_ipv6_dnat(net, flow, dir, flow_rule);
-		flow_offload_port_dnat(net, flow, dir, flow_rule);
+		if (flow_offload_ipv6_dnat(net, flow, dir, flow_rule) < 0 ||
+		    flow_offload_port_dnat(net, flow, dir, flow_rule) < 0)
+			return -1;
 	}
 
-	flow_offload_redirect(net, flow, dir, flow_rule);
+	if (flow_offload_redirect(net, flow, dir, flow_rule) < 0)
+		return -1;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv6);
 
-#define NF_FLOW_RULE_ACTION_MAX	16
-
 static struct nf_flow_rule *
 nf_flow_offload_rule_alloc(struct net *net,
 			   const struct flow_offload_work *offload,
-- 
2.47.3

