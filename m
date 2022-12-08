Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E349BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiLHPrB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiLHPqy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:46:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8CC442E6
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2OLObfF9hDDSXOAuRRszauenCcpl5XhpuBludPBgUSQ=; b=hjqfdL3gEGHfhfwz2dXvjDsQrA
        A6qYRWYPI9Su+Ig2HIt9uiGCG/JCGf4wE0MtuS68OSYeyL/3RECM4+3KAbbmUlWgBJySh3cg1R+ll
        Uwm3kmTXmxQdfdijDdp7pOcmMKQuKLgql1jlMgB9GYjaCPm0BM2OxGJUDQfWMFPRGeQCk9L1fexvc
        O+McalVsyhzijES0jZ811YEt4mfAgEuIQmAMyuLO4ab4lmatA7rchwI05N1c7ZguKDjyLUGzhLCls
        CEg7gHlb1EaAdqJWJerSXpdOdrX9Z5yNyoIIWYtKJ0tMEMMKytWZPwN0kCY75ih3RgQ7lSwRP1hos
        4WGK/PCw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J6q-0005fT-Cg; Thu, 08 Dec 2022 16:46:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 00/11] Support 'make dist' and 'make check'
Date:   Thu,  8 Dec 2022 16:46:05 +0100
Message-Id: <20221208154616.14622-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The goal of this series is to replace the custom 'tarball' Makefile
target by automake's standard 'dist' target. Due to the special
non-automake extensions/GNUMakefile.in and some other minor details,
this hasn't been functional.

Patches 1-6 are preparation work and cleanup of left-overs noticed when
comparing final tarball contents.

Patches 7 and 8 then enable 'dist' and 'distcheck' targets.

Finally, patches 9 and 10 integrate testsuite scripts for use with 'make
check'. The 'distcheck' target triggers them, too. But since one doesn't
do that as uid 0, only xlate-test.py actually executes and the others
are skipped.

Changes since v1:
- Replace bashism in patch 3.
- Generate .tar.xz instead of .tar.bz2 in patch 8.

Phil Sutter (11):
  Drop INCOMPATIBILITIES file
  Drop libiptc/linux_stddef.h
  Makefile: Generate ip6tables man pages on the fly
  extensions: Makefile: Merge initext targets
  iptables/Makefile: Reorg variable assignments
  iptables/Makefile: Split nft-variant man page list
  Makefile: Fix for 'make distcheck'
  Makefile: Generate .tar.xz archive with 'make dist'
  include/Makefile: xtables-version.h is generated
  tests: Adjust testsuite return codes to automake guidelines
  Makefile.am: Integrate testsuites

 .gitignore                        |  12 +++
 INCOMPATIBILITIES                 |  14 ----
 Makefile.am                       |   8 +-
 extensions/GNUmakefile.in         | 121 +++++++-----------------------
 include/Makefile.am               |   8 +-
 iptables-test.py                  |   2 +-
 iptables/Makefile.am              |  84 +++++++++++----------
 iptables/ip6tables-apply.8        |   1 -
 iptables/ip6tables-restore.8      |   1 -
 iptables/ip6tables-save.8         |   1 -
 iptables/ip6tables.8              |   1 -
 iptables/tests/shell/run-tests.sh |   4 +-
 libipq/Makefile.am                |   2 +-
 libiptc/Makefile.am               |   2 +
 libiptc/linux_stddef.h            |  39 ----------
 utils/Makefile.am                 |   4 +-
 xlate-test.py                     |   2 +-
 17 files changed, 107 insertions(+), 199 deletions(-)
 delete mode 100644 INCOMPATIBILITIES
 delete mode 100644 iptables/ip6tables-apply.8
 delete mode 100644 iptables/ip6tables-restore.8
 delete mode 100644 iptables/ip6tables-save.8
 delete mode 100644 iptables/ip6tables.8
 delete mode 100644 libiptc/linux_stddef.h

-- 
2.38.0

