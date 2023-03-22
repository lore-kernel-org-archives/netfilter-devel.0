Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140D8C6FD1C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCVVxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjCVVxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 017872BEDD
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 0/8] mark statement support for non-constant expression
Date:   Wed, 22 Mar 2023 22:52:55 +0100
Message-Id: <20230322215303.239763-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is v2 of the following patchset:

https://marc.info/?l=netfilter-devel&m=167904710124404&w=2

this takes over the initial effort from Jeremy Sowden to enhance mark
statements support for variable expression.

No kernel updates are required in this batch.

Previous patch #1 in this series has been already applied upstream:

fe623a509492 ("evaluate: insert byte-order conversions for expressions between 9 and 15 bits")

Main change is patch #2 in this series:

("evaluate: support shifts larger than the width of the left operand")

which slightly simplifies the logic to set the maximum shift length
according to the mark statement datatype length (which is 32-bits).

Anything else, no changes.

Jeremy Sowden (4):
  netlink_delinearize: correct type and byte-order of shifts
  evaluate: don't eval unary arguments
  tests: shell: rename and move bitwise test-cases
  tests: shell: add test-cases for ct and packet mark payload expressions

Pablo Neira Ayuso (4):
  evaluate: support shifts larger than the width of the left operand
  evaluate: get length from statement instead of lhs expression
  evaluate: relax type-checking for integer arguments in mark statements
  tests: py: add test-cases for ct and packet mark payload expressions

 src/evaluate.c                                | 48 ++++++++----
 src/netlink_delinearize.c                     | 17 +++-
 tests/py/ip/ct.t                              |  2 +
 tests/py/ip/ct.t.json                         | 58 ++++++++++++++
 tests/py/ip/ct.t.payload                      | 18 +++++
 tests/py/ip/meta.t                            |  5 ++
 tests/py/ip/meta.t.json                       | 78 +++++++++++++++++++
 tests/py/ip/meta.t.payload                    | 25 ++++++
 tests/py/ip6/ct.t                             |  6 ++
 tests/py/ip6/ct.t.payload                     | 19 +++++
 tests/py/ip6/meta.t                           |  3 +
 tests/py/ip6/meta.t.json                      | 58 ++++++++++++++
 tests/py/ip6/meta.t.payload                   | 20 +++++
 .../0040mark_binop_0}                         |  2 +-
 .../0040mark_binop_1}                         |  2 +-
 .../shell/testcases/bitwise/0040mark_binop_2  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_3  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_4  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_5  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_6  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_7  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_8  | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_9  | 11 +++
 .../dumps/0040mark_binop_0.nft}               |  2 +-
 .../dumps/0040mark_binop_1.nft}               |  2 +-
 .../bitwise/dumps/0040mark_binop_2.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_3.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_4.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_5.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_6.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_7.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_8.nft        |  6 ++
 .../bitwise/dumps/0040mark_binop_9.nft        |  6 ++
 33 files changed, 478 insertions(+), 23 deletions(-)
 create mode 100644 tests/py/ip6/ct.t
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

