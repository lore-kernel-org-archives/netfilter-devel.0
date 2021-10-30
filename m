Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7022CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DD8960EB2
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhJ3QEU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70108C0613B9
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EAMvjVunuf4u4WOAan1mx3rFjB8CTpaysIfPd59wstA=; b=BjVJxupiWqbN6IX0jENCtLGcmv
        yQsYdImAwSUk5Ai4tl6sSy/0WM2kx9a6a3nlT7YbTHBvZfZrsaRHottvhwrB6C405mnbFPpGr9Y7G
        IX6zrFlC+N5AqFPFPNMO1yYBA1uHztIgKANcKmNUlkQKTKNeXg4VNLJFHpTFTnLhYv9Hzkw4K13hE
        P+KoR9esoU7yCvLr1YhF+9DgROfpvcYdz/CtCqXFUYqGxAFTk2UBflNngHPWfuVf+Brhh9y42nr3D
        M39Xkgy9Y6D+XZ4KpiLIS5WIDeTGsYPNYfp2r74IZ5uyBlJiDPrfPmI5qzljNdNQIKV+ekXr3RIxz
        7YszrkPA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqnf-00AFQk-DL
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 00/13] Build Improvements
Date:   Sat, 30 Oct 2021 17:01:28 +0100
Message-Id: <20211030160141.1132819-1-jeremy@azazel.net>
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

Jeremy Sowden (13):
  gitignore: Add Emacs artefacts
  gitignore: ignore util/.dirstamp
  build: remove unused Makefile fragment
  build: remove empty filter sub-directory
  build: move cpp flag to the only Makefile.am file where it's needed
  build: add Make_global.am for common flags and include it where
    necessary
  build: use `dist_man_MANS`
  build: only conditionally enter sub-directories containing optional
    code
  build: move library dependencies from LDFLAGS to LIBADD
  build: update obsolete autoconf macros
  build: quote and reformat some autoconf macro arguments
  build: reformat autoconf AC_ARG_WITH, AC_ARG_ENABLE and related macros
  build: bump autoconf version to 2.71

 .gitignore                     |   5 +-
 Make_global.am                 |   2 +
 Makefile.am                    |  11 +-
 Rules.make.in                  |  43 -------
 configure.ac                   | 228 ++++++++++++++-------------------
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
 output/Makefile.am             |  41 +++++-
 output/dbi/Makefile.am         |   8 +-
 output/ipfix/Makefile.am       |   3 +-
 output/mysql/Makefile.am       |   7 +-
 output/pcap/Makefile.am        |   8 +-
 output/pgsql/Makefile.am       |   8 +-
 output/sqlite3/Makefile.am     |   7 +-
 src/Makefile.am                |   8 +-
 23 files changed, 190 insertions(+), 261 deletions(-)
 create mode 100644 Make_global.am
 delete mode 100644 Rules.make.in
 delete mode 100644 filter/packet2flow/Makefile.am

-- 
2.33.0

