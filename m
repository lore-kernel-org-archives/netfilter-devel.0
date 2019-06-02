Return-Path: <SRS0=NG1t=UB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C46C46460
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jun 2019 13:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48AFB27932
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jun 2019 13:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFBNtk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jun 2019 09:49:40 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:55194 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFBNtk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jun 2019 09:49:40 -0400
Received: from 10-19-61-167.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 7BF405C187A;
        Sun,  2 Jun 2019 21:49:30 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2] netfilter: ipv6: Fix undefined symbol nf_ct_frag6_gather
Date:   Sun,  2 Jun 2019 21:49:26 +0800
Message-Id: <1559483366-12371-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVT0hPS0tLS0pOSU5DTEJZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTI6MBw*FTg3HCERKyNCKk0X
        PC4KCwpVSlVKTk5CT0NISExLTkNNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpNTU03Bg++
X-HM-Tid: 0a6b1873cc1c2087kuqy7bf405c187a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set

ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!

Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: Forgot to include "net-next"

 net/ipv6/netfilter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 9530cc2..96d7abf 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,8 +238,10 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6)
+#if IS_MODULE(CONFIG_IPV6) && IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
+#endif
+#if IS_MODULE(CONFIG_IPV6)
 	.br_fragment		= br_ip6_fragment,
 #endif
 };
-- 
1.8.3.1

