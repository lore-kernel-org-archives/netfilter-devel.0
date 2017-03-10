From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/5] Introduce boolean type and existence checks
Date: Fri, 10 Mar 2017 18:13:48 +0100
Message-ID: <20170310171353.28868-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36719 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdCJROG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch series implements a boolean datatype for use in a
boolean expression as right-hand side of a relational. Based upon that,
header existence matches are implemented for IPv6 extension and TCP
option headers as well as an existence match of a FIB entry.

Phil Sutter (5):
  Introduce boolean datatype and boolean expression
  exthdr: Add support for exthdr specific flags
  exthdr: Implement existence check
  fib: Support existence check
  doc: Document boolean type and applications

 doc/nft.xml                         | 134 ++++++++++++++++++++++++++++++++++++
 include/datatype.h                  |   2 +
 include/expression.h                |   3 +
 include/exthdr.h                    |   4 +-
 include/linux/netfilter/nf_tables.h |   1 +
 include/tcpopt.h                    |   3 +-
 src/datatype.c                      |  19 +++++
 src/evaluate.c                      |  17 ++++-
 src/expression.c                    |   4 ++
 src/exthdr.c                        |  39 ++++++++---
 src/fib.c                           |   5 +-
 src/netlink_delinearize.c           |   5 +-
 src/netlink_linearize.c             |   1 +
 src/parser_bison.y                  |  54 +++++++++++++++
 src/scanner.l                       |   5 ++
 src/tcpopt.c                        |  11 ++-
 tests/py/inet/fib.t                 |   3 +
 tests/py/inet/fib.t.payload         |  10 +++
 tests/py/inet/tcpopt.t              |   3 +
 tests/py/inet/tcpopt.t.payload.inet |  14 ++++
 tests/py/ip6/exthdr.t               |  19 +++++
 tests/py/ip6/exthdr.t.payload.ip6   |  60 ++++++++++++++++
 22 files changed, 399 insertions(+), 17 deletions(-)
 create mode 100644 tests/py/ip6/exthdr.t
 create mode 100644 tests/py/ip6/exthdr.t.payload.ip6

-- 
2.11.0

