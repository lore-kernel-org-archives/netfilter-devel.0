Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E630BC04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C318A20675
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="fmSWrwlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfERSXT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 14:23:19 -0400
Received: from mx1.riseup.net ([198.252.153.129]:60056 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfERSXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 14:23:19 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D119B1A3C78
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 11:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558203798; bh=i/2vc7iMykYWsXXNyseM21usISOjdsX2eUsGAmqmNvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmSWrwlIn/Wy4BFcfjMTRTiC+J5c6DdLbjxM91BV3skpZk8jCvx2dlo4uM5OODdwX
         YOmsS1z/5dj1A578SKhJ2OtlTlItYsihFKfzD9770XrSj5qXEZl2OccLpaEnCF0xS6
         kJB7ijNoVJgQtTd5wUTV2OXLDnpCCqb8QVMfslGw=
X-Riseup-User-ID: 94B21D758DF2B379B0D2C3D2218A5FB516537EB18DBBC27B8D6E1BD89470C25F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id EF69312056F;
        Sat, 18 May 2019 11:23:17 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 5/5 nf-next] netfilter: add NF_SYNPROXY_IPV6 symbol
Date:   Sat, 18 May 2019 20:21:56 +0200
Message-Id: <20190518182151.1231-6-ffmancera@riseup.net>
In-Reply-To: <20190518182151.1231-1-ffmancera@riseup.net>
References: <20190518182151.1231-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/ipv6/netfilter/Kconfig  | 4 ++++
 net/ipv6/netfilter/Makefile | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 086fc669279e..60146a0d390d 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -5,6 +5,9 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
+config NF_SYNPROXY_IPV6
+	tristate
+
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -212,6 +215,7 @@ config IP6_NF_TARGET_REJECT
 config IP6_NF_TARGET_SYNPROXY
 	tristate "SYNPROXY target support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+	select NF_SYNPROXY_IPV6
 	select NETFILTER_SYNPROXY
 	select SYN_COOKIES
 	help
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 731a74c60dca..d9ee2f8c9ae2 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -15,6 +15,9 @@ obj-$(CONFIG_IP6_NF_NAT) += ip6table_nat.o
 nf_defrag_ipv6-y := nf_defrag_ipv6_hooks.o nf_conntrack_reasm.o
 obj-$(CONFIG_NF_DEFRAG_IPV6) += nf_defrag_ipv6.o
 
+#synproxy
+obj-$(CONFIG_NF_SYNPROXY_IPV6) += nf_synproxy_ipv6.o
+
 obj-$(CONFIG_NF_SOCKET_IPV6) += nf_socket_ipv6.o
 obj-$(CONFIG_NF_TPROXY_IPV6) += nf_tproxy_ipv6.o
 
-- 
2.20.1

