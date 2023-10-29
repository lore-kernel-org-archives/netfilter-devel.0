Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D62CC4167B
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Oct 2023 23:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjJ2XHJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Oct 2023 19:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjJ2XGn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2023 19:06:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFB06595;
        Sun, 29 Oct 2023 16:01:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E08C433CC;
        Sun, 29 Oct 2023 23:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698620469;
        bh=uEtJBRzg7Zr+VZEfWwug+VgiKu2cYuMf1hhXMXL/dkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqW1Hvee0vuqWBQsU6Zf+N7sCpKuFpjAFp2NIw6UPi0kI9u/RXizzvXlqmiGTXrCV
         Ri9j3EIjUyKErRqLh0G6ZoUt2qailb1xjV2wt4J65mZ2ZfkhkREx6JqkMVcVdEBKmz
         fXYuujW4k1VdNFECy4/PoQ9K7oVVIFpCag10Qf4blUCJMb3INjz7TRIVWEYtnqfOpG
         wM/nPYryn8OtlloJ9EbjAB3YeHsm/2A9jJJO68E5pU69hMBVM0bj06Wru6EVi6rOw1
         GFNSCXLeJku+ydeEKKZAV4WEF1XgmVlY/CJqVpYFG1g6t/5OvTeMASOL4LgkNEjwOu
         z4aajbkiD0b3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/13] netfilter: nfnetlink_log: silence bogus compiler warning
Date:   Sun, 29 Oct 2023 19:00:39 -0400
Message-ID: <20231029230057.792930-6-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231029230057.792930-1-sashal@kernel.org>
References: <20231029230057.792930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.259
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 2e1d175410972285333193837a4250a74cd472e6 ]

net/netfilter/nfnetlink_log.c:800:18: warning: variable 'ctinfo' is uninitialized

The warning is bogus, the variable is only used if ct is non-NULL and
always initialised in that case.  Init to 0 too to silence this.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309100514.ndBFebXN-lkp@intel.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index f087baa95b07b..80c09070ea9fa 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -683,8 +683,8 @@ nfulnl_log_packet(struct net *net,
 	unsigned int plen = 0;
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	const struct nfnl_ct_hook *nfnl_ct = NULL;
+	enum ip_conntrack_info ctinfo = 0;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info ctinfo;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
 		li = li_user;
-- 
2.42.0

