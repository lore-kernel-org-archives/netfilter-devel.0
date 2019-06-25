Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF977C4646C
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FAAC205ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfFYAOP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 20:14:15 -0400
Received: from mail.us.es ([193.147.175.20]:38048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbfFYAMy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72D26C04B6
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 617F4DA70A
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 572BEDA708; Tue, 25 Jun 2019 02:12:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BEFCDA701;
        Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1EAFC4265A2F;
        Tue, 25 Jun 2019 02:12:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 20/26] netfilter: synproxy: fix building syncookie calls
Date:   Tue, 25 Jun 2019 02:12:27 +0200
Message-Id: <20190625001233.22057-21-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When either CONFIG_IPV6 or CONFIG_SYN_COOKIES are disabled, the kernel
fails to build:

include/linux/netfilter_ipv6.h:180:9: error: implicit declaration of function '__cookie_v6_init_sequence'
      [-Werror,-Wimplicit-function-declaration]
        return __cookie_v6_init_sequence(iph, th, mssp);
include/linux/netfilter_ipv6.h:194:9: error: implicit declaration of function '__cookie_v6_check'
      [-Werror,-Wimplicit-function-declaration]
        return __cookie_v6_check(iph, th, cookie);
net/ipv6/netfilter.c:237:26: error: use of undeclared identifier '__cookie_v6_init_sequence'; did you mean 'cookie_init_sequence'?
net/ipv6/netfilter.c:238:21: error: use of undeclared identifier '__cookie_v6_check'; did you mean '__cookie_v4_check'?

Fix the IS_ENABLED() checks to match the function declaration
and definitions for these.

Fixes: 3006a5224f15 ("netfilter: synproxy: remove module dependency on IPv6 SYNPROXY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h | 14 ++++++++------
 net/ipv6/netfilter.c           |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 35b12525ee45..22e6398bc482 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -163,31 +163,33 @@ static inline u32 nf_ipv6_cookie_init_sequence(const struct ipv6hdr *iph,
 					       const struct tcphdr *th,
 					       u16 *mssp)
 {
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
 
 	if (v6_ops)
 		return v6_ops->cookie_init_sequence(iph, th, mssp);
-
-	return 0;
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return __cookie_v6_init_sequence(iph, th, mssp);
 #endif
+#endif
+	return 0;
 }
 
 static inline int nf_cookie_v6_check(const struct ipv6hdr *iph,
 				     const struct tcphdr *th, __u32 cookie)
 {
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 #if IS_MODULE(CONFIG_IPV6)
 	const struct nf_ipv6_ops *v6_ops = nf_get_ipv6_ops();
 
 	if (v6_ops)
 		return v6_ops->cookie_v6_check(iph, th, cookie);
-
-	return 0;
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return __cookie_v6_check(iph, th, cookie);
 #endif
+#endif
+	return 0;
 }
 
 __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index dffb10fdc3e8..61819ed858b1 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -234,9 +234,11 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
 	.cookie_init_sequence	= __cookie_v6_init_sequence,
 	.cookie_v6_check	= __cookie_v6_check,
 #endif
+#endif
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-- 
2.11.0

