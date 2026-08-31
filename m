Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F5476CF9;
	Mon, 31 Aug 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192403; cv=none; b=B3xXwxVQDBr+CItRwuTOruCx2ZrMoCspdOKVb64MjZgyhiBh/A28H1Lu7XeustAjQYx5A8fiqRKy35gO2bnkAS+uuXZXIduKTBj9s0gWMiEzH7zJZQoImw/EDioHDHJyIfNbXjqM3ukEVe5dU0nhuDCHX67bPOnfx5Eo4jgUzV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192403; c=relaxed/simple;
	bh=mfZaWwTA0R2KmCm4fOqEJA3oAp3CDY7e4VRESDSh9kE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lT93Pk14XWdjr3vi8xTAhFJP7NfzYaalOErCh7mLFq2zZRkPCv6xpSkt+7IdUWMDJqW/em4vQRowz47zaMNElBXhHpHBWCnmqG360AmIGe9+CM6yeBNp6W4mmcdhEyQum5egutU1WEG7XV1w4YqM8PaspMzhCbzFU2DJisdaP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=2ZlPiXNN; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="2ZlPiXNN"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 3B60D4E4147A;
	Mon, 31 Aug 2026 16:06:39 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0811160231;
	Mon, 31 Aug 2026 16:06:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8198711C78B96;
	Mon, 31 Aug 2026 18:06:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192398; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=JEJ1uhUFqV6G4Uf8bVvW+BruDxKnhgyJ2Y6JOmXEK70=;
	b=2ZlPiXNNipmGCy9TaxqM336K7rHIPI7Kt8wkW+GQPBD5qEq9HGT5syl4laUiIS5koiHdpA
	zS5mUJOcLoKYNruLN+QxikxEUZx0jOq2T/X9ILea+y7xzNqB9IStcp1rCC+mXZOzjB9Ofj
	monu/tvVU9k8ialufJYHH6AMAH9LbWc+oA5mX+z8WNPd3uD7gZIh88AdpkAxPVHT1kIIHC
	cRRoRW/LM6nj2m9f3S6tI3JAqfMEiCjwsWgrccnXCETxfSLWvih1ALa4OCQZ7LPCrCsVmq
	cxXgiG1z8txMpMkpnhkcyE+V3ynNNhsMziAItG5DSQrog8q7Mr/jQi6ZLIYlRg==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Mon, 31 Aug 2026 18:06:21 +0200
Subject: [PATCH 6.6.y 2/4] ipv4: adopt dst_dev, skb_dst_dev and
 skb_dst_dev_net[_rcu]
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-cve-2025-40074-6-6-v1-2-027e51b162a3@bootlin.com>
References: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
In-Reply-To: <20260831-cve-2025-40074-6-6-v1-0-027e51b162a3@bootlin.com>
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Martin KaFai Lau <kafai@fb.com>, 
 Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788192387; l=14378;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=wF2QPjBS5wdN+AisRnim+T100qCdVqqYDXpsxDEltao=;
 b=IKmSSf+xLT4To8O1zEAKoSsyQ0MkaXbfimRFEVW17drbo03OXGZ6kxrg0AlTHSDYtQMTnF5B/
 poUnKS1CdcLCePX59rF7zdZpqN3wljZHMCCPjlk8FU8sT6hllYYqTYQ
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a74fc62eec155ca5a6da8ff3856f3dc87fe24558 ]

