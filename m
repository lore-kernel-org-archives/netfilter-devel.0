Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D629ACF1;
	Thu, 22 May 2025 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932785; cv=none; b=dqax6I6i1JkRw4doYwkiHdEVuQcw3NNE+DA3dgub4wMTVtTLTyNWIKzaEO7iFz3aPVr007m/EQyCakBRFaiuqxK5Y0s4XEsSrhSdfmnzYt6+YG3VM5TYTLF8D4Kks+Mof2fKt9dcjv8UnkkCyAi4JAUC1nlhA8/Uj/qxY23hIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932785; c=relaxed/simple;
	bh=h34umUyWQmUq9LjZUuQ8vfsDn+QT2EHCIqvWmx4FPEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nANbJKtBvlBU54Dmzi2yBnyAuQJVfAnECOVQMYUS8YK9Vi8H0g8Qu4+ydR3n3/d9pt7yQe28YorEZVFekQ4vTf2UhKPp0hvE/XOmp4H/DmyR80J1D/mSUmVwOxXueokCbNvPkT0xK7VwdlTBDapc3DUMSqZUoSKv4wKnthGo3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qp42bJLN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GZKBCMow; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qp42bJLN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GZKBCMow"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6E6F060741; Thu, 22 May 2025 18:53:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932782;
	bh=yLtJVe/sln0qR2s3vouPyYnntZSfq2Et4rlJAE13A10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp42bJLNqkUeB4kmgGTbCQKCw18+od1VW23CGd/FXCEnO//TWT3ZOJiGtz7jBUF/O
	 gXOa6CkbIPp/gV8QvhdeVnZnaBzVdDAtZr7zf7GA+TfoFCK467Pba/XFSPAH3DmcKD
	 aprUamNxvmL8mGotSIlEhFgRQ6JHveZJI2W3M7Ca+mABDJ4LeUeOyZGZimmRobkO3C
	 CBYloJdAbyqaXysXq8jO2PEiG+eEyuyNtBdx76lumo6IXHgsK2xSrk+sMOUyhrMb29
	 2WvvHj+AJ3xoaAp30+uomtFqpB4r+e4OkYe1Qzgj3KgrMX3omdfS+ISLBz1MeJ4mvU
	 TR8xzB/jCG+NA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AB54760730;
	Thu, 22 May 2025 18:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932771;
	bh=yLtJVe/sln0qR2s3vouPyYnntZSfq2Et4rlJAE13A10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZKBCMowi1eBtDSt6wYZrtQM84stsxp7BT1AvPOpm8/B+Xpbip2FEthOtMvduNB8a
	 CciGmcTNKeFX3YuJP28K53csAdmUQLVLh8ay/IMbMelgzZ0jLftK/ik4EnJp86GGW5
	 AxQoJ6Pulz7F0VZprwHT6KKPMgFHAW5aDzqvmcvzzZW835+Qx08k32VWozvNZOJ8wt
	 j9Gp1QQR70z7iyJV9DCHXg1+lktYQm4FIsFdkI14dHRpLHOYBDc4eV+gS2Mxfi74JU
	 3thba9g/Es12q7XWzsSetFBf2r3eAo0IRgE1WCOD5PPQIh0csgnRHpcCOZbfNo5KdU
	 v9XtGazi5wRtw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent l3mdev handling
Date: Thu, 22 May 2025 18:52:18 +0200
Message-Id: <20250522165238.378456-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

fib has two modes:
1. Obtain output device according to source or destination address
2. Obtain the type of the address, e.g. local, unicast, multicast.

'fib daddr type' should return 'local' if the address is configured
in this netns or unicast otherwise.

'fib daddr . iif type' should return 'local' if the address is configured
on the input interface or unicast otherwise, i.e. more restrictive.

However, if the interface is part of a VRF, then 'fib daddr type'
returns unicast even if the address is configured on the incoming
interface.

This is broken for both ipv4 and ipv6.

In the ipv4 case, inet_dev_addr_type must only be used if the
'iif' or 'oif' (strict mode) was requested.

Else inet_addr_type_dev_table() needs to be used and the correct
dev argument must be passed as well so the correct fib (vrf) table
is used.

In the ipv6 case, the bug is similar, without strict mode, dev is NULL
so .flowi6_l3mdev will be set to 0.

Add a new 'nft_fib_l3mdev_master_ifindex_rcu()' helper and use that
to init the .l3mdev structure member.

