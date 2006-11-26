From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: nf_conntrack: proc/sysctl compatibility
Date: Sun, 26 Nov 2006 15:44:47 +0100 (MET)
Message-ID: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

These patches are a new attempt at proc and sysctl compatibility. The first
three patches clean up the old sysctls a bit (move all protocol specific
sysctls to the individual source files and perform automatic registration),
the third and fourth patch introduce the actual compatibilty.


 include/linux/netfilter.h                             |    8 
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h        |    7 
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h        |   25 +
 include/net/netfilter/nf_conntrack.h                  |    5 
 include/net/netfilter/nf_conntrack_l3proto.h          |    6 
 include/net/netfilter/nf_conntrack_l4proto.h          |   12 
 net/ipv4/netfilter/Kconfig                            |   11 
 net/ipv4/netfilter/Makefile                           |    5 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c        |  130 +++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |  412 ++++++++++++++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c          |   43 +
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c        |   73 ---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c        |   26 -
 net/netfilter/Makefile                                |    1 
 net/netfilter/nf_conntrack_core.c                     |   10 
 net/netfilter/nf_conntrack_expect.c                   |    1 
 net/netfilter/nf_conntrack_l3proto_generic.c          |    3 
 net/netfilter/nf_conntrack_proto.c                    |  133 +++++
 net/netfilter/nf_conntrack_proto_generic.c            |   43 +
 net/netfilter/nf_conntrack_proto_sctp.c               |  170 ++++---
 net/netfilter/nf_conntrack_proto_tcp.c                |  249 ++++++++++
 net/netfilter/nf_conntrack_proto_udp.c                |   68 ++
 net/netfilter/nf_conntrack_standalone.c               |  150 ------
 net/netfilter/nf_sysctl.c                             |  132 +++++
 25 files changed, 1358 insertions(+), 366 deletions(-)

Patrick McHardy:
      [NETFILTER]: nf_conntrack: move extern declaration to header files
      [NETFILTER]: nf_conntrack: automatic sysctl registation for conntrack protocols
      [NETFILTER]: nf_conntrack: move conntrack protocol sysctls to individual modules
      [NETFILTER]: nf_conntrack: sysctl compatibility with old connection tracking
      [NETFILTER]: nf_conntrack: /proc compatibility with old connection tracking
