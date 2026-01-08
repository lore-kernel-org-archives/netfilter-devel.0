Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084781DBB3A
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Jan 2026 23:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767913866; cv=none; b=MTU0trGM8Dp9APzJ3AdY/qLCs3yyOHbObsZIoJpXbBetQSc9T3L0NgVMWuhB3GYOVIN7soQ3Wsa7Irzi5EE2rkX5VerblSPDlWgK4DUof0oIMo3/mjeJOQkIo/L32rNgyCobqO+T3yQVJsTrRy6JSBzH+eYlGiJGO8GSUSBqO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767913866; c=relaxed/simple;
	bh=qrYjc1K8qcANPnHTSVacI8s2PsEOXICGP5W4qmFuDCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GI98qLDO5NxAeYwN09yTt1RfkZJ77ihDX2DkXr/840k26QBUhA6RjLvLT5xGvny1kOMS68lyCTgHntcJwv6jcjwOc6pl0bcf5B8CH+pXe3L5IWMTzLmp86HMcaBAITxhmyO2Id7Sn+Hf2RO9UPJhx9LF+zByN261W2cNZqGb0IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C9CF4602A9; Fri, 09 Jan 2026 00:11:02 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next] netfilter: nf_conntrack: don't rely on implicit includes
Date: Fri,  9 Jan 2026 00:10:45 +0100
Message-ID: <20260108231049.6886-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

several netfilter compilation units rely on implicit includes
coming from nf_conntrack_proto_gre.h.

Clean this up and add the required dependencies where needed.

nf_conntrack.h requires net_generic() helper.
Place various gre/ppp/vlan includes to where they are needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: nf_conntrack_bpf.c relied on implict net/sock.h (kbuild robot)

 include/linux/netfilter/nf_conntrack_proto_gre.h | 3 ---
 include/net/netfilter/nf_conntrack.h             | 1 +
 net/netfilter/nf_conntrack_bpf.c                 | 1 +
 net/netfilter/nf_conntrack_netlink.c             | 1 +
 net/netfilter/nf_conntrack_proto_gre.c           | 2 ++
 net/netfilter/nf_flow_table_ip.c                 | 2 ++
 net/netfilter/nf_flow_table_offload.c            | 1 +
 net/netfilter/nf_flow_table_path.c               | 1 +
 net/netfilter/nf_nat_ovs.c                       | 3 +++
 net/netfilter/nf_nat_proto.c                     | 1 +
 net/netfilter/nft_flow_offload.c                 | 1 +
 net/sched/act_ct.c                               | 2 ++
 net/sched/act_ctinfo.c                           | 1 +
 13 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 34ce5d2f37a2..9ee7014400e8 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -1,9 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _CONNTRACK_PROTO_GRE_H
 #define _CONNTRACK_PROTO_GRE_H
-#include <asm/byteorder.h>
-#include <net/gre.h>
-#include <net/pptp.h>
 
 struct nf_ct_gre {
 	unsigned int stream_timeout;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index aa0a7c82199e..bc42dd0e10e6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -16,6 +16,7 @@
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 
+#include <net/netns/generic.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 4a136fc3a9c0..4fe6d9d33329 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/btf_ids.h>
 #include <linux/net_namespace.h>
+#include <net/sock.h>
 #include <net/xdp.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a04665adf99..662f6bbfa805 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -32,6 +32,7 @@
 #include <linux/siphash.h>
 
 #include <linux/netfilter.h>
+#include <net/ipv6.h>
 #include <net/netlink.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index af369e686fc5..b894bb7a97ad 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -33,12 +33,14 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <net/dst.h>
+#include <net/gre.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
+#include <net/pptp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 165ec8c5a169..17fc111bb705 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -8,6 +8,8 @@
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
 #include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <net/gre.h>
 #include <net/gso.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d8f7bfd60ac6..b1966b68c48a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/tc_act/tc_csum.h>
 #include <net/flow_offload.h>
+#include <net/ip_tunnels.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index eb24fe2715dc..6bb9579dcc2a 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -2,6 +2,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/etherdevice.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/spinlock.h>
diff --git a/net/netfilter/nf_nat_ovs.c b/net/netfilter/nf_nat_ovs.c
index 0f9a559f6207..31474e8c034a 100644
--- a/net/netfilter/nf_nat_ovs.c
+++ b/net/netfilter/nf_nat_ovs.c
@@ -2,6 +2,9 @@
 /* Support nat functions for openvswitch and used by OVS and TC conntrack. */
 
 #include <net/netfilter/nf_nat.h>
+#include <net/ipv6.h>
+#include <linux/ip.h>
+#include <linux/if_vlan.h>
 
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index b14a434b9561..97c0f841fc96 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -25,6 +25,7 @@
 #include <net/ip6_route.h>
 #include <net/xfrm.h>
 #include <net/ipv6.h>
+#include <net/pptp.h>
 
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b8f76c9057fd..179d0e59e2b5 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2b6ac7069dc1..81d488655793 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -13,9 +13,11 @@
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/pkt_cls.h>
+#include <linux/if_tunnel.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/rhashtable.h>
+#include <net/gre.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 71efe04d00b5..d2c750bab1d3 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -16,6 +16,7 @@
 #include <net/pkt_sched.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
+#include <net/inet_ecn.h>
 #include <uapi/linux/tc_act/tc_ctinfo.h>
 #include <net/tc_act/tc_ctinfo.h>
 #include <net/tc_wrapper.h>
-- 
2.52.0

