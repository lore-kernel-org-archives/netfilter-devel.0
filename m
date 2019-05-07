Return-Path: <SRS0=SeaY=TH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F45C004C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 05:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8AAD2054F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 May 2019 05:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557208377;
	bh=KwRV0uxZD+ee2/dxIQ+5k9LAHpPD+90ojoWl+cbZvzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bBdp+iXdzZ3gkuGpmQ2lvsvcIv9GyxBH4h+3AfCMFVjw+KzOF/9jDQgQMbekur7TT
	 bFFZDYVSbyYEFEXOwhTtYVftKO2t+zY3gaF0kMFHIkAuGTJHHcS+AzrArt+aLYg0Ut
	 NCps4Kn1TsmpnUqAzXVr+fbqdsvBmrLCmrbCHBUM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfEGFjT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 May 2019 01:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbfEGFjS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 May 2019 01:39:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE4A20675;
        Tue,  7 May 2019 05:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207558;
        bh=KwRV0uxZD+ee2/dxIQ+5k9LAHpPD+90ojoWl+cbZvzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2Dzx517wDUtb84eDudQkxuUnKyqzVtzs4uz0at4Zz3pmCYJjfuWHngFUPzlRfucW
         gtRjP56zyDGu0TlyqK0esbOsjdYGfk3P5riizUkKJJ0bkK8LMkvBdZbixpuI3ic+lF
         Sua4GWXKhFvhUWZ010rCUf/vvQEUFm/oZnPtoP4w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.14 24/95] ipvs: do not schedule icmp errors from tunnels
Date:   Tue,  7 May 2019 01:37:13 -0400
Message-Id: <20190507053826.31622-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 0261ea1bd1eb0da5c0792a9119b8655cf33c80a3 ]

We can receive ICMP errors from client or from
tunneling real server. While the former can be
scheduled to real server, the latter should
not be scheduled, they are decapsulated only when
existing connection is found.

Fixes: 6044eeffafbe ("ipvs: attempt to schedule icmp packets")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4278f5c947ab..d1c0378144f3 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1635,7 +1635,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	if (!cp) {
 		int v;
 
-		if (!sysctl_schedule_icmp(ipvs))
+		if (ipip || !sysctl_schedule_icmp(ipvs))
 			return NF_ACCEPT;
 
 		if (!ip_vs_try_to_schedule(ipvs, AF_INET, skb, pd, &v, &cp, &ciph))
-- 
2.20.1

