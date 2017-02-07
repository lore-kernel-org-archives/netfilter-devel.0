From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 0/7] TCP option matching
Date: Tue,  7 Feb 2017 03:14:08 +0100
Message-ID: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:52556 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751606AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id CA089B007E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:26 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set is part of the TCP option matching implementation for nftables.

These patch sets enable nft to match against the following TCP options:
* End of Option List
* No-Operation
* Maximum Segment Size
* Window Scale
* SACK
* SACK Permitted
* Timestamps

Florian Westphal (1):
  payload: insert implicit meta tcp dependency when matching tcp options

Manuel Messner (6):
  include: linux: netfilter: nf_tables: copy file from nf-next
  exthdr: prepare for tcp support
  exthdr: prepare exthdr_gen_dependency for tcp support
  src: add TCP option matching
  payload: automatically kill dependencies for exthdr and tcpopt
  tests: py: Add basic tests for ip, ip6 and inet

 doc/nft.xml                         | 178 +++++++++++++++++++++++-
 include/expression.h                |   1 +
 include/exthdr.h                    |   5 +-
 include/linux/netfilter/nf_tables.h |  17 ++-
 include/payload.h                   |   5 +-
 include/tcpopt.h                    |  26 ++++
 src/Makefile.am                     |   1 +
 src/evaluate.c                      |  42 +++++-
 src/exthdr.c                        |  36 ++++-
 src/netlink_delinearize.c           |   7 +-
 src/netlink_linearize.c             |   5 +-
 src/parser_bison.y                  |  46 +++++-
 src/payload.c                       |  39 +++++-
 src/scanner.l                       |   1 +
 src/tcpopt.c                        | 269 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcpopt.t              |  38 +++++
 tests/py/inet/tcpopt.t.payload.inet | 181 ++++++++++++++++++++++++
 tests/py/ip/tcpopt.t                |  38 +++++
 tests/py/ip/tcpopt.t.payload        | 181 ++++++++++++++++++++++++
 tests/py/ip6/tcpopt.t               |  37 +++++
 tests/py/ip6/tcpopt.t.payload       | 181 ++++++++++++++++++++++++
 21 files changed, 1303 insertions(+), 31 deletions(-)
 create mode 100644 include/tcpopt.h
 create mode 100644 src/tcpopt.c
 create mode 100644 tests/py/inet/tcpopt.t
 create mode 100644 tests/py/inet/tcpopt.t.payload.inet
 create mode 100644 tests/py/ip/tcpopt.t
 create mode 100644 tests/py/ip/tcpopt.t.payload
 create mode 100644 tests/py/ip6/tcpopt.t
 create mode 100644 tests/py/ip6/tcpopt.t.payload

--
2.11.1

