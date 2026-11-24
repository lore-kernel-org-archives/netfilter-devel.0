Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525664;
	b=Cq2bMCCvYpjZdsb5kk71t73CGfF11eEMP/bFcDKMNClMgIZ9aL2wPfmqgpgn+RBDKjWk
	 JvE3h6i053pUdMaK7Us6hBHLvlJIBH5oWyHsNocRGMuMqy2bo0C34adD+M7gbjkYKVXK0
	 pd11USMI8C6FiQT919hfGO3mmrbB4KtDuV3jWk4COtoQuKiOOGaCguW/Wu36G8GHc+ZS6
	 llsZrbwAQzzX7htokc4VbuwZgqqgrhWghHTU7QkLt8jDlk6qokE0XePflHcbDoP9k21pA
	 UhL04hpvjxTVJaatfMsxw2WSL9bahm4QMTd7SHK3O4MM+8/Ot8oGOPk951RhumLJDZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525664;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fEuuayYjW4XK27k8r55+0VUrC6Hs/dGSwkUdlWW+LZE=;
	b=MvYEJ8Ohn2U116oWZaj8ejW4MNoMIUrVzsYBAxUrltd48ascvw9GMIp6Jh5lcdSX8mff
	 rrZNtNYLj6isOgCvqK768uwZwyH2t0jvxpFl/ASlooCF1Qas4tfX/NjiOoSwzQ1pjHp9o
	 +DAhk63PFracHG4fFxglLAwmHN/PPjw6/f2HGIHliO6/5NTlBsgYLKUBb+0i8pPn5CH+4
	 Ryq0dXVeSjSQtSP00mydH+v8pcY1/6gJw2YomKfHLDqCc3utxPXW6zZyu2DHEuRIE6Qgm
	 SzKMBrOUcE541qNsU397dDME886+8dmZBVytc+2LzPJCORwTa1CnS9MVt1QOvSRw9CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nTCif5DH;
	arc=none smtp.remote-ip=91.218.175.92
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC6606A31E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4AC6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nTCif5DH
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lVCqhItCiIoTTyh8Q0RjFysA+d8zHM9N0SL1I0gqsaw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525662; v=1; x=1796130462;
 b=nTCif5DHsuLLhbABZFrmTXL5VR37CfhjfNsbhVpjzZv5jdB/g3kRwQIIhEtexDBr3tDefviF
 Wuaix+5yQrTZ6lgwuUkaRPtZtF1ih6dD2ynTmfsOfP8VcsqY4DH6izzReWCYCyJU5IUnmnS/3Ct
 z7OjGj7N/L7dca0zY7NGiOPM=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a0f3c9bae6bbb747;
	Tue, 24 Nov 2026 13:07:41 +0000
X-Mizu-Trace-ID: a0f3c9bae6bbb747
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v1 2/6] ipv4: avoid a stack canary in ip_finish_output2()
Date: Tue, 24 Nov 2026 22:06:27 +0900
Message-ID: <20261124130631.1886963-3-xuanqiang.luo@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

ip_neigh_gw4() passes the address of its by-value @daddr argument to
__neigh_create() when the lockless lookup finds no neighbour.

Once inlined, this forces a stack canary (CONFIG_STACKPROTECTOR_STRONG=y)
into its callers, ip_finish_output2() being the one in the transmit path
of every IPv4 packet, although creating a neighbour is rare compared to
finding one.

Change ip_neigh_gw4() to take a pointer to the address, like
ip_neigh_gw6(). All callers have the address in the route, in the packet
or in another object that is not on their stack.

Call it only once in ip_neigh_for_gw() and ipv4_dst_neigh_lookup(), so
that the lookup and the creation are no longer inlined twice there.

Change the type of ipv4_nh in struct bpf_nh_params to __be32, since its
address is now given to ip_neigh_gw4().

