From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v4 0/3] Fix printing of range elements in named sets
Date: Wed, 19 Jul 2017 15:05:26 +0200
Message-ID: <20170719130529.25398-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46061 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbdGSNFs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 09:05:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v4 of 'nft monitor' fixes for range elements. Apart from
changing the new flag's location in struct expr as requested, this
series now also covers mappings.

Arturo Borrero Gonzalez (1):
  monitor: Fix printing of range elements in named sets

Phil Sutter (2):
  segtree: Introduce flag for half-open range elements
  tests: Add basic monitor testing framework

 include/expression.h                   |   1 +
 include/rule.h                         |  18 +++++
 src/netlink.c                          | 123 +++++++++++++++++++++++++++------
 src/segtree.c                          |   5 ++
 tests/monitor/run-tests.sh             |  78 +++++++++++++++++++++
 tests/monitor/testcases/set-maps.t     |  11 +++
 tests/monitor/testcases/set-mixed.t    |  19 +++++
 tests/monitor/testcases/set-multiple.t |  13 ++++
 tests/monitor/testcases/set-simple.t   |  47 +++++++++++++
 9 files changed, 294 insertions(+), 21 deletions(-)
 create mode 100755 tests/monitor/run-tests.sh
 create mode 100644 tests/monitor/testcases/set-maps.t
 create mode 100644 tests/monitor/testcases/set-mixed.t
 create mode 100644 tests/monitor/testcases/set-multiple.t
 create mode 100644 tests/monitor/testcases/set-simple.t

-- 
2.13.1

