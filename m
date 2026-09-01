Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D479363C46;
	Tue,  1 Sep 2026 11:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788263463; cv=none; b=FNl8RjxKlvBZINCwOGINytuS2V2UzCEIooHhMFuq/ovPJSemv7WQdzojsMz+Rth2ZlcKSAVloiC08xddS3NFmRPF/o39aaQ8Zwe5TwzGz9erW3Bl+TwQrjxJmhalZHsmuZcmCyOIJ1MIav8aSdYdgfhPTrdX9VWUyXrjiDhRMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788263463; c=relaxed/simple;
	bh=zqdUYV1yNctxuRi2ceiURU5QKjQzKpJ/jpsDnKflsTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fYQsbJ1BNim9ufD0x1LI4lcsCt2eFvQQ0+qtL61SKDS7l6+xv/b6CkWFzAoCmH08T4hWzMpkGOOGNSRTsiaqDNlAQx9ncfRUDY3qO6OWahLzKmzcBF1Gc4ptqrgqIpiOFf0O5p+odme8Yc+a2YCG4oQ+xVRpsEpf12JmYBSZDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=VfUylumr; arc=none smtp.client-ip=198.252.153.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="VfUylumr"
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.riseup.net (Postfix) with ESMTPS id 4hZ41b1B0tzDqhC;
	Tue,  1 Sep 2026 11:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1788263454; bh=IPswc6Cjd8p7WwVezZA2g6UODoR/ie6W2jlz9aPTgYY=;
	h=From:To:Cc:Subject:Date:From;
	b=VfUylumrcmaQjvyhXLkMyiR9wENqWf4nTKiGtdP8Yvs/Q5OqprQU4gIcKq0gKOIok
	 46FJYz5quOY4S4XLDs53bNJwcZ1+mtizdi3Q3gCrvScbu94Bxzoh9HCltv1nydkw0V
	 m/yoim5TLMIg2q0i6yXrsZWZucC3RsqmJXC0zyQA=
X-Riseup-User-ID: E5F8F7D98D2829322768F754E05AE5AE62A09FBC44B70DAB5A0A24EA938CE3A6
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4hZ41Q1d1Sz1xpZ;
	Tue,  1 Sep 2026 11:50:34 +0000 (UTC)
From: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>
To: David Ahern <dsahern@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Neal Cardwell <ncardwell@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Phil Sutter <phil@nwl.cc>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Junseo Lim <zirajs7@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	Kees Cook <kees@kernel.org>,
	Qi Tang <tpluszz77@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Joe Damato <joe@dama.to>,
	Breno Leitao <leitao@debian.org>,
	Li RongQing <lirongqing@baidu.com>,
	netdev@vger.kernel.org (open list:VRF),
	linux-kernel@vger.kernel.org (open list),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_))
Subject: [PATCH net] net/ipv6: don't route packets with unknown source address
Date: Tue,  1 Sep 2026 13:50:07 +0200
Message-ID: <20260901115021.50057-1-ihuguet@riseup.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Don't allow routing packets with a source address that is not configured
in the host. Allow it only in certain cases like when using a
transparent socket, by setting the ANYSRC flag in flowi_flags.

Until now, it was possible to send such a packet if a route can be found
in the routing table for it. For example:
1. Configure an address 1:2::3:4/64 and a static route 1:2::/64
2. Establish a TCP connection to 1:2::3:4
3. Remove the address from the interface, but keep the route.
4. Packets are still sent out by the TCP connection because of
   the static route. No incoming packets are accepted, though.

This patch prevents the outgoing packets to be sent in normal
circumnstances.

This aligns the behaviour with the IPv4 stack. To determine the places
where the ANYSRC needs to be set, I set the flag in the same places as
the IPv4 stack does.

Apart from consolidating the behaviour of both stacks, there is a more
important reason why this is needed. RFC 4862 states that "an invalid
address MUST NOT be used as the source address of outbound packets".
Therefore, sending packets with a source address considered "invalid",
like an expired address, is disallowed.

Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>

