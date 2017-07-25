From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/6] monitor: Some fixes and improvements
Date: Tue, 25 Jul 2017 16:56:23 +0200
Message-ID: <20170725145629.20974-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40067 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbdGYO5O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 10:57:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series happened while fixing monitor tests and contains
some changes to monitor code along the way.

Phil Sutter (6):
  tests/monitor: Ignore newgen messages in output
  monitor: Fix printing of set declarations
  tests/monitor: Simplify testcases
  monitor: Print space after semicolon
  tests/monitor: Clear ruleset after testing
  tests/monitor: Add a small README

 src/rule.c                             |  8 +++---
 tests/monitor/README                   | 48 ++++++++++++++++++++++++++++++++++
 tests/monitor/run-tests.sh             | 16 +++++++++---
 tests/monitor/testcases/set-maps.t     |  7 +++--
 tests/monitor/testcases/set-mixed.t    | 10 +++----
 tests/monitor/testcases/set-multiple.t |  7 ++---
 tests/monitor/testcases/set-simple.t   | 21 ++++++---------
 7 files changed, 80 insertions(+), 37 deletions(-)
 create mode 100644 tests/monitor/README

-- 
2.13.1

