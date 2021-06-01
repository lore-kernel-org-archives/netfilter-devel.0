Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5113AC4709A
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3403D6139A
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhFAWIX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39552 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhFAWIU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 91AB164194;
        Wed,  2 Jun 2021 00:05:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/16] netfilter: xt_CT: Remove redundant assignment to ret
Date:   Wed,  2 Jun 2021 00:06:20 +0200
Message-Id: <20210601220629.18307-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Variable 'ret' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed

Clean up the following clang-analyzer warning:

net/netfilter/xt_CT.c:175:2: warning: Value stored to 'ret' is never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_CT.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index d4deee39158b..12404d221026 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -172,7 +172,6 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 		goto err2;
 	}
 
-	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
 				  GFP_KERNEL)) {
-- 
2.30.2

