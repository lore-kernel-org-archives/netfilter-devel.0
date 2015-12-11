From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 1/5] tests/: rearrange tests directory
Date: Fri, 11 Dec 2015 11:10:14 +0100
Message-ID: <144982861420.31246.5857618349281263108.stgit@r2d2.cica.es>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36360 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754668AbbLKKKY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:24 -0500
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rearrange the directory to obtain a better organization of files and
tests-suites.

We end with a tree like this:

tests
  |
  .--- py
  .--- shell
  .--- files

This was suggested by Pablo.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/files/chain-rename.1                    |    0 
 tests/files/chain-rename.2                    |    0 
 tests/files/chain-rename.3                    |    0 
 tests/files/dictionary                        |    0 
 tests/files/error.1                           |    0 
 tests/files/error.2                           |    0 
 tests/files/expr-concat                       |    0 
 tests/files/expr-ct                           |    0 
 tests/files/expr-meta                         |    0 
 tests/files/family-bridge                     |    0 
 tests/files/family-ipv4                       |    0 
 tests/files/family-ipv6                       |    0 
 tests/files/feat-adjancent-load-merging       |    0 
 tests/files/loop-detect.1                     |    0 
 tests/files/loop-detect.2                     |    0 
 tests/files/loop-detect.3                     |    0 
 tests/files/loop-detect.4                     |    0 
 tests/files/obj-chain                         |    0 
 tests/files/obj-table                         |    0 
 tests/files/payload-ll                        |    0 
 tests/files/prefix                            |    0 
 tests/files/set                               |    0 
 tests/files/stmt-log                          |    0 
 tests/files/symbolic-define.1                 |    0 
 tests/files/symbolic-define.2                 |    0 
 tests/files/symbolic-define.3                 |    0 
 tests/files/verdict-maps                      |    0 
 tests/py/README                               |    0 
 tests/py/any/ct.t                             |    0 
 tests/py/any/ct.t.payload                     |    0 
 tests/py/any/frag.t                           |    0 
 tests/py/any/frag.t.payload                   |    0 
 tests/py/any/limit.t                          |    0 
 tests/py/any/limit.t.payload                  |    0 
 tests/py/any/log.t                            |    0 
 tests/py/any/log.t.payload                    |    0 
 tests/py/any/meta.t                           |    0 
 tests/py/any/meta.t.payload                   |    0 
 tests/py/any/queue.t                          |    0 
 tests/py/any/queue.t.payload                  |    0 
 tests/py/arp/arp.t                            |    0 
 tests/py/arp/arp.t.payload                    |    0 
 tests/py/arp/chains.t                         |    0 
 tests/py/arp/chains.t.payload                 |    0 
 tests/py/bridge/chains.t                      |    0 
 tests/py/bridge/chains.t.payload              |    0 
 tests/py/bridge/ether.t                       |    0 
 tests/py/bridge/ether.t.payload               |    0 
 tests/py/bridge/reject.t                      |    0 
 tests/py/bridge/reject.t.payload              |    0 
 tests/py/bridge/vlan.t                        |    0 
 tests/py/bridge/vlan.t.payload                |    0 
 tests/py/inet/ah.t                            |    0 
 tests/py/inet/ah.t.payload.inet               |    0 
 tests/py/inet/ah.t.payload.ip                 |    0 
 tests/py/inet/ah.t.payload.ip6                |    0 
 tests/py/inet/comp.t                          |    0 
 tests/py/inet/comp.t.payload.inet             |    0 
 tests/py/inet/comp.t.payload.ip               |    0 
 tests/py/inet/comp.t.payload.ip6              |    0 
 tests/py/inet/dccp.t                          |    0 
 tests/py/inet/dccp.t.payload.inet             |    0 
 tests/py/inet/dccp.t.payload.ip               |    0 
 tests/py/inet/dccp.t.payload.ip6              |    0 
 tests/py/inet/esp.t                           |    0 
 tests/py/inet/esp.t.payload.inet              |    0 
 tests/py/inet/esp.t.payload.ip                |    0 
 tests/py/inet/esp.t.payload.ip6               |    0 
 tests/py/inet/ether-ip.t                      |    0 
 tests/py/inet/ether-ip.t.payload              |    0 
 tests/py/inet/ether.t                         |    0 
 tests/py/inet/ether.t.payload                 |    0 
 tests/py/inet/ether.t.payload.bridge          |    0 
 tests/py/inet/ether.t.payload.ip              |    0 
 tests/py/inet/ether.t.payload.ip6             |    0 
 tests/py/inet/ip.t                            |    0 
 tests/py/inet/ip.t.payload.bridge             |    0 
 tests/py/inet/ip.t.payload.inet               |    0 
 tests/py/inet/ip.t.payload.ip                 |    0 
 tests/py/inet/reject.t                        |    0 
 tests/py/inet/reject.t.payload.inet           |    0 
 tests/py/inet/sctp.t                          |    0 
 tests/py/inet/sctp.t.payload.inet             |    0 
 tests/py/inet/sctp.t.payload.ip               |    0 
 tests/py/inet/sctp.t.payload.ip6              |    0 
 tests/py/inet/tcp.t                           |    0 
 tests/py/inet/tcp.t.payload.inet              |    0 
 tests/py/inet/tcp.t.payload.ip                |    0 
 tests/py/inet/tcp.t.payload.ip6               |    0 
 tests/py/inet/udp.t                           |    0 
 tests/py/inet/udp.t.payload.ip                |    0 
 tests/py/inet/udplite.t                       |    0 
 tests/py/inet/udplite.t.payload.inet          |    0 
 tests/py/inet/udplite.t.payload.ip            |    0 
 tests/py/inet/udplite.t.payload.ip6           |    0 
 tests/py/ip/chains.t                          |    0 
 tests/py/ip/dnat.t                            |    0 
 tests/py/ip/dnat.t.payload.ip                 |    0 
 tests/py/ip/dup.t                             |    0 
 tests/py/ip/dup.t.payload                     |    0 
 tests/py/ip/dup.t.payload.got                 |    0 
 tests/py/ip/ether.t                           |    0 
 tests/py/ip/ether.t.payload                   |    0 
 tests/py/ip/icmp.t                            |    0 
 tests/py/ip/icmp.t.payload.ip                 |    0 
 tests/py/ip/ip.t                              |    0 
 tests/py/ip/ip.t.payload                      |    0 
 tests/py/ip/ip.t.payload.inet                 |    0 
 tests/py/ip/masquerade.t                      |    0 
 tests/py/ip/masquerade.t.payload              |    0 
 tests/py/ip/redirect.t                        |    0 
 tests/py/ip/redirect.t.payload                |    0 
 tests/py/ip/reject.t                          |    0 
 tests/py/ip/reject.t.payload                  |    0 
 tests/py/ip/sets.t                            |    0 
 tests/py/ip/sets.t.payload.inet               |    0 
 tests/py/ip/sets.t.payload.ip                 |    0 
 tests/py/ip/snat.t                            |    0 
 tests/py/ip/snat.t.payload                    |    0 
 tests/py/ip6/chains.t                         |    0 
 tests/py/ip6/dnat.t                           |    0 
 tests/py/ip6/dnat.t.payload.ip6               |    0 
 tests/py/ip6/dst.t                            |    0 
 tests/py/ip6/dst.t.payload.inet               |    0 
 tests/py/ip6/dst.t.payload.ip6                |    0 
 tests/py/ip6/dup.t                            |    0 
 tests/py/ip6/dup.t.payload                    |    0 
 tests/py/ip6/ether.t                          |    0 
 tests/py/ip6/ether.t.payload                  |    0 
 tests/py/ip6/hbh.t                            |    0 
 tests/py/ip6/hbh.t.payload.inet               |    0 
 tests/py/ip6/hbh.t.payload.ip6                |    0 
 tests/py/ip6/icmpv6.t                         |    0 
 tests/py/ip6/icmpv6.t.payload.ip6             |    0 
 tests/py/ip6/ip6.t                            |    0 
 tests/py/ip6/ip6.t.payload.inet               |    0 
 tests/py/ip6/ip6.t.payload.ip6                |    0 
 tests/py/ip6/masquerade.t                     |    0 
 tests/py/ip6/masquerade.t.payload.ip6         |    0 
 tests/py/ip6/mh.t                             |    0 
 tests/py/ip6/mh.t.payload.inet                |    0 
 tests/py/ip6/mh.t.payload.ip6                 |    0 
 tests/py/ip6/redirect.t                       |    0 
 tests/py/ip6/redirect.t.payload.ip6           |    0 
 tests/py/ip6/reject.t                         |    0 
 tests/py/ip6/reject.t.payload.ip6             |    0 
 tests/py/ip6/rt.t                             |    0 
 tests/py/ip6/rt.t.payload.inet                |    0 
 tests/py/ip6/rt.t.payload.ip6                 |    0 
 tests/py/ip6/sets.t                           |    0 
 tests/py/ip6/sets.t.payload                   |    0 
 tests/py/ip6/sets.t.payload.inet              |    0 
 tests/py/ip6/sets.t.payload.ip6               |    0 
 tests/py/ip6/snat.t                           |    0 
 tests/py/ip6/snat.t.payload.ip6               |    0 
 tests/py/ip6/vmap.t                           |    0 
 tests/py/ip6/vmap.t.payload.inet              |    0 
 tests/py/ip6/vmap.t.payload.ip6               |    0 
 tests/py/nft-test.py                          |    0 
 159 files changed, 0 insertions(+), 0 deletions(-)
 rename tests/{chain-rename.1 => files/chain-rename.1} (100%)
 rename tests/{chain-rename.2 => files/chain-rename.2} (100%)
 rename tests/{chain-rename.3 => files/chain-rename.3} (100%)
 rename tests/{dictionary => files/dictionary} (100%)
 rename tests/{error.1 => files/error.1} (100%)
 rename tests/{error.2 => files/error.2} (100%)
 rename tests/{expr-concat => files/expr-concat} (100%)
 rename tests/{expr-ct => files/expr-ct} (100%)
 rename tests/{expr-meta => files/expr-meta} (100%)
 rename tests/{family-bridge => files/family-bridge} (100%)
 rename tests/{family-ipv4 => files/family-ipv4} (100%)
 rename tests/{family-ipv6 => files/family-ipv6} (100%)
 rename tests/{feat-adjancent-load-merging => files/feat-adjancent-load-merging} (100%)
 rename tests/{loop-detect.1 => files/loop-detect.1} (100%)
 rename tests/{loop-detect.2 => files/loop-detect.2} (100%)
 rename tests/{loop-detect.3 => files/loop-detect.3} (100%)
 rename tests/{loop-detect.4 => files/loop-detect.4} (100%)
 rename tests/{obj-chain => files/obj-chain} (100%)
 rename tests/{obj-table => files/obj-table} (100%)
 rename tests/{payload-ll => files/payload-ll} (100%)
 rename tests/{prefix => files/prefix} (100%)
 rename tests/{set => files/set} (100%)
 rename tests/{stmt-log => files/stmt-log} (100%)
 rename tests/{symbolic-define.1 => files/symbolic-define.1} (100%)
 rename tests/{symbolic-define.2 => files/symbolic-define.2} (100%)
 rename tests/{symbolic-define.3 => files/symbolic-define.3} (100%)
 rename tests/{verdict-maps => files/verdict-maps} (100%)
 rename tests/{regression/README => py/README} (100%)
 rename tests/{regression/any/ct.t => py/any/ct.t} (100%)
 rename tests/{regression/any/ct.t.payload => py/any/ct.t.payload} (100%)
 rename tests/{regression/any/frag.t => py/any/frag.t} (100%)
 rename tests/{regression/any/frag.t.payload => py/any/frag.t.payload} (100%)
 rename tests/{regression/any/limit.t => py/any/limit.t} (100%)
 rename tests/{regression/any/limit.t.payload => py/any/limit.t.payload} (100%)
 rename tests/{regression/any/log.t => py/any/log.t} (100%)
 rename tests/{regression/any/log.t.payload => py/any/log.t.payload} (100%)
 rename tests/{regression/any/meta.t => py/any/meta.t} (100%)
 rename tests/{regression/any/meta.t.payload => py/any/meta.t.payload} (100%)
 rename tests/{regression/any/queue.t => py/any/queue.t} (100%)
 rename tests/{regression/any/queue.t.payload => py/any/queue.t.payload} (100%)
 rename tests/{regression/arp/arp.t => py/arp/arp.t} (100%)
 rename tests/{regression/arp/arp.t.payload => py/arp/arp.t.payload} (100%)
 rename tests/{regression/arp/chains.t => py/arp/chains.t} (100%)
 rename tests/{regression/bridge/chains.t.payload => py/arp/chains.t.payload} (100%)
 rename tests/{regression/bridge/chains.t => py/bridge/chains.t} (100%)
 rename tests/{regression/arp/chains.t.payload => py/bridge/chains.t.payload} (100%)
 rename tests/{regression/bridge/ether.t => py/bridge/ether.t} (100%)
 rename tests/{regression/bridge/ether.t.payload => py/bridge/ether.t.payload} (100%)
 rename tests/{regression/bridge/reject.t => py/bridge/reject.t} (100%)
 rename tests/{regression/bridge/reject.t.payload => py/bridge/reject.t.payload} (100%)
 rename tests/{regression/bridge/vlan.t => py/bridge/vlan.t} (100%)
 rename tests/{regression/bridge/vlan.t.payload => py/bridge/vlan.t.payload} (100%)
 rename tests/{regression/inet/ah.t => py/inet/ah.t} (100%)
 rename tests/{regression/inet/ah.t.payload.inet => py/inet/ah.t.payload.inet} (100%)
 rename tests/{regression/inet/ah.t.payload.ip => py/inet/ah.t.payload.ip} (100%)
 rename tests/{regression/inet/ah.t.payload.ip6 => py/inet/ah.t.payload.ip6} (100%)
 rename tests/{regression/inet/comp.t => py/inet/comp.t} (100%)
 rename tests/{regression/inet/comp.t.payload.inet => py/inet/comp.t.payload.inet} (100%)
 rename tests/{regression/inet/comp.t.payload.ip => py/inet/comp.t.payload.ip} (100%)
 rename tests/{regression/inet/comp.t.payload.ip6 => py/inet/comp.t.payload.ip6} (100%)
 rename tests/{regression/inet/dccp.t => py/inet/dccp.t} (100%)
 rename tests/{regression/inet/dccp.t.payload.inet => py/inet/dccp.t.payload.inet} (100%)
 rename tests/{regression/inet/dccp.t.payload.ip => py/inet/dccp.t.payload.ip} (100%)
 rename tests/{regression/inet/dccp.t.payload.ip6 => py/inet/dccp.t.payload.ip6} (100%)
 rename tests/{regression/inet/esp.t => py/inet/esp.t} (100%)
 rename tests/{regression/inet/esp.t.payload.inet => py/inet/esp.t.payload.inet} (100%)
 rename tests/{regression/inet/esp.t.payload.ip => py/inet/esp.t.payload.ip} (100%)
 rename tests/{regression/inet/esp.t.payload.ip6 => py/inet/esp.t.payload.ip6} (100%)
 rename tests/{regression/inet/ether-ip.t => py/inet/ether-ip.t} (100%)
 rename tests/{regression/inet/ether-ip.t.payload => py/inet/ether-ip.t.payload} (100%)
 rename tests/{regression/inet/ether.t => py/inet/ether.t} (100%)
 rename tests/{regression/inet/ether.t.payload => py/inet/ether.t.payload} (100%)
 rename tests/{regression/inet/ether.t.payload.bridge => py/inet/ether.t.payload.bridge} (100%)
 rename tests/{regression/inet/ether.t.payload.ip => py/inet/ether.t.payload.ip} (100%)
 rename tests/{regression/inet/ether.t.payload.ip6 => py/inet/ether.t.payload.ip6} (100%)
 rename tests/{regression/inet/ip.t => py/inet/ip.t} (100%)
 rename tests/{regression/inet/ip.t.payload.bridge => py/inet/ip.t.payload.bridge} (100%)
 rename tests/{regression/inet/ip.t.payload.inet => py/inet/ip.t.payload.inet} (100%)
 rename tests/{regression/inet/ip.t.payload.ip => py/inet/ip.t.payload.ip} (100%)
 rename tests/{regression/inet/reject.t => py/inet/reject.t} (100%)
 rename tests/{regression/inet/reject.t.payload.inet => py/inet/reject.t.payload.inet} (100%)
 rename tests/{regression/inet/sctp.t => py/inet/sctp.t} (100%)
 rename tests/{regression/inet/sctp.t.payload.inet => py/inet/sctp.t.payload.inet} (100%)
 rename tests/{regression/inet/sctp.t.payload.ip => py/inet/sctp.t.payload.ip} (100%)
 rename tests/{regression/inet/sctp.t.payload.ip6 => py/inet/sctp.t.payload.ip6} (100%)
 rename tests/{regression/inet/tcp.t => py/inet/tcp.t} (100%)
 rename tests/{regression/inet/tcp.t.payload.inet => py/inet/tcp.t.payload.inet} (100%)
 rename tests/{regression/inet/tcp.t.payload.ip => py/inet/tcp.t.payload.ip} (100%)
 rename tests/{regression/inet/tcp.t.payload.ip6 => py/inet/tcp.t.payload.ip6} (100%)
 rename tests/{regression/inet/udp.t => py/inet/udp.t} (100%)
 rename tests/{regression/inet/udp.t.payload.ip => py/inet/udp.t.payload.ip} (100%)
 rename tests/{regression/inet/udplite.t => py/inet/udplite.t} (100%)
 rename tests/{regression/inet/udplite.t.payload.inet => py/inet/udplite.t.payload.inet} (100%)
 rename tests/{regression/inet/udplite.t.payload.ip => py/inet/udplite.t.payload.ip} (100%)
 rename tests/{regression/inet/udplite.t.payload.ip6 => py/inet/udplite.t.payload.ip6} (100%)
 rename tests/{regression/ip/chains.t => py/ip/chains.t} (100%)
 rename tests/{regression/ip/dnat.t => py/ip/dnat.t} (100%)
 rename tests/{regression/ip/dnat.t.payload.ip => py/ip/dnat.t.payload.ip} (100%)
 rename tests/{regression/ip/dup.t => py/ip/dup.t} (100%)
 rename tests/{regression/ip/dup.t.payload => py/ip/dup.t.payload} (100%)
 rename tests/{regression/ip/dup.t.payload.got => py/ip/dup.t.payload.got} (100%)
 rename tests/{regression/ip/ether.t => py/ip/ether.t} (100%)
 rename tests/{regression/ip/ether.t.payload => py/ip/ether.t.payload} (100%)
 rename tests/{regression/ip/icmp.t => py/ip/icmp.t} (100%)
 rename tests/{regression/ip/icmp.t.payload.ip => py/ip/icmp.t.payload.ip} (100%)
 rename tests/{regression/ip/ip.t => py/ip/ip.t} (100%)
 rename tests/{regression/ip/ip.t.payload => py/ip/ip.t.payload} (100%)
 rename tests/{regression/ip/ip.t.payload.inet => py/ip/ip.t.payload.inet} (100%)
 rename tests/{regression/ip/masquerade.t => py/ip/masquerade.t} (100%)
 rename tests/{regression/ip/masquerade.t.payload => py/ip/masquerade.t.payload} (100%)
 rename tests/{regression/ip/redirect.t => py/ip/redirect.t} (100%)
 rename tests/{regression/ip/redirect.t.payload => py/ip/redirect.t.payload} (100%)
 rename tests/{regression/ip/reject.t => py/ip/reject.t} (100%)
 rename tests/{regression/ip/reject.t.payload => py/ip/reject.t.payload} (100%)
 rename tests/{regression/ip/sets.t => py/ip/sets.t} (100%)
 rename tests/{regression/ip/sets.t.payload.inet => py/ip/sets.t.payload.inet} (100%)
 rename tests/{regression/ip/sets.t.payload.ip => py/ip/sets.t.payload.ip} (100%)
 rename tests/{regression/ip/snat.t => py/ip/snat.t} (100%)
 rename tests/{regression/ip/snat.t.payload => py/ip/snat.t.payload} (100%)
 rename tests/{regression/ip6/chains.t => py/ip6/chains.t} (100%)
 rename tests/{regression/ip6/dnat.t => py/ip6/dnat.t} (100%)
 rename tests/{regression/ip6/dnat.t.payload.ip6 => py/ip6/dnat.t.payload.ip6} (100%)
 rename tests/{regression/ip6/dst.t => py/ip6/dst.t} (100%)
 rename tests/{regression/ip6/dst.t.payload.inet => py/ip6/dst.t.payload.inet} (100%)
 rename tests/{regression/ip6/dst.t.payload.ip6 => py/ip6/dst.t.payload.ip6} (100%)
 rename tests/{regression/ip6/dup.t => py/ip6/dup.t} (100%)
 rename tests/{regression/ip6/dup.t.payload => py/ip6/dup.t.payload} (100%)
 rename tests/{regression/ip6/ether.t => py/ip6/ether.t} (100%)
 rename tests/{regression/ip6/ether.t.payload => py/ip6/ether.t.payload} (100%)
 rename tests/{regression/ip6/hbh.t => py/ip6/hbh.t} (100%)
 rename tests/{regression/ip6/hbh.t.payload.inet => py/ip6/hbh.t.payload.inet} (100%)
 rename tests/{regression/ip6/hbh.t.payload.ip6 => py/ip6/hbh.t.payload.ip6} (100%)
 rename tests/{regression/ip6/icmpv6.t => py/ip6/icmpv6.t} (100%)
 rename tests/{regression/ip6/icmpv6.t.payload.ip6 => py/ip6/icmpv6.t.payload.ip6} (100%)
 rename tests/{regression/ip6/ip6.t => py/ip6/ip6.t} (100%)
 rename tests/{regression/ip6/ip6.t.payload.inet => py/ip6/ip6.t.payload.inet} (100%)
 rename tests/{regression/ip6/ip6.t.payload.ip6 => py/ip6/ip6.t.payload.ip6} (100%)
 rename tests/{regression/ip6/masquerade.t => py/ip6/masquerade.t} (100%)
 rename tests/{regression/ip6/masquerade.t.payload.ip6 => py/ip6/masquerade.t.payload.ip6} (100%)
 rename tests/{regression/ip6/mh.t => py/ip6/mh.t} (100%)
 rename tests/{regression/ip6/mh.t.payload.inet => py/ip6/mh.t.payload.inet} (100%)
 rename tests/{regression/ip6/mh.t.payload.ip6 => py/ip6/mh.t.payload.ip6} (100%)
 rename tests/{regression/ip6/redirect.t => py/ip6/redirect.t} (100%)
 rename tests/{regression/ip6/redirect.t.payload.ip6 => py/ip6/redirect.t.payload.ip6} (100%)
 rename tests/{regression/ip6/reject.t => py/ip6/reject.t} (100%)
 rename tests/{regression/ip6/reject.t.payload.ip6 => py/ip6/reject.t.payload.ip6} (100%)
 rename tests/{regression/ip6/rt.t => py/ip6/rt.t} (100%)
 rename tests/{regression/ip6/rt.t.payload.inet => py/ip6/rt.t.payload.inet} (100%)
 rename tests/{regression/ip6/rt.t.payload.ip6 => py/ip6/rt.t.payload.ip6} (100%)
 rename tests/{regression/ip6/sets.t => py/ip6/sets.t} (100%)
 rename tests/{regression/ip6/sets.t.payload => py/ip6/sets.t.payload} (100%)
 rename tests/{regression/ip6/sets.t.payload.inet => py/ip6/sets.t.payload.inet} (100%)
 rename tests/{regression/ip6/sets.t.payload.ip6 => py/ip6/sets.t.payload.ip6} (100%)
 rename tests/{regression/ip6/snat.t => py/ip6/snat.t} (100%)
 rename tests/{regression/ip6/snat.t.payload.ip6 => py/ip6/snat.t.payload.ip6} (100%)
 rename tests/{regression/ip6/vmap.t => py/ip6/vmap.t} (100%)
 rename tests/{regression/ip6/vmap.t.payload.inet => py/ip6/vmap.t.payload.inet} (100%)
 rename tests/{regression/ip6/vmap.t.payload.ip6 => py/ip6/vmap.t.payload.ip6} (100%)
 rename tests/{regression/nft-test.py => py/nft-test.py} (100%)

