From: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH net-next] net: preserve sock reference when scrubbing the skb.
Date: Mon, 25 Jun 2018 12:56:10 -0300
Message-ID: <20180625155610.30802-1-fbl@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Flavio Leitner <fbl@redhat.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The sock reference is lost when scrubbing the packet and that breaks
TSQ (TCP Small Queues) and XPS (Transmit Packet Steering) causing
performance impacts of about 50% in a single TCP stream when crossing
network namespaces.

XPS breaks because the queue mapping stored in the socket is not
available, so another random queue might be selected when the stack
needs to transmit something like a TCP ACK, or TCP Retransmissions.
That causes packet re-ordering and/or performance issues.

TSQ breaks because it orphans the packet while it is still in the
host, so packets are queued contributing to the buffer bloat problem.

Preserving the sock reference fixes both issues. The socket is
orphaned anyways in the receiving path before any relevant action,
but the transmit side needs some extra checking included in the
patch.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 include/net/netfilter/nf_log.h         | 3 ++-
 net/core/skbuff.c                      | 1 -
 net/ipv4/netfilter/nf_log_ipv4.c       | 8 ++++----
 net/ipv6/netfilter/nf_log_ipv6.c       | 8 ++++----
 net/netfilter/nf_conntrack_broadcast.c | 2 +-
 net/netfilter/nf_log_common.c          | 5 +++--
 net/netfilter/nf_nat_core.c            | 6 +++++-
 net/netfilter/nft_meta.c               | 9 ++++++---
 net/netfilter/nft_socket.c             | 5 ++++-
 net/netfilter/xt_cgroup.c              | 6 ++++--
 net/netfilter/xt_owner.c               | 2 +-
 net/netfilter/xt_recent.c              | 3 ++-
 net/netfilter/xt_socket.c              | 6 ++++++
 13 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index e811ac07ea94..0d3920896d50 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -106,7 +106,8 @@ int nf_log_dump_udp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 			   u8 proto, int fragment, unsigned int offset,
 			   unsigned int logflags);
-void nf_log_dump_sk_uid_gid(struct nf_log_buf *m, struct sock *sk);
+void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
+			    struct sock *sk);
 void nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 			       unsigned int hooknum, const struct sk_buff *skb,
 			       const struct net_device *in,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c642304f178c..37263095545a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4911,7 +4911,6 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 		return;
 
 	ipvs_reset(skb);
-	skb_orphan(skb);
 	skb->mark = 0;
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 4388de0e5380..1e6f28c97d3a 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -35,7 +35,7 @@ static const struct nf_loginfo default_loginfo = {
 };
 
 /* One level of recursion won't kill us */
-static void dump_ipv4_packet(struct nf_log_buf *m,
+static void dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
 			     const struct nf_loginfo *info,
 			     const struct sk_buff *skb, unsigned int iphoff)
 {
@@ -183,7 +183,7 @@ static void dump_ipv4_packet(struct nf_log_buf *m,
 			/* Max length: 3+maxlen */
 			if (!iphoff) { /* Only recurse once. */
 				nf_log_buf_add(m, "[");
-				dump_ipv4_packet(m, info, skb,
+				dump_ipv4_packet(net, m, info, skb,
 					    iphoff + ih->ihl*4+sizeof(_icmph));
 				nf_log_buf_add(m, "] ");
 			}
@@ -251,7 +251,7 @@ static void dump_ipv4_packet(struct nf_log_buf *m,
 
 	/* Max length: 15 "UID=4294967295 " */
 	if ((logflags & NF_LOG_UID) && !iphoff)
-		nf_log_dump_sk_uid_gid(m, skb->sk);
+		nf_log_dump_sk_uid_gid(net, m, skb->sk);
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
 	if (!iphoff && skb->mark)
@@ -333,7 +333,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 	if (in != NULL)
 		dump_ipv4_mac_header(m, loginfo, skb);
 
-	dump_ipv4_packet(m, loginfo, skb, 0);
+	dump_ipv4_packet(net, m, loginfo, skb, 0);
 
 	nf_log_buf_close(m);
 }
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index b397a8fe88b9..c6bf580d0f33 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -36,7 +36,7 @@ static const struct nf_loginfo default_loginfo = {
 };
 
 /* One level of recursion won't kill us */
-static void dump_ipv6_packet(struct nf_log_buf *m,
+static void dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 			     const struct nf_loginfo *info,
 			     const struct sk_buff *skb, unsigned int ip6hoff,
 			     int recurse)
@@ -258,7 +258,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 			/* Max length: 3+maxlen */
 			if (recurse) {
 				nf_log_buf_add(m, "[");
-				dump_ipv6_packet(m, info, skb,
+				dump_ipv6_packet(net, m, info, skb,
 						 ptr + sizeof(_icmp6h), 0);
 				nf_log_buf_add(m, "] ");
 			}
@@ -278,7 +278,7 @@ static void dump_ipv6_packet(struct nf_log_buf *m,
 
 	/* Max length: 15 "UID=4294967295 " */
 	if ((logflags & NF_LOG_UID) && recurse)
-		nf_log_dump_sk_uid_gid(m, skb->sk);
+		nf_log_dump_sk_uid_gid(net, m, skb->sk);
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
 	if (recurse && skb->mark)
@@ -365,7 +365,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 	if (in != NULL)
 		dump_ipv6_mac_header(m, loginfo, skb);
 
-	dump_ipv6_packet(m, loginfo, skb, skb_network_offset(skb), 1);
+	dump_ipv6_packet(net, m, loginfo, skb, skb_network_offset(skb), 1);
 
 	nf_log_buf_close(m);
 }
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index a1086bdec242..5423b197d98a 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -32,7 +32,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	__be32 mask = 0;
 
 	/* we're only interested in locally generated packets */
-	if (skb->sk == NULL)
+	if (skb->sk == NULL || !net_eq(nf_ct_net(ct), sock_net(skb->sk)))
 		goto out;
 	if (rt == NULL || !(rt->rt_flags & RTCF_BROADCAST))
 		goto out;
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index dc61399e30be..a8c5c846aec1 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -132,9 +132,10 @@ int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(nf_log_dump_tcp_header);
 
-void nf_log_dump_sk_uid_gid(struct nf_log_buf *m, struct sock *sk)
+void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
+			    struct sock *sk)
 {
-	if (!sk || !sk_fullsock(sk))
+	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
 		return;
 
 	read_lock_bh(&sk->sk_callback_lock);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 46f9df99d276..86df2a1666fd 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -108,6 +108,7 @@ int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
 	struct flowi fl;
 	unsigned int hh_len;
 	struct dst_entry *dst;
+	struct sock *sk = skb->sk;
 	int err;
 
 	err = xfrm_decode_session(skb, &fl, family);
@@ -119,7 +120,10 @@ int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
 		dst = ((struct xfrm_dst *)dst)->route;
 	dst_hold(dst);
 
-	dst = xfrm_lookup(net, dst, &fl, skb->sk, 0);
+	if (sk && !net_eq(net, sock_net(sk)))
+		sk = NULL;
+
+	dst = xfrm_lookup(net, dst, &fl, sk, 0);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 1105a23bda5e..2b94dcc43456 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -107,7 +107,8 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 	case NFT_META_SKUID:
 		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk))
+		if (!sk || !sk_fullsock(sk) ||
+		    !net_eq(nft_net(pkt), sock_net(sk)))
 			goto err;
 
 		read_lock_bh(&sk->sk_callback_lock);
@@ -123,7 +124,8 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 		break;
 	case NFT_META_SKGID:
 		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk))
