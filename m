From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/09]: Use generic netlink functions for nfnetlink
Date: Thu, 27 Sep 2007 15:45:59 +0200 (MEST)
Message-ID: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXI0NqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I've queued these patches which convert nfnetlink to use the generic
netlink functions. Will push upstream after a bit more testing. Comments,
review and patches on top to use the typeful attribute parsing/dumping
functions (NLA_PUT_BE32, nla_get_u32, ...) welcome :)


 include/linux/netfilter/Kbuild                 |    1 +
 include/linux/netfilter/nfnetlink.h            |   98 +-----
 include/linux/netfilter/nfnetlink_compat.h     |   61 +++
 include/net/netfilter/nf_conntrack_helper.h    |    2 +-
 include/net/netfilter/nf_conntrack_l3proto.h   |    9 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |   17 +-
 include/net/netfilter/nf_nat_protocol.h        |    8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   30 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   40 +-
 net/ipv4/netfilter/nf_nat_core.c               |   22 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |    4 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |    4 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c          |    4 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   30 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   40 +-
 net/netfilter/nf_conntrack_core.c              |   31 +-
 net/netfilter/nf_conntrack_netlink.c           |  498 ++++++++++++-----------
 net/netfilter/nf_conntrack_proto_gre.c         |    5 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |   87 +++--
 net/netfilter/nf_conntrack_proto_udp.c         |   10 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |   10 +-
 net/netfilter/nfnetlink.c                      |  107 ++----
 net/netfilter/nfnetlink_log.c                  |  155 ++++-----
 net/netfilter/nfnetlink_queue.c                |  133 +++----
 25 files changed, 665 insertions(+), 745 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_compat.h

Patrick McHardy (9):
      [NETFILTER]: nfnetlink: make subsystem and callbacks const
      [NETFILTER]: nfnetlink: convert to generic netlink attribute functions
      [NETFILTER]: nfnetlink: rename functions containing 'nfattr'
      [NETFILTER]: nfnetlink: use nlmsg_notify()
      [NETFILTER]: nfnetlink: support attribute policies
      [NETFILTER]: nfnetlink_log: use netlink policy
      [NETFILTER]: nfnetlink_queue: use netlink policy
      [NETFILTER]: ctnetlink: use netlink policy
      [NETFILTER]: nfnetlink: kill nlattr_bad_size
