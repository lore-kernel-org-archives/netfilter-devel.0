Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192925;
	b=pBKYu7Awv1d3vz1iv9jZj34aYYn/UQqt/d12Xqm57YNsUYkGSA0OU/A4CyyCb17urw4N
	 bDvYUjO+jEZoTfSnVUbvwqHsT3zD+rS1YhyDIrrQyCVlrPSBNwK4ImgnWlNPXCKJqvfas
	 JV6GpzIO7a+jnBdrUGuoL7hqbaiI/PoBzIev1xJ1HdunJrh309Dnt+Kr3Y64OWeNj35XB
	 iPATSW+H6yk6RSP1ZueuxLoOHzC4NRJbVVX7lpS7PLp8A/c/8duq398CRyjqyHQ3ofEwH
	 A1vxqEgDvQU32lI3/pYQN8Wfu7JxbHe1PgpfjHk6aAMtKCPv0lt7AJCKZSCA6+FZtrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192925;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=98LE/RewkB/mIgXW5VS/v06u2iEnrqunStfHDCrZQtU=;
	b=JhttWHGRcXt6RnaMw6eDJGoEu/HsBwr9gJhOF7Fy2lm4s4n+IcKdwONgeH32TI4cHBq3
	 zxIIm0qWGfOZbtSR8RnNdJhZs+ESBbmxZRnJJHjLToXM8SAgWlVVJJPQMQjCg5OmRHCJQ
	 hDWDYWx97I3k+HOEu0GMKPBFS/gGRKfV5CFeeVcNY4URbPEQdZQ6Jva0wI2pKyRlb8mZe
	 kA9N/ZRg1kPCMHNf2Jz8vx3JL+dG8i0NSvgQYioX8qdY00b+v1oFKD/CgJZpcKGxUN/kW
	 3Om/S2XLpkyCDoQ0caf7doQ/GWujAwiNhOQHSUeH1kBAb3gkdGwdWKX2KMHBJXln4sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WFbQ1y71;
	arc=none smtp.remote-ip=91.218.175.37
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF89606A320
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 02:55:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAF89606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WFbQ1y71
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=inXLUMxi88jjAjyCcfXQ3nh2o8NgWQcLnFDb+eW27Lc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192922; v=1; x=1794797722;
 b=WFbQ1y71lK7GLyzNjPhra3OLXkwovIXx0c9PhLuI6eRoSd0t+kwA0lTQsNOSaRCbKJ1TIV3j
 /MzB31Le9lDvpoVr2AdqEN0W+oIebFW/kDrr9jnT+E+YBLu6o0yjVrsZMj40frrCae7bopZr41q
 cpNaqUIyJbDdfrRzpSaVyYXc=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 582f103ddfa10910;
	Mon, 09 Nov 2026 02:55:19 +0000
X-Mizu-Trace-ID: 582f103ddfa10910
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netdev@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paul Moore <paul@paul-moore.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Allison Henderson <achender@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	mptcp@lists.linux.dev,
	lvs-devel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-sctp@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH net-next 01/14] ipv4: annotate data-races around ip_rt_* sysctls
Date: Mon,  9 Nov 2026 10:52:00 +0800
Message-ID: <20261109025425.328445-2-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109025425.328445-1-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
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

ip_rt_redirect_number, ip_rt_redirect_load, ip_rt_redirect_silence,
ip_rt_error_cost, ip_rt_error_burst, ip_rt_gc_timeout, ip_rt_min_pmtu,
ip_rt_mtu_expires and ip_rt_min_advmss are read without any lock while
their sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to
the readers.

KCSAN reports it when net.ipv4.route.min_adv_mss is changed while TCP
connections are being opened:

  BUG: KCSAN: data-race in do_proc_int_conv / ipv4_default_advmss

  write (marked) to 0xffffffffb0828f70 of 4 bytes by task 715 on cpu 0:
   do_proc_int_conv+0xa9/0xd0
   proc_vec_conv+0x21/0x40
   proc_vec+0x21e/0x6f0
   proc_dointvec+0x16/0x30
   proc_sys_call_handler+0x282/0x3a0
   proc_sys_write+0x13/0x20
   ...

  read to 0xffffffffb0828f70 of 4 bytes by task 719 on cpu 1:
   ipv4_default_advmss+0x98/0x2c0
   __tcp_transmit_skb+0x1df4/0x28f0
   tcp_connect+0x266b/0x3c30
   tcp_v4_connect+0x9a1/0xae0
   __inet_stream_connect+0x1cc/0x760
   inet_stream_connect+0x49/0x80
   ...

  value changed: 0x00000100 -> 0x00000101

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/ipv4/route.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d0a5f6d77094c..83f49b2d4c36a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -829,7 +829,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 				nhc = FIB_RES_NHC(res);
 				update_or_create_fnhe(nhc, fl4->daddr, new_gw,
 						0, false,
-						jiffies + ip_rt_gc_timeout);
+						jiffies + READ_ONCE(ip_rt_gc_timeout));
 			}
 			if (kill_route)
 				WRITE_ONCE(rt->dst.obsolete, DST_OBSOLETE_KILL);
