From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/10] nftables remove use of meta nfproto
Date: Wed, 27 Sep 2017 20:16:44 +0200
Message-ID: <20170927181654.3129-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37744 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdI0SQg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 14:16:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

inet family (and others, e.g. bridge) lack context to figure
out the layer 3 address type.

examples:
ct original saddr $addr
rt nexthop $addr

We can't use $addr, because it might be a set reference, e.g.

ct original saddr @whitelist

currently implemented workaround is to use 'meta nfproto'
to provide the l3 context, e.g.

meta nfproto ip rt nexthop 10.2.3.4

i.e. users need to fill dependency manually.

Pablo suggested to instead specify ip saddr, ip6 saddr:

ct original ip saddr $address

and then let nft handle the dependency injection.

This series does just that.

Old syntax is preserved.

 doc/nft.xml                |   23 ++++++++---
 include/ct.h               |    3 -
 include/expression.h       |    2 
 src/ct.c                   |   70 ++++++++++++++++++++++++----------
 src/evaluate.c             |   92 +++++++++++++++++++++++++++++++++++----------
 src/netlink_delinearize.c  |   52 +++++++++++--------------
 src/parser_bison.y         |   42 ++++++++++++++++++--
 src/rt.c                   |   14 ++++++
 tests/py/bridge/icmpX.t    |    4 -
 tests/py/inet/ct.t         |    7 ++-
 tests/py/inet/ct.t.payload |    4 -
 tests/py/inet/icmpX.t      |    4 -
 tests/py/inet/rt.t         |   10 +++-
 tests/py/inet/rt.t.payload |    4 -
 tests/py/ip/ct.t           |   18 ++++----
 tests/py/ip/ct.t.payload   |   16 +++----
 tests/py/ip/rt.t           |    3 -
 tests/py/ip6/rt0.t         |    2 
 18 files changed, 260 insertions(+), 110 deletions(-)
