Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BFBE7D0A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 17:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjIUR1z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjIUR1Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 13:27:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589033589
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:03:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qjFMl-0004LQ-Cv; Thu, 21 Sep 2023 10:48:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/3] nftables: add feature probes for sctp and multistmt set support
Date:   Thu, 21 Sep 2023 10:48:43 +0200
Message-ID: <20230921084849.634-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On some kernels tests can fail because a required feature is absent.
This can happen depending on kernel .config or because a required
feature was added in a later kernel release.

Patch 1 adds a missing check for catchall to the vmap timeout test so we
no longer try to add '*' keys.

Patch 2 adds a feature probe for multi-statement support in sets.
Add REQUIRES condition to all tests that do involve multistmt.
One of the test cases can be run partially, we only need to skip the
dump validation.

Patch 3 adds feature probing for sctp chunk matching in nft_exthdr
and the needed conditionals to the test.

Florian Westphal (3):
  tests: shell: skip adding catchall elements if unuspported
  tests: shell: add feature probe for sets with more than one element
  tests: shell: add feature probe for sctp chunk matching

 tests/shell/features/sctp_chunks.nft          |  7 +++++
 .../features/set_with_two_expressions.nft     |  9 +++++++
 tests/shell/testcases/maps/vmap_timeout       |  8 ++++--
 .../shell/testcases/nft-f/0025empty_dynset_0  |  8 ++++++
 .../testcases/sets/0059set_update_multistmt_0 |  2 ++
 .../shell/testcases/sets/0060set_multistmt_0  |  2 ++
 .../shell/testcases/sets/0060set_multistmt_1  |  2 ++
 tests/shell/testcases/sets/typeof_sets_0      | 26 ++++++++++++-------
 8 files changed, 52 insertions(+), 12 deletions(-)
 create mode 100644 tests/shell/features/sctp_chunks.nft
 create mode 100644 tests/shell/features/set_with_two_expressions.nft

-- 
2.41.0

