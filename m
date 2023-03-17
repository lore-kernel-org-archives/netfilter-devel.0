Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534A5C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 09:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCQJ6m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCQJ6k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 05:58:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E4ECA34
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 02:58:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/9] mark statement support for non-constant expression
Date:   Fri, 17 Mar 2023 10:58:24 +0100
Message-Id: <20230317095833.1225401-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This patchset recovers the initial effort from Jeremy Sowden to enhance
mark statement support for variable expression, eg. use an existing
selector to set the meta and ct mark.

This also includes support for bitwise arithmetics, including shift
operations.

Selectors in network byte order are turned into host byte order before
the assignment to ensure ruleset portability.

No kernel updates are required in this batch.

Patches 1 to 5 are preparation work for patch 5, which finally adds support
for mark statements compatibility with selectors using integer basetype:

Patch #1 provides a fix for missing byteorder conversion in network byteorder
         field between 9 and 15 bytes such as ip6 dscp.

Patch #2 prepares for listing bitwise expression in hexadecimal, instead of
         using symbolic values specific of the datatype of the expression.

Patch #3 upgrade length of shift to the mark statement size, to allow for
	 larger shift than the expression length.

Patch #4 remove redundant evaluation of unary expression arguments.

Patch #5 use length of mark statements for the bitwise expression, instead of
	 the length of the r-value expression.

Finally patch #6 allows for datatype compatibility between mark statements
and rvalue expression of integer datatype. This includes byteorder
compatibility conversion.

Patch 7 to 9 add more tests.

Jeremy Sowden (6):
  evaluate: insert byte-order conversions for expressions between 9 and 15 bits
  netlink_delinearize: correct type and byte-order of shifts
  evaluate: support shifts larger than the width of the left operand
  evaluate: don't eval unary arguments
  tests: shell: rename and move bitwise test-cases
  tests: shell: add test-cases for ct and packet mark payload expressions

Pablo Neira Ayuso (3):
  evaluate: get length from statement instead of lhs expression
  evaluate: relax type-checking for integer arguments in mark statements
  tests: py: add test-cases for ct and packet mark payload expressions

 src/evaluate.c                                | 46 +++++++----
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
 33 files changed, 474 insertions(+), 25 deletions(-)
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
2.40.0

