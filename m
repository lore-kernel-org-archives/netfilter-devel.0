From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/2] monitor: Fix printing of range elements in named sets
Date: Mon, 17 Jul 2017 17:06:04 +0200
Message-ID: <20170717150606.32097-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34517 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQPGS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:06:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is supposed to be v2 of my patch series sent earlier, but it turned
into a complete rewrite of the whole SETELEM callback and so there is no
reuse of former changes.

The second patch adds a simple testbench for 'nft monitor' output which
helped me quite a lot to get things right.

Phil Sutter (2):
  monitor: Rewrite SETELEM callback
  tests: Add basic monitor testing framework

 src/netlink.c                          | 272 ++++++++++++++++++++++++++-------
 tests/monitor/run-tests.sh             |  78 ++++++++++
 tests/monitor/testcases/set-mixed.t    |  21 +++
 tests/monitor/testcases/set-multiple.t |  15 ++
 tests/monitor/testcases/set-simple.t   |  49 ++++++
 5 files changed, 382 insertions(+), 53 deletions(-)
 create mode 100755 tests/monitor/run-tests.sh
 create mode 100644 tests/monitor/testcases/set-mixed.t
 create mode 100644 tests/monitor/testcases/set-multiple.t
 create mode 100644 tests/monitor/testcases/set-simple.t

-- 
2.13.1

