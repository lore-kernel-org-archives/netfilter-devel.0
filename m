Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7E9C19F28
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 20:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiHCUNu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbiHCUNt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 16:13:49 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0104E86B
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AVTUQUvh7mSJcvKrOHCi3BonNvqPm0cXBXEvEVgdhe0=; b=VoZUm+VYeCXbZzbByH9HDCtt8q
        IvJw5R88SCiVtXvY6t4xGcHJJacvOIFrfKS3Xr1eBoTB3V6ub/527p4/X09PSpiao+wT3LXR+FkMh
        142Gtem4Mvzl1qF3SrcORldiN0TWr9pFf+ZYQJrApbW9Mck7SKGbmtiBXRN3BktxrGDadSCdYVyTv
        8p9Sb4bI9n/OL7APr06KJn+UAymHl1+S0XUdbBCW+E8M9FYaL2ZuQRJBV5d3I78zBf8xR9Vms/6Vh
        N3TQP8bqSOs09s7/gq10wbYTb2jmf7usrs8G+KoDEi+mv9p30RvzND8AZ9diqoxkMTF7VXnsRKpW/
        cjZtoeKQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJKkJ-001Fnp-L0; Wed, 03 Aug 2022 21:13:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl 0/6] Doxygen Build Improvements
Date:   Wed,  3 Aug 2022 21:12:41 +0100
Message-Id: <20220803201247.3057365-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These changes were prompted by Mark Mentovai's request to remove a hard-coded
`/bin/bash` path from the rule that creates the man-page sym-links.  Hitherto,
the doxygen Makefile has jumped through a number of hoops to make sure
everything works with `make distcheck` and parallel builds.  This patch-set
makes some doxygen config changes that obviate the need for them, fixes a bug in
`make clean`, updates .gitignore and moves the shell-script out of the Makefile
into a separate file for ease of maintenance.  In the process, the hard-coded
`/bin/bash` is removed.

One thing I have left is the setting of `-p` when running the shell-script.  The
comment reads "`bash -p` prevents import of functions from the environment".
Why is this a problem?

Jeremy Sowden (6):
  build: add `make dist` tar-balls to .gitignore
  doc: add .gitignore for Doxygen artefacts
  doc: change `INPUT` doxygen setting to `@top_srcdir@`
  doc: move doxygen config file into doxygen directory
  doc: move man-page sym-link shell-script into a separate file
  doc: fix doxygen `clean-local` rule

 .gitignore                               |  3 +-
 configure.ac                             | 15 ++++++-
 doxygen/.gitignore                       |  4 ++
 doxygen/Makefile.am                      | 53 +++---------------------
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  4 +-
 doxygen/finalize_manpages.sh             | 40 ++++++++++++++++++
 6 files changed, 67 insertions(+), 52 deletions(-)
 create mode 100644 doxygen/.gitignore
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (91%)
 create mode 100644 doxygen/finalize_manpages.sh

-- 
2.35.1
