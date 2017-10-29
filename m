From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 00/16] tests: files: Remove test files.
Date: Mon, 30 Oct 2017 02:09:24 +0530
Message-ID: <cover.1509305217.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45267 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbdJ2UkL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:40:11 -0400
Received: by mail-pg0-f66.google.com with SMTP id b192so9679313pga.2
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:40:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes tests from tests/files and add tests to 
tests/shell which are not present in it.

Varsha Rao (16):
  tests: files: Remove tests for ipv4
  tests: files: Remove tests for ipv6
  tests: shell: Add test for log statement.
  tests: files: Remove log statement tests.
  tests: shell: Add test for log flags.
  tests: shell: Add tests for payload expression.
  tests: files: Remove payload expression tests.
  tests: files: Remove test for syntactical errors.
  tests: shell: Add test for ct expression.
  tests: files: Remove test for ct expression.
  tests: files: Remove prefix file.
  tests: files: Test for meta expressions.
  tests: files: Remove test for meta expression.
  tests: shell: Add tests for concat expression.
  tests: files: Remove tests for concat expression.
  tests: shell: Add test case for map expression.

 tests/files/error.1                              |  9 -----
 tests/files/error.2                              | 18 ----------
 tests/files/expr-concat                          | 19 ----------
 tests/files/expr-ct                              | 26 --------------
 tests/files/expr-meta                            | 40 ---------------------
 tests/files/family-ipv4                          | 14 --------
 tests/files/family-ipv6                          | 13 -------
 tests/files/feat-adjancent-load-merging          | 13 -------
 tests/files/prefix                               |  5 ---
 tests/files/stmt-log                             |  6 ----
 tests/shell/testcases/maps/different_map_types_1 | 10 ++++++
 tests/shell/testcases/optionals/log_0            | 22 ++++++++++++
 tests/shell/testcases/optionals/log_flags_0      | 29 ++++++++++++++++
 tests/shell/testcases/transactions/0024rule_0    | 44 ++++++++++++++++++++++++
 tests/shell/testcases/transactions/0025rule_0    | 36 +++++++++++++++++++
 tests/shell/testcases/transactions/0026rule_0    | 44 ++++++++++++++++++++++++
 tests/shell/testcases/transactions/0050concat_1  | 26 ++++++++++++++
 17 files changed, 211 insertions(+), 163 deletions(-)
 delete mode 100644 tests/files/error.1
 delete mode 100644 tests/files/error.2
 delete mode 100644 tests/files/expr-concat
 delete mode 100644 tests/files/expr-ct
 delete mode 100644 tests/files/expr-meta
 delete mode 100644 tests/files/family-ipv4
 delete mode 100644 tests/files/family-ipv6
 delete mode 100644 tests/files/feat-adjancent-load-merging
 delete mode 100644 tests/files/prefix
 delete mode 100644 tests/files/stmt-log
 create mode 100755 tests/shell/testcases/maps/different_map_types_1
 create mode 100755 tests/shell/testcases/optionals/log_0
 create mode 100755 tests/shell/testcases/optionals/log_flags_0
 create mode 100755 tests/shell/testcases/transactions/0024rule_0
 create mode 100755 tests/shell/testcases/transactions/0025rule_0
 create mode 100755 tests/shell/testcases/transactions/0026rule_0
 create mode 100755 tests/shell/testcases/transactions/0050concat_1

-- 
2.13.6

