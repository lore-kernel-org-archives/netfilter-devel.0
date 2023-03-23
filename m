Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDECC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjCWQ7I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjCWQ7H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BBCC2D62
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:05 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 00/12] mark statement support for non-constant expression
Date:   Thu, 23 Mar 2023 17:58:43 +0100
Message-Id: <20230323165855.559837-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is v3 of the following patchset:

https://marc.info/?l=netfilter-devel&m=167904710124404&w=2

this takes over the initial effort from Jeremy Sowden to enhance mark
statements support for variable expression.

This round emphasizes on the support for bitwise expression (not only shift).

No kernel updates are required in this batch.

Patch #1 no changes.

Patch #2 changes to sets ctx->stmt_len for meta and ct only, reset
	 ctx->stmt_len in expr_evaluate_map() to avoid interference
	 with map evaluation.

Patch #3 no changes.

Patch #4 no changes.

Patch #5 new in this series, missing type in shift evaluation.
	 This is required to evaluate constant shift, eg. 1 << 1
         which is reduced at evaluation step to 0x2.

Patch #6 disable lhs maximum length cap when ctx->stmt_len is available.
	 This allows for: meta mark set ip dscp | 0xff000000

Patch #7 honor ctx->stmt_len in bitwise evaluation, otherwise evaluation
         results in incorrect bytecode. This assumes host byteorder for
	 the statement, which is fine at this stage since only ct and
	 meta statement are supported.

Patch #8 adjust byteorder in delinearize path if bitwise length hints
	 that it refers to the statement length. This assumes host
	 byteorder, in this future, when this support is generalized this
	 requires to infer the byteorder from the statement that has been
	 used.

Patch #9-#12 tests already posted in the previous batch and new ones.

Jeremy Sowden (5):
  netlink_delinearize: correct type and byte-order of shifts
  evaluate: don't eval unary arguments
  tests: py: add test-cases for ct and packet mark payload expressions
  tests: shell: rename and move bitwise test-cases
  tests: shell: add test-cases for ct and packet mark payload expressions

Pablo Neira Ayuso (7):
  evaluate: support shifts larger than the width of the left operand
  evaluate: relax type-checking for integer arguments in mark statements
  evaluate: set up integer type to shift expression
  evaluate: honor statement length in integer evaluation
  evaluate: honor statement length in bitwise evaluation
  netlink_delinerize: incorrect byteorder in mark statement listing
  tests: py: extend test-cases for mark statements with bitwise expressions

 include/rule.h                                |   1 +
 src/evaluate.c                                | 119 +++++--
 src/netlink_delinearize.c                     |  35 ++-
 tests/py/ip/ct.t                              |   6 +
 tests/py/ip/ct.t.json                         | 154 +++++++++
 tests/py/ip/ct.t.payload                      |  50 +++
 tests/py/ip/meta.t                            |   5 +
 tests/py/ip/meta.t.json                       |  78 +++++
 tests/py/ip/meta.t.payload                    |  25 ++
 tests/py/ip6/ct.t                             |   9 +
 tests/py/ip6/ct.t.json                        | 293 ++++++++++++++++++
 tests/py/ip6/ct.t.payload                     |  46 +++
 tests/py/ip6/meta.t                           |   3 +
 tests/py/ip6/meta.t.json                      |  58 ++++
 tests/py/ip6/meta.t.payload                   |  20 ++
 .../0040mark_binop_0}                         |   2 +-
 .../0040mark_binop_1}                         |   2 +-
 .../shell/testcases/bitwise/0040mark_binop_2  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_3  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_4  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_5  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_6  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_7  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_8  |  11 +
 .../shell/testcases/bitwise/0040mark_binop_9  |  11 +
 .../dumps/0040mark_binop_0.nft}               |   2 +-
 .../dumps/0040mark_binop_1.nft}               |   2 +-
 .../bitwise/dumps/0040mark_binop_2.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_3.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_4.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_5.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_6.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_7.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_8.nft        |   6 +
 .../bitwise/dumps/0040mark_binop_9.nft        |   6 +
 35 files changed, 1004 insertions(+), 42 deletions(-)
 create mode 100644 tests/py/ip6/ct.t
 create mode 100644 tests/py/ip6/ct.t.json
 create mode 100644 tests/py/ip6/ct.t.payload
 rename tests/shell/testcases/{chains/0040mark_shift_0 => bitwise/0040mark_binop_0} (68%)
 rename tests/shell/testcases/{chains/0040mark_shift_1 => bitwise/0040mark_binop_1} (70%)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_2
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_3
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_4
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_5
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_6
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_7
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_8
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_9
 rename tests/shell/testcases/{chains/dumps/0040mark_shift_0.nft => bitwise/dumps/0040mark_binop_0.nft} (58%)
 rename tests/shell/testcases/{chains/dumps/0040mark_shift_1.nft => bitwise/dumps/0040mark_binop_1.nft} (64%)
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_2.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_3.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_4.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_5.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_6.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_7.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_8.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_9.nft

-- 
2.30.2

