Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E614C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54F6E21019
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfE1VEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 17:04:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38502 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfE1VEJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 17:04:09 -0400
Received: from localhost ([::1]:51590 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVjGR-0002Lz-RB; Tue, 28 May 2019 23:04:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v4 0/7] Cache update fix && intra-transaction rule references
Date:   Tue, 28 May 2019 23:03:16 +0200
Message-Id: <20190528210323.14605-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series combines the two series submitted earlier since they became
closely related in this iteration.

Patch 1 fixes a basic problem with cache_flush() after Eric's
cache_needs_more() change.

Patches 2, 3, 5 and 6 are requirements for patches 4 and 7 which are the
interesting ones: Patch 4 restores needed cache entries from command
list after a cache update. Patch 7 enables referencing a rule added by
the same transaction from another new rule by further exploiting the
logic added by patch 4.

Changes since v2 of "Resolve cache update woes" and v1 of "Support
intra-transaction rule references":

- Adjust cache_release() just like cache_flush().
- Split preparation work into separate patches.
- Adjust cache_add_commands() for later reuse by rule reference code,
  also add error handling in case kernel ruleset changes incompatibly.
- Finally drop that workaround in tests/json_echo.
- Introduce rule_cache_update() as requested.
- Avoid fetching a full cache if the new rule does not contain any
  reference.

Phil Sutter (7):
  src: Fix cache_flush() in cache_needs_more() logic
  libnftables: Keep list of commands in nft context
  src: Make {table,chain}_not_found() public
  src: Restore local entries after cache update
  rule: Introduce rule_lookup_by_index()
  src: Make cache_is_complete() public
  src: Support intra-transaction rule references

 include/nftables.h                            |   1 +
 include/rule.h                                |  12 ++
 src/evaluate.c                                | 107 +++++++-----
 src/libnftables.c                             |  21 ++-
 src/mnl.c                                     |   4 +
 src/rule.c                                    | 152 +++++++++++++++++-
 tests/json_echo/run-test.py                   |   6 +-
 .../shell/testcases/cache/0003_cache_update_0 |   7 +
 .../shell/testcases/nft-f/0006action_object_0 |   2 +-
 tests/shell/testcases/transactions/0024rule_0 |  17 ++
 .../transactions/dumps/0024rule_0.nft         |   8 +
 11 files changed, 280 insertions(+), 57 deletions(-)
 create mode 100755 tests/shell/testcases/transactions/0024rule_0
 create mode 100644 tests/shell/testcases/transactions/dumps/0024rule_0.nft

-- 
2.21.0

