Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1FAC04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA0C926679
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEaJKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 05:10:45 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:36170 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaJKp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 05:10:45 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 05:10:43 EDT
Received: from 10-19-61-167.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1706941B73;
        Fri, 31 May 2019 17:02:59 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: ipv6: fix compile err unknown field br_defrag and br_fragment
Date:   Fri, 31 May 2019 17:02:55 +0800
Message-Id: <1559293375-14385-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kIGBQJHllBWUlVSUNJQkJCQkJJSExLTUpZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBg6Qio*Mjg#DCIJNjdODQ4P
        H00aCitVSlVKTk5CSUJISExCSUhMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMSEo3Bg++
X-HM-Tid: 0a6b0d20c2612086kuqy1706941b73
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When CONFIG_IPV6 is not build with modules and CONIFG_NF_CONNTRACK_BRIDGE=m
There will compile err:
net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
  .br_defrag  = nf_ct_frag6_gather,
net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
  .br_fragment  = br_ip6_fragment,

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv6/netfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index c666538..9530cc2 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,7 +238,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_NF_CONNTRACK_BRIDGE)
+#if IS_MODULE(CONFIG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
 	.br_fragment		= br_ip6_fragment,
 #endif
-- 
1.8.3.1