Use the new helpers as a first step to deal with
potential dst->dev races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250630121934.3399505-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ minor modifications to fix conflict ]
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 include/net/inet_hashtables.h |  2 +-
 include/net/ip.h              | 11 ++++++-----
 include/net/route.h           |  2 +-
 net/ipv4/icmp.c               | 24 +++++++++++++-----------
 net/ipv4/igmp.c               |  2 +-
 net/ipv4/ip_fragment.c        |  2 +-
 net/ipv4/ip_output.c          |  4 ++--
 net/ipv4/ip_vti.c             |  4 ++--
 net/ipv4/netfilter.c          |  4 ++--
 net/ipv4/route.c              |  8 ++++----
 net/ipv4/tcp_fastopen.c       |  4 +++-
 net/ipv4/tcp_ipv4.c           |  3 ++-
 net/ipv4/tcp_metrics.c        |  8 ++++----
 net/ipv4/xfrm4_output.c       |  2 +-
 14 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 8eeb3708f20b..21119e962f00 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -511,7 +511,7 @@ static inline struct sock *__inet_lookup_skb(struct inet_hashinfo *hashinfo,
 					     const int sdif,
 					     bool *refcounted)
 {
-	struct net *net = dev_net(skb_dst(skb)->dev);
+	struct net *net = skb_dst_dev_net(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	struct sock *sk;
 
diff --git a/include/net/ip.h b/include/net/ip.h
index bacdb4fecc89..f66dd581ba83 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -458,7 +458,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net *net = dev_net(dst->dev);
+	struct net *net = dev_net(dst_dev(dst));
 	unsigned int mtu;
 
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
@@ -474,7 +474,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst->dev->mtu);
+	mtu = READ_ONCE(dst_dev(dst)->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
@@ -490,16 +490,17 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
 					  const struct sk_buff *skb)
 {
+	const struct dst_entry *dst = skb_dst(skb);
 	unsigned int mtu;
 
 	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
 		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
 
-		return ip_dst_mtu_maybe_forward(skb_dst(skb), forwarding);
+		return ip_dst_mtu_maybe_forward(dst, forwarding);
 	}
 
-	mtu = min(READ_ONCE(skb_dst(skb)->dev->mtu), IP_MAX_MTU);
-	return mtu - lwtunnel_headroom(skb_dst(skb)->lwtstate, mtu);
+	mtu = min(READ_ONCE(dst_dev(dst)->mtu), IP_MAX_MTU);
+	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
 struct dst_metrics *ip_fib_metrics_init(struct nlattr *fc_mx, int fc_mx_len,
diff --git a/include/net/route.h b/include/net/route.h
index 1d5d975c1707..d443de683628 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -359,7 +359,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst->dev);
+		net = dev_net_rcu(dst_dev(dst));
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 7c4c7b7fe384..f0c8c3366740 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -313,18 +313,20 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 {
 	struct dst_entry *dst = &rt->dst;
 	struct inet_peer *peer;
+	struct net_device *dev;
 	bool rc = true;
 
 	if (!apply_ratelimit)
 		return true;
 
 	/* No rate limit on loopback */
-	if (dst->dev && (dst->dev->flags&IFF_LOOPBACK))
+	dev = dst_dev(dst);
+	if (dev && (dev->flags & IFF_LOOPBACK))
 		goto out;
 
 	rcu_read_lock();
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
-			       l3mdev_master_ifindex_rcu(dst->dev));
+			       l3mdev_master_ifindex_rcu(dev));
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	rcu_read_unlock();
@@ -472,13 +474,13 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
  */
 static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
 {
-	struct net_device *route_lookup_dev = NULL;
+	struct net_device *dev = skb->dev;
+	const struct dst_entry *dst;
 
-	if (skb->dev)
-		route_lookup_dev = skb->dev;
-	else if (skb_dst(skb))
-		route_lookup_dev = skb_dst(skb)->dev;
-	return route_lookup_dev;
+	if (dev)
+		return dev;
+	dst = skb_dst(skb);
+	return dst ? dst_dev(dst) : NULL;
 }
 
 static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
@@ -911,7 +913,7 @@ static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 	struct net *net;
 	u32 info = 0;
 
-	net = dev_net_rcu(skb_dst(skb)->dev);
+	net = skb_dst_dev_net_rcu(skb);
 
 	/*
 	 *	Incomplete header ?
@@ -1054,7 +1056,7 @@ static enum skb_drop_reason icmp_echo(struct sk_buff *skb)
 	struct icmp_bxm icmp_param;
 	struct net *net;
 
-	net = dev_net_rcu(skb_dst(skb)->dev);
+	net = skb_dst_dev_net_rcu(skb);
 	/* should there be an ICMP stat for ignored echos? */
 	if (READ_ONCE(net->ipv4.sysctl_icmp_echo_ignore_all))
 		return SKB_NOT_DROPPED_YET;
@@ -1231,7 +1233,7 @@ static enum skb_drop_reason icmp_timestamp(struct sk_buff *skb)
 	return SKB_NOT_DROPPED_YET;
 
 out_err:
-	__ICMP_INC_STATS(dev_net_rcu(skb_dst(skb)->dev), ICMP_MIB_INERRORS);
+	__ICMP_INC_STATS(skb_dst_dev_net_rcu(skb), ICMP_MIB_INERRORS);
 	return SKB_DROP_REASON_PKT_TOO_SMALL;
 }
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 732804f3a0aa..8509e9473834 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -428,7 +428,7 @@ static int igmpv3_sendpack(struct sk_buff *skb)
 
 	pig->csum = ip_compute_csum(igmp_hdr(skb), igmplen);
 
