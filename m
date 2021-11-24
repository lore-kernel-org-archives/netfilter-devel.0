Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E672C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbhKXR1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbhKXR1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707E8C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:40 -0800 (PST)
Received: from localhost ([::1]:44916 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0c-0001BQ-Nc; Wed, 24 Nov 2021 18:24:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 00/15] Fix netlink debug output on Big Endian
Date:   Wed, 24 Nov 2021 18:22:36 +0100
Message-Id: <20211124172251.11539-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make use of recent changes to libnftnl and make tests/py testsuite pass
on Big Endian systems.

Patches 1, 2 and 3 are more or less unrelated fallout from the actual
work but simple enough to not deserve separate submission.

Patches 4-9 fix actual bugs on Big Endian.

Patch 10 is part convenience and part preparation for the following
patches.

Patches 11 and 12 prepare for patch 13 which fixes set element dumping.

Patch 14 adds a shell script which regenerates all payload records,
respecting the separation into family-specific files where used.

Patch 15 contains the big mess of regenerated payload records from using
the previous patch's script. It is at the same time too large to read
and a clear illustration of this and the respective libnftnl's patch
series' effect.

Phil Sutter (15):
  tests/py: Avoid duplicate records in *.got files
  exthdr: Fix for segfault with unknown exthdr
  mnl: Fix for missing info in rule dumps
  src: Fix payload statement mask on Big Endian
  meta: Fix {g,u}id_type on Big Endian
  meta: Fix hour_type size
  datatype: Fix size of time_type
  ct: Fix ct label value parser
  netlink_delinearize: Fix for escaped asterisk strings on Big Endian
  Make string-based data types Big Endian
  evaluate: Fix key byteorder value in range sets/maps
  include: Use struct nftnl_set_desc
  mnl: Provide libnftnl with set element meta info when dumping
  tests/py/tools: Add regen_payloads.sh
  tests/py: Regenerate payload records

 include/rule.h                          |   11 +-
 src/ct.c                                |    7 +-
 src/datatype.c                          |   18 +-
 src/evaluate.c                          |   60 +-
 src/expression.c                        |    2 +-
 src/exthdr.c                            |   12 +-
 src/fib.c                               |    2 +-
 src/json.c                              |    2 +-
 src/meta.c                              |   41 +-
 src/mnl.c                               |   88 +-
 src/netlink.c                           |   10 +-
 src/netlink_delinearize.c               |   67 +-
 src/netlink_linearize.c                 |   13 +-
 src/osf.c                               |    2 +-
 src/parser_bison.y                      |   16 +-
 tests/py/any/counter.t.payload          |    9 +-
 tests/py/any/ct.t.payload               |  242 +--
 tests/py/any/limit.t.payload            |    7 +-
 tests/py/any/log.t.payload              |    1 +
 tests/py/any/meta.t.payload             |  447 ++---
 tests/py/any/queue.t.payload            |   23 +-
 tests/py/any/quota.t.payload            |   26 +-
 tests/py/any/rawpayload.t.payload       |   28 +-
 tests/py/any/rt.t.payload               |   12 +-
 tests/py/any/tcpopt.t.payload           |  128 +-
 tests/py/arp/arp.t.payload              |  134 +-
 tests/py/arp/arp.t.payload.netdev       |  298 ++--
 tests/py/bridge/ether.t.payload         |   42 +-
 tests/py/bridge/icmpX.t.payload         |   24 +-
 tests/py/bridge/meta.t.payload          |   21 +-
 tests/py/bridge/reject.t.payload        |   50 +-
 tests/py/bridge/vlan.t.payload          |  255 +--
 tests/py/bridge/vlan.t.payload.netdev   |  335 ++--
 tests/py/inet/ah.t.payload              |  172 +-
 tests/py/inet/comp.t.payload            |   98 +-
 tests/py/inet/ct.t.payload              |   11 +-
 tests/py/inet/dccp.t.payload            |   98 +-
 tests/py/inet/dnat.t.payload            |   56 +-
 tests/py/inet/esp.t.payload             |   86 +-
 tests/py/inet/ether-ip.t.payload        |   23 +-
 tests/py/inet/ether-ip.t.payload.netdev |   26 +-
 tests/py/inet/ether.t.payload           |   20 +-
 tests/py/inet/ether.t.payload.bridge    |   16 +-
 tests/py/inet/ether.t.payload.ip        |   20 +-
 tests/py/inet/fib.t.payload             |   15 +-
 tests/py/inet/icmp.t.payload            |   48 +-
 tests/py/inet/icmpX.t.payload           |   35 +-
 tests/py/inet/ip.t.payload              |   11 +-
 tests/py/inet/ip.t.payload.bridge       |    9 +-
 tests/py/inet/ip.t.payload.inet         |    8 +-
 tests/py/inet/ip.t.payload.netdev       |   24 +-
 tests/py/inet/ip_tcp.t.payload          |   41 +-
 tests/py/inet/ip_tcp.t.payload.bridge   |   43 +-
 tests/py/inet/ip_tcp.t.payload.netdev   |   43 +-
 tests/py/inet/ipsec.t.payload           |   24 +-
 tests/py/inet/map.t.payload             |   14 +-
 tests/py/inet/map.t.payload.ip          |   14 +-
 tests/py/inet/map.t.payload.netdev      |   14 +-
 tests/py/inet/meta.t.payload            |   67 +-
 tests/py/inet/osf.t.payload             |   49 +-
 tests/py/inet/reject.t.payload.inet     |   38 +-
 tests/py/inet/rt.t.payload              |    6 +-
 tests/py/inet/sctp.t.payload            |  308 ++--
 tests/py/inet/sets.t.payload.bridge     |   32 +-
 tests/py/inet/sets.t.payload.inet       |   25 +-
 tests/py/inet/sets.t.payload.netdev     |   33 +-
 tests/py/inet/snat.t.payload            |   31 +-
 tests/py/inet/socket.t.payload          |   21 +-
 tests/py/inet/synproxy.t.payload        |   12 +-
 tests/py/inet/tcp.t.payload             |  641 +++----
 tests/py/inet/tproxy.t.payload          |   58 +-
 tests/py/inet/udp.t.payload             |  217 +--
 tests/py/inet/udplite.t.payload         |  142 +-
 tests/py/ip/ct.t.payload                |   45 +-
 tests/py/ip/dnat.t.payload.ip           |  136 +-
 tests/py/ip/dup.t.payload               |   18 +-
 tests/py/ip/ether.t.payload             |   36 +-
 tests/py/ip/flowtable.t.payload         |    4 +-
 tests/py/ip/hash.t.payload              |    9 +-
 tests/py/ip/icmp.t.payload.ip           |  399 ++---
 tests/py/ip/igmp.t.payload              |   92 +-
 tests/py/ip/ip.t.payload                |  271 +--
 tests/py/ip/ip.t.payload.bridge         |  550 +++---
 tests/py/ip/ip.t.payload.inet           |  434 ++---
 tests/py/ip/ip.t.payload.netdev         |  564 +++---
 tests/py/ip/ip_tcp.t.payload            |   10 +-
 tests/py/ip/masquerade.t.payload        |   80 +-
 tests/py/ip/meta.t.payload              |   33 +-
 tests/py/ip/numgen.t.payload            |   12 +-
 tests/py/ip/objects.t.payload           |   41 +-
 tests/py/ip/redirect.t.payload          |  132 +-
 tests/py/ip/reject.t.payload            |    2 +-
 tests/py/ip/rt.t.payload                |    2 +-
 tests/py/ip/sets.t.payload.inet         |   49 +-
 tests/py/ip/sets.t.payload.ip           |   23 +-
 tests/py/ip/sets.t.payload.netdev       |   53 +-
 tests/py/ip/snat.t.payload              |  111 +-
 tests/py/ip/tcp.t.payload               |   10 +-
 tests/py/ip/tproxy.t.payload            |   40 +-
 tests/py/ip6/dnat.t.payload.ip6         |   45 +-
 tests/py/ip6/dst.t.payload.inet         |   97 +-
 tests/py/ip6/dst.t.payload.ip6          |   51 +-
 tests/py/ip6/dup.t.payload              |   18 +-
 tests/py/ip6/ether.t.payload            |   37 +-
 tests/py/ip6/exthdr.t.payload.ip6       |   24 +-
 tests/py/ip6/flowtable.t.payload        |    4 +-
 tests/py/ip6/frag.t.payload.inet        |  152 +-
 tests/py/ip6/frag.t.payload.ip6         |   96 +-
 tests/py/ip6/frag.t.payload.netdev      | 2080 +++++++++--------------
 tests/py/ip6/hbh.t.payload.inet         |   80 +-
 tests/py/ip6/hbh.t.payload.ip6          |   48 +-
 tests/py/ip6/icmpv6.t.payload.ip6       |  350 ++--
 tests/py/ip6/ip6.t.payload.inet         |  408 ++---
 tests/py/ip6/ip6.t.payload.ip6          |  234 +--
 tests/py/ip6/map.t.payload              |    6 +-
 tests/py/ip6/masquerade.t.payload.ip6   |   80 +-
 tests/py/ip6/meta.t.payload             |   39 +-
 tests/py/ip6/mh.t.payload.inet          |  163 +-
 tests/py/ip6/mh.t.payload.ip6           |   97 +-
 tests/py/ip6/redirect.t.payload.ip6     |  116 +-
 tests/py/ip6/reject.t.payload.ip6       |    2 +-
 tests/py/ip6/rt.t.payload.inet          |  148 +-
 tests/py/ip6/rt.t.payload.ip6           |   88 +-
 tests/py/ip6/rt0.t.payload              |    2 +-
 tests/py/ip6/sets.t.payload.inet        |   15 +-
 tests/py/ip6/sets.t.payload.netdev      |   14 +-
 tests/py/ip6/snat.t.payload.ip6         |   26 +-
 tests/py/ip6/srh.t.payload              |   22 +-
 tests/py/ip6/tproxy.t.payload           |   40 +-
 tests/py/ip6/vmap.t.payload.inet        |  252 +--
 tests/py/ip6/vmap.t.payload.ip6         |  168 +-
 tests/py/ip6/vmap.t.payload.netdev      |  336 ++--
 tests/py/netdev/dup.t.payload           |   10 +-
 tests/py/netdev/fwd.t.payload           |   16 +-
 tests/py/netdev/reject.t.payload        |   92 +-
 tests/py/nft-test.py                    |   29 +-
 tests/py/tools/regen_payloads.sh        |   72 +
 137 files changed, 6695 insertions(+), 7100 deletions(-)
 create mode 100755 tests/py/tools/regen_payloads.sh

-- 
2.33.0

