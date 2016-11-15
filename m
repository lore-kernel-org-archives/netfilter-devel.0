From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 nf-next] netfilter: allow disabling conntrack-on-by-default
Date: Tue, 15 Nov 2016 21:36:38 +0100
Message-ID: <1479242205-21675-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45074 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752742AbcKOUg2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 15:36:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Historically all the netfilter hooks got registered on module load time.

When net namespace support was added, hooks were registered in each
namespace (and new net namespaces inherit already-registered hooks from
global list).

This means that once nf_conntrack_ipv4/6.ko is loaded, all
existing and future net namespaces do connection tracking.

This series adds a new sysctl, nf_conntrack_default_on, that can be set
to 0 to disable this behaviour.

Once its set to 0, conntrack hooks are not registered in newly created
net namespaces, and new l3 protocol trackers are not registered with any
existing namespaces either.

The setting does NOT disable already-active connection tracking
in existing namespaces.

connection tracking is enabled via packet filter ruleset, regardless of
the sysctl setting, once a rule that needs conntrack functionality is
added (e.g. iptables -m conntrack, targets like SNAT/DNAT or nftables
equivalents make sure the hooks get registered, and deleted, as needed).

It is currently NOT possible to disable connection tracking inside a
net namespace that had its hooks registered implicitly due to
nf_conntrack_default_on=1 (except unloading the l3 tracker module).

Comments welcome.

 Documentation/networking/nf_conntrack-sysctl.txt |   11 +++
 include/net/netfilter/ipv4/nf_defrag_ipv4.h      |    3 
 include/net/netfilter/ipv6/nf_defrag_ipv6.h      |    3 
 include/net/netfilter/nf_conntrack.h             |    4 +
 include/net/netfilter/nf_conntrack_l3proto.h     |   16 ++++-
 include/net/netns/conntrack.h                    |    2 
 net/ipv4/netfilter/ipt_CLUSTERIP.c               |    4 -
 net/ipv4/netfilter/ipt_MASQUERADE.c              |    8 ++
 net/ipv4/netfilter/ipt_SYNPROXY.c                |    4 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c   |   62 ++++++++++++++-----
 net/ipv4/netfilter/nf_defrag_ipv4.c              |   41 +++++++++++-
 net/ipv4/netfilter/nft_masq_ipv4.c               |    7 ++
 net/ipv4/netfilter/nft_redir_ipv4.c              |    7 ++
 net/ipv6/netfilter/ip6t_SYNPROXY.c               |    4 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c   |   61 +++++++++++++++----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c        |   42 +++++++++++--
 net/ipv6/netfilter/nft_masq_ipv6.c               |    7 ++
 net/ipv6/netfilter/nft_redir_ipv6.c              |    7 ++
 net/netfilter/nf_conntrack_proto.c               |   73 ++++++++++++++++++++---
 net/netfilter/nf_conntrack_standalone.c          |   10 +++
 net/netfilter/nft_ct.c                           |   26 ++++----
 net/netfilter/nft_masq.c                         |    2 
 net/netfilter/nft_nat.c                          |   11 +++
 net/netfilter/nft_redir.c                        |    2 
 net/netfilter/xt_CONNSECMARK.c                   |    4 -
 net/netfilter/xt_CT.c                            |    6 -
 net/netfilter/xt_NETMAP.c                        |   11 ++-
 net/netfilter/xt_REDIRECT.c                      |   12 +++
 net/netfilter/xt_TPROXY.c                        |   15 +++-
 net/netfilter/xt_connbytes.c                     |    4 -
 net/netfilter/xt_connlabel.c                     |    6 -
 net/netfilter/xt_connlimit.c                     |    6 -
 net/netfilter/xt_connmark.c                      |    8 +-
 net/netfilter/xt_conntrack.c                     |    4 -
 net/netfilter/xt_helper.c                        |    4 -
 net/netfilter/xt_nat.c                           |   18 +++++
 net/netfilter/xt_socket.c                        |   33 ++++++++--
 net/netfilter/xt_state.c                         |    4 -
 38 files changed, 443 insertions(+), 109 deletions(-)
