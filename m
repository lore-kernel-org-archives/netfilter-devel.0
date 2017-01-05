From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/4] netfilter: skbuff: merge nfctinfo bits and nfct pointer
Date: Thu,  5 Jan 2017 12:26:45 +0100
Message-ID: <1483615609-29155-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48196 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032320AbdAEL6w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 06:58:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Caveat: Patch #1 depends on 'netfilter: conntrack: validate SCTP crc32c in
PREROUTING' to be applied first, this patch is sitting in patchwork at
https://patchwork.ozlabs.org/patch/710170/ .

See individual patches for changes since v1.

Whenever we fetch skb conntrack info, we need to access two
distinct cache lines in sk_buff, #2 (nfct pointer) and #3
(nfctinfo bits).  This series removes nfctinfo and joins it
with the data pointer in a single ulong.

We have 3 nfctinfo bits, the slab cache used for nf_conn objects
guarantees at least 8 byte alignment so there is no overlap.

For the conntrack templates the situaton isn't obvious to me,
these get allocated via kmalloc which guarantees ARCH_KMALLOC_MINALIGN
(alignof(unsigned long long) so that begs the question if that is >= 8
on all arches or not.  I added a BUILD_BUG_ON test to catch
ARCH_KMALLOC_MINALIGN < 8, just in case.

If that triggers we'd need to align by hand in nf_ct_tmpl_alloc()
and store the padding in the conntrack somewhere.

But as its ugly I did not do this.

A followup series to this one will resurrect an old patch from
Pablo that adds an 'untracked' ctinfo status, this then allows
to get rid of the conntrack template object (which in turn avoids
get/put atomic ops for untracked skbs).

 include/linux/skbuff.h                         |   30 ++++++++++--------
 include/net/ip_vs.h                            |   11 ++++--
 include/net/netfilter/nf_conntrack.h           |   10 ++++--
 include/net/netfilter/nf_conntrack_core.h      |    2 -
 include/net/netfilter/nf_conntrack_l4proto.h   |    2 -
 net/core/skbuff.c                              |    2 -
 net/ipv4/netfilter/ipt_SYNPROXY.c              |   11 +++---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   16 ++++-----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    4 +-
 net/ipv4/netfilter/nf_dup_ipv4.c               |   11 ++++--
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |   11 +++---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   22 ++++++-------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    4 +-
 net/ipv6/netfilter/nf_dup_ipv6.c               |   12 ++++---
 net/netfilter/core.c                           |    2 -
 net/netfilter/nf_conntrack_core.c              |   41 ++++++++++++-------------
 net/netfilter/nf_conntrack_proto_dccp.c        |    1 
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 -
 net/netfilter/nf_conntrack_proto_tcp.c         |    1 
 net/netfilter/nf_conntrack_proto_udp.c         |    3 -
 net/netfilter/nf_conntrack_standalone.c        |    4 ++
 net/netfilter/nf_nat_helper.c                  |    2 -
 net/netfilter/nft_ct.c                         |    3 -
 net/netfilter/xt_CT.c                          |   13 +++----
 net/openvswitch/conntrack.c                    |   22 ++++++-------
 net/sched/cls_flow.c                           |    2 -
 26 files changed, 130 insertions(+), 114 deletions(-)
