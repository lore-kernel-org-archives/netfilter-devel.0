Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410A5C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD0620645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfDWNWQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:16 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57306 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:16 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNF-0000p4-S6; Tue, 23 Apr 2019 15:22:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-nft 0/6] handle parallel restore case
Date:   Tue, 23 Apr 2019 15:16:19 +0200
Message-Id: <20190423131625.23377-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series handles the case of parallel iptables-nft-restore
invocations.

As xtables-nft ignores -w option (userspace-based serialization
lock), several nft instances can race.

In worse case, we can restore a ruleset twice, i.e. we get
duplicated rules:

1. "iptables-nft-restore < foo" is called for first time.
   No tables exist, so we create a transaction that creates
   the table/chains/rules.
2. "iptables-nft-restore < foo" is called in parallel.
   If the timing is right, it will also find no existing table,
   and will create a 2nd batch that adds rules.

   If the 2nd version doesn't run in parallel, it will detect
   that the table exists and will add a flush operation to the
   batch.

The first patches are preparation work, the fix is coming in patch 5,
it uses the generation counter to detect when the transaction batch
was based off an old state.

In case kernel indicates the generation id doesn't match anymore,
we fetch the current state and will refresh the pending transaction
before re-try.

The refresh currently includes adding/removing flush and chain add
operations.

Last patch adds a test script for this.

Florian Westphal (6):
      xtables: unify user chain add/flush for restore case
      xtables: add skip flag to objects
      xtables: add and use nft_build_cache
      xtables: add and set "implict" flag on transaction objects
      xtables: handle concurrent ruleset modifications
      tests: add test script for race-free restore

 nft-shared.h                                          |    7 
 nft.c                                                 |  325 +++++++++++++-----
 nft.h                                                 |    7 
 tests/shell/testcases/ipt-restore/0004-restore-race_0 |  119 ++++++
 xtables-restore.c                                     |   35 -
 xtables-translate.c                                   |    6 
 6 files changed, 379 insertions(+), 120 deletions(-)


