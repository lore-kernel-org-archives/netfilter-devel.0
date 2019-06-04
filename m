Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D58C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73D242067C
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFDRci (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:38 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56488 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfFDRci (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:38 -0400
Received: from localhost ([::1]:41344 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDIb-0000n4-09; Tue, 04 Jun 2019 19:32:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 00/10] Cache update fix && intra-transaction rule references
Date:   Tue,  4 Jun 2019 19:31:48 +0200
Message-Id: <20190604173158.1184-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Next round of combined cache update fix and intra-transaction rule
reference support.

Patch 2 is new, it avoids accidential cache updates when committing a
transaction containing flush ruleset command and kernel ruleset has
changed meanwhile.

Patch 3 is also new: If a transaction fails in kernel, local cache is
incorrect - drop it.

Patch 9 is a new requirement for patch 10 due to relocation of new
functions.

Patch 10 was changed, changelog included.

Phil Sutter (10):
  src: Fix cache_flush() in cache_needs_more() logic
  src: Utilize CMD_FLUSH for cache->cmd
  libnftables: Drop cache in error case
  libnftables: Keep list of commands in nft context
  src: Make {table,chain}_not_found() public
  src: Restore local entries after cache update
  rule: Introduce rule_lookup_by_index()
  src: Make cache_is_complete() public
  include: Collect __stmt_binary_error() wrapper macros
  src: Support intra-transaction rule references

 include/erec.h                                |   6 +
 include/nftables.h                            |   1 +
 include/rule.h                                |  10 +
 src/evaluate.c                                |  71 ++----
 src/libnftables.c                             |  25 ++-
 src/mnl.c                                     |   4 +
 src/rule.c                                    | 202 +++++++++++++++++-
 tests/json_echo/run-test.py                   |   6 +-
 .../shell/testcases/cache/0003_cache_update_0 |   7 +
 tests/shell/testcases/transactions/0024rule_0 |  17 ++
 tests/shell/testcases/transactions/0025rule_0 |  21 ++
 .../transactions/dumps/0024rule_0.nft         |   8 +
 .../transactions/dumps/0025rule_0.nft         |   6 +
 13 files changed, 314 insertions(+), 70 deletions(-)
 create mode 100755 tests/shell/testcases/transactions/0024rule_0
 create mode 100755 tests/shell/testcases/transactions/0025rule_0
 create mode 100644 tests/shell/testcases/transactions/dumps/0024rule_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0025rule_0.nft

-- 
2.21.0

