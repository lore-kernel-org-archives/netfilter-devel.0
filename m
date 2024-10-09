Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D715118E758
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728462904; cv=none; b=RP2+rdhxwFmXp3d1V5yQuz7/ISfBvRA1w3S8QSqWIUCNtEL/xL+XD7decHaBHHHs6uFeyggukticjzDDEXa7VJQWpmelen6L0wV8eucskYOh+5Tm5ZjvVBHRkSPTe+8itoI1OVwUamF3EOFGkogh67683lGyyV6UNekA4MX4NBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728462904; c=relaxed/simple;
	bh=ae4IcdhJrZW4Ckwu1k2XMRruQgZmgOKeCnGjKt7pw2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xok9xY3Bq4cnb85Gk/dxFsXBEphKUtbZX0eui7kCajlZQCE/2tdBnScY0TXrCbr8cbggS6BsDpWQnSqcXw7SDBC/rSIK7HSdR6sbdUskRJEdyDMJwpnopyzf/MdOZhfsksHnJrObTd+xnDuwsFXt/sIsSda8FmkAGTAnx7ImBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1syS9r-0002pX-Ql; Wed, 09 Oct 2024 10:34:59 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: fib: check correct rtable in vrf setups
Date: Wed,  9 Oct 2024 09:19:02 +0200
Message-ID: <20241009071908.17644-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to init l3mdev unconditionally, else main routing table is searched
and incorrect result is returned unless strict (iif keyword) matching is
requested.

Next patch adds a selftest for this.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1761
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 net/ipv6/netfilter/nft_fib_ipv6.c | 5 +++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 00da1332bbf1..09fff5d424ef 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -65,6 +65,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
 		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
+		.flowi4_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
@@ -83,9 +84,6 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
-	if (priv->flags & NFTA_FIB_F_IIF)
-		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
-
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 36dc14b34388..c9f1634b3838 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,8 +41,6 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
-	} else if (priv->flags & NFTA_FIB_F_IIF) {
-		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
@@ -75,6 +73,8 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		dev = nft_out(pkt);
 
+	fl6.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
+
 	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
 	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
@@ -165,6 +165,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
+		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.46.2

