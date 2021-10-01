Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8219BC4167B
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABF661A8E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhJARr1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355185AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7037C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XbHq6uzUlkN4+mYpgldC5XOh8dhzy+SyuzZUvRoeITw=; b=PetK10tY/5VBM/NlwDxLOT9t0l
        ldgdSEglpCFp+BifkD7b0jjRV3z/Y7Edt60xlEqCy/miN9aOBGXRRR5JTYqIBPar1hjCNglGzVx7r
        NEcivK7M2b/ksU49rxWwCUDSOw4T8SEuMbWZCaTly9XvwmUKQmz/E2AF5H5KKljWm3vw898mKLKZ1
        lKFUtCh1CQi73imdH9qU/G6UwN1SPiui/cpCLBVPqv6wCzFFUO9EvgPyAmj38JPhVgX64Ds4TmqRs
        ny8Mr6wcHyobvtXWSm2WI2blR7o4+QmxiQIwxcdu9aFh1qyvgJFgGdQT8lXgMYnUNohbSIljZOUCE
        mjZaS6Pg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbF-002RLP-Cv; Fri, 01 Oct 2021 18:45:33 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft back-end for iptables-nft
Date:   Fri,  1 Oct 2021 18:41:34 +0100
Message-Id: <20211001174142.1267726-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables supports 128-character prefixes for nflog whereas legacy
iptables only supports 64 characters.  This patch series converts
iptables-nft to use the nft back-end in order to take advantage of the
longer prefixes.

  * Patches 1-5 implement the conversion and update some related Python
    unit-tests.
  * Patch 6 fixes an minor bug in the output of nflog prefixes.
  * Patch 7 contains a couple of libtool updates.
  * Patch 8 fixes some typo's.

Changes since v1:

  * Patches 1 and 5-8 are new.
  * White-space fixes in patches 2 and 3.
  * Fixes for typo's in commit-messages of patches 2 and 4.
  * Removal of stray `struct xt_nflog_info` allocation from
    `nft_parse_log` in patch 3.
  * Leave commented-out `--nflog-range` test-cases in libxt_NFLOG.t
    with an explanatory comment in patch 4.

Jeremy Sowden (5):
  nft: fix indentation error.
  extensions: libxt_NFLOG: fix `--nflog-prefix` Python test-cases
  extensions: libxt_NFLOG: remove extra space when saving targets with
    prefixes
  build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with
    `LT_INIT`
  tests: iptables-test: correct misspelt variable

Kyle Bowman (3):
  extensions: libxt_NFLOG: use nft built-in logging instead of xt_NFLOG
  extensions: libxt_NFLOG: don't truncate log prefix on print/save
  extensions: libxt_NFLOG: disable `--nflog-range` Python test-cases

 configure.ac             |  3 +-
 extensions/libxt_NFLOG.c |  8 ++++-
 extensions/libxt_NFLOG.t | 16 ++++-----
 iptables-test.py         | 18 +++++-----
 iptables/nft-shared.c    | 52 ++++++++++++++++++++++++++++
 iptables/nft.c           | 74 ++++++++++++++++++++++++++++------------
 iptables/nft.h           |  1 +
 7 files changed, 131 insertions(+), 41 deletions(-)

-- 
2.33.0

