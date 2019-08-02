Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E79C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CAF621851
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564752607;
	bh=9J3VMBHUArBhUK4Sg+ljXqo8wwD81SF21cANTQ67C2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=W541RgoZGG1edo67biu7OFmiQXe29R0Lv7SNf5ogPGLLThr/jLP+XuHN+5FhVCSqT
	 yp5eMTs30q9oz44VKIB1QZKcm9+HFkZrm88dUmMKAU467I2Ijjv42kd37xyq3uOlk5
	 1KA7lcfq/dbmhfqoDbYXHxjY9S9xGaJnaSBi2pLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394179AbfHBNY2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394174AbfHBNY2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 09:24:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B75E20644;
        Fri,  2 Aug 2019 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752267;
        bh=9J3VMBHUArBhUK4Sg+ljXqo8wwD81SF21cANTQ67C2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2jBagP0E6kaAJrs+zO45dXrrqyEOTHcBQCHq9Oo8rtjo2owGiATvepuT2BbxvdDB
         My5alm9wQ9i8sU84tv9ZGYeP7Nr6X6xheqipnuJ0q1z7SP8mhcomCtrCqiEbQbIbJl
         1qeusnoCBkuBGOZGrZ9xhq4nzKX6Oy3q+4hWDdt4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/30] netfilter: Fix rpfilter dropping vrf packets by mistake
Date:   Fri,  2 Aug 2019 09:23:55 -0400
Message-Id: <20190802132422.13963-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132422.13963-1-sashal@kernel.org>
References: <20190802132422.13963-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit b575b24b8eee37f10484e951b62ce2a31c579775 ]

When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
ipv4/ipv6 packets will be dropped. Vrf device will pass
through netfilter hook twice. One with enslaved device
and another one with l3 master device. So in device may
dismatch witch out device because out device is always
enslaved device.So failed with the check of the rpfilter
and drop the packets by mistake.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 1 +
 net/ipv6/netfilter/ip6t_rpfilter.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 37fb9552e8589..341d1bd637af2 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -96,6 +96,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
 	flow.flowi4_tos = RT_TOS(iph->tos);
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
+	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 40eb16bd97860..d535768bea0fd 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -58,7 +58,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	if (rpfilter_addr_linklocal(&iph->saddr)) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6.flowi6_oif = dev->ifindex;
-	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
+	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
+	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
+		  (flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *) ip6_route_lookup(net, &fl6, lookup_flags);
@@ -73,7 +75,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
-- 
2.20.1

