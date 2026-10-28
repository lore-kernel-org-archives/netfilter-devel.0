Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.252.153.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214739;
	b=CFaW1GNwPSFnTphYtKsOBXMFV1WihMdKVkrM7ukttaEFy+YTxeVI+evBFM2qiD/ZS42d
	 GP16Fq1fMB6r762Z7j0xoxrcaRVVk+X7TNx2l6+FuYKTpgGtwbDeYGJbwLtQSs7T3Q54c
	 U5gFB4wqDfZjeqrs151dtirbuut1Ve5BO167EEzAhuLiiUg+KT6TiU/bGQmIXjnItiY82
	 xgnFO4+NZHMnOE6iwEyOVapLB30/1VDExeYBu5f6CQrfeo+9BH8Wy70f0Tr4RGwcwI1Sz
	 yAJb31yevUSW1rcHVLLTTe/VLzkpF3FIgw0dltXGTYBinYGBdmH+tnpiwyyqan4+B5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214739;
	h=DMARC-Filter:DKIM-Signature:Received:X-Riseup-User-ID:Received:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=oLtuv/gnFrQwOqM+6mYeoBXo66sebKdzhikXW1E05XU=;
	b=CBx3ow80+MFUNSbaCOHdin0e2sWyo1+XRRKBApNcGb0j9FIIVW1p/q8kLKAYooP9VQ8P
	 8Ri7qzjD2yLhL/uWLrDuzucYCh6Cu6ZM4Av+SBO4VVnTEzLnPJGyvxQ5Cx1rq6XBa8jrB
	 6IKBI9O7BtM5Ym76SOXcxbqcc+vUs9LjAllE1vqKwNT3efD7p8PxqaGpiJQvD1BICmsv0
	 UQ/y/0KxcJFOWrRdx8sDgud+mrKPn9OHsKFx5oyTwDq5l8ucmUBx1OAEcPhGh5w48k1hq
	 Y08KJ/v2i2seXAppXmxuuz22f+idSr9GVWosm2CvfXmUrJr+iny8Byam53jnNxx5hDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=riseup.net;
	spf=pass smtp.mailfrom=riseup.net;
	dkim=pass header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=ZTOYUTQX;
	arc=none smtp.remote-ip=198.252.153.6
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B0606A33D;
	Wed, 28 Oct 2026 19:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E49B0606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=ZTOYUTQX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1793214738; bh=oLtuv/gnFrQwOqM+6mYeoBXo66sebKdzhikXW1E05XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTOYUTQXAKca5JkW0zTxh2LEzFHTFELMeBFqeVHFugNwEs5qj9tbjYkvWIlhDOFBy
	 1SlhOvsxYup967yHQOAvyPB6jbkNrsS5t0FHkdoZqXz10AY4Pwqou3RQrOx3ifOEId
	 MxAlufw3Uq2fvogVbwFfiyr+e5GP2N2nDTZXxJ/0=
