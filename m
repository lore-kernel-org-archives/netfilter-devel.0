Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EABFC10F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06BA02064A
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555963863;
	bh=Zw6sOMOYVPjk+flDR37jtDfzQLdPaAeJts5zJijBkFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FY2jAiFhHAuP98evPO1AFS760YCpu5XckPavWRfZ0Bgx4GYxyns0oOTP7WxNH5NNh
	 K2r/gC6bHRe1lWV3WvIhelxq3sOA90WXcXM45dPfdGDKwfsKxEplUPm0xEjiIGH53H
	 6pzMaO3S1FXBEKD4g7CphPwY97AQ/qaaZN79VlFA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfDVTm1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 15:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbfDVTm0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 15:42:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B8B2075A;
        Mon, 22 Apr 2019 19:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555962145;
        bh=Zw6sOMOYVPjk+flDR37jtDfzQLdPaAeJts5zJijBkFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poYtIwsWdwVyTGk4OI4TaKYkcH7kXzIYEPRPzB4sAO57xdxbO5kiJ/hfZ02rJ4L8F
         CnKRgVaBZzwcNVUX771qbdfFXpzdfO0QgErbnYxdaxsrhn6q2PZhWGJscE7lNNWyWp
         SqEaU3x2zi4e4tfN48Gx9sRHocXnhvziB9EoqfNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 17/98] netfilter: bridge: set skb transport_header before entering NF_INET_PRE_ROUTING
Date:   Mon, 22 Apr 2019 15:40:44 -0400
Message-Id: <20190422194205.10404-17-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit e166e4fdaced850bee3d5ee12a5740258fb30587 ]

Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
skb->transport_header has been always set before entering INET
netfilter. This patch is to set skb->transport_header for bridge
before entering INET netfilter by bridge-nf-call-iptables.

It also fixes an issue that sctp_error() couldn't compute a right
csum due to unset skb->transport_header.

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Reported-by: Li Shuang <shuali@redhat.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 net/bridge/br_netfilter_ipv6.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 40d058378b52..fc605758323b 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IP);
+	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
 
 	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 564710f88f93..e88d6641647b 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
 	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
 
 	skb->protocol = htons(ETH_P_IPV6);
+	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
 		skb->dev, NULL,
 		br_nf_pre_routing_finish_ipv6);
-- 
2.19.1

