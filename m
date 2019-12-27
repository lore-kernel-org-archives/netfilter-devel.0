Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21546C3F68F
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB2EE21D7E
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469042;
	bh=ibTZwRKS6VoVkzjX7po10SasPNuQ7+a9R/Nk96beczE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GoBU9sYvJxR+Gh/2nQX1LDaI5xRr8yuWR4Ukrn/KZ/0qZWeUrdXu4TdulYYxMBbCy
	 qZcZKHjQRK5V0Xt7CV2TJwJymmzb4K+6OPlCAsrpA6CEDptX9RKKoT+uST2dZv+RvX
	 bcMCbML7mQVe7zEli3mC6Lrr6wtL3e/YvqwtQXVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfL0RoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbfL0RoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5F6222C2;
        Fri, 27 Dec 2019 17:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468648;
        bh=ibTZwRKS6VoVkzjX7po10SasPNuQ7+a9R/Nk96beczE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuKoLlWVp84OTmn1+BnhkZfDhTljcIrEBUoqBfYi4dqENm8kdODUECy6eXXO0o+sH
         6LFTXLwl7wJO47Dj3FOkxn3HsihoEgMcOV3Zhd6ccI+XWgnEgo4dgmJPWklTYH/Dzi
         NKi9Pgg1RAiCD0cAd1raetGobhARP7t3Kq88U7DY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Oliverio <marco.oliverio@tanaza.com>,
        Rocco Folino <rocco.folino@tanaza.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/84] netfilter: nf_queue: enqueue skbs with NULL dst
Date:   Fri, 27 Dec 2019 12:42:40 -0500
Message-Id: <20191227174352.6264-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Marco Oliverio <marco.oliverio@tanaza.com>

[ Upstream commit 0b9173f4688dfa7c5d723426be1d979c24ce3d51 ]

Bridge packets that are forwarded have skb->dst == NULL and get
dropped by the check introduced by
b60a77386b1d4868f72f6353d35dabe5fbe981f2 (net: make skb_dst_force
return true when dst is refcounted).

To fix this we check skb_dst() before skb_dst_force(), so we don't
drop skb packet with dst == NULL. This holds also for skb at the
PRE_ROUTING hook so we remove the second check.

Fixes: b60a77386b1d ("net: make skb_dst_force return true when dst is refcounted")
Signed-off-by: Marco Oliverio <marco.oliverio@tanaza.com>
Signed-off-by: Rocco Folino <rocco.folino@tanaza.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a96a8c16baf9..ee6d98355081 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -174,7 +174,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		goto err;
 	}
 
-	if (!skb_dst_force(skb) && state->hook != NF_INET_PRE_ROUTING) {
+	if (skb_dst(skb) && !skb_dst_force(skb)) {
 		status = -ENETDOWN;
 		goto err;
 	}
-- 
2.20.1

