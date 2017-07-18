From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v3 0/3] Fix printing of range elements in named sets
Date: Tue, 18 Jul 2017 17:40:26 +0200
Message-ID: <20170718154029.23976-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34445 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbdGRPlB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the third attempt at fixing 'nft monitor' for range elements.
This time introduce a flag which allows to identify half-open ranges,
then reuse Arturo's patch since it works nicely after a few adjustments.
Finally resubmit my 'nft monitor' test framework without any changes to
it's first version.

Arturo Borrero Gonzalez (1):
  monitor: Fix printing of range elements in named sets

Phil Sutter (2):
  segtree: Introduce flag for half-open range elements
  tests: Add basic monitor testing framework

 include/expression.h                   |   1 +
 include/rule.h                         |   9 +++
 src/netlink.c                          | 121 ++++++++++++++++++++++++++++-----
 src/segtree.c                          |   5 ++
 tests/monitor/run-tests.sh             |  78 +++++++++++++++++++++
 tests/monitor/testcases/set-mixed.t    |  21 ++++++
 tests/monitor/testcases/set-multiple.t |  15 ++++
 tests/monitor/testcases/set-simple.t   |  49 +++++++++++++
 8 files changed, 282 insertions(+), 17 deletions(-)
 create mode 100755 tests/monitor/run-tests.sh
 create mode 100644 tests/monitor/testcases/set-mixed.t
 create mode 100644 tests/monitor/testcases/set-multiple.t
 create mode 100644 tests/monitor/testcases/set-simple.t

-- 
2.13.1

