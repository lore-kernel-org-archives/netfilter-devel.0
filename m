Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD80FC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFCA206C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714096;
	bh=w8JOCLULl7JTOFDUDC+FFkiBsazpMCqRDn6nVASIaZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AL3vWtzIGi68O0qVW7JqK2+a3rko8EkS9Zmm/VgKGfxzGbgdKzs1bva72BtGHTXeZ
	 ECTKUCZtA2Zu5+m4bD8Mczp9FImnjqtnyf6eRuf8kKdJKC2zht2aBqhIm4RFohN0u9
	 fWikuLCplPHx3wbIg9BuGNzxmYAt25Z5Jbu40ohs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbfC0SJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388580AbfC0SJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 14:09:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD0D2063F;
        Wed, 27 Mar 2019 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710171;
        bh=w8JOCLULl7JTOFDUDC+FFkiBsazpMCqRDn6nVASIaZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSWdVQRCTQb40wqcHByKeeAnE1qhzvm5BMSnsnPyd1f8bhs/a7ugnuZrR731lbcti
         LeFwYLh8Sn2CcmnouGhtgety97MiIEVwsKw9t9h2b94lh8t3Valt67znj6k+rQ/y0t
         /Cz1svxB0xqpYAJcu4GluPiETjsbxvN5/JscqPc8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 233/262] netfilter: physdev: relax br_netfilter dependency
Date:   Wed, 27 Mar 2019 14:01:28 -0400
Message-Id: <20190327180158.10245-233-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8e2f311a68494a6677c1724bdcb10bada21af37c ]

Following command:
  iptables -D FORWARD -m physdev ...
causes connectivity loss in some setups.

Reason is that iptables userspace will probe kernel for the module revision
of the physdev patch, and physdev has an artificial dependency on
br_netfilter (xt_physdev use makes no sense unless a br_netfilter module
is loaded).

This causes the "phydev" module to be loaded, which in turn enables the
"call-iptables" infrastructure.

bridged packets might then get dropped by the iptables ruleset.

The better fix would be to change the "call-iptables" defaults to 0 and
enforce explicit setting to 1, but that breaks backwards compatibility.

This does the next best thing: add a request_module call to checkentry.
This was a stray '-D ... -m physdev' won't activate br_netfilter
anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/br_netfilter.h | 1 -
 net/bridge/br_netfilter_hooks.c      | 5 -----
 net/netfilter/xt_physdev.c           | 9 +++++++--
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 4cd56808ac4e..89808ce293c4 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -43,7 +43,6 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 }
 
 struct net_device *setup_pre_routing(struct sk_buff *skb);
-void br_netfilter_enable(void);
 
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index c93c35bb73dd..40d058378b52 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -881,11 +881,6 @@ static const struct nf_br_ops br_ops = {
 	.br_dev_xmit_hook =	br_nf_dev_xmit,
 };
 
-void br_netfilter_enable(void)
-{
-}
-EXPORT_SYMBOL_GPL(br_netfilter_enable);
-
 /* For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
  * br_dev_queue_push_xmit is called afterwards */
 static const struct nf_hook_ops br_nf_ops[] = {
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 4034d70bff39..b2e39cb6a590 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -96,8 +96,7 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int physdev_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
-
-	br_netfilter_enable();
+	static bool brnf_probed __read_mostly;
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
@@ -111,6 +110,12 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
 			return -EINVAL;
 	}
+
+	if (!brnf_probed) {
+		brnf_probed = true;
+		request_module("br_netfilter");
+	}
+
 	return 0;
 }
 
-- 
2.19.1

