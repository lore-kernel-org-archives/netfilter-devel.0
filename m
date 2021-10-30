Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAF0C43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3525A60F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhJ3QET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB7FC061205
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZsLo62ZgK42eAqd1ICirjS1rL67Lvl8P5jhqIqPc7Qg=; b=cddvb9yhkMK5Z2KjAl05D4hD7t
        KqFbB/wEdzaBgxWMci10L4JpoAL3VxHWGJ4pnfCPTNVpEfQPBsA8hRwreuOFR0hse0aqW9+hQNPdP
        jTeTHRsdC6Jfv/7v+jHp1vBfiYuVDVNhr8c8aL3Ki4QQWBfZZGtdT5cQiO8A8gxUGJiOlXQpkkuzz
        zcSHffqd4t4ul+iw9Uc9sMXtp9EgOu5qKJ3L1GT39sreJe8DnDZeSwwlnvreBsWanFwvyhQSrgKA7
        hthDI2wSoCVgU8p3ifNL1MOFKH8g3iw6urRbgfSPaWi4nAQabv42GKat/MdTglqUkX/VtSCcJRxZ9
        5AsavUYA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqnf-00AFQk-Or
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 04/13] build: remove empty filter sub-directory
Date:   Sat, 30 Oct 2021 17:01:32 +0100
Message-Id: <20211030160141.1132819-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030160141.1132819-1-jeremy@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
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

