Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48F3C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A429260EE7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKNPzl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbhKNPzi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:55:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D4C061202
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZsLo62ZgK42eAqd1ICirjS1rL67Lvl8P5jhqIqPc7Qg=; b=OB8+GWBpx5xtsSE2L0gwIqiUkH
        Q9VDO7bJN6ZOWs8l8bMqPHKT8pvMjJ9OSRFZb9kEDdFTYppNFh8HJXIuh1K1QqMnOeD50cpZOUX0t
        8uoP7We9ZBV9I+Z8BLH4xekxELAZj6hDMa2J9degojm75rBjOfWmCsugU/WwI35MF0o/lf5lI33nK
        g2ODHFBXHflD01VcBus/QtlI9uSfyTbahRaSsWZbVOKu3pyycW9CiuZEkADb2Dgfx1txGuBX+b0GI
        9JTCFYaX8GR0zuw6g3fmCcpoG1p4cx72z/84HIPKGMD9eTsCKRzsTLYAycSj21gaIS/38cIghJcTJ
        aiqueiIQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo8-00CfJ1-Se
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 04/15] build: remove empty filter sub-directory
Date:   Sun, 14 Nov 2021 15:52:20 +0000
Message-Id: <20211114155231.793594-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
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

