Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA634C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D7820823
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfFRIxv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 04:53:51 -0400
Received: from mail.us.es ([193.147.175.20]:40008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfFRIxv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 04:53:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9DD4FB6D0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:53:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAE9BDA70A
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 10:53:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA3E6DA707; Tue, 18 Jun 2019 10:53:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F363DA717;
        Tue, 18 Jun 2019 10:53:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 10:53:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7AD4D4265A2F;
        Tue, 18 Jun 2019 10:53:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     ffmancera@riseup.net
Subject: [PATCH nf-next] netfilter: ipv6: fix CONFIG_SYN_COOKIES=n
Date:   Tue, 18 Jun 2019 10:53:43 +0200
Message-Id: <20190618085343.8761-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With CONFIG_SYN_COOKIES=n:

   In file included from net/ipv6/ip6_output.c:44:0:
   include/linux/netfilter_ipv6.h: In function 'nf_ipv6_cookie_init_sequence':
>> include/linux/netfilter_ipv6.h:174:9: error: implicit declaration of function '__cookie_v6_init_sequence'; did you mean 'cookie_init_sequence'? [-Werror=implicit-function-declaration]
     return __cookie_v6_init_sequence(iph, th, mssp);
            ^~~~~~~~~~~~~~~~~~~~~~~~~
            cookie_init_sequence
   include/linux/netfilter_ipv6.h: In function 'nf_cookie_v6_check':
>> include/linux/netfilter_ipv6.h:189:9: error: implicit declaration of function '__cookie_v6_check'; did you mean '__cookie_v4_check'? [-Werror=implicit-function-declaration]
     return __cookie_v6_check(iph, th, cookie);
            ^~~~~~~~~~~~~~~~~
            __cookie_v4_check

Fixes: 3006a5224f15 ("netfilter: synproxy: remove module dependency on IPv6 SYNPROXY")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index dffb10fdc3e8..f80188b749c0 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -234,6 +234,8 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_me_harder	= ip6_route_me_harder,
 	.dev_get_saddr		= ipv6_dev_get_saddr,
 	.route			= __nf_ip6_route,
+#endif
+#if IS_MODULE(CONFIG_IPV6) && defined(CONFIG_SYN_COOKIES)
 	.cookie_init_sequence	= __cookie_v6_init_sequence,
 	.cookie_v6_check	= __cookie_v6_check,
 #endif
-- 
2.11.0

