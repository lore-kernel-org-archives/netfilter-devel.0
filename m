Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D671C04AB5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B32C20840
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="RNMi+6nn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfFGAjW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 20:39:22 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58878 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfFGAjW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 20:39:22 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id E21911A311B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 17:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1559867961; bh=ZSwTYi4AWwIIPJ97XwE++Mq8F9fqD3UyBuewOOFU4ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNMi+6nnfE8+03ztEg1KGnxZeXLr9ydtkyJHnjfpVtLh6LPX8J64hTv40a1ZbsQvj
         M6cwH66akWXg7OrIKA5sMFsx3UhDyEjktAlz/FTezjDzOoxULcOBn+GaQiX/qqsJbM
         Lg6M0WQmoonlyd+UmLZpLFSAwSXgTRckhXn9euWw=
X-Riseup-User-ID: A52A4915A9CEF50F0F75E4E252E298E177C1E19D08B628C119C7B5D0D5DE81D4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 26E232238A5;
        Thu,  6 Jun 2019 17:39:20 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v4 2/3] netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
Date:   Fri,  7 Jun 2019 02:36:05 +0200
Message-Id: <20190607003603.7758-3-ffmancera@riseup.net>
In-Reply-To: <20190607003603.7758-1-ffmancera@riseup.net>
References: <20190607003603.7758-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a prerequisite for the infrastructure module NETFILTER_SYNPROXY.  The
new module is needed to avoid duplicated code for the SYNPROXY nftables
support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/linux/netfilter_ipv6.h | 36 ++++++++++++++++++++++++++++++++++
 net/ipv6/netfilter.c           |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3a3dc4b1f0e7..c4b403c746fa 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -8,6 +8,7 @@
 #define __LINUX_IP6_NETFILTER_H
 
 #include <uapi/linux/netfilter_ipv6.h>
+#include <net/tcp.h>
 
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
@@ -35,6 +36,10 @@ struct nf_ipv6_ops {
 		       struct in6_addr *saddr);
 	int (*route)(struct net *net, struct dst_entry **dst, struct flowi *fl,
 		     bool strict);
+	u32 (*cookie_init_sequence)(const struct ipv6hdr *iph,
+				    const struct tcphdr *th, u16 *mssp);
+	int (*cookie_v6_check)(const struct ipv6hdr *iph,
+			       const struct tcphdr *th, __32 cookie);
 #endif
 	void (*route_input)(struct sk_buff *skb);
 	int (*fragment)(struct net *net, struct sock *sk, struct sk_buff *skb,
@@ -154,6 +159,37 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
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
+
+	return 0;
+#else
+	return __cookie_v6_init_sequence(iph, th, mssp);
+#endif
+}
+
+static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
+				     const struct tcphdr *th, __u32 cookie)
+{
+#if IS_MODULE(CONFIG_IPV6)
+	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
+
+	if (v6_ops)
+		return v6_ops->cookie_v6_check(iph, th, cookie);
+
+	return 0;
+#else
+	return __cookie_v6_check(iph, th, cookie);
+#endif
+}
+
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 			unsigned int dataoff, u_int8_t protocol);
 
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d9673e10c60c..89a05be82c95 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -234,6 +234,8 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+	.cookie_init_sequence	= __cookie_v6_init_sequence,
+	.cookie_v6_check	= __cookie_v6_check,
 #endif
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
-- 
2.20.1

