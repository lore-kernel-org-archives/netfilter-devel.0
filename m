From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 0/7] flow statement
Date: Wed, 27 Apr 2016 12:29:43 +0100
Message-ID: <1461756590-22880-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33521 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcD0L3z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2016 07:29:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add the "flow" statement to dynamically instantiate
stateful expression for each user defined flow. This can currently be used
for per flow accounting and per flow rate limiting, similar to what hashlimit
provides, but with a much more flexible definition of a flow.

Examples:

# Per flow accounting
$ nft filter input flow table acct ip saddr . ip daddr counter

# Host rate limiting for each port
$ nft filter input flow ip saddr . tcp dport timeout 60s limit rate 10/second

The tables are so far not shown in the ruleset output, but can be displayed
using "nft list set". This will not be a permanent solution, the plan is to
add new commands for flow tables that will display them in a more structured
fashion and allow sorting by individual keys or parts of the per flow statment,
f.i. the counters. However this requires some rather large changes to how
nft prints data and needs more work, so the intention is to merge this part
now and add the output part once it is finished.

Comments and testing welcome.


Patrick McHardy (7):
  netlink: make dump functions object argument constant
  set: allow non-constant implicit set declarations
  set: explicitly supply name to implicit set declarations
  tests: update for changed set name
  netlink_delinearize: support parsing statements not contained within a rule
  stmt: support generating stateful statements outside of rule context
  nft: add flow statement

 include/expression.h                   |   1 +
 include/netlink.h                      |  15 +-
 include/nftables.h                     |   2 +-
 include/rule.h                         |   1 +
 include/statement.h                    |  13 ++
 src/evaluate.c                         |  51 ++++++-
 src/expression.c                       |  16 ++-
 src/netlink.c                          |  16 ++-
 src/netlink_delinearize.c              | 119 +++++++++++-----
 src/netlink_linearize.c                | 120 +++++++++++-----
 src/parser_bison.y                     |  57 ++++++++
 src/scanner.l                          |   2 +
 src/statement.c                        |  45 +++++-
 tests/py/any/ct.t.payload              |  66 ++++-----
 tests/py/any/dup.t.payload             |   6 +-
 tests/py/any/fwd.t.payload             |   6 +-
 tests/py/any/meta.t.payload            | 168 +++++++++++-----------
 tests/py/arp/arp.t.payload             |  42 +++---
 tests/py/arp/arp.t.payload.netdev      |  42 +++---
 tests/py/bridge/vlan.t.payload         |   6 +-
 tests/py/bridge/vlan.t.payload.netdev  |   6 +-
 tests/py/inet/ah.t.payload.inet        |  48 +++----
 tests/py/inet/ah.t.payload.ip          |  48 +++----
 tests/py/inet/ah.t.payload.ip6         |  48 +++----
 tests/py/inet/ah.t.payload.netdev      |  48 +++----
 tests/py/inet/comp.t.payload.inet      |  24 ++--
 tests/py/inet/comp.t.payload.ip        |  24 ++--
 tests/py/inet/comp.t.payload.ip6       |  24 ++--
 tests/py/inet/comp.t.payload.netdev    |  24 ++--
 tests/py/inet/dccp.t.payload.inet      |  36 ++---
 tests/py/inet/dccp.t.payload.ip        |  36 ++---
 tests/py/inet/dccp.t.payload.ip6       |  36 ++---
 tests/py/inet/dccp.t.payload.netdev    |  36 ++---
 tests/py/inet/esp.t.payload.inet       |  24 ++--
 tests/py/inet/esp.t.payload.ip         |  24 ++--
 tests/py/inet/esp.t.payload.ip6        |  24 ++--
 tests/py/inet/esp.t.payload.netdev     |  24 ++--
 tests/py/inet/ip.t.payload.bridge      |   6 +-
 tests/py/inet/ip.t.payload.inet        |   6 +-
 tests/py/inet/ip.t.payload.ip          |   6 +-
 tests/py/inet/ip.t.payload.netdev      |   6 +-
 tests/py/inet/map.t.payload.inet       |  12 +-
 tests/py/inet/map.t.payload.ip         |  12 +-
 tests/py/inet/map.t.payload.netdev     |  12 +-
 tests/py/inet/sctp.t.payload.inet      |  48 +++----
 tests/py/inet/sctp.t.payload.ip        |  48 +++----
 tests/py/inet/sctp.t.payload.ip6       |  48 +++----
 tests/py/inet/sctp.t.payload.netdev    |  48 +++----
 tests/py/inet/tcp.t.payload.inet       | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.ip         | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.ip6        | 126 ++++++++---------
 tests/py/inet/tcp.t.payload.netdev     | 126 ++++++++---------
 tests/py/inet/udp.t.payload.inet       |  48 +++----
 tests/py/inet/udp.t.payload.ip         |  48 +++----
 tests/py/inet/udp.t.payload.ip6        |  48 +++----
 tests/py/inet/udp.t.payload.netdev     |  48 +++----
 tests/py/inet/udplite.t.payload.inet   |  36 ++---
 tests/py/inet/udplite.t.payload.ip     |  36 ++---
 tests/py/inet/udplite.t.payload.ip6    |  36 ++---
 tests/py/inet/udplite.t.payload.netdev |  36 ++---
 tests/py/ip/dnat.t.payload.ip          |  18 +--
 tests/py/ip/dup.t.payload              |   6 +-
 tests/py/ip/icmp.t.payload.ip          |  90 ++++++------
 tests/py/ip/ip.t.payload               |  84 +++++------
 tests/py/ip/ip.t.payload.inet          |  84 +++++------
 tests/py/ip/ip.t.payload.netdev        |  78 +++++-----
 tests/py/ip/masquerade.t.payload       |  12 +-
 tests/py/ip/redirect.t.payload         |  18 +--
 tests/py/ip/snat.t.payload             |   6 +-
 tests/py/ip6/dst.t.payload.inet        |  30 ++--
 tests/py/ip6/dst.t.payload.ip6         |  30 ++--
 tests/py/ip6/dup.t.payload             |   6 +-
 tests/py/ip6/frag.t.payload.inet       |  42 +++---
 tests/py/ip6/frag.t.payload.ip6        |  42 +++---
 tests/py/ip6/hbh.t.payload.inet        |  30 ++--
 tests/py/ip6/hbh.t.payload.ip6         |  30 ++--
 tests/py/ip6/icmpv6.t.payload.ip6      |  96 ++++++-------
 tests/py/ip6/ip6.t.payload.inet        |  48 +++----
 tests/py/ip6/ip6.t.payload.ip6         |  48 +++----
 tests/py/ip6/map.t.payload             |   6 +-
 tests/py/ip6/masquerade.t.payload.ip6  |  12 +-
 tests/py/ip6/mh.t.payload.inet         |  60 ++++----
 tests/py/ip6/mh.t.payload.ip6          |  60 ++++----
 tests/py/ip6/redirect.t.payload.ip6    |  18 +--
 tests/py/ip6/rt.t.payload.inet         |  54 +++----
 tests/py/ip6/rt.t.payload.ip6          |  54 +++----
 tests/py/ip6/vmap.t.payload.inet       | 252 ++++++++++++++++-----------------
 tests/py/ip6/vmap.t.payload.ip6        | 252 ++++++++++++++++-----------------
 tests/py/ip6/vmap.t.payload.netdev     | 252 ++++++++++++++++-----------------
 89 files changed, 2260 insertions(+), 1978 deletions(-)

-- 
2.5.5

