Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63319308F2A;
	Fri, 21 Aug 2026 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319262; cv=none; b=E3D6Ddz3rucN4yeEvb3IGbE1IZ7GBDfUFNbH/YYs8yakOb0oO803g3eCeEwraN0HILBtN6J/IBB4+vSJe3HNP+CJFgAn65RsV/4M/vIbWaN8p/etUHiAG1LnuQZAc1xXuHYc5DV82XEV0g8JKS6hZotwZnX4TLh9y/f67JbdU/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319262; c=relaxed/simple;
	bh=9RmWmG6TCAK3Qc3e5Fz0iYlxuYN74qkU8jzdClOZC7U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ws7QdgAKi/iYKXul8zU3pX82Jokk84NjjwA9N8FsjLaaLeVCb/6DbrxrSQeGFugUvV4+V63ZqNIlyMB6xHVc6XSoF0Vj0U59eX2PDFE3FdPZ0HSf8v0oBnQ4F8k3GDtPfROASUqELSEAyLiW4JagsWLVGLaS9A4Gjq/QhXUaztw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=aJbiLYJj; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="aJbiLYJj"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id D17EE4E4131F;
	Fri, 21 Aug 2026 13:34:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9D8EC604AA;
	Fri, 21 Aug 2026 13:34:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DBE9311C7714B;
	Fri, 21 Aug 2026 15:34:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787319253; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=INNS0HrYZ668pkp9FS3gsEOdefJAhBkILcgEHBCAIrA=;
	b=aJbiLYJjc4mMJUmYheb67z+jQuQ3kjLyW6aXPETak/ev8jv6KVvWSGG7YRHu6vKwqibqYU
	KWCWIegAGFh2IcQyuLH3syeaDO4VJQwJpt5TU9yEQTtM9gwwswLAu5dum2AeJ/DKHsOT/r
	iBX0FG7iin6cwQklx6Y6CGbfArfX0TKO7X+3FrQ8SPrbW9Boq6j+yEqKHcGeIMBKS6zmYW
	fFiLdOsnsQb8JkOE0Krts66JQOpZQjJceAAhKG/4P3OFYhJENizUZ6N+Hvw4dTm66vK7nJ
	QnkrqLZnWc6gxfDSVUIFgd/Kgdo273CC+GL6KZD3QB6TqJfVu+2TeKsAeconuA==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Fri, 21 Aug 2026 15:33:36 +0200
