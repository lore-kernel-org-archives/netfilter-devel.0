Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C1DC43462
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20994613CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344111AbhDFMW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:22:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34452 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343976AbhDFMWC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:22:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id EA94763E66;
        Tue,  6 Apr 2021 14:21:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 15/28] netfilter: ipvs: do not printk on netns creation
Date:   Tue,  6 Apr 2021 14:21:20 +0200
Message-Id: <20210406122133.1644-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This causes dmesg spew during normal operation, so remove this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index cf925906f59b..ef1f45e43b63 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -591,8 +591,6 @@ static int __net_init __ip_vs_ftp_init(struct net *net)
 		ret = register_ip_vs_app_inc(ipvs, app, app->protocol, ports[i]);
 		if (ret)
 			goto err_unreg;
-		pr_info("%s: loaded support on port[%d] = %u\n",
-			app->name, i, ports[i]);
 	}
 	return 0;
 
-- 
2.30.2