-	return ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
+	return ip_local_out(skb_dst_dev_net(skb), skb->sk, skb);
 }
 
 static int grec_size(struct ip_mc_list *pmc, int type, int gdel, int sdel)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 8524f2ac2cf3..46b84d029205 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -470,7 +470,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst(skb)->dev;
+	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
 	int vif = l3mdev_master_ifindex_rcu(dev);
 	struct ipq *qp;
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 150cdea8aacb..3bb198b2c101 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -116,7 +116,7 @@ int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IP);
 
 	return nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT,
-		       net, sk, skb, NULL, skb_dst(skb)->dev,
+		       net, sk, skb, NULL, skb_dst_dev(skb),
 		       dst_output);
 }
 
@@ -199,7 +199,7 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct rtable *rt = (struct rtable *)dst;
-	struct net_device *dev = dst->dev;
+	struct net_device *dev = dst_dev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 	struct neighbour *neigh;
 	bool is_v6gw = false;
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 02744447e435..cd61a417c44d 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -226,7 +226,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error_icmp;
 	}
 
-	tdev = dst->dev;
+	tdev = dst_dev(dst);
 
 	if (tdev == dev) {
 		dst_release(dst);
@@ -256,7 +256,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 xmit:
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
-	skb->dev = skb_dst(skb)->dev;
+	skb->dev = skb_dst_dev(skb);
 
 	err = dst_output(tunnel->net, skb->sk, skb);
 	if (net_xmit_eval(err) == 0)
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index bd135165482a..c450509d6efd 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -19,12 +19,12 @@
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
 int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned int addr_type)
 {
+	struct net_device *dev = skb_dst_dev(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt;
 	struct flowi4 fl4 = {};
 	__be32 saddr = iph->saddr;
 	__u8 flags;
-	struct net_device *dev = skb_dst(skb)->dev;
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 
@@ -73,7 +73,7 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 #endif
 
 	/* Change in oif may mean change in hh_len. */
-	hh_len = skb_dst(skb)->dev->hard_header_len;
+	hh_len = skb_dst_dev(skb)->hard_header_len;
 	if (skb_headroom(skb) < hh_len &&
 	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)),
 				0, GFP_ATOMIC))
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 789953096c80..5010a9a75418 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -416,7 +416,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 					   const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst->dev;
+	struct net_device *dev = dst_dev(dst);
 	struct neighbour *n;
 
 	rcu_read_lock();
@@ -443,7 +443,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst->dev;
+	struct net_device *dev = dst_dev(dst);
 	const __be32 *pkey = daddr;
 
 	if (rt->rt_gw_family == AF_INET) {
@@ -1069,7 +1069,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		return;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst->dev);
+	net = dev_net_rcu(dst_dev(dst));
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1367,7 +1367,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 	struct net *net;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst->dev);
+	net = dev_net_rcu(dst_dev(dst));
 	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
 				   net->ipv4.ip_rt_min_advmss);
 	rcu_read_unlock();
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 408985eb74ee..86c995dc1c5e 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -558,6 +558,7 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
 void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	struct net_device *dev;
 	struct dst_entry *dst;
 	struct sk_buff *skb;
 
@@ -575,7 +576,8 @@ void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 	} else if (tp->syn_fastopen_ch &&
 		   atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times)) {
 		dst = sk_dst_get(sk);
-		if (!(dst && dst->dev && (dst->dev->flags & IFF_LOOPBACK)))
+		dev = dst ? dst_dev(dst) : NULL;
+		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);
 		dst_release(dst);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3f9e1cfde008..3055478860c1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -732,7 +732,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
-	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
+	net = sk ? sock_net(sk) : skb_dst_dev_net(skb);
+
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index e0883ba709b0..49983d864e4f 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -166,11 +166,11 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 					  unsigned int hash)
 {
 	struct tcp_metrics_block *tm;
-	struct net *net;
 	bool reclaim = false;
+	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net(dst->dev);
+	net = dev_net(dst_dev(dst));
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dev_net(dst->dev);
+	net = dev_net(dst_dev(dst));
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dev_net(dst->dev);
+	net = dev_net(dst_dev(dst));
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 3cff51ba72bb..0ae67d537499 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -31,7 +31,7 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
-			    net, sk, skb, skb->dev, skb_dst(skb)->dev,
+			    net, sk, skb, skb->dev, skb_dst_dev(skb),
 			    __xfrm4_output,
 			    !(IPCB(skb)->flags & IPSKB_REROUTED));
 }

-- 
2.55.0