Received: from fews04-sea.riseup.net (fews04-sea-pn.riseup.net [10.0.1.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx0.riseup.net (Postfix) with ESMTPS id 4jFH6n5zJYz9rwx;
	Wed, 28 Oct 2026 19:12:17 +0000 (UTC)
X-Riseup-User-ID: 2119D5AE5C25B5EF5F3A60F4F818DA3EA670DAD9BEECF2F47086DA9D383C0FE6
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews04-sea.riseup.net (Postfix) with ESMTPSA id 4jFH6Z74lrz5vZ5;
	Wed, 28 Oct 2026 19:12:06 +0000 (UTC)
From: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>
To: Alexei Starovoitov <ast@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@riseup.net>,
	bpf@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	coreteam@netfilter.org,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Jeff Layton <jlayton@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Joe Damato <joe@dama.to>,
	John Fastabend <john.fastabend@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Li RongQing <lirongqing@baidu.com>,
	linux-kselftest@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>,
	Qi Tang <tpluszz77@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Willem de Bruijn <willemb@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Yonghong Song <yonghong.song@linux.dev>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
	Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net v3 2/3] net/ipv6: don't route packets with unknown source address
Date: Wed, 28 Oct 2026 20:10:56 +0100
Message-ID: <20261028191103.623156-3-ihuguet@riseup.net>
In-Reply-To: <20261028191103.623156-1-ihuguet@riseup.net>
References: <20261028191103.623156-1-ihuguet@riseup.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Don't allow routing packets with a source address that is not configured
in the host. Allow it only in certain cases like when using a
transparent socket, by setting the ANYSRC flag in flowi_flags.

Until now, it was possible to send such a packet if a route can be found
in the routing table for it. For example:
1. Configure two addresses 1:2::3:4/64 and 1:2::3:5/64
2. Establish a TCP connection to 1:2::3:4
3. Remove the address from the interface, but keep the other.
4. Packets are still sent out by the TCP connection because of
   the automatic route created for the 2nd address. No incoming
   packets are accepted, though.

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

This issue was reported by a user to whom IPv6 packets were leaked after
removing the IPv6 address for the interface. The same happens if the
address has its valid_lft expired.

There is a valid use case that would break with this change: loopback
subnets (aka AnyIP). They work in the following way: the administrator
adds a route like `local 2001:db8:cafe::/64 dev lo`, so that the host
will accept connections to all the addresses of that subnet. However,
there is no address assigned to any interface, only a route, so that
outgoing packets would be dropped because the source address doesn't
belong to any interface in the host.

In IPv4, loopback subnets work because __ip_dev_find fallbacks to a
FIB lookup. For IPv6 it is unclear if such a change would be desired
by all the current callers of ipv6_dev_find, ipv6_chk_addr and
ipv6_chk_addr_and_flags, likely not. Because of that, add the FIB lookup
fallback into ip6_output, where the check of the source address has been
added.

Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>

---
 drivers/net/vrf.c                |  1 +
 net/core/filter.c                |  1 +
 net/core/lwt_bpf.c               |  1 +
 net/ipv6/af_inet6.c              |  1 +
 net/ipv6/datagram.c              |  1 +
 net/ipv6/icmp.c                  |  5 +++++
 net/ipv6/inet6_connection_sock.c |  2 ++
 net/ipv6/ip6_output.c            | 38 ++++++++++++++++++++++++++++++++
 net/ipv6/ip6_udp_tunnel.c        |  1 +
 net/ipv6/netfilter.c             | 11 +++++++--
 net/ipv6/ping.c                  |  1 +
 net/ipv6/raw.c                   |  1 +
 net/ipv6/syncookies.c            |  1 +
 net/ipv6/tcp_ipv6.c              |  7 +++++-
 net/ipv6/udp.c                   |  1 +
 net/l2tp/l2tp_ip6.c              |  2 ++
 16 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 79d433f49f80..4222e598290c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -432,6 +432,7 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	fl6.flowlabel = ip6_flowinfo(iph);
 	fl6.flowi6_mark = skb->mark;
 	fl6.flowi6_proto = iph->nexthdr;
+	fl6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 
 	dst = ip6_dst_lookup_flow(net, NULL, &fl6, NULL);
 	if (IS_ERR(dst) || dst == dst_null)
diff --git a/net/core/filter.c b/net/core/filter.c
index 70dc621672f2..65ff54f6a29d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5077,6 +5077,7 @@ BPF_CALL_4(bpf_skb_set_tunnel_key, struct sk_buff *, skb,
 		       sizeof(from->local_ipv6));
 		info->key.label = cpu_to_be32(from->tunnel_label) &
 				  IPV6_FLOWLABEL_MASK;
+		info->key.flow_flags = FLOWI_FLAG_ANYSRC;
 	} else {
 		info->key.u.ipv4.dst = cpu_to_be32(from->remote_ipv4);
 		info->key.u.ipv4.src = cpu_to_be32(from->local_ipv4);
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
index a9b8b4b42a1a..8e3c6e095419 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -816,6 +816,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
 	fl6->flowi6_uid = sk_uid(sk);
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
 	ip6_ecmp_set_mp_hash(sock_net(sk), fl6, sk->sk_txhash);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 7b71a932544d..f09bbffec0e7 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -52,6 +52,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6,
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk_uid(sk);
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a95b0351824f..b4b54297c923 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -393,6 +393,11 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
 	if (err)
 		goto relookup_failed;
 
+	/* New src is the original dst. It may not be a local address, like with
+	 * encapsulated traffic.
+	 */
+	fl2.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+
 	err = ip6_dst_lookup(net, sk, &dst2, &fl2);
 	if (err)
 		goto relookup_failed;
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
index 25fe0ba98b1a..8715cf43f00a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1134,6 +1134,33 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
 	return dst;
 }
 
