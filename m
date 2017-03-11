From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/3] Follow-up to boolean type and existence checks
Date: Sat, 11 Mar 2017 14:31:38 +0100
Message-ID: <20170311133141.8748-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58463 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932711AbdCKNcB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2017 08:32:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series is a follow-up to the partially applied v1 which takes into
account the previously submitted changes to libnftnl debug output format
for fib and exthdr ops.

Phil Sutter (3):
  fib: Support existence check
  tests: Adjust for changed exthdr debug output
  doc: Document boolean type and applications

 doc/nft.xml                         | 134 ++++++++++++++++++++++++++++++++++++
 include/expression.h                |   2 +
 include/linux/netfilter/nf_tables.h |   1 +
 src/evaluate.c                      |  14 +++-
 src/expression.c                    |   4 ++
 src/fib.c                           |   5 +-
 tests/py/inet/fib.t                 |   3 +
 tests/py/inet/fib.t.payload         |  10 +++
 tests/py/inet/tcpopt.t.payload.inet |   4 +-
 tests/py/ip6/exthdr.t.payload.ip6   |  24 +++----
 10 files changed, 185 insertions(+), 16 deletions(-)

-- 
2.11.0

