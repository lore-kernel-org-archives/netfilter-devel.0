Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.252.153.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214729;
	b=v3uoVaMn4WT6h+W447evUrxnGJ0/fZpRyYsYIjozaSopch+Phma5yZQ8cLOQrhYFPUws
	 At+csQ4in2OoTH96nGHq7GHjSl6LVxtUgyaS6htr+cAkZCe0i3cSbmeVkH/l7js+EbwqK
	 ZepozTfNPE3iuUUKT+NnAXxQMdqINyXfdV2sLu7auJ2aYN4lrEETLhbezglOwfHZhQ/Xw
	 k2nhNir3i4NjUqAf+C+/GmrV7acAQrJAeiFwOXW0wALZFk5QCW/fxTogS6godsDbSWixj
	 QSyAUgTtjOLuhZGj0x9FwndoxsyE1En2OQdZeutT46W/lug9RpXyGQkKMR5H9Tz+lhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214729;
	h=DMARC-Filter:DKIM-Signature:Received:X-Riseup-User-ID:Received:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=j7h2J5um34mr7dhb1zW4rK+MKNd/sk6AUwtX5W8Oxo4=;
	b=JlY3Hxk6yo+0p1wvnmUDev160JyN88xPyh4CU6Es2EY4EvRYRxYfHkiRQlc7F6Xi4CEj
	 7DhlSYIQ5UfyHn2b/Wkna0Gz80NfVn5DS80TwETWZjbu72o8ZLQjrEUw6kjuYDF7gwsCm
	 QM4UgVfPG3Am9hfojedB9GopHIenqiWI2AlXXXGoC9tFvAsht7dbztkahHY829/Cwz8U2
	 ry5ZDky2vXnu7DcIZ3orZQW/FfcZH0RMX3oS8hhihSFeLrIDYVqimYdEE/Avs8crfIm5O
	 Wuy138mNtyaQ2aNnuUzajiV/4iC1Nj3YgLfLzJxwFDIA8Iv8rc2zGgreQx47ck7Wfvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=riseup.net;
	spf=pass smtp.mailfrom=riseup.net;
	dkim=pass header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=XyhEbzxz;
	arc=none smtp.remote-ip=198.252.153.6
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B41C606AB0C;
	Wed, 28 Oct 2026 19:12:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B41C606AB0C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=riseup.net header.i=@riseup.net header.a=rsa-sha256 header.s=squak header.b=XyhEbzxz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riseup.net; s=squak;
	t=1793214727; bh=j7h2J5um34mr7dhb1zW4rK+MKNd/sk6AUwtX5W8Oxo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyhEbzxzdPizVCYzr8mmFrpE1edejonK3649iGmH6v2Sifb58evC6Ns33SXjdIMXQ
	 IqxxlrfuUHQjYcV3IrvP30PxVaD3itHFceqcAdv+8YEVxOnYAUq0yp358pAtik4wCO
	 xIWaGEKfLqsZjY7/Yc+eX4+brjDu/36AgtkFM/68=
