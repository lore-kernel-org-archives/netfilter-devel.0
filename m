Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2E2C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05EA206E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 17:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfFGRVl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 13:21:41 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35938 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbfFGRVl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 13:21:41 -0400
Received: from localhost ([::1]:49028 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hZIYe-0006ts-Ad; Fri, 07 Jun 2019 19:21:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH v6 0/5] Support intra-transaction rule references
Date:   Fri,  7 Jun 2019 19:21:16 +0200
Message-Id: <20190607172121.21752-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After Pablo's evaluation sequence rework, this series (formerly fixing
cache updates as well) has shrunken considerably:

Patch 1 contains a proper fix for that workaround in
evaluate_cache_add().

Patch 2 removes the cache-related workaround in tests/json_echo.

Patches 3 and 4 contain prerequisites for the last one, which actually
implements the support for referencing rules of the same transation with
'index' keyword.

Phil Sutter (5):
  cache: Fix evaluation for rules with index reference
  tests/json_echo: Drop needless workaround
  rule: Introduce rule_lookup_by_index()
  src: Make cache_is_complete() public
  src: Support intra-transaction rule references

 include/rule.h                                |  5 +
 src/cache.c                                   |  8 +-
 src/evaluate.c                                | 94 +++++++++++++++----
 src/mnl.c                                     |  4 +
 src/rule.c                                    | 13 ++-
 tests/json_echo/run-test.py                   |  6 +-
 .../shell/testcases/cache/0003_cache_update_0 |  7 ++
 tests/shell/testcases/transactions/0024rule_0 | 17 ++++
 tests/shell/testcases/transactions/0025rule_0 | 21 +++++
 .../transactions/dumps/0024rule_0.nft         |  8 ++
 .../transactions/dumps/0025rule_0.nft         |  6 ++
 11 files changed, 157 insertions(+), 32 deletions(-)
 create mode 100755 tests/shell/testcases/transactions/0024rule_0
 create mode 100755 tests/shell/testcases/transactions/0025rule_0
 create mode 100644 tests/shell/testcases/transactions/dumps/0024rule_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0025rule_0.nft

-- 
2.21.0

