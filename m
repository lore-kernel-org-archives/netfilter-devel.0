Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4B6C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC9A610E9
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhKFQUy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhKFQUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:53 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7A7C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3lpzVWqTCvH+LZb8sNEKpBkgget8DHnN2giBwN3JnJI=; b=MHrFVuILE+Wdh8OKDlxsF8FAU6
        44VbnWk7hNa2zcHVWL9iYpCymJWpQvWZ2EkkMLD+99H0yZxOvvsY5TxJ5fS9WEaDZ9pYpMoxqjR+B
        1PAZz8qvBy1BUrM8iiQ2+bhj+k2JpGRqPQdpbxXoqRHTrLbT7i+A4El+ehpiAOMCda1uxdRGdlUbp
        Hk9u4n9dfmkWJnNZCt/b0mjreqZ5+JY2e0GhN/nQmjWBypKQQ1jVSOwHvrIWJmZvE8nFLR3FpPxBE
        B5zZuDRaKdxi31/e8L1JFbZeI3+5x8Crpoi+UPBSRnI4t8gG473+nvqYJu0Df+5PAjA01ZsJayyia
        N43OF5+Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOQ-004loO-9n
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 00/13] Build Improvements
Date:   Sat,  6 Nov 2021 16:17:47 +0000
Message-Id: <20211106161759.128364-1-jeremy@azazel.net>
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

Changes since v1:

  * ignore `.dirstamp` anywhere;
  * fix `--disable-static`;
  * drop `AC_PREREQ` bump.

Jeremy Sowden (12):
  gitignore: add Emacs artefacts
  gitignore: ignore .dirstamp
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

 .gitignore                     |   5 +-
 Make_global.am                 |   2 +
 Makefile.am                    |  11 +-
 Rules.make.in                  |  43 -------
 configure.ac                   | 226 ++++++++++++++-------------------
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
 23 files changed, 189 insertions(+), 260 deletions(-)
 create mode 100644 Make_global.am
 delete mode 100644 Rules.make.in
 delete mode 100644 filter/packet2flow/Makefile.am

-- 
2.33.0