Subject: [PATCH v6.1.y 2/4] ipv4: adopt dst_dev, skb_dst_dev and
 skb_dst_dev_net[_rcu]
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cve-2025-40074-6-1-v1-2-cad5cf499b76@bootlin.com>
References: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
In-Reply-To: <20260821-cve-2025-40074-6-1-v1-0-cad5cf499b76@bootlin.com>
To: stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>, 
 Martin KaFai Lau <kafai@fb.com>, 
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
 David Ahern <dsahern@kernel.org>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, Miguel Gazquez <miguel.gazquez@bootlin.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787319234; l=14405;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=A8sC6YP7637wm/fpcRHTREvRbqLDf8K4cyF2KRvHF9Y=;
 b=tvr3EUE0AkBLZXJmHT6Vl7WSEREPcVxiH9KcQWa69+EpyS8NsYs61YN/cBUZbPR3vqLqQF20L
 8R6Zcr5kiUTBhZhCNaQFnnBRCjtlMIvqSuLpF+vBnghk7LSTENVSKO8
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
Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
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
index ce58cf10ecb4..ac85405308c9 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -470,7 +470,7 @@ static inline struct sock *__inet_lookup_skb(struct inet_hashinfo *hashinfo,
 	if (sk)
 		return sk;
 
-	return __inet_lookup(dev_net(skb_dst(skb)->dev), hashinfo, skb,
+	return __inet_lookup(skb_dst_dev_net(skb), hashinfo, skb,
 			     doff, iph->saddr, sport,
 			     iph->daddr, dport, inet_iif(skb), sdif,
 			     refcounted);
diff --git a/include/net/ip.h b/include/net/ip.h
index 1b0722e9b55e..fe0ceb3fd6e6 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -452,7 +452,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net *net = dev_net(dst->dev);
+	struct net *net = dev_net(dst_dev(dst));
 	unsigned int mtu;
 
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
@@ -468,7 +468,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst->dev->mtu);
+	mtu = READ_ONCE(dst_dev(dst)->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
@@ -484,16 +484,17 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
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
 
 struct dst_metrics *ip_fib_metrics_init(struct net *net, struct nlattr *fc_mx,
diff --git a/include/net/route.h b/include/net/route.h
index 4fa45dda2bb3..ce608f883040 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -362,7 +362,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst->dev);
+		net = dev_net_rcu(dst_dev(dst));
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index e8c59c2051c2..7763a98ddc96 100644
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
@@ -905,7 +907,7 @@ static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 	struct net *net;
 	u32 info = 0;
 
-	net = dev_net_rcu(skb_dst(skb)->dev);
+	net = skb_dst_dev_net_rcu(skb);
 
 	/*
 	 *	Incomplete header ?
@@ -1048,7 +1050,7 @@ static enum skb_drop_reason icmp_echo(struct sk_buff *skb)
 	struct icmp_bxm icmp_param;
 	struct net *net;
 
-	net = dev_net_rcu(skb_dst(skb)->dev);
+	net = skb_dst_dev_net_rcu(skb);
 	/* should there be an ICMP stat for ignored echos? */
 	if (READ_ONCE(net->ipv4.sysctl_icmp_echo_ignore_all))
 		return SKB_NOT_DROPPED_YET;
@@ -1225,7 +1227,7 @@ static enum skb_drop_reason icmp_timestamp(struct sk_buff *skb)
 	return SKB_NOT_DROPPED_YET;
 
 out_err:
-	__ICMP_INC_STATS(dev_net_rcu(skb_dst(skb)->dev), ICMP_MIB_INERRORS);
+	__ICMP_INC_STATS(skb_dst_dev_net_rcu(skb), ICMP_MIB_INERRORS);
 	return SKB_DROP_REASON_PKT_TOO_SMALL;
 }
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index fd12b256e05d..bd1726b8ae88 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -424,7 +424,7 @@ static int igmpv3_sendpack(struct sk_buff *skb)
 
 	pig->csum = ip_compute_csum(igmp_hdr(skb), igmplen);
 
-	return ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
+	return ip_local_out(skb_dst_dev_net(skb), skb->sk, skb);
 }
 
 static int grec_size(struct ip_mc_list *pmc, int type, int gdel, int sdel)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 0ed999fdca2d..a70ede523297 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -481,7 +481,7 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst(skb)->dev;
+	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
 	int vif = l3mdev_master_ifindex_rcu(dev);
 	struct ipq *qp;
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 778214137e4a..5e1c368132de 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -113,7 +113,7 @@ int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IP);
 
 	return nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT,
-		       net, sk, skb, NULL, skb_dst(skb)->dev,
+		       net, sk, skb, NULL, skb_dst_dev(skb),
 		       dst_output);
 }
 
@@ -195,7 +195,7 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct rtable *rt = (struct rtable *)dst;
-	struct net_device *dev = dst->dev;
+	struct net_device *dev = dst_dev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 	struct neighbour *neigh;
 	bool is_v6gw = false;
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 7daf01af6295..2e07592d8b96 100644
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
index 783460ebfc47..a2985265c792 100644
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
index cbce1306bb08..b295e2e555bb 100644
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
index 753a881ce3cd..f72e7a5856d0 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -733,7 +733,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_base = (unsigned char *)&rep;
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
-	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
+	net = sk ? sock_net(sk) : skb_dst_dev_net(skb);
+
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index a4e03a7a2c03..8bf1118e04c6 100644
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