For ipv6, use it from nft_fib6_flowi_init() which gets called from
both the 'type' and the 'route' mode eval functions.

This provides consistent behaviour for all modes for both ipv4 and ipv6:
If strict matching is requested, the input respectively output device
of the netfilter hooks is used.

Otherwise, use skb->dev to obtain the l3mdev ifindex.

Without this, most type checks in updated nft_fib.sh selftest fail:

  FAIL: did not find veth0 . 10.9.9.1 . local in fibtype4
  FAIL: did not find veth0 . dead:1::1 . local in fibtype6
  FAIL: did not find veth0 . dead:9::1 . local in fibtype6
  FAIL: did not find tvrf . 10.0.1.1 . local in fibtype4
  FAIL: did not find tvrf . 10.9.9.1 . local in fibtype4
  FAIL: did not find tvrf . dead:1::1 . local in fibtype6
  FAIL: did not find tvrf . dead:9::1 . local in fibtype6
  FAIL: fib expression address types match (iif in vrf)

(fib errounously returns 'unicast' for all of them, even
 though all of these addresses are local to the vrf).

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_fib.h   | 16 ++++++++++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c | 11 +++++++++--
 net/ipv6/netfilter/nft_fib_ipv6.c |  4 +---
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 6e202ed5e63f..2eea102c6609 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -2,6 +2,7 @@
 #ifndef _NFT_FIB_H_
 #define _NFT_FIB_H_
 
+#include <net/l3mdev.h>
 #include <net/netfilter/nf_tables.h>
 
 struct nft_fib {
@@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
 	return nft_fib_is_loopback(pkt->skb, indev);
 }
 
+/**
+ * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device
+ * @pkt: pktinfo container passed to nft_fib_eval function
+ * @iif: input interface, can be NULL
+ *
+ * Return: interface index or 0.
+ */
+static inline int nft_fib_l3mdev_master_ifindex_rcu(const struct nft_pktinfo *pkt,
+						    const struct net_device *iif)
+{
+	const struct net_device *dev = iif ? iif : pkt->skb->dev;
+
+	return l3mdev_master_ifindex_rcu(dev);
+}
+
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9082ca17e845..7e7c49535e3f 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -50,7 +50,12 @@ void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		addr = iph->saddr;
 
-	*dst = inet_dev_addr_type(nft_net(pkt), dev, addr);
+	if (priv->flags & (NFTA_FIB_F_IIF | NFTA_FIB_F_OIF)) {
+		*dst = inet_dev_addr_type(nft_net(pkt), dev, addr);
+		return;
+	}
+
+	*dst = inet_addr_type_dev_table(nft_net(pkt), pkt->skb->dev, addr);
 }
 EXPORT_SYMBOL_GPL(nft_fib4_eval_type);
 
@@ -65,8 +70,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct flowi4 fl4 = {
 		.flowi4_scope = RT_SCOPE_UNIVERSE,
 		.flowi4_iif = LOOPBACK_IFINDEX,
+		.flowi4_proto = pkt->tprot,
 		.flowi4_uid = sock_net_uid(nft_net(pkt), NULL),
-		.flowi4_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	const struct net_device *oif;
 	const struct net_device *found;
@@ -90,6 +95,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	fl4.flowi4_l3mdev = nft_fib_l3mdev_master_ifindex_rcu(pkt, oif);
+
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index f1f5640da672..421036a3605b 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -50,6 +50,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 		fl6->flowi6_mark = pkt->skb->mark;
 
 	fl6->flowlabel = (*(__be32 *)iph) & IPV6_FLOWINFO_MASK;
+	fl6->flowi6_l3mdev = nft_fib_l3mdev_master_ifindex_rcu(pkt, dev);
 
 	return lookup_flags;
 }
@@ -73,8 +74,6 @@ static u32 __nft_fib6_eval_type(const struct nft_fib *priv,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		dev = nft_out(pkt);
 
-	fl6.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
-
 	nft_fib6_flowi_init(&fl6, priv, pkt, dev, iph);
 
 	if (dev && nf_ipv6_chk_addr(nft_net(pkt), &fl6.daddr, dev, true))
@@ -166,7 +165,6 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		.flowi6_iif = LOOPBACK_IFINDEX,
 		.flowi6_proto = pkt->tprot,
 		.flowi6_uid = sock_net_uid(nft_net(pkt), NULL),
-		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(nft_in(pkt)),
 	};
 	struct rt6_info *rt;
 	int lookup_flags;
-- 
2.30.2