Note that skb_do_redirect() and nf_flow_offload_ip_hook() still need a
canary for other reasons.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 1/5 up/down: 3/-846 (-843)
Function                                     old     new   delta
nf_flow_offload_ip_hook                     2065    2068      +3
ip_do_fragment                              1441    1425     -16
ipv4_dst_neigh_lookup                        684     587     -97
skb_do_redirect                             4382    4222    -160
vrf_finish_output                           1614    1345    -269
ip_finish_output2                           1775    1471    -304
Total: Before=24068916, After=24068073, chg -0.00%

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 include/linux/filter.h           |  2 +-
 include/net/route.h              | 16 ++++++++--------
 net/core/filter.c                |  2 +-
 net/ipv4/route.c                 | 15 +++++++--------
 net/netfilter/nf_flow_table_ip.c |  4 +++-
 5 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 4f0cd67caccb..e258ba4741af 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -871,7 +871,7 @@ struct bpf_skb_data_end {
 struct bpf_nh_params {
 	u32 nh_family;
 	union {
-		u32 ipv4_nh;
+		__be32 ipv4_nh;
 		struct in6_addr ipv6_nh;
 	};
 };
diff --git a/include/net/route.h b/include/net/route.h
index 3fccd31eb74d..1571e1c6082c 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -406,15 +406,15 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 }
 
 static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
-					     __be32 daddr)
+					     const __be32 *daddr)
 {
 	struct neighbour *neigh;
 
-	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
+	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)*daddr);
 	if (unlikely(!neigh)) {
 		struct neigh_table *tbl = arp_table(dev_net(dev));
 
-		neigh = __neigh_create(tbl, &daddr, dev, false);
+		neigh = __neigh_create(tbl, daddr, dev, false);
 	}
 
 	return neigh;
@@ -425,17 +425,17 @@ static inline struct neighbour *ip_neigh_for_gw(struct rtable *rt,
 						bool *is_v6gw)
 {
 	struct net_device *dev = rt->dst.dev;
-	struct neighbour *neigh;
+	const __be32 *daddr;
 
 	if (likely(rt->rt_gw_family == AF_INET)) {
-		neigh = ip_neigh_gw4(dev, rt->rt_gw4);
+		daddr = &rt->rt_gw4;
 	} else if (rt->rt_gw_family == AF_INET6) {
-		neigh = ip_neigh_gw6(dev, &rt->rt_gw6);
 		*is_v6gw = true;
+		return ip_neigh_gw6(dev, &rt->rt_gw6);
 	} else {
-		neigh = ip_neigh_gw4(dev, ip_hdr(skb)->daddr);
+		daddr = &ip_hdr(skb)->daddr;
 	}
-	return neigh;
+	return ip_neigh_gw4(dev, daddr);
 }
 
 #endif	/* _ROUTE_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index f42ecfb5841f..8ee023c87c24 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2376,7 +2376,7 @@ static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb,
 		neigh = ip_neigh_gw6(dev, &nh->ipv6_nh);
 		is_v6gw = true;
 	} else if (nh->nh_family == AF_INET) {
-		neigh = ip_neigh_gw4(dev, nh->ipv4_nh);
+		neigh = ip_neigh_gw4(dev, &nh->ipv4_nh);
 	} else {
 		rcu_read_unlock();
 		goto out_drop;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d0930ae4c5ae..585c10743e1b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -419,15 +419,14 @@ static struct neighbour *ipv4_dst_neigh_lookup(const struct dst_entry *dst,
 
 	rcu_read_lock();
 	dev = dst_dev_rcu(dst);
-	if (likely(rt->rt_gw_family == AF_INET)) {
-		n = ip_neigh_gw4(dev, rt->rt_gw4);
-	} else if (rt->rt_gw_family == AF_INET6) {
+	if (unlikely(rt->rt_gw_family == AF_INET6)) {
 		n = ip_neigh_gw6(dev, &rt->rt_gw6);
-        } else {
-		__be32 pkey;
-
-		pkey = skb ? ip_hdr(skb)->daddr : *((__be32 *) daddr);
-		n = ip_neigh_gw4(dev, pkey);
+	} else {
+		if (likely(rt->rt_gw_family == AF_INET))
+			daddr = &rt->rt_gw4;
+		else if (skb)
+			daddr = &ip_hdr(skb)->daddr;
+		n = ip_neigh_gw4(dev, daddr);
 	}
 
 	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 78bba416dd5b..19f62005b517 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -872,7 +872,9 @@ static int nf_flow_queue_xmit4(struct sk_buff *skb,
 			flow_offload_teardown(flow);
 			return NF_DROP;
 		}
-		neigh = ip_neigh_gw4(rt->dst.dev, rt_nexthop(rt, ip_addr->ip));
+		neigh = ip_neigh_gw4(rt->dst.dev,
+				     rt->rt_gw_family == AF_INET ?
+				     &rt->rt_gw4 : &ip_addr->ip);
 		if (IS_ERR(neigh)) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
-- 
2.43.0

