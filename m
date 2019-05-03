Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCD7C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 03:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F0962075E
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 03:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ByPE3kWF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TMwPT9sn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfECDW4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 23:22:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfECDW4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 23:22:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 580406115B; Fri,  3 May 2019 03:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556853775;
        bh=azniW0lytE8xplUR7z4aa5bQmjAruiH5oksE9dU3JaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ByPE3kWFugvcgr1xNIs/snTH4CutpjA2aMdg7KmXOlWCm8GsM6/hNuSVyWeEEDZHF
         qlFB8N+UPiD8qotHKJArVRFE4j8COa11ijZ7T1YaVC+P4XC5xBuSkXk7GB4QpHLj6d
         F+TjfrEztc25juc/WKv5kgQl7PDpp6MgkobXPaMU=
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47FA260E59;
        Fri,  3 May 2019 03:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556853774;
        bh=azniW0lytE8xplUR7z4aa5bQmjAruiH5oksE9dU3JaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TMwPT9sn4H8JNi50wYmNPbZ7VwvXJmGkXf9d7t+IWkwT7o0fROa1kaaBd/PUxju/+
         wtfTbouP5yDkuVaSVvJjeMC8kMptv4RsxRxGd2lm2jP0CZFzZDo8NAOB5cUGWH34dO
         MoX3/f8pVjLwOPKsf/MYs5NTIZhlELjD8IK/LawQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47FA260E59
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     fw@strlen.de, pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf] netfilter: nf_conntrack_h323: Remove deprecated config check
Date:   Thu,  2 May 2019 21:22:17 -0600
Message-Id: <1556853737-14697-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONFIG_NF_CONNTRACK_IPV6 has been deprecated so replace it with
a check for IPV6 instead.

Fixes: a0ae2562c6c4b2 ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 include/linux/netfilter_ipv6.h         | 2 +-
 net/netfilter/nf_conntrack_h323_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 12113e5..61f7ac9 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -25,7 +25,7 @@ struct ip6_rt_info {
  * if IPv6 is a module.
  */
 struct nf_ipv6_ops {
-#if IS_MODULE(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
 			const struct net_device *dev, int strict);
 	int (*route_me_harder)(struct net *net, struct sk_buff *skb);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 005589c..1c6769b 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -748,7 +748,7 @@ static int callforward_do_filter(struct net *net,
 		}
 		break;
 	}
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6: {
 		const struct nf_ipv6_ops *v6ops;
 		struct rt6_info *rt1, *rt2;
-- 
1.9.1

