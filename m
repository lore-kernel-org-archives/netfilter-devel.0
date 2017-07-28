From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v3 0/4] Implement --echo option
Date: Fri, 28 Jul 2017 13:55:44 +0200
Message-ID: <20170728115548.5171-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54465 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751740AbdG1L4M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2017 07:56:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Long description of what it is and how it works in patch 3. Patches 1
and 2 are dependencies to patch 3.

I noticed that netlink_events_*_cb() functions accept 'type' parameter
as signed integer, which allows to pass a negative value to enable echo
printing mode without the risk of colliding with one of
nf_tables_msg_types values.

Another change since v2 is a minor fix of the added documentation in
nft.xml - I used <cmd> tag which is not known.

Phil Sutter (4):
  mnl: Consolidate mnl_batch_talk() parameters
  netlink: Pass nlmsg flags from rule.c
  Implement --echo option
  tests: Add a simple test suite for --echo option

 doc/nft.xml                   |  52 +++++++++++++++++
 include/mnl.h                 |   4 +-
 include/netlink.h             |  12 ++--
 include/nftables.h            |   1 +
 src/main.c                    |  11 +++-
 src/mnl.c                     |  31 ++++++++--
 src/netlink.c                 | 133 +++++++++++++++++++++++++++++-------------
 src/rule.c                    |  33 ++++++-----
 tests/echo/run-tests.sh       |  53 +++++++++++++++++
 tests/echo/testcases/simple.t |   8 +++
 10 files changed, 272 insertions(+), 66 deletions(-)
 create mode 100755 tests/echo/run-tests.sh
 create mode 100644 tests/echo/testcases/simple.t

-- 
2.13.1

