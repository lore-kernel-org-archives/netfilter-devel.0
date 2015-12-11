From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 0/5] new testsuite for nft
Date: Fri, 11 Dec 2015 11:10:08 +0100
Message-ID: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36347 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754275AbbLKKKU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

he following series implements a new testsuite for nft.

It's almost similar to what I sent a couple of month ago, but updated
with comments by Pablo and other small fixes.
---

Arturo Borrero Gonzalez (5):
      tests/: rearrange tests directory
      tests/: add shell test-suite
      tests/shell: add maps tests cases
      tests/shell: add tests for handles and comments
      tests/shell: add test case for cache bug


 tests/files/chain-rename.1                         |    0 
 tests/files/chain-rename.2                         |    0 
 tests/files/chain-rename.3                         |    0 
 tests/files/dictionary                             |    0 
 tests/files/error.1                                |    0 
 tests/files/error.2                                |    0 
 tests/files/expr-concat                            |    0 
 tests/files/expr-ct                                |    0 
 tests/files/expr-meta                              |    0 
 tests/files/family-bridge                          |    0 
 tests/files/family-ipv4                            |    0 
 tests/files/family-ipv6                            |    0 
 tests/files/feat-adjancent-load-merging            |    0 
 tests/files/loop-detect.1                          |    0 
 tests/files/loop-detect.2                          |    0 
 tests/files/loop-detect.3                          |    0 
 tests/files/loop-detect.4                          |    0 
 tests/files/obj-chain                              |    0 
 tests/files/obj-table                              |    0 
 tests/files/payload-ll                             |    0 
 tests/files/prefix                                 |    0 
 tests/files/set                                    |    0 
 tests/files/stmt-log                               |    0 
 tests/files/symbolic-define.1                      |    0 
 tests/files/symbolic-define.2                      |    0 
 tests/files/symbolic-define.3                      |    0 
 tests/files/verdict-maps                           |    0 
 tests/py/README                                    |    0 
 tests/py/any/ct.t                                  |    0 
 tests/py/any/ct.t.payload                          |    0 
 tests/py/any/frag.t                                |    0 
 tests/py/any/frag.t.payload                        |    0 
 tests/py/any/limit.t                               |    0 
 tests/py/any/limit.t.payload                       |    0 
 tests/py/any/log.t                                 |    0 
 tests/py/any/log.t.payload                         |    0 
 tests/py/any/meta.t                                |    0 
 tests/py/any/meta.t.payload                        |    0 
 tests/py/any/queue.t                               |    0 
 tests/py/any/queue.t.payload                       |    0 
 tests/py/arp/arp.t                                 |    0 
 tests/py/arp/arp.t.payload                         |    0 
 tests/py/arp/chains.t                              |    0 
 tests/py/arp/chains.t.payload                      |    0 
 tests/py/bridge/chains.t                           |    0 
 tests/py/bridge/chains.t.payload                   |    0 
 tests/py/bridge/ether.t                            |    0 
 tests/py/bridge/ether.t.payload                    |    0 
 tests/py/bridge/reject.t                           |    0 
 tests/py/bridge/reject.t.payload                   |    0 
 tests/py/bridge/vlan.t                             |    0 
 tests/py/bridge/vlan.t.payload                     |    0 
 tests/py/inet/ah.t                                 |    0 
 tests/py/inet/ah.t.payload.inet                    |    0 
 tests/py/inet/ah.t.payload.ip                      |    0 
 tests/py/inet/ah.t.payload.ip6                     |    0 
 tests/py/inet/comp.t                               |    0 
 tests/py/inet/comp.t.payload.inet                  |    0 
 tests/py/inet/comp.t.payload.ip                    |    0 
 tests/py/inet/comp.t.payload.ip6                   |    0 
 tests/py/inet/dccp.t                               |    0 
 tests/py/inet/dccp.t.payload.inet                  |    0 
 tests/py/inet/dccp.t.payload.ip                    |    0 
 tests/py/inet/dccp.t.payload.ip6                   |    0 
 tests/py/inet/esp.t                                |    0 
 tests/py/inet/esp.t.payload.inet                   |    0 
 tests/py/inet/esp.t.payload.ip                     |    0 
 tests/py/inet/esp.t.payload.ip6                    |    0 
 tests/py/inet/ether-ip.t                           |    0 
 tests/py/inet/ether-ip.t.payload                   |    0 
 tests/py/inet/ether.t                              |    0 
 tests/py/inet/ether.t.payload                      |    0 
 tests/py/inet/ether.t.payload.bridge               |    0 
 tests/py/inet/ether.t.payload.ip                   |    0 
 tests/py/inet/ether.t.payload.ip6                  |    0 
 tests/py/inet/ip.t                                 |    0 
 tests/py/inet/ip.t.payload.bridge                  |    0 
 tests/py/inet/ip.t.payload.inet                    |    0 
 tests/py/inet/ip.t.payload.ip                      |    0 
 tests/py/inet/reject.t                             |    0 
 tests/py/inet/reject.t.payload.inet                |    0 
 tests/py/inet/sctp.t                               |    0 
 tests/py/inet/sctp.t.payload.inet                  |    0 
 tests/py/inet/sctp.t.payload.ip                    |    0 
 tests/py/inet/sctp.t.payload.ip6                   |    0 
 tests/py/inet/tcp.t                                |    0 
 tests/py/inet/tcp.t.payload.inet                   |    0 
 tests/py/inet/tcp.t.payload.ip                     |    0 
 tests/py/inet/tcp.t.payload.ip6                    |    0 
 tests/py/inet/udp.t                                |    0 
 tests/py/inet/udp.t.payload.ip                     |    0 
 tests/py/inet/udplite.t                            |    0 
 tests/py/inet/udplite.t.payload.inet               |    0 
 tests/py/inet/udplite.t.payload.ip                 |    0 
 tests/py/inet/udplite.t.payload.ip6                |    0 
 tests/py/ip/chains.t                               |    0 
 tests/py/ip/dnat.t                                 |    0 
 tests/py/ip/dnat.t.payload.ip                      |    0 
 tests/py/ip/dup.t                                  |    0 
 tests/py/ip/dup.t.payload                          |    0 
 tests/py/ip/dup.t.payload.got                      |    0 
 tests/py/ip/ether.t                                |    0 
 tests/py/ip/ether.t.payload                        |    0 
 tests/py/ip/icmp.t                                 |    0 
 tests/py/ip/icmp.t.payload.ip                      |    0 
 tests/py/ip/ip.t                                   |    0 
 tests/py/ip/ip.t.payload                           |    0 
 tests/py/ip/ip.t.payload.inet                      |    0 
 tests/py/ip/masquerade.t                           |    0 
 tests/py/ip/masquerade.t.payload                   |    0 
 tests/py/ip/redirect.t                             |    0 
 tests/py/ip/redirect.t.payload                     |    0 
 tests/py/ip/reject.t                               |    0 
 tests/py/ip/reject.t.payload                       |    0 
 tests/py/ip/sets.t                                 |    0 
 tests/py/ip/sets.t.payload.inet                    |    0 
 tests/py/ip/sets.t.payload.ip                      |    0 
 tests/py/ip/snat.t                                 |    0 
 tests/py/ip/snat.t.payload                         |    0 
 tests/py/ip6/chains.t                              |    0 
 tests/py/ip6/dnat.t                                |    0 
 tests/py/ip6/dnat.t.payload.ip6                    |    0 
 tests/py/ip6/dst.t                                 |    0 
 tests/py/ip6/dst.t.payload.inet                    |    0 
 tests/py/ip6/dst.t.payload.ip6                     |    0 
 tests/py/ip6/dup.t                                 |    0 
 tests/py/ip6/dup.t.payload                         |    0 
 tests/py/ip6/ether.t                               |    0 
 tests/py/ip6/ether.t.payload                       |    0 
 tests/py/ip6/hbh.t                                 |    0 
 tests/py/ip6/hbh.t.payload.inet                    |    0 
 tests/py/ip6/hbh.t.payload.ip6                     |    0 
 tests/py/ip6/icmpv6.t                              |    0 
 tests/py/ip6/icmpv6.t.payload.ip6                  |    0 
 tests/py/ip6/ip6.t                                 |    0 
 tests/py/ip6/ip6.t.payload.inet                    |    0 
 tests/py/ip6/ip6.t.payload.ip6                     |    0 
 tests/py/ip6/masquerade.t                          |    0 
 tests/py/ip6/masquerade.t.payload.ip6              |    0 
 tests/py/ip6/mh.t                                  |    0 
 tests/py/ip6/mh.t.payload.inet                     |    0 
 tests/py/ip6/mh.t.payload.ip6                      |    0 
 tests/py/ip6/redirect.t                            |    0 
 tests/py/ip6/redirect.t.payload.ip6                |    0 
 tests/py/ip6/reject.t                              |    0 
 tests/py/ip6/reject.t.payload.ip6                  |    0 
 tests/py/ip6/rt.t                                  |    0 
 tests/py/ip6/rt.t.payload.inet                     |    0 
 tests/py/ip6/rt.t.payload.ip6                      |    0 
 tests/py/ip6/sets.t                                |    0 
 tests/py/ip6/sets.t.payload                        |    0 
 tests/py/ip6/sets.t.payload.inet                   |    0 
 tests/py/ip6/sets.t.payload.ip6                    |    0 
 tests/py/ip6/snat.t                                |    0 
 tests/py/ip6/snat.t.payload.ip6                    |    0 
 tests/py/ip6/vmap.t                                |    0 
 tests/py/ip6/vmap.t.payload.inet                   |    0 
 tests/py/ip6/vmap.t.payload.ip6                    |    0 
 tests/py/nft-test.py                               |    0 
 tests/shell/README                                 |   23 ++++++
 tests/shell/run-tests.sh                           |   72 ++++++++++++++++++++
 tests/shell/testcases/maps/anonymous_snat_map_0    |    8 ++
 tests/shell/testcases/maps/named_snat_map_0        |   10 +++
 tests/shell/testcases/optionals/comments_0         |    8 ++
 tests/shell/testcases/optionals/comments_handles_0 |   10 +++
 .../testcases/optionals/comments_handles_monitor_0 |   29 ++++++++
 tests/shell/testcases/optionals/handles_0          |    8 ++
 tests/shell/testcases/optionals/handles_1          |    8 ++
 tests/shell/testcases/sets/cache_handling_0        |   35 ++++++++++
 169 files changed, 211 insertions(+)
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
 create mode 100644 tests/shell/README
 create mode 100755 tests/shell/run-tests.sh
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_0
 create mode 100755 tests/shell/testcases/maps/named_snat_map_0
 create mode 100755 tests/shell/testcases/optionals/comments_0
 create mode 100755 tests/shell/testcases/optionals/comments_handles_0
 create mode 100755 tests/shell/testcases/optionals/comments_handles_monitor_0
 create mode 100755 tests/shell/testcases/optionals/handles_0
 create mode 100755 tests/shell/testcases/optionals/handles_1
 create mode 100755 tests/shell/testcases/sets/cache_handling_0

--
Arturo Borrero Gonzalez
