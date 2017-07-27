From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC 0/4] Implement --echo option
Date: Thu, 27 Jul 2017 16:26:18 +0200
Message-ID: <20170727142622.12029-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54597 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751748AbdG0O0x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 10:26:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Long description of what it is and how it works in patch 3. Patches 1
and 2 are dependencies to patch 3.

The whole thing is RFC, mainly because of NFT_MSG_META_ECHO which
doesn't quite belong to where it is but I didn't find a better way to
reuse monitor callbacks for the job at hand.

Feedback highly appreciated, of course!

Phil Sutter (4):
  mnl: Consolidate mnl_batch_talk() parameters
  netlink: Pass nlmsg flags from rule.c
  Implement --echo option
  tests: Add a simple test suite for --echo option

 doc/nft.xml                         |  51 ++++++++++++++
 include/linux/netfilter/nf_tables.h |   1 +
 include/mnl.h                       |   4 +-
 include/netlink.h                   |  12 ++--
 include/nftables.h                  |   2 +
 src/main.c                          |  11 ++-
 src/mnl.c                           |  31 +++++++--
 src/netlink.c                       | 134 +++++++++++++++++++++++++-----------
 src/rule.c                          |  33 +++++----
 tests/echo/run-tests.sh             |  53 ++++++++++++++
 tests/echo/testcases/simple.t       |   8 +++
 11 files changed, 274 insertions(+), 66 deletions(-)
 create mode 100755 tests/echo/run-tests.sh
 create mode 100644 tests/echo/testcases/simple.t

-- 
2.13.1

