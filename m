Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1146BC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D31E6217F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IFZxu22s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390910AbfEXRB1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 13:01:27 -0400
Received: from mx1.riseup.net ([198.252.153.129]:42210 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390532AbfEXRB1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 13:01:27 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 22D601A2934
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 10:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558717287; bh=eTO9JmQLGqnZxFHtF8jSB09QxsqO5NPeHRjAmDon4AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFZxu22s8wFtZm+cxoiFt3a13X5t/fpI1yC6Lrt7T6CXaKNVSN3OUxRA9V2HDl5R/
         iP1Y6YIU4PPie/0S+Anyur38FIODdCTKH8VlJk3fsOt05GJpujqSOQ0UZimpXf/fUB
         428FA09exPOUet6qI9dFN+fjJyrpq/R37bRYB8Tk=
X-Riseup-User-ID: E77E8D13714FB9135BA74E5CE19D6290F590A506F365C6B6FCA579B2D2C40876
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4B6AD223561;
        Fri, 24 May 2019 10:01:26 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v3 2/4] netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
Date:   Fri, 24 May 2019 19:01:06 +0200
Message-Id: <20190524170106.2686-3-ffmancera@riseup.net>
In-Reply-To: <20190524170106.2686-1-ffmancera@riseup.net>
References: <20190524170106.2686-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a prerequisite for the new infrastructure module NF_SYNPROXY. The new
module is needed to avoid duplicated code for the SYNPROXY nftables support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/linux/netfilter_ipv6.h | 17 +++++++++++++++++
 net/ipv6/netfilter.c           |  1 +
 2 files changed, 18 insertions(+)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 12113e502656..549a5df39cf9 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -8,6 +8,7 @@
 #define __LINUX_IP6_NETFILTER_H
 
 #include <uapi/linux/netfilter_ipv6.h>
+#include <net/tcp.h>
 
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
@@ -34,6 +35,8 @@ struct nf_ipv6_ops {
 		       struct in6_addr *saddr);
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
+	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
+				    const struct tcphdr *th, u16 *mssp);
 #endif
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
@@ -102,6 +105,20 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 #endif
 }
 
+static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
+					       const struct tcphdr *th,
+					       u16 *mssp)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (v6_ops)
+		return v6_ops->cookie_init_sequence(iph, th, mssp);
+#else
+	return __cookie_v6_init_sequence(iph, th, mssp);
+#endif
+}
+
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 1240ccd57f39..32b8b1f470f4 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -115,6 +115,7 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+	.cookie_init_sequence	= __cookie_v6_init_sequence,
 #endif
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
-- 
2.20.1