Received: from fews04-sea.riseup.net (fews04-sea-pn.riseup.net [10.0.1.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx0.riseup.net (Postfix) with ESMTPS id 4jFH6Z6yLCz9t0w;
	Wed, 28 Oct 2026 19:12:06 +0000 (UTC)
X-Riseup-User-ID: 3F13C1FB11223F2834012ED7FD44949C590C44C3AC4F3639E6C321C5712DE02C
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews04-sea.riseup.net (Postfix) with ESMTPSA id 4jFH6N2SgCz5vbL;
	Wed, 28 Oct 2026 19:11:56 +0000 (UTC)
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
Subject: [PATCH net v3 1/3] net/ipv6: add ipv6_chk_addr_namespace
Date: Wed, 28 Oct 2026 20:10:55 +0100
Message-ID: <20261028191103.623156-2-ihuguet@riseup.net>
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

The ipv6_chk_addr and related functions are all VRF aware, as most
callers need it. The next patch needs to check if the address exists in
the entire namespace, so add a new function for that.

Clarify the behaviour of ipv6_chk_addr and other existing functions
when dev=NULL, as it is not completely obvious that, in that case, the
address is only searched in the main L3 domain.

Signed-off-by: Íñigo Huguet <ihuguet@riseup.net>
---
 include/net/addrconf.h |  4 ++-
 net/ipv6/addrconf.c    | 76 ++++++++++++++++++++++++++----------------
 net/ipv6/anycast.c     |  2 +-
 net/ipv6/datagram.c    |  2 +-
 net/ipv6/ip6_tunnel.c  | 10 +++---
 net/ipv6/ndisc.c       |  2 +-
 net/ipv6/route.c       |  4 +--
 7 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 6818057cf727..43201e410c1b 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -120,7 +120,9 @@ int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 		  const struct net_device *dev, int strict);
 int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			    const struct net_device *dev, bool skip_dev_check,
-			    int strict, u32 banned_flags);
+			    bool skip_l3mdev_check, int strict,
+			    u32 banned_flags);
+int ipv6_chk_addr_namespace(struct net *net, const struct in6_addr *addr);
 
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)
 int ipv6_chk_home_addr(struct net *net, const struct in6_addr *addr);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c8c0dd04982d..b13a5846ec95 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1979,43 +1979,30 @@ static int ipv6_count_addresses(const struct inet6_dev *idev)
 	return cnt;
 }
 
-int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
-		  const struct net_device *dev, int strict)
-{
-	return ipv6_chk_addr_and_flags(net, addr, dev, !dev,
-				       strict, IFA_F_TENTATIVE);
-}
-EXPORT_SYMBOL(ipv6_chk_addr);
-
-/* device argument is used to find the L3 domain of interest. If
- * skip_dev_check is set, then the ifp device is not checked against
- * the passed in dev argument. So the 2 cases for addresses checks are:
- *   1. does the address exist in the L3 domain that dev is part of
- *      (skip_dev_check = true), or
- *
- *   2. does the address exist on the specific device
- *      (skip_dev_check = false)
- */
+/* See ipv6_chk_addr_and_flags */
 static struct net_device *
 __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			  const struct net_device *dev, bool skip_dev_check,
-			  int strict, u32 banned_flags)
+			  bool skip_l3mdev_check, int strict, u32 banned_flags)
 {
 	unsigned int hash = inet6_addr_hash(net, addr);
-	struct net_device *l3mdev, *ndev;
+	struct net_device *l3mdev = NULL, *ndev;
 	struct inet6_ifaddr *ifp;
 	u32 ifp_flags;
 
-	rcu_read_lock();
+	if (!dev)
+		skip_dev_check = true;
+	if (!skip_dev_check)
+		skip_l3mdev_check = false;
 
-	l3mdev = l3mdev_master_dev_rcu(dev);
-	if (skip_dev_check)
-		dev = NULL;
+	rcu_read_lock();
+	if (dev && !skip_l3mdev_check)
+		l3mdev = l3mdev_master_dev_rcu(dev);
 
 	hlist_for_each_entry_rcu(ifp, &net->ipv6.inet6_addr_lst[hash], addr_lst) {
 		ndev = ifp->idev->dev;
 
-		if (l3mdev_master_dev_rcu(ndev) != l3mdev)
+		if (!skip_l3mdev_check && l3mdev_master_dev_rcu(ndev) != l3mdev)
 			continue;
 
 		/* Decouple optimistic from tentative for evaluation here.
@@ -2026,7 +2013,7 @@ __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			    : ifp->flags;
 		if (ipv6_addr_equal(&ifp->addr, addr) &&
 		    !(ifp_flags&banned_flags) &&
-		    (!dev || ndev == dev ||
+		    (skip_dev_check || ndev == dev ||
 		     !(ifp->scope&(IFA_LINK|IFA_HOST) || strict))) {
 			rcu_read_unlock();
 			return ndev;
@@ -2037,15 +2024,46 @@ __ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 	return NULL;
 }
 
+/* The 'dev' argument is used to match the exact device or find the L3 domain of
+ * interest.
+ * The 3 cases for addresses checks are:
+ *   1. With 'skip_dev_check == false': check if 'addr' exists on 'dev'.
+ *   2. With 'skip_dev_check == true && skip_l3mdev_check == false': check if
+ *      'addr' exists on the same L3 domain as 'dev'.
+ *   3. With 'skip_dev_check == true && skip_l3mdev_check == true': check if
+ *      'addr' exists in the entire namespace.
+ * For the purpose of searching in a specific L3 domain, 'dev == NULL' means
+ * "search in the main L3 domain".
+ */
 int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			    const struct net_device *dev, bool skip_dev_check,
-			    int strict, u32 banned_flags)
+			    bool skip_l3mdev_check, int strict,
+			    u32 banned_flags)
 {
 	return __ipv6_chk_addr_and_flags(net, addr, dev, skip_dev_check,
-					 strict, banned_flags) ? 1 : 0;
+					 skip_l3mdev_check, strict,
+					 banned_flags) ? 1 : 0;
 }
 EXPORT_SYMBOL(ipv6_chk_addr_and_flags);
 
