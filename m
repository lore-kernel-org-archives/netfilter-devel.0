Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C248FC83F33
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 09:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237922AbjIDJG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 05:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjIDJG6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 05:06:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F96184
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:06:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qd5Xq-0000EQ-3i; Mon, 04 Sep 2023 11:06:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/5] tests: shell: add and use feature probing
Date:   Mon,  4 Sep 2023 11:06:29 +0200
Message-ID: <20230904090640.3015-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series allows to run run-tests.sh on the centos-stream-9 kernel,
which is based on 5.14.y, with all tests either passing or getting
skipped as the feature tested isn't available.

Before:
I: results: [OK] 366 [FAILED] 7 [TOTAL] 373

After:
I: results: [OK] 370 [FAILED] 0 [SKIPPED] 3 [TOTAL] 373

First patch adds feature probe skeleton, second patch adds feature
probe for netdev chains without a device.

Third patch alters a few test cases to no longer depend on 'inner header
offset base'.

Patch 4 adds and uses feature probe test for treating maps like sets
and last patch does the same for the inner header base offset.

Florian Westphal (5):
  tests: add feature probing
  tests: shell: let netdev_chain_0 test indicate SKIP if kernel requires
    netdev device
  tests: shell: typeof_integer/raw: prefer @nh for payload matching
  tests: shell: add and use feature probe for map query like a set
  tests: shell skip inner matching tests if unsupported

 tests/shell/features/chain_binding.nft        |  7 +++
 tests/shell/features/inner_matching.nft       |  7 +++
 tests/shell/features/map_lookup.nft           | 11 ++++
 .../features/netdev_chain_without_device.nft  |  7 +++
 tests/shell/run-tests.sh                      | 35 ++++++++++++-
 tests/shell/testcases/chains/netdev_chain_0   |  2 +
 .../testcases/maps/dumps/typeof_integer_0.nft |  4 +-
 .../testcases/maps/dumps/typeof_raw_0.nft     |  4 +-
 tests/shell/testcases/maps/typeof_integer_0   |  4 +-
 .../testcases/maps/typeof_maps_add_delete     | 35 ++++++++++---
 tests/shell/testcases/maps/typeof_raw_0       |  4 +-
 .../testcases/sets/dumps/typeof_raw_0.nft     |  4 +-
 tests/shell/testcases/sets/inner_0            |  2 +
 tests/shell/testcases/sets/typeof_raw_0       |  4 +-
 tests/shell/testcases/transactions/30s-stress | 52 ++++++++++++++++---
 15 files changed, 154 insertions(+), 28 deletions(-)
 create mode 100644 tests/shell/features/chain_binding.nft
 create mode 100644 tests/shell/features/inner_matching.nft
 create mode 100644 tests/shell/features/map_lookup.nft
 create mode 100644 tests/shell/features/netdev_chain_without_device.nft

-- 
2.41.0