diff --git a/tests/chain-rename.1 b/tests/files/chain-rename.1
similarity index 100%
rename from tests/chain-rename.1
rename to tests/files/chain-rename.1
diff --git a/tests/chain-rename.2 b/tests/files/chain-rename.2
similarity index 100%
rename from tests/chain-rename.2
rename to tests/files/chain-rename.2
diff --git a/tests/chain-rename.3 b/tests/files/chain-rename.3
similarity index 100%
rename from tests/chain-rename.3
rename to tests/files/chain-rename.3
diff --git a/tests/dictionary b/tests/files/dictionary
similarity index 100%
rename from tests/dictionary
rename to tests/files/dictionary
diff --git a/tests/error.1 b/tests/files/error.1
similarity index 100%
rename from tests/error.1
rename to tests/files/error.1
diff --git a/tests/error.2 b/tests/files/error.2
similarity index 100%
rename from tests/error.2
rename to tests/files/error.2
diff --git a/tests/expr-concat b/tests/files/expr-concat
similarity index 100%
rename from tests/expr-concat
rename to tests/files/expr-concat
diff --git a/tests/expr-ct b/tests/files/expr-ct
similarity index 100%
rename from tests/expr-ct
rename to tests/files/expr-ct
diff --git a/tests/expr-meta b/tests/files/expr-meta
similarity index 100%
rename from tests/expr-meta
rename to tests/files/expr-meta
diff --git a/tests/family-bridge b/tests/files/family-bridge
similarity index 100%
rename from tests/family-bridge
rename to tests/files/family-bridge
diff --git a/tests/family-ipv4 b/tests/files/family-ipv4
similarity index 100%
rename from tests/family-ipv4
rename to tests/files/family-ipv4
diff --git a/tests/family-ipv6 b/tests/files/family-ipv6
similarity index 100%
rename from tests/family-ipv6
rename to tests/files/family-ipv6
diff --git a/tests/feat-adjancent-load-merging b/tests/files/feat-adjancent-load-merging
similarity index 100%
rename from tests/feat-adjancent-load-merging
rename to tests/files/feat-adjancent-load-merging
diff --git a/tests/loop-detect.1 b/tests/files/loop-detect.1
similarity index 100%
rename from tests/loop-detect.1
rename to tests/files/loop-detect.1
diff --git a/tests/loop-detect.2 b/tests/files/loop-detect.2
similarity index 100%
rename from tests/loop-detect.2
rename to tests/files/loop-detect.2
diff --git a/tests/loop-detect.3 b/tests/files/loop-detect.3
similarity index 100%
rename from tests/loop-detect.3
rename to tests/files/loop-detect.3
diff --git a/tests/loop-detect.4 b/tests/files/loop-detect.4
similarity index 100%
rename from tests/loop-detect.4
rename to tests/files/loop-detect.4
diff --git a/tests/obj-chain b/tests/files/obj-chain
similarity index 100%
rename from tests/obj-chain
rename to tests/files/obj-chain
diff --git a/tests/obj-table b/tests/files/obj-table
similarity index 100%
rename from tests/obj-table
rename to tests/files/obj-table
diff --git a/tests/payload-ll b/tests/files/payload-ll
similarity index 100%
rename from tests/payload-ll
rename to tests/files/payload-ll
diff --git a/tests/prefix b/tests/files/prefix
similarity index 100%
rename from tests/prefix
rename to tests/files/prefix
diff --git a/tests/set b/tests/files/set
similarity index 100%
rename from tests/set
rename to tests/files/set
diff --git a/tests/stmt-log b/tests/files/stmt-log
similarity index 100%
rename from tests/stmt-log
rename to tests/files/stmt-log
diff --git a/tests/symbolic-define.1 b/tests/files/symbolic-define.1
similarity index 100%
rename from tests/symbolic-define.1
rename to tests/files/symbolic-define.1
diff --git a/tests/symbolic-define.2 b/tests/files/symbolic-define.2
similarity index 100%
rename from tests/symbolic-define.2
rename to tests/files/symbolic-define.2
diff --git a/tests/symbolic-define.3 b/tests/files/symbolic-define.3
similarity index 100%
rename from tests/symbolic-define.3
rename to tests/files/symbolic-define.3
diff --git a/tests/verdict-maps b/tests/files/verdict-maps
similarity index 100%
rename from tests/verdict-maps
rename to tests/files/verdict-maps
diff --git a/tests/regression/README b/tests/py/README
similarity index 100%
rename from tests/regression/README
rename to tests/py/README
diff --git a/tests/regression/any/ct.t b/tests/py/any/ct.t
similarity index 100%
rename from tests/regression/any/ct.t
rename to tests/py/any/ct.t
diff --git a/tests/regression/any/ct.t.payload b/tests/py/any/ct.t.payload
similarity index 100%
rename from tests/regression/any/ct.t.payload
rename to tests/py/any/ct.t.payload
diff --git a/tests/regression/any/frag.t b/tests/py/any/frag.t
similarity index 100%
rename from tests/regression/any/frag.t
rename to tests/py/any/frag.t
diff --git a/tests/regression/any/frag.t.payload b/tests/py/any/frag.t.payload
similarity index 100%
rename from tests/regression/any/frag.t.payload
rename to tests/py/any/frag.t.payload
diff --git a/tests/regression/any/limit.t b/tests/py/any/limit.t
similarity index 100%
rename from tests/regression/any/limit.t
rename to tests/py/any/limit.t
diff --git a/tests/regression/any/limit.t.payload b/tests/py/any/limit.t.payload
similarity index 100%
rename from tests/regression/any/limit.t.payload
rename to tests/py/any/limit.t.payload
diff --git a/tests/regression/any/log.t b/tests/py/any/log.t
similarity index 100%
rename from tests/regression/any/log.t
rename to tests/py/any/log.t
diff --git a/tests/regression/any/log.t.payload b/tests/py/any/log.t.payload
similarity index 100%
rename from tests/regression/any/log.t.payload
rename to tests/py/any/log.t.payload
diff --git a/tests/regression/any/meta.t b/tests/py/any/meta.t
similarity index 100%
rename from tests/regression/any/meta.t
rename to tests/py/any/meta.t
diff --git a/tests/regression/any/meta.t.payload b/tests/py/any/meta.t.payload
similarity index 100%
rename from tests/regression/any/meta.t.payload
rename to tests/py/any/meta.t.payload
diff --git a/tests/regression/any/queue.t b/tests/py/any/queue.t
similarity index 100%
rename from tests/regression/any/queue.t
rename to tests/py/any/queue.t
diff --git a/tests/regression/any/queue.t.payload b/tests/py/any/queue.t.payload
similarity index 100%
rename from tests/regression/any/queue.t.payload
rename to tests/py/any/queue.t.payload
diff --git a/tests/regression/arp/arp.t b/tests/py/arp/arp.t
similarity index 100%
rename from tests/regression/arp/arp.t
rename to tests/py/arp/arp.t
diff --git a/tests/regression/arp/arp.t.payload b/tests/py/arp/arp.t.payload
similarity index 100%
rename from tests/regression/arp/arp.t.payload
rename to tests/py/arp/arp.t.payload
diff --git a/tests/regression/arp/chains.t b/tests/py/arp/chains.t
similarity index 100%
rename from tests/regression/arp/chains.t
rename to tests/py/arp/chains.t
diff --git a/tests/regression/bridge/chains.t.payload b/tests/py/arp/chains.t.payload
similarity index 100%
rename from tests/regression/bridge/chains.t.payload
rename to tests/py/arp/chains.t.payload
diff --git a/tests/regression/bridge/chains.t b/tests/py/bridge/chains.t
similarity index 100%
rename from tests/regression/bridge/chains.t
rename to tests/py/bridge/chains.t
diff --git a/tests/regression/arp/chains.t.payload b/tests/py/bridge/chains.t.payload
similarity index 100%
rename from tests/regression/arp/chains.t.payload
rename to tests/py/bridge/chains.t.payload
diff --git a/tests/regression/bridge/ether.t b/tests/py/bridge/ether.t
similarity index 100%
rename from tests/regression/bridge/ether.t
rename to tests/py/bridge/ether.t
diff --git a/tests/regression/bridge/ether.t.payload b/tests/py/bridge/ether.t.payload
similarity index 100%
rename from tests/regression/bridge/ether.t.payload
rename to tests/py/bridge/ether.t.payload
diff --git a/tests/regression/bridge/reject.t b/tests/py/bridge/reject.t
similarity index 100%
rename from tests/regression/bridge/reject.t
rename to tests/py/bridge/reject.t
diff --git a/tests/regression/bridge/reject.t.payload b/tests/py/bridge/reject.t.payload
similarity index 100%
rename from tests/regression/bridge/reject.t.payload
rename to tests/py/bridge/reject.t.payload
diff --git a/tests/regression/bridge/vlan.t b/tests/py/bridge/vlan.t
similarity index 100%
rename from tests/regression/bridge/vlan.t
rename to tests/py/bridge/vlan.t
diff --git a/tests/regression/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
similarity index 100%
rename from tests/regression/bridge/vlan.t.payload
rename to tests/py/bridge/vlan.t.payload
diff --git a/tests/regression/inet/ah.t b/tests/py/inet/ah.t
similarity index 100%
rename from tests/regression/inet/ah.t
rename to tests/py/inet/ah.t
diff --git a/tests/regression/inet/ah.t.payload.inet b/tests/py/inet/ah.t.payload.inet
similarity index 100%
rename from tests/regression/inet/ah.t.payload.inet
rename to tests/py/inet/ah.t.payload.inet
diff --git a/tests/regression/inet/ah.t.payload.ip b/tests/py/inet/ah.t.payload.ip
similarity index 100%
rename from tests/regression/inet/ah.t.payload.ip
rename to tests/py/inet/ah.t.payload.ip
diff --git a/tests/regression/inet/ah.t.payload.ip6 b/tests/py/inet/ah.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/ah.t.payload.ip6
rename to tests/py/inet/ah.t.payload.ip6
diff --git a/tests/regression/inet/comp.t b/tests/py/inet/comp.t
similarity index 100%
rename from tests/regression/inet/comp.t
rename to tests/py/inet/comp.t
diff --git a/tests/regression/inet/comp.t.payload.inet b/tests/py/inet/comp.t.payload.inet
similarity index 100%
rename from tests/regression/inet/comp.t.payload.inet
rename to tests/py/inet/comp.t.payload.inet
diff --git a/tests/regression/inet/comp.t.payload.ip b/tests/py/inet/comp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/comp.t.payload.ip
rename to tests/py/inet/comp.t.payload.ip
diff --git a/tests/regression/inet/comp.t.payload.ip6 b/tests/py/inet/comp.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/comp.t.payload.ip6
rename to tests/py/inet/comp.t.payload.ip6
diff --git a/tests/regression/inet/dccp.t b/tests/py/inet/dccp.t
similarity index 100%
rename from tests/regression/inet/dccp.t
rename to tests/py/inet/dccp.t
diff --git a/tests/regression/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
similarity index 100%
rename from tests/regression/inet/dccp.t.payload.inet
rename to tests/py/inet/dccp.t.payload.inet
diff --git a/tests/regression/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/dccp.t.payload.ip
rename to tests/py/inet/dccp.t.payload.ip
diff --git a/tests/regression/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/dccp.t.payload.ip6
rename to tests/py/inet/dccp.t.payload.ip6
diff --git a/tests/regression/inet/esp.t b/tests/py/inet/esp.t
similarity index 100%
rename from tests/regression/inet/esp.t
rename to tests/py/inet/esp.t
diff --git a/tests/regression/inet/esp.t.payload.inet b/tests/py/inet/esp.t.payload.inet
similarity index 100%
rename from tests/regression/inet/esp.t.payload.inet
rename to tests/py/inet/esp.t.payload.inet
diff --git a/tests/regression/inet/esp.t.payload.ip b/tests/py/inet/esp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/esp.t.payload.ip
rename to tests/py/inet/esp.t.payload.ip
diff --git a/tests/regression/inet/esp.t.payload.ip6 b/tests/py/inet/esp.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/esp.t.payload.ip6
rename to tests/py/inet/esp.t.payload.ip6
diff --git a/tests/regression/inet/ether-ip.t b/tests/py/inet/ether-ip.t
similarity index 100%
rename from tests/regression/inet/ether-ip.t
rename to tests/py/inet/ether-ip.t
diff --git a/tests/regression/inet/ether-ip.t.payload b/tests/py/inet/ether-ip.t.payload
similarity index 100%
rename from tests/regression/inet/ether-ip.t.payload
rename to tests/py/inet/ether-ip.t.payload
diff --git a/tests/regression/inet/ether.t b/tests/py/inet/ether.t
similarity index 100%
rename from tests/regression/inet/ether.t
rename to tests/py/inet/ether.t
diff --git a/tests/regression/inet/ether.t.payload b/tests/py/inet/ether.t.payload
similarity index 100%
rename from tests/regression/inet/ether.t.payload
rename to tests/py/inet/ether.t.payload
diff --git a/tests/regression/inet/ether.t.payload.bridge b/tests/py/inet/ether.t.payload.bridge
similarity index 100%
rename from tests/regression/inet/ether.t.payload.bridge
rename to tests/py/inet/ether.t.payload.bridge
diff --git a/tests/regression/inet/ether.t.payload.ip b/tests/py/inet/ether.t.payload.ip
similarity index 100%
rename from tests/regression/inet/ether.t.payload.ip
rename to tests/py/inet/ether.t.payload.ip
diff --git a/tests/regression/inet/ether.t.payload.ip6 b/tests/py/inet/ether.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/ether.t.payload.ip6
rename to tests/py/inet/ether.t.payload.ip6
diff --git a/tests/regression/inet/ip.t b/tests/py/inet/ip.t
similarity index 100%
rename from tests/regression/inet/ip.t
rename to tests/py/inet/ip.t
diff --git a/tests/regression/inet/ip.t.payload.bridge b/tests/py/inet/ip.t.payload.bridge
similarity index 100%
rename from tests/regression/inet/ip.t.payload.bridge
rename to tests/py/inet/ip.t.payload.bridge
diff --git a/tests/regression/inet/ip.t.payload.inet b/tests/py/inet/ip.t.payload.inet
similarity index 100%
rename from tests/regression/inet/ip.t.payload.inet
rename to tests/py/inet/ip.t.payload.inet
diff --git a/tests/regression/inet/ip.t.payload.ip b/tests/py/inet/ip.t.payload.ip
similarity index 100%
rename from tests/regression/inet/ip.t.payload.ip
rename to tests/py/inet/ip.t.payload.ip
diff --git a/tests/regression/inet/reject.t b/tests/py/inet/reject.t
similarity index 100%
rename from tests/regression/inet/reject.t
rename to tests/py/inet/reject.t
diff --git a/tests/regression/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
similarity index 100%
rename from tests/regression/inet/reject.t.payload.inet
rename to tests/py/inet/reject.t.payload.inet
diff --git a/tests/regression/inet/sctp.t b/tests/py/inet/sctp.t
similarity index 100%
rename from tests/regression/inet/sctp.t
rename to tests/py/inet/sctp.t
diff --git a/tests/regression/inet/sctp.t.payload.inet b/tests/py/inet/sctp.t.payload.inet
similarity index 100%
rename from tests/regression/inet/sctp.t.payload.inet
rename to tests/py/inet/sctp.t.payload.inet
diff --git a/tests/regression/inet/sctp.t.payload.ip b/tests/py/inet/sctp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/sctp.t.payload.ip
rename to tests/py/inet/sctp.t.payload.ip
diff --git a/tests/regression/inet/sctp.t.payload.ip6 b/tests/py/inet/sctp.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/sctp.t.payload.ip6
rename to tests/py/inet/sctp.t.payload.ip6
diff --git a/tests/regression/inet/tcp.t b/tests/py/inet/tcp.t
similarity index 100%
rename from tests/regression/inet/tcp.t
rename to tests/py/inet/tcp.t
diff --git a/tests/regression/inet/tcp.t.payload.inet b/tests/py/inet/tcp.t.payload.inet
similarity index 100%
rename from tests/regression/inet/tcp.t.payload.inet
rename to tests/py/inet/tcp.t.payload.inet
diff --git a/tests/regression/inet/tcp.t.payload.ip b/tests/py/inet/tcp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/tcp.t.payload.ip
rename to tests/py/inet/tcp.t.payload.ip
diff --git a/tests/regression/inet/tcp.t.payload.ip6 b/tests/py/inet/tcp.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/tcp.t.payload.ip6
rename to tests/py/inet/tcp.t.payload.ip6
diff --git a/tests/regression/inet/udp.t b/tests/py/inet/udp.t
similarity index 100%
rename from tests/regression/inet/udp.t
rename to tests/py/inet/udp.t
diff --git a/tests/regression/inet/udp.t.payload.ip b/tests/py/inet/udp.t.payload.ip
similarity index 100%
rename from tests/regression/inet/udp.t.payload.ip
rename to tests/py/inet/udp.t.payload.ip
diff --git a/tests/regression/inet/udplite.t b/tests/py/inet/udplite.t
similarity index 100%
rename from tests/regression/inet/udplite.t
rename to tests/py/inet/udplite.t
diff --git a/tests/regression/inet/udplite.t.payload.inet b/tests/py/inet/udplite.t.payload.inet
similarity index 100%
rename from tests/regression/inet/udplite.t.payload.inet
rename to tests/py/inet/udplite.t.payload.inet
diff --git a/tests/regression/inet/udplite.t.payload.ip b/tests/py/inet/udplite.t.payload.ip
similarity index 100%
rename from tests/regression/inet/udplite.t.payload.ip
rename to tests/py/inet/udplite.t.payload.ip
diff --git a/tests/regression/inet/udplite.t.payload.ip6 b/tests/py/inet/udplite.t.payload.ip6
similarity index 100%
rename from tests/regression/inet/udplite.t.payload.ip6
rename to tests/py/inet/udplite.t.payload.ip6
diff --git a/tests/regression/ip/chains.t b/tests/py/ip/chains.t
similarity index 100%
rename from tests/regression/ip/chains.t
rename to tests/py/ip/chains.t
diff --git a/tests/regression/ip/dnat.t b/tests/py/ip/dnat.t
similarity index 100%
rename from tests/regression/ip/dnat.t
rename to tests/py/ip/dnat.t
diff --git a/tests/regression/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
similarity index 100%
rename from tests/regression/ip/dnat.t.payload.ip
rename to tests/py/ip/dnat.t.payload.ip
diff --git a/tests/regression/ip/dup.t b/tests/py/ip/dup.t
similarity index 100%
rename from tests/regression/ip/dup.t
rename to tests/py/ip/dup.t
diff --git a/tests/regression/ip/dup.t.payload b/tests/py/ip/dup.t.payload
similarity index 100%
rename from tests/regression/ip/dup.t.payload
rename to tests/py/ip/dup.t.payload
diff --git a/tests/regression/ip/dup.t.payload.got b/tests/py/ip/dup.t.payload.got
similarity index 100%
rename from tests/regression/ip/dup.t.payload.got
rename to tests/py/ip/dup.t.payload.got
diff --git a/tests/regression/ip/ether.t b/tests/py/ip/ether.t
similarity index 100%
rename from tests/regression/ip/ether.t
rename to tests/py/ip/ether.t
diff --git a/tests/regression/ip/ether.t.payload b/tests/py/ip/ether.t.payload
similarity index 100%
rename from tests/regression/ip/ether.t.payload
rename to tests/py/ip/ether.t.payload
diff --git a/tests/regression/ip/icmp.t b/tests/py/ip/icmp.t
similarity index 100%
rename from tests/regression/ip/icmp.t
rename to tests/py/ip/icmp.t
diff --git a/tests/regression/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
similarity index 100%
rename from tests/regression/ip/icmp.t.payload.ip
rename to tests/py/ip/icmp.t.payload.ip
diff --git a/tests/regression/ip/ip.t b/tests/py/ip/ip.t
similarity index 100%
rename from tests/regression/ip/ip.t
rename to tests/py/ip/ip.t
diff --git a/tests/regression/ip/ip.t.payload b/tests/py/ip/ip.t.payload
similarity index 100%
rename from tests/regression/ip/ip.t.payload
rename to tests/py/ip/ip.t.payload
diff --git a/tests/regression/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
similarity index 100%
rename from tests/regression/ip/ip.t.payload.inet
rename to tests/py/ip/ip.t.payload.inet
diff --git a/tests/regression/ip/masquerade.t b/tests/py/ip/masquerade.t
similarity index 100%
rename from tests/regression/ip/masquerade.t
rename to tests/py/ip/masquerade.t
diff --git a/tests/regression/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
similarity index 100%
rename from tests/regression/ip/masquerade.t.payload
rename to tests/py/ip/masquerade.t.payload
diff --git a/tests/regression/ip/redirect.t b/tests/py/ip/redirect.t
similarity index 100%
rename from tests/regression/ip/redirect.t
rename to tests/py/ip/redirect.t
diff --git a/tests/regression/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
similarity index 100%
rename from tests/regression/ip/redirect.t.payload
rename to tests/py/ip/redirect.t.payload
diff --git a/tests/regression/ip/reject.t b/tests/py/ip/reject.t
similarity index 100%
rename from tests/regression/ip/reject.t
rename to tests/py/ip/reject.t
diff --git a/tests/regression/ip/reject.t.payload b/tests/py/ip/reject.t.payload
similarity index 100%
rename from tests/regression/ip/reject.t.payload
rename to tests/py/ip/reject.t.payload
diff --git a/tests/regression/ip/sets.t b/tests/py/ip/sets.t
similarity index 100%
rename from tests/regression/ip/sets.t
rename to tests/py/ip/sets.t
diff --git a/tests/regression/ip/sets.t.payload.inet b/tests/py/ip/sets.t.payload.inet
similarity index 100%
rename from tests/regression/ip/sets.t.payload.inet
rename to tests/py/ip/sets.t.payload.inet
diff --git a/tests/regression/ip/sets.t.payload.ip b/tests/py/ip/sets.t.payload.ip
similarity index 100%
rename from tests/regression/ip/sets.t.payload.ip
rename to tests/py/ip/sets.t.payload.ip
diff --git a/tests/regression/ip/snat.t b/tests/py/ip/snat.t
similarity index 100%
rename from tests/regression/ip/snat.t
rename to tests/py/ip/snat.t
diff --git a/tests/regression/ip/snat.t.payload b/tests/py/ip/snat.t.payload
similarity index 100%
rename from tests/regression/ip/snat.t.payload
rename to tests/py/ip/snat.t.payload
diff --git a/tests/regression/ip6/chains.t b/tests/py/ip6/chains.t
similarity index 100%
rename from tests/regression/ip6/chains.t
rename to tests/py/ip6/chains.t
diff --git a/tests/regression/ip6/dnat.t b/tests/py/ip6/dnat.t
similarity index 100%
rename from tests/regression/ip6/dnat.t
rename to tests/py/ip6/dnat.t
diff --git a/tests/regression/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/dnat.t.payload.ip6
rename to tests/py/ip6/dnat.t.payload.ip6
diff --git a/tests/regression/ip6/dst.t b/tests/py/ip6/dst.t
similarity index 100%
rename from tests/regression/ip6/dst.t
rename to tests/py/ip6/dst.t
diff --git a/tests/regression/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/dst.t.payload.inet
rename to tests/py/ip6/dst.t.payload.inet
diff --git a/tests/regression/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/dst.t.payload.ip6
rename to tests/py/ip6/dst.t.payload.ip6
diff --git a/tests/regression/ip6/dup.t b/tests/py/ip6/dup.t
similarity index 100%
rename from tests/regression/ip6/dup.t
rename to tests/py/ip6/dup.t
diff --git a/tests/regression/ip6/dup.t.payload b/tests/py/ip6/dup.t.payload
similarity index 100%
rename from tests/regression/ip6/dup.t.payload
rename to tests/py/ip6/dup.t.payload
diff --git a/tests/regression/ip6/ether.t b/tests/py/ip6/ether.t
similarity index 100%
rename from tests/regression/ip6/ether.t
rename to tests/py/ip6/ether.t
diff --git a/tests/regression/ip6/ether.t.payload b/tests/py/ip6/ether.t.payload
similarity index 100%
rename from tests/regression/ip6/ether.t.payload
rename to tests/py/ip6/ether.t.payload
diff --git a/tests/regression/ip6/hbh.t b/tests/py/ip6/hbh.t
similarity index 100%
rename from tests/regression/ip6/hbh.t
rename to tests/py/ip6/hbh.t
diff --git a/tests/regression/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/hbh.t.payload.inet
rename to tests/py/ip6/hbh.t.payload.inet
diff --git a/tests/regression/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/hbh.t.payload.ip6
rename to tests/py/ip6/hbh.t.payload.ip6
diff --git a/tests/regression/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
similarity index 100%
rename from tests/regression/ip6/icmpv6.t
rename to tests/py/ip6/icmpv6.t
diff --git a/tests/regression/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/icmpv6.t.payload.ip6
rename to tests/py/ip6/icmpv6.t.payload.ip6
diff --git a/tests/regression/ip6/ip6.t b/tests/py/ip6/ip6.t
similarity index 100%
rename from tests/regression/ip6/ip6.t
rename to tests/py/ip6/ip6.t
diff --git a/tests/regression/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/ip6.t.payload.inet
rename to tests/py/ip6/ip6.t.payload.inet
diff --git a/tests/regression/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/ip6.t.payload.ip6
rename to tests/py/ip6/ip6.t.payload.ip6
diff --git a/tests/regression/ip6/masquerade.t b/tests/py/ip6/masquerade.t
similarity index 100%
rename from tests/regression/ip6/masquerade.t
rename to tests/py/ip6/masquerade.t
diff --git a/tests/regression/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/masquerade.t.payload.ip6
rename to tests/py/ip6/masquerade.t.payload.ip6
diff --git a/tests/regression/ip6/mh.t b/tests/py/ip6/mh.t
similarity index 100%
rename from tests/regression/ip6/mh.t
rename to tests/py/ip6/mh.t
diff --git a/tests/regression/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/mh.t.payload.inet
rename to tests/py/ip6/mh.t.payload.inet
diff --git a/tests/regression/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/mh.t.payload.ip6
rename to tests/py/ip6/mh.t.payload.ip6
diff --git a/tests/regression/ip6/redirect.t b/tests/py/ip6/redirect.t
similarity index 100%
rename from tests/regression/ip6/redirect.t
rename to tests/py/ip6/redirect.t
diff --git a/tests/regression/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/redirect.t.payload.ip6
rename to tests/py/ip6/redirect.t.payload.ip6
diff --git a/tests/regression/ip6/reject.t b/tests/py/ip6/reject.t
similarity index 100%
rename from tests/regression/ip6/reject.t
rename to tests/py/ip6/reject.t
diff --git a/tests/regression/ip6/reject.t.payload.ip6 b/tests/py/ip6/reject.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/reject.t.payload.ip6
rename to tests/py/ip6/reject.t.payload.ip6
diff --git a/tests/regression/ip6/rt.t b/tests/py/ip6/rt.t
similarity index 100%
rename from tests/regression/ip6/rt.t
rename to tests/py/ip6/rt.t
diff --git a/tests/regression/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/rt.t.payload.inet
rename to tests/py/ip6/rt.t.payload.inet
diff --git a/tests/regression/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/rt.t.payload.ip6
rename to tests/py/ip6/rt.t.payload.ip6
diff --git a/tests/regression/ip6/sets.t b/tests/py/ip6/sets.t
similarity index 100%
rename from tests/regression/ip6/sets.t
rename to tests/py/ip6/sets.t
diff --git a/tests/regression/ip6/sets.t.payload b/tests/py/ip6/sets.t.payload
similarity index 100%
rename from tests/regression/ip6/sets.t.payload
rename to tests/py/ip6/sets.t.payload
diff --git a/tests/regression/ip6/sets.t.payload.inet b/tests/py/ip6/sets.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/sets.t.payload.inet
rename to tests/py/ip6/sets.t.payload.inet
diff --git a/tests/regression/ip6/sets.t.payload.ip6 b/tests/py/ip6/sets.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/sets.t.payload.ip6
rename to tests/py/ip6/sets.t.payload.ip6
diff --git a/tests/regression/ip6/snat.t b/tests/py/ip6/snat.t
similarity index 100%
rename from tests/regression/ip6/snat.t
rename to tests/py/ip6/snat.t
diff --git a/tests/regression/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/snat.t.payload.ip6
rename to tests/py/ip6/snat.t.payload.ip6
diff --git a/tests/regression/ip6/vmap.t b/tests/py/ip6/vmap.t
similarity index 100%
rename from tests/regression/ip6/vmap.t
rename to tests/py/ip6/vmap.t
diff --git a/tests/regression/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
similarity index 100%
rename from tests/regression/ip6/vmap.t.payload.inet
rename to tests/py/ip6/vmap.t.payload.inet
diff --git a/tests/regression/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
similarity index 100%
rename from tests/regression/ip6/vmap.t.payload.ip6
rename to tests/py/ip6/vmap.t.payload.ip6
diff --git a/tests/regression/nft-test.py b/tests/py/nft-test.py
similarity index 100%
rename from tests/regression/nft-test.py
rename to tests/py/nft-test.py

