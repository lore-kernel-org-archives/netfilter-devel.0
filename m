From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/3] monitor: Some fixes and improvements
Date: Tue, 25 Jul 2017 20:39:41 +0200
Message-ID: <20170725183944.9377-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60441 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdGYSkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 14:40:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v2 containing the patches not applied from v1. Apart from
rebasing upon current upstream master, I folded patch 4 into patch 1
since they really belong together: The code changes to make 'nft
monitor' print correct syntax (by including the mandatory semicolons)
harmed readability since it dropped whitespace from the output. Former
patch 4 resolved this, not only for the cases patch 1 broke, but also at
another spot (i.e. between 'type' attribute and the following ones).

Patch 2 of this series depends on patch 1 since the simplification
requires that 'nft monitor' output matches given input (apart from
whitespace change) which wasn't the case before patch 1.

Finally, patch 3 (along with patch 2) remains unchanged.

Phil Sutter (3):
  monitor: Fix printing of set declarations
  tests/monitor: Simplify testcases
  tests/monitor: Clear ruleset after testing

 src/rule.c                             |  8 ++++----
 tests/monitor/run-tests.sh             | 15 ++++++++++-----
 tests/monitor/testcases/set-maps.t     |  7 +++----
 tests/monitor/testcases/set-mixed.t    | 10 +++-------
 tests/monitor/testcases/set-multiple.t |  7 ++-----
 tests/monitor/testcases/set-simple.t   | 21 ++++++++-------------
 6 files changed, 30 insertions(+), 38 deletions(-)

-- 
2.13.1