@@ -930,7 +930,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	/* No redirected packets during ip_rt_redirect_silence;
 	 * reset the algorithm.
 	 */
-	if (time_after(jiffies, peer->rate_last + ip_rt_redirect_silence)) {
+	if (time_after(jiffies, peer->rate_last + READ_ONCE(ip_rt_redirect_silence))) {
 		peer->rate_tokens = 0;
 		peer->n_redirects = 0;
 	}
@@ -938,7 +938,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	/* Too many ignored redirects; do not send anything
 	 * set dst.rate_last to the last seen redirected packet.
 	 */
-	if (peer->n_redirects >= ip_rt_redirect_number) {
+	if (peer->n_redirects >= READ_ONCE(ip_rt_redirect_number)) {
 		peer->rate_last = jiffies;
 		goto out_unlock;
 	}
@@ -946,7 +946,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	/* Check for load limit; set rate_last to the latest sent
 	 * redirect.
 	 */
-	backoff = (u64)ip_rt_redirect_load << min(peer->n_redirects, 31U);
+	backoff = (u64)READ_ONCE(ip_rt_redirect_load) << min(peer->n_redirects, 31U);
 	backoff = min_t(u64, backoff, MAX_JIFFY_OFFSET);
 	if (peer->n_redirects == 0 ||
 	    time_after(jiffies, peer->rate_last + (unsigned long)backoff)) {
@@ -956,7 +956,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 		peer->rate_last = jiffies;
 		++peer->n_redirects;
 		if (IS_ENABLED(CONFIG_IP_ROUTE_VERBOSE) && log_martians &&
-		    peer->n_redirects == ip_rt_redirect_number)
+		    peer->n_redirects == READ_ONCE(ip_rt_redirect_number))
 			net_warn_ratelimited("host %pI4/if%d ignores redirects for %pI4 to %pI4\n",
 					     &ip_hdr(skb)->saddr, inet_iif(skb),
 					     &ip_hdr(skb)->daddr, &gw);
@@ -1027,13 +1027,16 @@ static int ip_error(struct sk_buff *skb)
 			       l3mdev_master_ifindex_rcu(skb->dev));
 	send = true;
 	if (peer) {
+		int burst = READ_ONCE(ip_rt_error_burst);
+		int cost = READ_ONCE(ip_rt_error_cost);
+
 		now = jiffies;
 		peer->rate_tokens += now - peer->rate_last;
-		if (peer->rate_tokens > ip_rt_error_burst)
-			peer->rate_tokens = ip_rt_error_burst;
+		if (peer->rate_tokens > burst)
+			peer->rate_tokens = burst;
 		peer->rate_last = now;
-		if (peer->rate_tokens >= ip_rt_error_cost)
-			peer->rate_tokens -= ip_rt_error_cost;
+		if (peer->rate_tokens >= cost)
+			peer->rate_tokens -= cost;
 		else
 			send = false;
 	}
@@ -1063,14 +1066,14 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 
 	rcu_read_lock();
 	net = dst_dev_net_rcu(dst);
-	if (mtu < net->ipv4.ip_rt_min_pmtu) {
+	if (mtu < READ_ONCE(net->ipv4.ip_rt_min_pmtu)) {
 		lock = true;
-		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
+		mtu = min(old_mtu, READ_ONCE(net->ipv4.ip_rt_min_pmtu));
 	}
 
 	if (rt->rt_pmtu == mtu && !lock &&
 	    time_before(jiffies, READ_ONCE(dst->expires) -
-				 net->ipv4.ip_rt_mtu_expires / 2))
+				 READ_ONCE(net->ipv4.ip_rt_mtu_expires) / 2))
 		goto out;
 
 	if (fib_lookup(net, fl4, &res, 0) == 0) {
@@ -1086,14 +1089,15 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 				if (!nhc)
 					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
-						      jiffies + net->ipv4.ip_rt_mtu_expires);
+						      jiffies +
+						      READ_ONCE(net->ipv4.ip_rt_mtu_expires));
 			}
 			goto out;
 		}
 #endif /* CONFIG_IP_ROUTE_MULTIPATH */
 		nhc = FIB_RES_NHC(res);
 		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
-				      jiffies + net->ipv4.ip_rt_mtu_expires);
+				      jiffies + READ_ONCE(net->ipv4.ip_rt_mtu_expires));
 	}
 out:
 	rcu_read_unlock();
@@ -1367,7 +1371,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 	rcu_read_lock();
 	net = dst_dev_net_rcu(dst);
 	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				   net->ipv4.ip_rt_min_advmss);
+				   READ_ONCE(net->ipv4.ip_rt_min_advmss));
 	rcu_read_unlock();
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
-- 
2.43.0

