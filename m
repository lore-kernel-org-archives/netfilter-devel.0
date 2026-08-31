Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985E42E007;
	Mon, 31 Aug 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788192406; cv=none; b=qIToEMg5SG0RI67Jphy5MeJlaMnQVbtCj4yvH30h3DGxXYI55Ewifp6xgZfTuqM7OpbeYiCWT7tyKwwI9nyKAKk3W0znNhrxQ5vvc+8ahfahT9lQkpx7CKXIx3eGJC8nzJxzoEh6LX2nQfqZrzxkBy+NOBid7qPia6FEcoxok+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788192406; c=relaxed/simple;
	bh=FX8YRA5w1FTm8TXCoN14fTaM+KZeJ6SabVYYn8ZuTuQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Au6M1lpjPLs8xT3Sj/ESB7H8S0dKTmL2BleiRDobsSxf2OX0ZQUSRyTHEbOShfKBdqcX+KCf1uxFDGELagF5vIzcQJfOLxFg+KMtVC/pOddJS9+YOgR2hFUMEsduCx2HIzSSZZZlAfJ8gpUSbTg+ApTIVfrnJyFQiVofflPWUh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ZZlZCHz1; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ZZlZCHz1"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id B43DC4E4147F;
	Mon, 31 Aug 2026 16:06:42 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 813BE60231;
	Mon, 31 Aug 2026 16:06:42 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E87B611C791C9;
	Mon, 31 Aug 2026 18:06:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788192401; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=FyXT90TH3izWaLD5OpCs3DkPlTbCODQkG/eyhvU7/c4=;
	b=ZZlZCHz1Pnlr90jE1csn2KGUb0I4NgdaAeZtz3kLOAoUVfXwHuhYdoJ1e/ymm3wEGiKshc
	NqmwOhPgX4FqPn8+VC0UhCZkcwHsw5gD6ermH9Uim/A3TfCmrtJEakBbYzk+7NE7YbtEaa
	xODRBQUOORM7PAKeu6B+V+kwiSf3PreyZp0P6EMNDomQc2Ss4BelEkr0L7guDq/LysQ7kG
	VBQIpHPCqcDJMxahOxKuDa+hHs6VpIo2n5VS8kanEBwWFSJBHkNXBOz3gsZwMoP+yfBJTD
	NskfsZxsaKiSlDfuyt6xmuYgRdnGcOTnCO/68w3Plh8+9yBXCmUZVvEZWeMYxA==
From: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Date: Mon, 31 Aug 2026 18:06:23 +0200
Subject: [PATCH 6.6.y 4/4] ipv4: start using dst_dev_rcu()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-cve-2025-40074-6-6-v1-4-027e51b162a3@bootlin.com>
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
 "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788192387; l=3497;
 i=miguel.gazquez@bootlin.com; s=20250708; h=from:subject:message-id;
 bh=34JJFq8RSXI5UoGgxvCuwKAwd5I70OkLIjHzCunZECQ=;
 b=wnwpLQ13J//AszAdF09FF/t/gV8ORXxpyI8MvO6cNC9oEATsu9dznMsf1BGK8YBH24lx/7Fk4
 8e6ZmCEIG6DAOUWlzWk7FXW3mmzz733P/F1Sev7DcAYtghwAy7MiulD
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
[ minor modifications to fix conflict ]
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 net/ipv4/icmp.c        | 6 +++---
 net/ipv4/ip_fragment.c | 6 ++++--
 net/ipv4/ipmr.c        | 2 +-
 net/ipv4/route.c       | 4 ++--
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f0c8c3366740..5c38af80bc14 100644
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
index 46b84d029205..e79ebe911548 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -470,14 +470,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
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
 	rcu_read_lock();
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret, refs = 0;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index af9412a507cf..f39cd565569a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1893,7 +1893,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			goto out_free;
 	}
 
-	dev = rt->dst.dev;
+	dev = dst_dev_rcu(&rt->dst);
 
 	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ce3397583b8f..b175a8292eb3 100644
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

