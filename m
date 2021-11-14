Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A79C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 472A260184
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhKNOEX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKNOEN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:13 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0932C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zNkx4FmWX8/ElWt8zYlP8hTZ005/S5g38VQ7p+QrZRs=; b=sK/msRlut+uF8jdpolWbme+s2m
        2kHWwQDvUIBpn4Rh2QdP3MY3x4fNkUd8MguYM+jOPFFpSe5z/Pi0LVydiVOErMEgdMQkg6V94u2bG
        QeBS3R3JRLUS6Kh8f2GydD+QHGVH+vmAApgfhCcER/dIUa9/d2adAMcjOb8Aae25IHL8f+zmJTdvI
        F0V12l3wcm2hgvkGxniefU3gzS44J8IkExG2OV8zJ+UsH3worhoAosvNAsjSS6Gep84C0Q6nfMp6K
        geS3kCVOCG8tOjc2WrhUwN8bDqmUwhm0yb1Ly//8+KNHe+sO9lIGLKD54n1U+elR9L9jHtYy3nqCF
        CZ7uF8MQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4B-00Cdsh-TO
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 00/16] Build Improvements
Date:   Sun, 14 Nov 2021 14:00:42 +0000
Message-Id: <20211114140058.752394-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some tidying and autotools updates and fixes.

Changes since v2:

  * more detailed commit-messages for most patches;
  * a number of the patches have been broken up or restructured
    for easier review;
  * patch 14, which removes a number of `AC_SUBST` calls, is new.

Changes since v1:

  * ignore `.dirstamp` anywhere;
  * fix `--disable-static`;
  * drop `AC_PREREQ` bump.

Jeremy Sowden (16):
  gitignore: add Emacs artefacts
  gitignore: ignore .dirstamp
  build: remove unused Makefile fragment
  build: remove empty filter sub-directory
  build: move CPP `-D` flag.
  build: add Make_global.am for common flags
  build: use `dist_man_MANS` to declare man-pages
  build: skip sub-directories containing disabled plugins
  build: group `*_la_*` variables with their libraries
  build: delete commented-out code
  build: use correct automake variable for library dependencies
  build: update obsolete autoconf macros
  build: remove commented-out code
  build: remove unnecessary `AC_SUBST` calls
  build: quote autoconf macro arguments
  build: use `AS_IF` consistently in configure.ac

 .gitignore                     |   5 +-
 Make_global.am                 |   2 +
 Makefile.am                    |  11 +-
 Rules.make.in                  |  43 ------
 acinclude.m4                   |  13 --
 configure.ac                   | 241 ++++++++++++++-------------------
 filter/Makefile.am             |   7 +-
 filter/packet2flow/Makefile.am |   0
 filter/raw2packet/Makefile.am  |   4 +-
 include/libipulog/Makefile.am  |   1 -
 include/ulogd/Makefile.am      |   1 -
 input/Makefile.am              |   9 +-
 input/flow/Makefile.am         |  14 +-
 input/packet/Makefile.am       |  23 ++--
 input/sum/Makefile.am          |   9 +-
 libipulog/Makefile.am          |   4 +-
 output/Makefile.am             |  35 ++++-
 output/dbi/Makefile.am         |   8 +-
 output/ipfix/Makefile.am       |   3 +-
 output/mysql/Makefile.am       |   7 +-
 output/pcap/Makefile.am        |   8 +-
 output/pgsql/Makefile.am       |   8 +-
 output/sqlite3/Makefile.am     |   7 +-
 src/Makefile.am                |   8 +-
 24 files changed, 194 insertions(+), 277 deletions(-)
 create mode 100644 Make_global.am
 delete mode 100644 Rules.make.in
 delete mode 100644 filter/packet2flow/Makefile.am

-- 
2.33.0

