Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B59C04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D79720657
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="bzWSxu5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfERSWt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 14:22:49 -0400
Received: from mx1.riseup.net ([198.252.153.129]:59942 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbfERSWs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 14:22:48 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id EC39E1A32CF
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 11:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558203768; bh=siXzP9SKvR/SIN+3kiMG6A24rHzBZU8Txwbn6FFysVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzWSxu5M+H5aBY+gFFSW6TPFsS3U/0ueFQFGdP8GpNMZKbsu26WiYwKnaKoc8Bw/Y
         X1sewS+swfXmDd0ooOi8FHdCOCL1DP8wxfcVPklBPdHaON7inv3l/fB93jVsoF+utk
         4SufTHpmxRKsM6FBXwW/bHMgNw5ZfVW1PEjQH2uQ=
X-Riseup-User-ID: D7DE92A4BB39D95416477BF651A2DAF343172B727334D2DB3AB8FEF586D20C37
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 11E58120ED1;
        Sat, 18 May 2019 11:22:46 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 3/5 nf-next] netfilter: add NF_SYNPROXY_IPV4 symbol
Date:   Sat, 18 May 2019 20:21:52 +0200
Message-Id: <20190518182151.1231-4-ffmancera@riseup.net>
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
 net/ipv4/netfilter/Kconfig  | 4 ++++
 net/ipv4/netfilter/Makefile | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1412b029f37f..5038bb95dbf2 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -18,6 +18,9 @@ config NF_SOCKET_IPV4
 config NF_TPROXY_IPV4
 	tristate "IPv4 tproxy support"
 
+config NF_SYNPROXY_IPV4
+	tristate
+
 if NF_TABLES
 
 config NF_TABLES_IPV4
@@ -196,6 +199,7 @@ config IP_NF_TARGET_REJECT
 config IP_NF_TARGET_SYNPROXY
 	tristate "SYNPROXY target support"
 	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+	select NF_SYNPROXY_IPV4
 	select NETFILTER_SYNPROXY
 	select SYN_COOKIES
 	help
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index c50e0ec095d2..01267eea7c4e 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -6,6 +6,9 @@
 # defrag
 obj-$(CONFIG_NF_DEFRAG_IPV4) += nf_defrag_ipv4.o
 
+#synproxy
+obj-$(CONFIG_NF_SYNPROXY_IPV4) += nf_synproxy_ipv4.o
+
 obj-$(CONFIG_NF_SOCKET_IPV4) += nf_socket_ipv4.o
 obj-$(CONFIG_NF_TPROXY_IPV4) += nf_tproxy_ipv4.o
 
-- 
2.20.1

