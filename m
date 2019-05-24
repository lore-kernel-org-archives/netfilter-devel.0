Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00682C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8DAB21850
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="eCn9fomf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391037AbfEXRCN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 13:02:13 -0400
Received: from mx1.riseup.net ([198.252.153.129]:42594 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390532AbfEXRCN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 13:02:13 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C5C341A2FA7
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 10:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558717332; bh=rnGL9ddmcKAFn1l4I/Qb1AeS61mJKTuLqE5+pRByl6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCn9fomfoVYPuUu6hj25uXAEY25+DIhVcFgnxTtJ5xFmD6T7nqEprpEyt17MHjcYz
         GDlCK8a/aYY5w0LzWmdWyytF8zRM25SjTmdocePadm6QnaOY/T1E6fGyDX51OdNyde
         7Oe4M3i2kdybTZsoJ8rkNd57sC2W/7kkJzVK4Jbw=
X-Riseup-User-ID: D0EB6807C4F8F2C87B5D8FF313FBD9873355349F35065F45005368892A6FDB2C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 0391C222DE9;
        Fri, 24 May 2019 10:02:11 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v3 4/4] netfilter: add NF_SYNPROXY symbol
Date:   Fri, 24 May 2019 19:01:10 +0200
Message-Id: <20190524170106.2686-5-ffmancera@riseup.net>
In-Reply-To: <20190524170106.2686-1-ffmancera@riseup.net>
References: <20190524170106.2686-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/ipv4/netfilter/Kconfig | 2 +-
 net/ipv6/netfilter/Kconfig | 2 +-
 net/netfilter/Kconfig      | 4 ++++
 net/netfilter/Makefile     | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1412b029f37f..87f6ec800e54 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -197,7 +197,7 @@ config IP_NF_TARGET_SYNPROXY
 	tristate "SYNPROXY target support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
 	select NETFILTER_SYNPROXY
-	select SYN_COOKIES
+	select NF_SYNPROXY
 	help
 	  The SYNPROXY target allows you to intercept TCP connections and
 	  establish them using syncookies before they are passed on to the
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 086fc669279e..f71879f875e1 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -213,7 +213,7 @@ config IP6_NF_TARGET_SYNPROXY
 	tristate "SYNPROXY target support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
 	select NETFILTER_SYNPROXY
-	select SYN_COOKIES
+	select NF_SYNPROXY
 	help
 	  The SYNPROXY target allows you to intercept TCP connections and
 	  establish them using syncookies before they are passed on to the
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 02b281d3c167..ae65fca0d509 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -435,6 +435,10 @@ config NF_NAT_REDIRECT
 config NF_NAT_MASQUERADE
 	bool
 
+config NF_SYNPROXY
+	tristate
+	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+
 config NETFILTER_SYNPROXY
 	tristate
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 72cca6b48960..7a6067513eee 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_NF_NAT_TFTP) += nf_nat_tftp.o
 
 # SYNPROXY
 obj-$(CONFIG_NETFILTER_SYNPROXY) += nf_synproxy_core.o
+obj-$(CONFIG_NF_SYNPROXY) += nf_synproxy.o
 
 obj-$(CONFIG_NETFILTER_CONNCOUNT) += nf_conncount.o
 
-- 
2.20.1