+/* Check if 'addr' is configured on 'dev'. If 'dev' is NULL, check the entire
+ * main L3 domain
+ */
+int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
+		  const struct net_device *dev, int strict)
+{
+	return ipv6_chk_addr_and_flags(net, addr, dev, !dev, false,
+				       strict, IFA_F_TENTATIVE);
+}
+EXPORT_SYMBOL(ipv6_chk_addr);
+
+/* Check if 'addr' exists in the entire namespace, in any L3 domain */
+int ipv6_chk_addr_namespace(struct net *net, const struct in6_addr *addr)
+{
+	return ipv6_chk_addr_and_flags(net, addr, NULL, true, true, 0,
+				       IFA_F_TENTATIVE);
+}
+EXPORT_SYMBOL(ipv6_chk_addr_namespace);
 
 /* Compares an address/prefix_len with addresses on device @dev.
  * If one is found it returns true.
@@ -2098,14 +2116,14 @@ EXPORT_SYMBOL(ipv6_chk_prefix);
  * ipv6_dev_find - find the first device with a given source address.
  * @net: the net namespace
  * @addr: the source address
- * @dev: used to find the L3 domain of interest
+ * @dev: used to find the L3 domain of interest (NULL = main L3 domain)
  *
  * The caller should be protected by RCU, or RTNL.
  */
 struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr,
 				 struct net_device *dev)
 {
-	return __ipv6_chk_addr_and_flags(net, addr, dev, !dev, 1,
+	return __ipv6_chk_addr_and_flags(net, addr, dev, !dev, false, 1,
 					 IFA_F_TENTATIVE);
 }
 EXPORT_SYMBOL(ipv6_dev_find);
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index be6dac8a8566..6b00e97b3041 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -82,7 +82,7 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 	if (ifindex)
 		dev = netdev_get_by_index(net, ifindex, &dev_tracker, GFP_KERNEL);
 
-	if (ipv6_chk_addr_and_flags(net, addr, dev, true, 0, IFA_F_TENTATIVE)) {
+	if (ipv6_chk_addr_and_flags(net, addr, dev, true, false, 0, IFA_F_TENTATIVE)) {
 		err = -EINVAL;
 		goto error;
 	}
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 191c9733ff9f..7b71a932544d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -867,7 +867,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				int strict = __ipv6_addr_src_scope(addr_type) <= IPV6_ADDR_SCOPE_LINKLOCAL;
 				if (!ipv6_can_nonlocal_bind(net, inet_sk(sk)) &&
 				    !ipv6_chk_addr_and_flags(net, &src_info->ipi6_addr,
-							     dev, !strict, 0,
+							     dev, !strict, false, 0,
 							     IFA_F_TENTATIVE) &&
 				    !ipv6_chk_acast_addr_src(net, dev,
 							     &src_info->ipi6_addr))
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 64a184bca467..baf5bba80346 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -794,10 +794,10 @@ int ip6_tnl_rcv_ctl(struct ip6_tnl *t,
 			ldev = dev_get_by_index_rcu(net, p->link);
 
 		if ((ipv6_addr_is_multicast(laddr) ||
-		     likely(ipv6_chk_addr_and_flags(net, laddr, ldev, false,
+		     likely(ipv6_chk_addr_and_flags(net, laddr, ldev, false, false,
 						    0, IFA_F_TENTATIVE))) &&
 		    ((p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE) ||
-		     likely(!ipv6_chk_addr_and_flags(net, raddr, ldev, true,
+		     likely(!ipv6_chk_addr_and_flags(net, raddr, ldev, true, false,
 						     0, IFA_F_TENTATIVE))))
 			ret = 1;
 	}
@@ -1059,14 +1059,14 @@ int ip6_tnl_xmit_ctl(struct ip6_tnl *t,
 		if (p->link)
 			ldev = dev_get_by_index_rcu(net, p->link);
 
-		if (unlikely(!ipv6_chk_addr_and_flags(net, laddr, ldev, false,
+		if (unlikely(!ipv6_chk_addr_and_flags(net, laddr, ldev, false, false,
 						      0, IFA_F_TENTATIVE)))
 			pr_warn_ratelimited("%s xmit: Local address not yet configured!\n",
 					    p->name);
 		else if (!(p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE) &&
 			 !ipv6_addr_is_multicast(raddr) &&
-			 unlikely(ipv6_chk_addr_and_flags(net, raddr, ldev,
-							  true, 0, IFA_F_TENTATIVE)))
+			 unlikely(ipv6_chk_addr_and_flags(net, raddr, ldev, true,
+							  false, 0, IFA_F_TENTATIVE)))
 			pr_warn_ratelimited("%s xmit: Routing loop! Remote address found on this node!\n",
 					    p->name);
 		else
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 0ed1a619372b..0bb131be969e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -746,7 +746,7 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
 	int probes = atomic_read(&neigh->probes);
 
 	if (skb && ipv6_chk_addr_and_flags(dev_net(dev), &ipv6_hdr(skb)->saddr,
-					   dev, false, 1,
+					   dev, false, false, 1,
 					   IFA_F_TENTATIVE|IFA_F_OPTIMISTIC))
 		saddr = &ipv6_hdr(skb)->saddr;
 	probes -= NEIGH_VAR(neigh->parms, UCAST_PROBES);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 94e5ef1c4f83..dae25a6638c4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3492,7 +3492,7 @@ static int ip6_validate_gw(struct net *net, struct fib6_config *cfg,
 	 * prefix route was assigned to, which might be non-loopback.
 	 */
 	if (dev &&
-	    ipv6_chk_addr_and_flags(net, gw_addr, dev, skip_dev, 0, 0)) {
+	    ipv6_chk_addr_and_flags(net, gw_addr, dev, skip_dev, false, 0, 0)) {
 		NL_SET_ERR_MSG(extack, "Gateway can not be a local address");
 		goto out;
 	}
@@ -3543,7 +3543,7 @@ static int ip6_validate_gw(struct net *net, struct fib6_config *cfg,
 	 * egress device has been resolved.
 	 */
 	if (need_addr_check &&
-	    ipv6_chk_addr_and_flags(net, gw_addr, dev, skip_dev, 0, 0)) {
+	    ipv6_chk_addr_and_flags(net, gw_addr, dev, skip_dev, false, 0, 0)) {
 		NL_SET_ERR_MSG(extack, "Gateway can not be a local address");
 		goto out;
 	}
-- 
2.54.0