---

Testing: tested with a manual reproducer executing the steps described
above. Tested also with transparent sockets to ensure that the packets
are sent in that case. Also executed the following selftests to prevent
potential regressions: fcnal-ipv6, fib_tests, fib-onlink-tests,
nft_nat, nft_tproxy_tcp, nft_tproxy_udp.

The change in the netfilter's ip6_route_me_harder function is the one
that I'm more unsure about. It was not clear to me the reason why it was
done like this in the IPv4 counterpart. Please review carefully.
---
 drivers/net/vrf.c                |  1 +
 net/core/lwt_bpf.c               |  1 +
 net/ipv6/af_inet6.c              |  1 +
 net/ipv6/datagram.c              |  1 +
 net/ipv6/inet6_connection_sock.c |  2 ++
 net/ipv6/ip6_output.c            | 28 ++++++++++++++++++++++++++++
 net/ipv6/netfilter.c             | 10 ++++++++--
 net/ipv6/ping.c                  |  1 +
 net/ipv6/raw.c                   |  1 +
 net/ipv6/syncookies.c            |  1 +
 net/ipv6/tcp_ipv6.c              |  2 ++
 net/ipv6/udp.c                   |  1 +
 net/l2tp/l2tp_ip6.c              |  2 ++
 13 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index a0557a3a7026..6c09d5f46d6b 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -432,6 +432,7 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	fl6.flowlabel = ip6_flowinfo(iph);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = iph->nexthdr;
+	fl6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 
 	dst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
 	if (IS_ERR(dst) || dst == dst_null)
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index da49364ec63d..e8b954282689 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -233,6 +233,7 @@ static int bpf_lwt_xmit_reroute(struct sk_buff *skb)
 		fl6.flowi6_mark = skb->mark;
 		fl6.flowi6_uid = sock_net_uid(net, sk);
 		fl6.flowlabel = ip6_flowinfo(iph6);
