Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BB4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiFHQ2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245139AbiFHQ2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:28:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C951FD9D0
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tj3mSEa9TIccOplSQwHIjb333D/mEuFvSXuxHz0HtyQ=; b=hj8TyPxmMpZdURdwo/yLXs1w79
        zvdC/oXnDF8B6XMsrn52VZRo7aU5DLLWz86Nk1LXiPcG3w74VcsZSqvQMdviH9jZgVIX/dnT6yEf5
        hPrXA0jFHwhBfBhpgozb8ph+jDnkxJRMYOGGds2RUGkeZcwwlpx79ywv7pZ7g9r/Nw5d/a/1MQb1F
        2lEPnJDDIvIYf+cBIbzwB3BoRAbqpLXnWuXSujD5PI0akY+EILNJvgOcReqFmJpOrE4UydLWeyXmi
        ihhFMcFzb2j8CkX6lPxMfu9SdjGcvu4g7ejoCF6MhNyYIUP+CFKjh2wJugH0YtN4d9tru62qt1T6i
        O5g3IIRw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyXB-00085J-It
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/9] Improve testsuites' code coverage
Date:   Wed,  8 Jun 2022 18:27:03 +0200
Message-Id: <20220608162712.31202-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

First patch adds support to conveniently build with profiling support
for coverage analysis using 'gcov'.

Patches 2-5 Improve results by extending test cases.

Patch 6 is fallout, fixes a segfault when trying to use --init-table
in input to ebtables-restore.

The remaining patches improve string match printing and parsing and
enable previously commented out tests.

Phil Sutter (9):
  Makefile: Add --enable-profiling configure option
  tests: shell: Add some more rules to 0002-verbose-output_0
  tests: shell: Extend iptables-xml test a bit
  tests: shell: Extend zero counters test a bit further
  extensions: libebt_standard.t: Test logical-{in,out} as well
  ebtables-restore: Deny --init-table
  extensions: string: Do not print default --to value
  extensions: string: Review parse_string() function
  extensions: string: Fix and enable tests

 .gitignore                                    |  4 ++++
 configure.ac                                  | 10 +++++++++
 extensions/GNUmakefile.in                     |  2 +-
 extensions/libebt_standard.t                  |  5 +++++
 extensions/libxt_string.c                     | 17 +++++++--------
 extensions/libxt_string.t                     | 21 +++++++------------
 iptables/Makefile.am                          |  1 +
 .../testcases/ip6tables/0002-verbose-output_0 | 15 +++++++++++++
 .../testcases/ipt-save/0006iptables-xml_0     | 10 +--------
 .../testcases/iptables/0007-zero-counters_0   | 15 +++++++++++++
 iptables/xtables-eb.c                         |  3 +++
 libipq/Makefile.am                            |  1 +
 libiptc/Makefile.am                           |  1 +
 libxtables/Makefile.am                        |  1 +
 utils/Makefile.am                             |  1 +
 15 files changed, 74 insertions(+), 33 deletions(-)

-- 
2.34.1

