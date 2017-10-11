From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: remove pf argument from conntrack l4 packet function
Date: Wed, 11 Oct 2017 10:47:39 +0200
Message-ID: <20171011084742.25989-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39180 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756569AbdJKIrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2017 04:47:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We currently pass pf to the packet() function of the l4 trackers,
but this isn't needed -- its only required for the 'log invalid' check
and the l4 protocol is also available in the nf_conn entry.

This series adds helpers for logging invalid packets, similar
to nf_ct_helper_log().
I added a __cold annotation, it makes gcc rearrange the callsites as they
are then considered unlikely and moved away from hotpath.

After this change, packet() gets passed 5 instead of 6 arguments.

 include/net/netfilter/nf_conntrack_l4proto.h   |   21 +++++++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   19 ++++----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   15 +++----
 net/netfilter/nf_conntrack_core.c              |    2 
 net/netfilter/nf_conntrack_proto.c             |   47 ++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_dccp.c        |   21 ++-------
 net/netfilter/nf_conntrack_proto_generic.c     |    1 
 net/netfilter/nf_conntrack_proto_gre.c         |    1 
 net/netfilter/nf_conntrack_proto_sctp.c        |    4 -
 net/netfilter/nf_conntrack_proto_tcp.c         |   53 +++++++++----------------
 net/netfilter/nf_conntrack_proto_udp.c         |   41 ++++++++-----------
 11 files changed, 128 insertions(+), 97 deletions(-)
