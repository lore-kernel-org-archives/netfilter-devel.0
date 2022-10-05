Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A15AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 16:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiJEQHh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 12:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJEQHe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 12:07:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA067B78C
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 09:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5d5SUhywQlkJ+/Q3aABJiYlDEVzGblnI1Loamisegi4=; b=kuKluRJHxhIeIF6uUyn0LzVZ9H
        5NRkzg6k7kO0XKZqUUQ44h2Q791oYCCYcwo51hilRtp1jlxmpFpl2o6lFD8V2MasveM72cXABNRWm
        NmBTnQd3MVLoPla2Oshl60G90LGfUNwPL8CePWIWKKYN+KrxiVxqN6tjQciiLAK6rk4FRp5l1iSFb
        1t+N4fzIZKEPtzdxyidRSLAKScpg87BFW7VUe8BppIbksAIAyJcJ+wn1eCB8La2E4Yyhvwr0TjwiL
        qrhtz4rosfh+ZmrLpghCpYTkH1eyZf2DyoIkAvg6L7rE8AOdiKSGVgDRMtjlGTGVGV/Lf4du88WBC
        BeGJ6Jfw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1og6vS-0005Zg-7f; Wed, 05 Oct 2022 18:07:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [nf-next PATCH 2/2] netfilter: rpfilter/fib: Populate flowic_l3mdev field
Date:   Wed,  5 Oct 2022 18:07:05 +0200
Message-Id: <20221005160705.8725-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221005160705.8725-1-phil@nwl.cc>
References: <20221005160705.8725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the introduced field for correct operation with VRF devices instead
of conditionally overwriting flowic_oif. This is a partial revert of
commit b575b24b8eee3 ("netfilter: Fix rpfilter dropping vrf packets by
mistake"), implementing a simpler solution.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c  | 2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c | 9 +++------
 net/ipv6/netfilter/nft_fib_ipv6.c  | 5 ++---
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8183bbcabb4af..ff85db52b2e56 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -77,7 +77,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
 	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
-	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
+	flow.flowi4_l3mdev = l3mdev_master_ifindex_rcu(xt_in(par));
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 7ade04ff972d7..e886147eed11d 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -84,7 +84,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		oif = NULL;
 
 	if (priv->flags & NFTA_FIB_F_IIF)
-		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+		fl4.flowi4_l3mdev = l3mdev_master_ifindex_rcu(oif);
 
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index d800801a5dd27..69d86b040a6af 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -37,6 +37,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	bool ret = false;
 	struct flowi6 fl6 = {
 		.flowi6_iif = LOOPBACK_IFINDEX,
+		.flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev),
 		.flowlabel = (* (__be32 *) iph) & IPV6_FLOWINFO_MASK,
 		.flowi6_proto = iph->nexthdr,
 		.daddr = iph->saddr,
@@ -55,9 +56,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	if (rpfilter_addr_linklocal(&iph->saddr)) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6.flowi6_oif = dev->ifindex;
-	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
-	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
-		  (flags & XT_RPFILTER_LOOSE) == 0)
+	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
@@ -72,9 +71,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev ||
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
-	    (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 1d7e520d9966c..91faac610e03d 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -41,9 +41,8 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 	if (ipv6_addr_type(&fl6->daddr) & IPV6_ADDR_LINKLOCAL) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6->flowi6_oif = get_ifindex(dev ? dev : pkt->skb->dev);
-	} else if ((priv->flags & NFTA_FIB_F_IIF) &&
-		   (netif_is_l3_master(dev) || netif_is_l3_slave(dev))) {
-		fl6->flowi6_oif = dev->ifindex;
+	} else if (priv->flags & NFTA_FIB_F_IIF) {
+		fl6->flowi6_l3mdev = l3mdev_master_ifindex_rcu(dev);
 	}
 
 	if (ipv6_addr_type(&fl6->saddr) & IPV6_ADDR_UNICAST)
-- 
2.34.1