+		fl6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 		fl6.flowi6_proto = iph6->nexthdr;
 		fl6.daddr = iph6->daddr;
 		fl6.saddr = iph6->saddr;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 282912a11999..e55a36372ab2 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -820,6 +820,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
 	fl6->flowi6_uid = sk_uid(sk);
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
 	ip6_ecmp_set_mp_hash(sock_net(sk), fl6, sk->sk_txhash);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 38d7b4845281..0773bfa0342d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -52,6 +52,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6,
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk_uid(sk);
 
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 3e4ce8cb478e..f295f3efe243 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -45,6 +45,7 @@ struct dst_entry *inet6_csk_route_req(const struct sock *sk,
 	fl6->flowi6_mark = ireq->ir_mark;
 	fl6->fl6_dport = ireq->ir_rmt_port;
 	fl6->fl6_sport = htons(ireq->ir_num);
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	fl6->flowi6_uid = sk_uid(sk);
 	security_req_classify_flow(req, flowi6_to_flowi_common(fl6));
 
@@ -71,6 +72,7 @@ struct dst_entry *inet6_csk_route_socket(struct sock *sk,
 	fl6->daddr = sk->sk_v6_daddr;
 	fl6->saddr = np->saddr;
 	fl6->flowlabel = np->flow_label;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	IP6_ECN_flow_xmit(sk, fl6->flowlabel);
 
 	if (sk->sk_protocol == IPPROTO_TCP)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8fc4766c8da9..57eebe347902 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1191,6 +1191,34 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 	if (err)
 		goto out_err_release;
 
+	/* Routing packets with a source address not present in the host is
+	 * disallowed unless the ANYSRC flag is set (i.e. with transparent sockets).
+	 * The source address must be in the same L3 domain as the destination device.
+	 */
+	if (!ipv6_addr_any(&fl6->saddr) &&
+	    !(fl6->flowi6_flags & FLOWI_FLAG_ANYSRC)) {
+		struct net_device *oif_dev;
+
+		rcu_read_lock();
+		/* For local routes, (*dst)->dev can be 'lo', which has no l3mdev
+		 * master, so that the L3 domain wouldn't match if the source
+		 * address is in a VRF-enslaved device. To avoid that, check the
+		 * outgoing interface from the flowi6 structure instead.
+		 */
+		if (fl6->flowi6_oif)
+			oif_dev = dev_get_by_index_rcu(net, fl6->flowi6_oif);
+		else
+			oif_dev = (*dst)->dev;
+
+		if (!ipv6_chk_addr_and_flags(net, &fl6->saddr, oif_dev,
+					     1, 1, IFA_F_TENTATIVE))
+			err = -ENETUNREACH;
+		rcu_read_unlock();
+
+		if (err)
+			goto out_err_release;
+	}
+
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
 	/*
 	 * Here if the dst entry we've looked up
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87035..7c19ecbec112 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -26,11 +26,11 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct sock *sk = sk_to_full_sk(sk_partial);
 	struct net_device *dev = skb_dst_dev(skb);
+	int daddr_type = ipv6_addr_type(&iph->daddr);
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
-	int strict = (ipv6_addr_type(&iph->daddr) &
-		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
+	int strict = daddr_type & (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL);
 	struct flowi6 fl6 = {
 		.flowi6_l3mdev = l3mdev_master_ifindex(dev),
 		.flowi6_mark = skb->mark,
@@ -41,6 +41,12 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	fl6.flowi6_flags = sk ? inet_sk_flowi_flags(sk) : 0;
+	if (daddr_type & (IPV6_ADDR_UNICAST | IPV6_ADDR_LINKLOCAL))
+		fl6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+	else
+		fl6.saddr = in6addr_any;
+
 	if (sk && sk->sk_bound_dev_if)
 		fl6.flowi6_oif = sk->sk_bound_dev_if;
 	else if (strict)
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 6e90d0bf9f3d..d0964396c2c5 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -140,6 +140,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
 	fl6.saddr = np->saddr;
 	fl6.daddr = *daddr;
+	fl6.flowi6_flags = inet_sk_flowi_flags(sk);
 	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk_uid(sk);
 	fl6.fl6_icmp_type = user_icmph.icmp6_type;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index b965258cf9e5..ef5ddbe7ac10 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -887,6 +887,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		fl6.flowi6_oif = READ_ONCE(np->ucast_oif);
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
+	fl6.flowi6_flags = inet_sk_flowi_flags(sk);
 	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index b581cb1ee2e8..3d665e93fcac 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -242,6 +242,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		fl6.flowi6_mark = ireq->ir_mark;
 		fl6.fl6_dport = ireq->ir_rmt_port;
 		fl6.fl6_sport = inet_sk(sk)->inet_sport;
+		fl6.flowi6_flags = inet_sk_flowi_flags(sk);
 		fl6.flowi6_uid = sk_uid(sk);
 		security_req_classify_flow(req, flowi6_to_flowi_common(&fl6));
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index df9c29eb5c1f..401a1297e7db 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -268,6 +268,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = usin->sin6_port;
 	fl6->fl6_sport = inet->inet_sport;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !fl6->fl6_sport)
 		fl6->flowi6_flags = FLOWI_FLAG_ANY_SPORT;
 	fl6->flowi6_uid = sk_uid(sk);
@@ -979,6 +980,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	fl6.flowi6_uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
+	fl6.flowi6_flags = sk ? inet_sk_flowi_flags(sk) : 0;
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
 
 	/* Pass a socket to ip6_dst_lookup either it is for RST
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 93478d1ad576..5154d445ba9c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1656,6 +1656,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
 		fl6->saddr = np->saddr;
 	fl6->fl6_sport = inet->inet_sport;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 
 	if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
 		err = BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index bdaae1b64d25..22ae5bc2669a 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -633,6 +633,8 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	else if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = READ_ONCE(np->ucast_oif);
 
+	fl6.flowi6_flags = inet_sk_flowi_flags(sk);
+
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
-- 
2.54.0

