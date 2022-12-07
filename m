Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E80C47089
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLGRo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiLGRon (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:44:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A480E55CBD
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fnmmMMAGQBfToCmROJvQtKeDFE2p1Gl7QcCcOFdsOks=; b=KCkDSzdNJY6Y0tA0gdlitHKsFS
        yczNWi9dbQWiuBe9lU9pUkImWOJWW2gYdf5kKxjZHLg78ZuhIN3PeNOMObGTtLx6zUibG4wfC4dB8
        3n9s0NMTgSdMriI4Z8jRy0PFRrGlRQ+d+qN7ZoK8CeARaVqoI9MnsZo4cYJFqreCi0l5HE19Gm4w7
        g2MKoyWFoVAv0jnRgDyybPeNEo3Cht5nz9ld0GUZ1l9eLqoG9fmkSTCVhPwddG8Rh+Q2zv4mB3Sx/
        brL/6hUCaId0kinPxNi55QFD3M4mYxvd4GgMani0/2bjxLBlU1V/TWDv/Umi7tBfJk/KjyATVN7on
        5E2nK4cQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTH-0000fI-DD
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:44:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/11] Support 'make dist' and 'make check'
Date:   Wed,  7 Dec 2022 18:44:19 +0100
Message-Id: <20221207174430.4335-1-phil@nwl.cc>
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

Phil Sutter (11):
  Drop INCOMPATIBILITIES file
  Drop libiptc/linux_stddef.h
  Makefile: Generate ip6tables man pages on the fly
  extensions: Makefile: Merge initext targets
  iptables/Makefile: Reorg variable assignments
  iptables/Makefile: Split nft-variant man page list
  Makefile: Fix for 'make distcheck'
  Makefile: Generate .tar.bz2 archive with 'make dist'
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

