From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/3] netfilter: conntrack: make l4 tracker structs const
Date: Tue,  7 Nov 2017 07:20:06 +0100
Message-ID: <20171107062009.2519-1-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49102 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753498AbdKGGUV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2017 01:20:21 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <fw@breakpoint.cc>)
        id 1eBxEf-0000cD-Mo
        for netfilter-devel@vger.kernel.org; Tue, 07 Nov 2017 07:19:46 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set removes the last runtime write accesses to the l4
protocol tracker structs, then marks them as 'const'.

Resending, seems only first patchi (not resent) made it to
list/patchwork.

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   12 ++++++------
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   12 ++++++------
 include/net/netfilter/nf_conntrack_l4proto.h   |   19 +++++++++----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c           |    2 +-
 net/netfilter/nf_conntrack_proto.c             |   18 +++++++-----------
 net/netfilter/nf_conntrack_proto_dccp.c        |   21 ++++++++++-----------
 net/netfilter/nf_conntrack_proto_generic.c     |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |   19 +++++++++----------
 net/netfilter/nf_conntrack_proto_tcp.c         |   20 ++++++++++----------
 net/netfilter/nf_conntrack_proto_udp.c         |    8 ++++----
 15 files changed, 68 insertions(+), 75 deletions(-)