+/* Check if the address belongs to the host */
+static bool ip6_is_local_saddr(struct net *net, struct in6_addr *saddr)
+{
+	struct fib6_result fib_result;
+	struct flowi6 fl6;
+	bool result;
+
+	if (ipv6_chk_addr_namespace(net, saddr) ||
+	    ipv6_chk_acast_addr_src(net, NULL, saddr))
+		return true;
+
+	/* Fallback to FIB local routes so that loopback subnets work. */
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.daddr = *saddr;
+	result = false;
+
+	rcu_read_lock();
+	if (fib6_lookup(net, 0, &fl6, &fib_result, 0) == 0 &&
+	    fib_result.fib6_type == RTN_LOCAL &&
+	    fib_result.nh->nh_common.nhc_dev) {
+		result = true;
+	}
+	rcu_read_unlock();
+
+	return result;
+}
+
 static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 			       struct dst_entry **dst, struct flowi6 *fl6)
 {
@@ -1191,6 +1218,17 @@ static int ip6_dst_lookup_tail(struct net *net, const struct sock *sk,
 	if (err)
 		goto out_err_release;
 
+	/* From RFC 4862, "an invalid address MUST NOT be used as the source
+	 * address of outbound packets". Exceptions to this must set the ANYSRC
+	 * flag (i.e. transparent sockets).
+	 */
+	if (!ipv6_addr_any(&fl6->saddr) &&
+	    !(fl6->flowi6_flags & FLOWI_FLAG_ANYSRC) &&
+	    !ip6_is_local_saddr(net, &fl6->saddr)) {
+		err = -ENETUNREACH;
+		goto out_err_release;
+	}
+
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
 	/*
 	 * Here if the dst entry we've looked up
diff --git a/net/ipv6/ip6_udp_tunnel.c b/net/ipv6/ip6_udp_tunnel.c
index 32525a051a6f..1727c36ff6a4 100644
--- a/net/ipv6/ip6_udp_tunnel.c
+++ b/net/ipv6/ip6_udp_tunnel.c
@@ -161,6 +161,7 @@ struct dst_entry *udp_tunnel6_dst_lookup(struct sk_buff *skb,
 	fl6.fl6_sport = sport;
 	fl6.fl6_dport = dport;
 	fl6.flowlabel = ip6_make_flowinfo(dsfield, key->label);
+	fl6.flowi6_flags = key->flow_flags;
 
 	dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL);
 	if (IS_ERR(dst)) {
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87035..716fc6e246de 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -29,8 +29,9 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	struct flow_keys flkeys;
 	unsigned int hh_len;
 	struct dst_entry *dst;
-	int strict = (ipv6_addr_type(&iph->daddr) &
-		      (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL));
+	int saddr_type = ipv6_addr_type(&iph->saddr);
+	int daddr_type = ipv6_addr_type(&iph->daddr);
+	int strict = daddr_type & (IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL);
 	struct flowi6 fl6 = {
 		.flowi6_l3mdev = l3mdev_master_ifindex(dev),
 		.flowi6_mark = skb->mark,
@@ -41,6 +42,12 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 	};
 	int err;
 
+	fl6.flowi6_flags = sk ? inet_sk_flowi_flags(sk) : 0;
+	if (saddr_type & (IPV6_ADDR_UNICAST | IPV6_ADDR_LINKLOCAL))
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
index e006a30360ea..5248cbd4b595 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -271,8 +271,9 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = usin->sin6_port;
 	fl6->fl6_sport = inet->inet_sport;
+	fl6->flowi6_flags = inet_sk_flowi_flags(sk);
 	if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !fl6->fl6_sport)
-		fl6->flowi6_flags = FLOWI_FLAG_ANY_SPORT;
+		fl6->flowi6_flags |= FLOWI_FLAG_ANY_SPORT;
 	fl6->flowi6_uid = sk_uid(sk);
 
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
@@ -982,6 +983,10 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	fl6.flowi6_uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
+	if (sk && sk_fullsock(sk))
+		fl6.flowi6_flags = inet_sk_flowi_flags(sk);
+	else if (sk && inet_sk_transparent(sk))
+		fl6.flowi6_flags = FLOWI_FLAG_ANYSRC;
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
 
 	/* Pass a socket to ip6_dst_lookup either it is for RST
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 59f9872c3552..7492d155726a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1650,6 +1650,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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

