From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: conntrack: make l4 tracker structs const
Date: Thu,  2 Nov 2017 19:41:08 +0100
Message-ID: <20171102184112.32584-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60412 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933748AbdKBSkz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2017 14:40:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set removes the last runtime write accesses to the l4
protocol tracker structs, then marks them as 'const'.

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   12 +++++------
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   12 +++++------
 include/net/netfilter/nf_conntrack_l4proto.h   |   23 ++++++++++-----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   11 +++++++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   11 +++++++---
 net/netfilter/nf_conntrack_core.c              |    9 ++++++--
 net/netfilter/nf_conntrack_netlink.c           |   12 +++++++----
 net/netfilter/nf_conntrack_proto.c             |   20 ++++++------------
 net/netfilter/nf_conntrack_proto_dccp.c        |   21 +++++++++----------
 net/netfilter/nf_conntrack_proto_generic.c     |    2 -
 net/netfilter/nf_conntrack_proto_gre.c         |    2 -
 net/netfilter/nf_conntrack_proto_sctp.c        |   19 ++++++++---------
 net/netfilter/nf_conntrack_proto_tcp.c         |   27 ++++++++++++++-----------
 net/netfilter/nf_conntrack_proto_udp.c         |    8 +++----
 16 files changed, 104 insertions(+), 89 deletions(-)

