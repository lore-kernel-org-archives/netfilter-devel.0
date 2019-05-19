Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBA9C04AB4
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83E6720657
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:54:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="VxjwhbOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfESUyM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 16:54:12 -0400
Received: from mx1.riseup.net ([198.252.153.129]:51968 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfESUyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 16:54:12 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 325461A228A
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558299251; bh=yDwWm0cvOzGeXwAMz1Wifpiu/mvwOFLejDLFZSYzlMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxjwhbOCo17rvdwaKRWbJJsuoEDjjhM7xB82ymwv6MYeYGWigOchOUI7VC8oOegsM
         SIEfNEXpSKDgJ48LFIMrtWK2uIoQnYmUzNGyTdS5kOi3a+w+a1Fr5GwV38vJnHm8C2
         rm/4KXS98UOmwHTl1Du0GLXmfxP4ZExQrIIBo3xQ=
X-Riseup-User-ID: 4C8E35490341BE691777C51AAD5815E1276F9F26E628F006D801ECB4956D0BE1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 664C812056F;
        Sun, 19 May 2019 13:54:10 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v2 4/4] netfilter: add NF_SYNPROXY symbol
Date:   Sun, 19 May 2019 22:53:04 +0200
Message-Id: <20190519205259.2821-5-ffmancera@riseup.net>
In-Reply-To: <20190519205259.2821-1-ffmancera@riseup.net>
References: <20190519205259.2821-1-ffmancera@riseup.net>
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
 net/netfilter/Kconfig      | 3 +++
 net/netfilter/Makefile     | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

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
index 086fc669279e..79fb64706017 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -212,8 +212,8 @@ config IP6_NF_TARGET_REJECT
 config IP6_NF_TARGET_SYNPROXY
 	tristate "SYNPROXY target support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+	select NF_SYNPROXY
 	select NETFILTER_SYNPROXY
-	select SYN_COOKIES
 	help
 	  The SYNPROXY target allows you to intercept TCP connections and
 	  establish them using syncookies before they are passed on to the
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 02b281d3c167..951e8daa896b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -435,6 +435,9 @@ config NF_NAT_REDIRECT
 config NF_NAT_MASQUERADE
 	bool
 
+config NF_SYNPROXY
+	tristate
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

