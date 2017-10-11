From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 0/9] tests: Move tests from files to shell.
Date: Wed, 11 Oct 2017 10:03:56 +0530
Message-ID: <cover.1507696149.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37126 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdJKEei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 00:34:38 -0400
Received: by mail-pg0-f65.google.com with SMTP id o1so827823pga.4
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 21:34:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test files of tests/files/ are moved to tests/shell.

Varsha Rao (9):
  tests: files: Remove jump chain tests.
  tests: shell: Add test case for jump chain.
  tests: shell: Add test case for sets.
  tests: files: Remove tests for set.
  tests: shell: Add tests for variable definition.
  tests: files: Remove test cases for variable definition.
  tests: files: Remove tests for chain.
  tests: files: Remove tests for table.
  tests: files: Remove tests for verdict maps.

 tests/files/loop-detect.1                          |  8 -------
 tests/files/loop-detect.2                          |  7 ------
 tests/files/loop-detect.3                          |  7 ------
 tests/files/loop-detect.4                          |  7 ------
 tests/files/obj-chain                              | 22 -------------------
 tests/files/obj-table                              |  9 --------
 tests/files/set                                    | 14 ------------
 tests/files/symbolic-define.1                      |  7 ------
 tests/files/symbolic-define.2                      |  7 ------
 tests/files/symbolic-define.3                      |  6 ------
 tests/files/verdict-maps                           | 20 -----------------
 tests/shell/testcases/chains/0015check_jump_loop_1 | 11 ++++++++++
 tests/shell/testcases/nft-f/0013defines_1          | 25 ++++++++++++++++++++++
 tests/shell/testcases/nft-f/0014defines_1          | 25 ++++++++++++++++++++++
 tests/shell/testcases/nft-f/0015defines_1          | 24 +++++++++++++++++++++
 tests/shell/testcases/sets/0025anonymous_set_0     | 17 +++++++++++++++
 16 files changed, 102 insertions(+), 114 deletions(-)
 delete mode 100644 tests/files/loop-detect.1
 delete mode 100644 tests/files/loop-detect.2
 delete mode 100644 tests/files/loop-detect.3
 delete mode 100644 tests/files/loop-detect.4
 delete mode 100644 tests/files/obj-chain
 delete mode 100644 tests/files/obj-table
 delete mode 100644 tests/files/set
 delete mode 100644 tests/files/symbolic-define.1
 delete mode 100644 tests/files/symbolic-define.2
 delete mode 100644 tests/files/symbolic-define.3
 delete mode 100644 tests/files/verdict-maps
 create mode 100755 tests/shell/testcases/chains/0015check_jump_loop_1
 create mode 100755 tests/shell/testcases/nft-f/0013defines_1
 create mode 100755 tests/shell/testcases/nft-f/0014defines_1
 create mode 100755 tests/shell/testcases/nft-f/0015defines_1
 create mode 100755 tests/shell/testcases/sets/0025anonymous_set_0

-- 
2.13.6

