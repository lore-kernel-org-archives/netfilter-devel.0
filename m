Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9D8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2194A60EE2
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhKNPzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhKNPzg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:55:36 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D714C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9aB8puznZ3LJBZsuLdU0WvnablMndMmyfAciCvi/OtU=; b=j5eGPV3Mt/oGU9ZaCPBsSSMepz
        LmH9PCxDooAZhU7i49Sjhmd94ZcXbtOf1lcCDljkVngrgi9WMuFG2dEL8AiS1gXgNwE0yP1Ohnj/y
        JQHv2FV96V841gjSzN077iH3SlTrOceq0pilNpulSZo41UTSvRjcSoQ51QMBEqnxNj63xT4cn5u69
        hi1k+FnDCdRbKoxYpwPc4NsmBbtTffRWnDZuf7HwgaItYc3324Q6GCbqq/dAeP3s0KhhjD5TJ0qgF
        K9sO89bXXQ4ZR8Uj7TWze5NXteVySUq9vI4/hNQBCQ3zBlegog64uOmQZOfVynf6Ot/k0MWcyJo9S
        h3ytiGhQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo8-00CfJ1-Ep
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 00/15] Build Improvements
Date:   Sun, 14 Nov 2021 15:52:16 +0000
Message-Id: <20211114155231.793594-1-jeremy@azazel.net>
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

Changes since v3:

  * drop patch removing `AC_SUBST` calls.

Changes since v2:

  * more detailed commit-messages for most patches;
  * a number of the patches have been broken up or restructured
    for easier review;
  * patch 14, which removes a number of `AC_SUBST` calls, is new.

Changes since v1:

  * ignore `.dirstamp` anywhere;
  * fix `--disable-static`;
  * drop `AC_PREREQ` bump.

Jeremy Sowden (15):
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
  build: quote autoconf macro arguments
  build: use `AS_IF` consistently in configure.ac

 .gitignore                     |   5 +-
 Make_global.am                 |   2 +
 Makefile.am                    |  11 +-
 Rules.make.in                  |  43 ------
 configure.ac                   | 237 ++++++++++++++-------------------
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
 23 files changed, 194 insertions(+), 260 deletions(-)
 create mode 100644 Make_global.am
 delete mode 100644 Rules.make.in
 delete mode 100644 filter/packet2flow/Makefile.am

-- 
2.33.0

