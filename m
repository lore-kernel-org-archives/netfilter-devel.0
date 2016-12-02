From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: merge udp and udplite helpers
Date: Fri,  2 Dec 2016 19:50:35 +0100
Message-ID: <1480704637-14994-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58638 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756009AbcLBSuU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:50:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Most of the code is copy&paste from the udp one; most of the udp
functions can be re-used for udplite.

After merge, udplite is another builtin available in the core.

before:
164288 nf_conntrack.ko
31472 nf_nat.ko
after:
165848 nf_conntrack.ko
32520 nf_nat.ko

removed:
11328 nf_conntrack_proto_udplite.ko
5480 nf_nat_proto_udplite.ko

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    1
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    1
 include/net/netfilter/nf_nat_l4proto.h         |    1
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1
 net/netfilter/Kconfig                          |   15
 net/netfilter/Makefile                         |    2
 net/netfilter/nf_conntrack_proto_udp.c         |  119 +++++++
 net/netfilter/nf_nat_core.c                    |    2
 net/netfilter/nf_nat_proto_udp.c               |   76 +++-
 net/netfilter/nf_conntrack_proto_udplite.c     |  385 -----------------------
 net/netfilter/nf_nat_proto_udplite.c           |  106 ------
 12 files changed, 191 insertions(+), 519 deletions(-)
