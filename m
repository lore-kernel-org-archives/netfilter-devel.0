Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB1BC433E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 19:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCFC2080C
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 19:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0TyK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 15:54:10 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:35548 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgH0TyK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 15:54:10 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2020 15:54:08 EDT
Received: from mxback17j.mail.yandex.net (mxback17j.mail.yandex.net [IPv6:2a02:6b8:0:1619::93])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 5611BB20D8C;
        Thu, 27 Aug 2020 22:48:17 +0300 (MSK)
Received: from iva7-f62245f79210.qloud-c.yandex.net (iva7-f62245f79210.qloud-c.yandex.net [2a02:6b8:c0c:2e83:0:640:f622:45f7])
        by mxback17j.mail.yandex.net (mxback/Yandex) with ESMTP id cCPYONAQh0-mGbekdjK;
        Thu, 27 Aug 2020 22:48:17 +0300
Received: by iva7-f62245f79210.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id JKX2XogRXs-mEnG4U43;
        Thu, 27 Aug 2020 22:48:15 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Lach <iam@lach.pw>
Cc:     iam@lach.pw, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove ipvs v6 dependency on iptables
Date:   Fri, 28 Aug 2020 00:48:02 +0500
Message-Id: <20200827194802.1164-1-iam@lach.pw>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This dependency was added in 63dca2c0b0e7a92cb39d1b1ecefa32ffda201975, because this commit had dependency on
ipv6_find_hdr, which was located in iptables-specific code

But it is no longer required, because f8f626754ebeca613cf1af2e6f890cfde0e74d5b moved them to a more common location
---
 net/netfilter/ipvs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 2c1593089..eb0e329f9 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -29,7 +29,6 @@ if IP_VS
 config	IP_VS_IPV6
 	bool "IPv6 support for IPVS"
 	depends on IPV6 = y || IP_VS = IPV6
-	select IP6_NF_IPTABLES
 	select NF_DEFRAG_IPV6
 	help
 	  Add IPv6 support to IPVS.
-- 
2.28.0