+		if (!sk || !sk_fullsock(sk) ||
+		    !net_eq(nft_net(pkt), sock_net(sk)))
 			goto err;
 
 		read_lock_bh(&sk->sk_callback_lock);
@@ -214,7 +216,8 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
 		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk))
+		if (!sk || !sk_fullsock(sk) ||
+		    !net_eq(nft_net(pkt), sock_net(sk)))
 			goto err;
 		*dest = sock_cgroup_classid(&sk->sk_cgrp_data);
 		break;
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 74e1b3bd6954..998c2b546f6d 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -23,6 +23,9 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	struct sock *sk = skb->sk;
 	u32 *dest = &regs->data[priv->dreg];
 
+	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
+		sk = NULL;
+
 	if (!sk)
 		switch(nft_pf(pkt)) {
 		case NFPROTO_IPV4:
@@ -39,7 +42,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			return;
 		}
 
-	if(!sk) {
+	if (!sk) {
 		nft_reg_store8(dest, 0);
 		return;
 	}
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 7df2dece57d3..5d92e1781980 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -72,8 +72,9 @@ static bool
 cgroup_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_cgroup_info_v0 *info = par->matchinfo;
+	struct sock *sk = skb->sk;
 
-	if (skb->sk == NULL || !sk_fullsock(skb->sk))
+	if (!sk || !sk_fullsock(sk) || !net_eq(xt_net(par), sock_net(sk)))
 		return false;
 
 	return (info->id == sock_cgroup_classid(&skb->sk->sk_cgrp_data)) ^
@@ -85,8 +86,9 @@ static bool cgroup_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_cgroup_info_v1 *info = par->matchinfo;
 	struct sock_cgroup_data *skcd = &skb->sk->sk_cgrp_data;
 	struct cgroup *ancestor = info->priv;
+	struct sock *sk = skb->sk;
 
-	if (!skb->sk || !sk_fullsock(skb->sk))
+	if (!sk || !sk_fullsock(sk) || !net_eq(xt_net(par), sock_net(sk)))
 		return false;
 
 	if (ancestor)
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 3d705c688a27..46686fb73784 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -67,7 +67,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct sock *sk = skb_to_full_sk(skb);
 	struct net *net = xt_net(par);
 
-	if (sk == NULL || sk->sk_socket == NULL)
+	if (!sk || !sk->sk_socket || !net_eq(net, sock_net(sk)))
 		return (info->match ^ info->invert) == 0;
 	else if (info->match & info->invert & XT_OWNER_SOCKET)
 		/*
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 07085c22b19c..f44de4bc2100 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -265,7 +265,8 @@ recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	/* use TTL as seen before forwarding */
-	if (xt_out(par) != NULL && skb->sk == NULL)
+	if (xt_out(par) != NULL &&
+	    (!skb->sk || !net_eq(net, sock_net(skb->sk))))
 		ttl++;
 
 	spin_lock_bh(&recent_lock);
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 5c0779c4fa3c..e2795f5f7000 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -58,6 +58,9 @@ socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 
 	if (!sk)
 		sk = nf_sk_lookup_slow_v4(xt_net(par), skb, xt_in(par));
+	else if (!net_eq(xt_net(par), sock_net(sk)))
+		sk = NULL;
+
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
@@ -115,6 +118,9 @@ socket_mt6_v1_v2_v3(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (!sk)
 		sk = nf_sk_lookup_slow_v6(xt_net(par), skb, xt_in(par));
+	else if (!net_eq(xt_net(par), sock_net(sk)))
+		sk = NULL;
+
 	if (sk) {
 		bool wildcard;
 		bool transparent = true;
-- 
2.14.3
