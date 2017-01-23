From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 0/7] netfilter: skbuff: merge nfctinfo bits and nfct pointer
Date: Mon, 23 Jan 2017 18:21:52 +0100
Message-ID: <1485192119-6144-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51176 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750732AbdAWRVo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 12:21:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Whenever we fetch skb conntrack info, we need to access two
distinct cache lines in sk_buff, #2 (nfct pointer) and #3
(nfctinfo bits).  This series removes nfctinfo and joins it
with the data pointer in a single ulong.

We have 3 nfctinfo bits, the slab cache used for nf_conn objects
guarantees at least 8 byte alignment so there is no overlap.

For the conntrack templates most arches also guarantee an
8 byte minalign, but not all.

Patch #6 adds manual alignment of the templates if
ARCH_KMALLOC_MINALIGN isn't sufficient.

A followup series to this one will resurrect an old patch from
Pablo that adds an 'untracked' ctinfo status, this then allows
to get rid of the conntrack template object (which in turn avoids
get/put atomic ops for untracked skbs).

See individual patches for changes since v3.

 include/linux/skbuff.h                         |   34 ++++++-----
 include/net/ip_vs.h                            |   12 ++--
 include/net/netfilter/nf_conntrack.h           |   21 +++++--
 include/net/netfilter/nf_conntrack_core.h      |    2 
 include/net/netfilter/nf_conntrack_l4proto.h   |    2 
 net/core/skbuff.c                              |    2 
 net/ipv4/netfilter/ipt_SYNPROXY.c              |   11 +--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   17 ++---
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    4 -
 net/ipv4/netfilter/nf_dup_ipv4.c               |    7 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |   11 +--
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   22 +++----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    4 -
 net/ipv6/netfilter/nf_dup_ipv6.c               |    7 +-
 net/netfilter/core.c                           |    2 
 net/netfilter/nf_conntrack_core.c              |   73 +++++++++++++++----------
 net/netfilter/nf_conntrack_proto_dccp.c        |    1 
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 
 net/netfilter/nf_conntrack_proto_tcp.c         |    1 
 net/netfilter/nf_conntrack_proto_udp.c         |    3 -
 net/netfilter/nf_conntrack_standalone.c        |    3 +
 net/netfilter/nf_nat_helper.c                  |    2 
 net/netfilter/nft_ct.c                         |    3 -
 net/netfilter/xt_CT.c                          |   12 +---
 net/openvswitch/conntrack.c                    |   12 +---
 net/sched/cls_flow.c                           |    2 
 26 files changed, 147 insertions(+), 125 deletions(-)

