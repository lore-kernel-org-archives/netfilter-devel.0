From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/4] A bunch of fixes for echo output
Date: Tue, 15 Aug 2017 01:43:01 +0200
Message-ID: <20170814234305.2829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59957 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbdHNXnn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 19:43:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series addresses the shortcomings of my echo option implementation
pointed out by Pablo. In addition to that, I figured that test suites
for monitor and echo are pretty similar so I merged both into one.

Phil Sutter (4):
  mnl: Drop --echo support for non-batch calls
  netlink: Fix segfault when using --echo flag
  echo: Fix for added delays in rule updates
  tests: Merge monitor and echo test suites

 include/netlink.h                |   5 +-
 src/evaluate.c                   |   9 ----
 src/mnl.c                        |  23 +--------
 src/netlink.c                    |  26 +++++++---
 src/rule.c                       |  26 ++++++++--
 tests/echo/run-tests.sh          |  45 ----------------
 tests/echo/testcases/simple.t    |  12 -----
 tests/monitor/run-tests.sh       | 107 +++++++++++++++++++++++++++------------
 tests/monitor/testcases/simple.t |  20 ++++++++
 9 files changed, 138 insertions(+), 135 deletions(-)
 delete mode 100755 tests/echo/run-tests.sh
 delete mode 100644 tests/echo/testcases/simple.t
 create mode 100644 tests/monitor/testcases/simple.t

-- 
2.13.1

