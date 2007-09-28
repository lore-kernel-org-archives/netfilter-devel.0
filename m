From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/19]: Netfilter update
Date: Fri, 28 Sep 2007 18:30:36 +0200 (MEST)
Message-ID: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55918 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbXI1Qai (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following is a netfilter update for 2.6.24, containing a set of patches to
use the generic netlink functions for nfnetlink, a new "time" match, some
nfnetlink_log cleanups and some minor other stuff.

Please apply, thanks.


 include/linux/netfilter/Kbuild                 |    1 +
 include/linux/netfilter/nfnetlink.h            |   98 +----
 include/linux/netfilter/nfnetlink_compat.h     |   61 +++
 include/linux/netfilter/nfnetlink_conntrack.h  |    1 +
 include/linux/netfilter/xt_time.h              |   25 ++
 include/net/netfilter/nf_conntrack.h           |    3 -
 include/net/netfilter/nf_conntrack_expect.h    |    3 -
 include/net/netfilter/nf_conntrack_helper.h    |    2 +-
 include/net/netfilter/nf_conntrack_l3proto.h   |    9 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |   17 +-
 include/net/netfilter/nf_nat_protocol.h        |    8 +-
 net/bridge/br_netfilter.c                      |    5 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   30 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   40 +-
 net/ipv4/netfilter/nf_nat_core.c               |   22 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    4 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c          |    4 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   30 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   40 +-
 net/netfilter/Kconfig                          |   14 +
 net/netfilter/Makefile                         |    1 +
 net/netfilter/nf_conntrack_core.c              |   33 +-
 net/netfilter/nf_conntrack_expect.c            |    2 -
 net/netfilter/nf_conntrack_netlink.c           |  551 +++++++++++++-----------
 net/netfilter/nf_conntrack_proto_gre.c         |    5 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   87 ++--
 net/netfilter/nf_conntrack_proto_udp.c         |   10 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |   10 +-
 net/netfilter/nfnetlink.c                      |  106 +----
 net/netfilter/nfnetlink_log.c                  |  221 +++++------
 net/netfilter/nfnetlink_queue.c                |  133 +++---
 net/netfilter/xt_time.c                        |  269 ++++++++++++
 34 files changed, 1052 insertions(+), 801 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_compat.h
 create mode 100644 include/linux/netfilter/xt_time.h
 create mode 100644 net/netfilter/xt_time.c

Jan Engelhardt (1):
      [NETFILTER]: x_tables: add xt_time match

Joseph Fannin (1):
      [NETFILTER]: bridge: remove broken netfilter binary sysctls

Michal Miroslaw (5):
      [NETFILTER]: nfnetlink_log: kill duplicate code
      [NETFILTER]: nfnetlink_log: flush queue early
      [NETFILTER]: nfnetlink_log: fix style
      [NETFILTER]: nfnetlink_log: fix instance_create() failure path
      [NETFILTER]: nfnetlink_log: fix some constants

Pablo Neira Ayuso (1):
      [NETFILTER]: nf_conntrack_netlink: add support to related connections

Patrick McHardy (11):
      [NETFILTER]: nfnetlink: make subsystem and callbacks const
      [NETFILTER]: nfnetlink: convert to generic netlink attribute functions
      [NETFILTER]: nfnetlink: rename functions containing 'nfattr'
      [NETFILTER]: nfnetlink: use nlmsg_notify()
      [NETFILTER]: nfnetlink: support attribute policies
      [NETFILTER]: nfnetlink_log: use netlink policy
      [NETFILTER]: nfnetlink_queue: use netlink policy
      [NETFILTER]: ctnetlink: use netlink policy
      [NETFILTER]: nfnetlink: kill nlattr_bad_size
      [NETFILTER]: nf_conntrack: kill unique ID
      [NETFILTER]: nf_conntrack_expect: kill unique ID
