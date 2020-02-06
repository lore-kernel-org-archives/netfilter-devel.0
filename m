Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC90C35247
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 00:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3ACB20658
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 00:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgBFA6x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 19:58:53 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:47686 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBFA6x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 19:58:53 -0500
Received: from localhost ([::1]:60776 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1izVVL-0000l3-8V; Thu, 06 Feb 2020 01:58:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/4] Extend testsuites to run against installed binaries
Date:   Thu,  6 Feb 2020 01:58:47 +0100
Message-Id: <20200206005851.28962-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Help with CI integration by allowing to run the testsuite on installed
binaries instead of the local ones in the built source tree.

This series contains an unrelated Python3 fix for json_echo test tool in
patch 1, the remaining three extend json_echo, monitor and py testsuites
as described. Of the remaining testsuites, shell already accepts NFT env
variable and build is bound to source tree anyway.

Phil Sutter (4):
  tests: json_echo: Fix for Python3
  tests: json_echo: Support testing host binaries
  tests: monitor: Support testing host's nft binary
  tests: py: Support testing host binaries

 tests/json_echo/run-test.py | 25 ++++++++++++++++++++-----
 tests/monitor/run-tests.sh  |  4 ++++
 tests/py/nft-test.py        | 22 ++++++++++++++++++----
 3 files changed, 42 insertions(+), 9 deletions(-)

-- 
2.24.1

