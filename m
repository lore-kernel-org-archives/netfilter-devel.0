Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BF8EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjFSUnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFSUnU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8DE91
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLiR-0003ql-HR; Mon, 19 Jun 2023 22:43:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/6] Misc parser fixes
Date:   Mon, 19 Jun 2023 22:43:00 +0200
Message-Id: <20230619204306.11785-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These patches fix various bugs in the parsing
and evaluation steps.

I added a new 'bogons' test dir to shell, this can be used
to collect invalid inputs that should be rejected instead
of nft exiting with an assertion failure.

Florian Westphal (6):
  json: dccp: remove erroneous const qualifier
  evaluate: do not abort when prefix map has non-map element
  parser: don't assert on scope underflows
  parser: reject zero-length interface names
  parser: reject zero-length interface names in flowtables
  ct timeout: fix 'list object x' vs. 'list objects in table' confusion

 include/rule.h                                |  1 +
 src/cache.c                                   |  1 +
 src/evaluate.c                                | 18 ++++--
 src/parser_bison.y                            | 61 ++++++++++++++-----
 src/parser_json.c                             |  2 +-
 src/rule.c                                    |  1 +
 tests/shell/testcases/bogons/assert_failures  | 12 ++++
 .../nat_prefix_map_with_set_element_assert    |  7 +++
 .../bogons/nft-f/scope_underflow_assert       |  6 ++
 .../nft-f/zero_length_devicename_assert       |  5 ++
 .../zero_length_devicename_flowtable_assert   |  5 ++
 11 files changed, 98 insertions(+), 21 deletions(-)
 create mode 100755 tests/shell/testcases/bogons/assert_failures
 create mode 100644 tests/shell/testcases/bogons/nft-f/nat_prefix_map_with_set_element_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/scope_underflow_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert

-- 
2.39.3

