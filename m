Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DA1327204;
	Fri, 21 Aug 2026 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319273; cv=none; b=BfjsG2wz//r3cCQa2qvvI79NfED4a3AN25iN626hm8jdA4eW5jBEM5jQMGPEXsT9QWtXeFpJa2RQKMxtL3XILCH3uAR6Kf5lHFRom9O3R0dvfj32939M/mQ36CbisGK9lcKoa62cGrGaM8GDRgF6okkGKpOKwMtDljzirC7JVnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319273; c=relaxed/simple;
	bh=0cBdeBKAoZMckm4oypj7qiBbqo45cHPDVRVN3aaz/uc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OoXtizPN8HV9JKeiZ0lWU7kPmeTYrruSo39YrSJsVMjl5P6zbMEj9aT1hlUtsXusv8Am3TqURt53W5rCSubaFq0dUhzlITQ4xHy/AzwmZPXjRgFch8Td2VY4av/ZGnhnmKUEHQ6DOi3KA90ovXiVRJKvWUzJKwRSowqyyhGQD3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=BWoFk8yu; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="BWoFk8yu"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id B79551A1780;
	Fri, 21 Aug 2026 13:34:30 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 83270604AA;
	Fri, 21 Aug 2026 13:34:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1A1E211C77155;
	Fri, 21 Aug 2026 15:34:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1787319265; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=sSK7wQls//2t/gBlSOfdfhT2YxJnO5Zs6EyGQfgl/c4=;
	b=BWoFk8yuq3757VU0qGG4P04JEutrbg+pMcZJWibyaPCYcCmJOxnQTBxsHi5yP8zi415wmh
	GZbwSn6f+NACAIWp/ZLgNgKhlL+OmYmY77/5dcJwu2GmKQv68kfO56sxOKLbINuDCGlYfB
	UQYqfhGFNhJCVz0xvbDj71Wl0Yh4GjNzhNUquc1k7sNkVl/3pGiTfQ6pFdcj4bOEnrX3+V
	1EActJYHgxJa2Q7hLPkPu+jlM+3HWOBv88/QoE16sD6HQuc9uF9Z4aA0qK9WnrnDU2oQDI
	gLPAQJA177Fqme7YVdgHG8LedSkHAKr5MMEC/CuCFS9yyBN7CdDJdrU/J0X40A==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Fri, 21 Aug 2026 15:33:38 +0200
Subject: [PATCH v6.1.y 4/4] ipv4: start using dst_dev_rcu()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-cve-2025-40074-6-1-v1-4-cad5cf499b76@bootlin.com>
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
 coreteam@netfilter.org, Miguel Gazquez <miguel.gazquez@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787319234; l=3849;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=KdCidSzyMWhI98Jiee7VIqnLTiAwLq+MAszWW3VzCjQ=;
 b=ZvBuuFbGmvLsoe99JGCB08NBg61pH7Q7lZi+lQZKDDxvqN06Ns0T8PDxT6uUYipuqQU4prtlM
 Fwqv3zghBzbCeswc0j4uK5JL+mGV2M2rbNQs8d6ZwhjH4vhR+4w4546
X-Developer-Key: i=miguel.gazquez@bootlin.com; a=ed25519;
 pk=k/2KI9jkmayaF0ghZ8QYUH9Wm/kFHDhl8QoZ0RHbr4w=
X-Last-TLS-Session-Version: TLSv1.3

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]

Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.

Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ minor modifications to fix conflict, added rcu_read_lock and unlock
to ip_defrag function ]
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 net/ipv4/icmp.c        | 6 +++---
 net/ipv4/ip_fragment.c | 9 +++++++--
 net/ipv4/ipmr.c        | 2 +-
 net/ipv4/route.c       | 4 ++--
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 7763a98ddc96..e87325b80e0c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -320,17 +320,17 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 		return true;
 
 	/* No rate limit on loopback */
-	dev = dst_dev(dst);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 	if (dev && (dev->flags & IFF_LOOPBACK))
 		goto out;
 
-	rcu_read_lock();
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
 			       l3mdev_master_ifindex_rcu(dev));
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
-	rcu_read_unlock();
 out:
+	rcu_read_unlock();
 	if (!rc)
 		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
 	else
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index a70ede523297..43b1265f5ac1 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -481,13 +481,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
-	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct net_device *dev;
 	struct ipq *qp;
+	int vif;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
 
 	/* Lookup (or create) queue header */
+	rcu_read_lock();
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret;
@@ -497,9 +500,11 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 		ret = ip_frag_queue(qp, skb);
 
 		spin_unlock(&qp->q.lock);
+		rcu_read_unlock();
 		ipq_put(qp);
 		return ret;
 	}
+	rcu_read_unlock();
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	kfree_skb(skb);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f64651c0dea6..8d4f556fced2 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1879,7 +1879,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			goto out_free;
 	}
 
-	dev = rt->dst.dev;
+	dev = dst_dev_rcu(&rt->dst);
 
 	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e3cce307e0e9..5528a5543df5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -416,11 +416,11 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 					   const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst_dev(dst);
+	struct net_device *dev;
 	struct neighbour *n;
 
 	rcu_read_lock();
-
+	dev = dst_dev_rcu(dst);
 	if (likely(rt->rt_gw_family == AF_INET)) {
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
 	} else if (rt->rt_gw_family == AF_INET6) {

-- 
2.55.0

