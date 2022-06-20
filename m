Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6310C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jun 2022 08:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbiFTIc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 04:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbiFTIcZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 04:32:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E30C12776
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2022 01:32:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 00/18] fixes and improvements for -o/--optimize
Date:   Mon, 20 Jun 2022 10:31:57 +0200
Message-Id: <20220620083215.1021238-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The following patchset contains a batch with fix/improvements for
-o/--optimize.

1) Fix statement comparison, leading to incorrect rule matching to be merged.

2) Do not merge rules using set reference.

3) Do not print stateful information, eg. counter packets 0 bytes 0

4) Drop comments when merging.

5) Fix reject statement comparison.

6) Do not fully compare verdict statement, otherwise statement vs rule matrix
   gets multiple occurrences of this statement.

7) Add missing expressions used in relationals: osf, xfrm, fib, numgen, hash.

8) Add binary expression support.

9) Add unsupported statement, to avoid merging rules with statements that are
   not yet supported.

10) Only merge relationals with OP_IMPLICIT and OP_EQ.

11) Assume verdict is the same when rule specifies no verdict.

12) Remove support for limit statement, not actually supported yet. Merging
    rules with the limit statement require a new class of transformation not
    yet supported.

13) Release top level scope to avoid a bogus variable redefinition error
    when using -c and -o.

And many new tests.

This infrastructure is new code, please help testing and reporting bugs
running it on your existing rulesets.

Thanks.

Pablo Neira Ayuso (18):
  optimize: do not compare relational expression rhs when collecting statements
  optimize: do not merge rules with set reference in rhs
  optimize: do not print stateful information
  optimize: remove comment after merging
  optimize: fix reject statement
  optimize: fix verdict map merging
  optimize: add osf expression support
  optimize: add xfrm expression support
  optimize: add fib expression support
  optimize: add binop expression support
  optimize: add numgen expression support
  optimize: add hash expression support
  optimize: add unsupported statement
  tests: shell: run -c -o on ruleset
  optimize: only merge OP_IMPLICIT and OP_EQ relational
  optimize: assume verdict is same when rules have no verdict
  optimize: limit statement is not supported yet
  libnftables: release top level scope

 src/libnftables.c                             |   2 +
 src/optimize.c                                | 205 ++++++++++++++----
 .../optimizations/dumps/merge_reject.nft      |  13 ++
 .../optimizations/dumps/skip_merge.nft        |  23 ++
 .../optimizations/dumps/skip_non_eq.nft       |   6 +
 .../optimizations/dumps/skip_unsupported.nft  |   7 +
 .../testcases/optimizations/merge_reject      |  26 +++
 .../shell/testcases/optimizations/merge_stmts |   6 +-
 tests/shell/testcases/optimizations/ruleset   | 168 ++++++++++++++
 .../shell/testcases/optimizations/skip_merge  |  34 +++
 .../shell/testcases/optimizations/skip_non_eq |  12 +
 .../testcases/optimizations/skip_unsupported  |  14 ++
 tests/shell/testcases/optimizations/variables |  15 ++
 13 files changed, 488 insertions(+), 43 deletions(-)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_reject.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/skip_merge.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/skip_non_eq.nft
 create mode 100644 tests/shell/testcases/optimizations/dumps/skip_unsupported.nft
 create mode 100755 tests/shell/testcases/optimizations/merge_reject
 create mode 100755 tests/shell/testcases/optimizations/ruleset
 create mode 100755 tests/shell/testcases/optimizations/skip_merge
 create mode 100755 tests/shell/testcases/optimizations/skip_non_eq
 create mode 100755 tests/shell/testcases/optimizations/skip_unsupported
 create mode 100755 tests/shell/testcases/optimizations/variables

-- 
2.30.2

