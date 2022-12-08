Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F91C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiLHPrC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiLHPrA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8AD42F77
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4YoTEQv1obGx5x7A2XXf3gI63E5rtUw7sE9dqcbNwqM=; b=Q4XL9xJOs4oeBvY+t9a/uJ1w7p
        fgGeJ1eJz2SPXCiR65peq6UlEg1f0oTZpDLhBx2mWpR6zGtHD+XGUbLwLP4CdBYD2HCxwbpUqEjhE
        iGe8qEQ5HFlUbgiEMSP0SIdgixCKN2toU0ov3pF5+kB/UTi1TOC1Cxpn9sdtYXvx9DXC5dmhojjwx
        4l1Cz54AG92tckPso+nMCtjpNEJHWpGQt0vCtl40ci2awWV3nqrnmJXbPKT1N8JHr9GAER/TykCRQ
        iCaxgcp9IEPuJnh1i00wa1HruVYtfzeJTlHnxL/Jg0QR5oJyM5IpXrDHT6XhVgFM3uk4xEzUQRLBg
        mbrcB8BA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J6v-0005fa-MT; Thu, 08 Dec 2022 16:46:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 03/11] Makefile: Generate ip6tables man pages on the fly
Date:   Thu,  8 Dec 2022 16:46:08 +0100
Message-Id: <20221208154616.14622-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to drag them around, creating them is simple.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Eliminate the <<< bashism, as reported by Jan.
---
 iptables/Makefile.am         | 3 +++
 iptables/ip6tables-apply.8   | 1 -
 iptables/ip6tables-restore.8 | 1 -
 iptables/ip6tables-save.8    | 1 -
 iptables/ip6tables.8         | 1 -
 5 files changed, 3 insertions(+), 4 deletions(-)
 delete mode 100644 iptables/ip6tables-apply.8
 delete mode 100644 iptables/ip6tables-restore.8
 delete mode 100644 iptables/ip6tables-save.8
 delete mode 100644 iptables/ip6tables.8

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 23f8352d30610..8c346698655c4 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -105,6 +105,9 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
+ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
+	${AM_VERBOSE_GEN} echo "$@" | sed 's|^ip6|.so man8/ip|' >$@
+
 pkgconfig_DATA = xtables.pc
 
 # Using if..fi avoids an ugly "error (ignored)" message :)
diff --git a/iptables/ip6tables-apply.8 b/iptables/ip6tables-apply.8
deleted file mode 100644
index 994b487a43598..0000000000000
--- a/iptables/ip6tables-apply.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-apply.8
diff --git a/iptables/ip6tables-restore.8 b/iptables/ip6tables-restore.8
deleted file mode 100644
index cf4ea3e7926c4..0000000000000
--- a/iptables/ip6tables-restore.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-restore.8
diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
deleted file mode 100644
index 182f55c12f962..0000000000000
--- a/iptables/ip6tables-save.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-save.8
diff --git a/iptables/ip6tables.8 b/iptables/ip6tables.8
deleted file mode 100644
index 0dee41adb3965..0000000000000
--- a/iptables/ip6tables.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables.8
-- 
2.38.0

