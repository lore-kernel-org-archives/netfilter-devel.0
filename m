From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v4 0/3] Implement --echo option
Date: Wed,  9 Aug 2017 13:16:40 +0200
Message-ID: <20170809111643.18906-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32887 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbdHILRI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 07:17:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Long description of what it is and how it works in patch 3. Patch 1 is a
dependency to patch 2, Patch 3 adds a simple test suite which was
helpful during development.

Patch 1 from v3 has been applied already, so it is no longer present
here. Changelog for remaining patches is contained in them.

Phil Sutter (3):
  netlink: Pass nlmsg flags from rule.c
  Implement --echo option
  tests: Add a simple test suite for --echo option

 doc/nft.xml                   | 10 ++++++
 include/netlink.h             | 12 ++++---
 include/nftables.h            |  1 +
 src/evaluate.c                |  7 ++++
 src/main.c                    | 11 +++++-
 src/mnl.c                     | 25 +++++++++++--
 src/netlink.c                 | 84 ++++++++++++++++++++++++-------------------
 src/rule.c                    | 35 ++++++++++--------
 tests/echo/run-tests.sh       | 45 +++++++++++++++++++++++
 tests/echo/testcases/simple.t | 12 +++++++
 10 files changed, 183 insertions(+), 59 deletions(-)
 create mode 100755 tests/echo/run-tests.sh
 create mode 100644 tests/echo/testcases/simple.t

-- 
2.13.1

