Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC1AC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 373EE20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgAJLLa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:11:30 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34992 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgAJLL3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:11:29 -0500
Received: from localhost ([::1]:48082 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ipsCO-0002l0-PL; Fri, 10 Jan 2020 12:11:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/3] Fixes for monitor/echo mode with maps
Date:   Fri, 10 Jan 2020 12:11:11 +0100
Message-Id: <20200110111114.23952-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 fixes a segfault when trying to add a rule referring to a map
and adds a relevant test case. Patch 2 fixes for wrong format of map
values, this is already covered by existing tests. Patch 3 merely
improves versatility of tests/monitor/run-tests.sh a bit.

Phil Sutter (3):
  monitor: Do not decompose non-anonymous sets
  monitor: Fix for use after free when printing map elements
  tests: monitor: Support running individual test cases

 src/monitor.c                          |  5 +++--
 tests/monitor/run-tests.sh             |  9 +++++++--
 tests/monitor/testcases/set-interval.t | 20 ++++++++++++++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)
 create mode 100644 tests/monitor/testcases/set-interval.t

-- 
2.24.1

