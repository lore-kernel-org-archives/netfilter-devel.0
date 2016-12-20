From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/2] netfilter: merge udp and udplite trackers
Date: Tue, 20 Dec 2016 21:57:01 +0100
Message-ID: <1482267423-1411-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38694 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758058AbcLTU4t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2016 15:56:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Most of the code is copy&paste from the udp one; most of the udp
functions can also be used for udplite.

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    1
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    1
 include/net/netns/conntrack.h                  |   16 -
 net/netfilter/Makefile                         |    2
 net/netfilter/nf_conntrack_proto_udp.c         |  123 ++++++++
 net/netfilter/nf_nat_proto_udp.c               |   78 ++++-
 net/netfilter/nf_conntrack_proto_udplite.c     |  324 -----------------------
 net/netfilter/nf_nat_proto_udplite.c           |   73 -----
 8 files changed, 191 insertions(+), 427 deletions(-)

