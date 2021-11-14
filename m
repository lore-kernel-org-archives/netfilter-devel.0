Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2CCC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E1B60184
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhKNOEg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhKNOEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:23 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBCCC061767
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZsLo62ZgK42eAqd1ICirjS1rL67Lvl8P5jhqIqPc7Qg=; b=nYd/CNPVuLLWj9vXaUUMIocfuj
        gicqvFPE5/kdcr46dm/9FK+IA5MlIYXUD9OEchXTAQfVL0kgUJITxn8oym4K6ocrZOsdsYHJQtFOR
        trTZDljYwCtbgx7yt2Fmp7N7Ocx15a0f7IJHnxNXNWKxddT2sKF2+3LLzgXReJTn0jmcCqe9kg9MD
        qoBuX85aK7apDuLya7BNNkKhgJERiZkI4jKidkEmnjpAgBpcSrE/h65PbDUyDS82BWUSP7wl8KrKH
        adooAE4weLXhUBFVeaJPAn1rwID4KXhWw0jMzFrR5jJ4veRaIhTjj/1tllU4eEqYADluvOcHuGEh5
        bZMwRkxg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4F-00Cdsh-5D
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 04/16] build: remove empty filter sub-directory
Date:   Sun, 14 Nov 2021 14:00:46 +0000
Message-Id: <20211114140058.752394-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The only file in filter/packet2flow is an empty Makefile.am.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac                   | 2 +-
 filter/Makefile.am             | 2 +-
 filter/packet2flow/Makefile.am | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 delete mode 100644 filter/packet2flow/Makefile.am

diff --git a/configure.ac b/configure.ac
index e341ad12a159..4e502171292e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -177,7 +177,7 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  include/linux/netfilter_ipv4/Makefile libipulog/Makefile \
 	  input/Makefile input/packet/Makefile input/flow/Makefile \
 	  input/sum/Makefile \
-	  filter/Makefile filter/raw2packet/Makefile filter/packet2flow/Makefile \
+	  filter/Makefile filter/raw2packet/Makefile \
 	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
 	  output/dbi/Makefile output/ipfix/Makefile \
 	  src/Makefile Makefile)
diff --git a/filter/Makefile.am b/filter/Makefile.am
index 875850b8ae90..c2755ecb7c49 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS = raw2packet packet2flow
+SUBDIRS = raw2packet
 
 AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNFNETLINK_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
diff --git a/filter/packet2flow/Makefile.am b/filter/packet2flow/Makefile.am
deleted file mode 100644
index e69de29bb2d1..000000000000
-- 
2.33.0

