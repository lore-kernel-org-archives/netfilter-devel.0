From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 0/8] netfilter: don't copy init ns hooks to new namespaces
Date: Fri,  2 Oct 2015 13:49:09 +0200
Message-ID: <1443786557-21315-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50299 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbbJBLt1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 07:49:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Historically, a particular table or netfilter feature (defrag, iptables
filter table ...) was registered with the netfilter core hook mechanism
on module load.

When netns support was added to iptables only the ip/ip6tables ruleset
was made namespace aware, not the actual hook points.

This has changed -- after Eric Biedermans recent work we now have
per net namespace hooks.

When a new namespace is created, all the hooks registered 'globally'
(i.e. via nf_register_hook() instead of a particular namespace via
 nf_register_net_hook api) get copied to the new netns.

This means f.e. that when ipt_filter table/module is loaded on a system,
then each namespace on that system has an (empty) iptables filter ruleset.

This work aims to change all major hook users to nf_register_net_hook
so that when a new netns is created it has no hooks at all, even when the
initial namespace uses conntrack, iptables and bridge netfilter.

To keep bahaviour somewhat compatible, hooks are registered once a
iptables set/getsockopt call is made within a net namespace.
This also means that e.g. conntrack behaviour is not yet optimal, we
still create all the data structures and only skip hook registration
at this time.

Note that I expect that I will need several iterations of this patch set,
I am sending this now so that reviewing can commence and to benefit from
recent addition of kbuild robot magic to patchwork (this is awesome,
thanks a lot!).

The patch set survives allmodconfig build with NAMESPACES=y and =N.

If anyone has further ideas on how to improve this, please let me know.

 include/linux/netfilter.h                      |   29 +++------
 include/linux/netfilter/x_tables.h             |   10 ++-
 include/linux/netfilter_ingress.h              |    9 ++-
 include/net/netfilter/ipv4/nf_defrag_ipv4.h    |    3 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    3 -
 include/net/netfilter/nf_conntrack.h           |    4 +
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 +
 net/bridge/br_netfilter_hooks.c                |   68 ++++++++++++++++++++++-
 net/ipv4/netfilter/arptable_filter.c           |   39 ++++++++-----
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    4 -
 net/ipv4/netfilter/ipt_SYNPROXY.c              |    4 -
 net/ipv4/netfilter/iptable_filter.c            |   65 ++++++++++++++++------
 net/ipv4/netfilter/iptable_mangle.c            |   50 +++++++++++++----
 net/ipv4/netfilter/iptable_nat.c               |   55 +++++++++++++-----
 net/ipv4/netfilter/iptable_raw.c               |   50 +++++++++++++----
 net/ipv4/netfilter/iptable_security.c          |   52 +++++++++++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   62 +++++++++++++++++----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   49 +++++++++++++++-
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |    4 -
 net/ipv6/netfilter/ip6table_filter.c           |   54 +++++++++++++-----
 net/ipv6/netfilter/ip6table_mangle.c           |   53 +++++++++++++-----
 net/ipv6/netfilter/ip6table_nat.c              |   55 +++++++++++++-----
 net/ipv6/netfilter/ip6table_raw.c              |   54 +++++++++++++-----
 net/ipv6/netfilter/ip6table_security.c         |   53 +++++++++++++-----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   60 ++++++++++++++++----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   50 +++++++++++++++--
 net/netfilter/nf_conntrack_proto.c             |   48 ++++++++++++++++
 net/netfilter/nft_ct.c                         |   24 ++++----
 net/netfilter/x_tables.c                       |   73 ++++++++++++++++++-------
 net/netfilter/xt_CONNSECMARK.c                 |    4 -
 net/netfilter/xt_CT.c                          |    6 +-
 net/netfilter/xt_TPROXY.c                      |   15 +++--
 net/netfilter/xt_connbytes.c                   |    4 -
 net/netfilter/xt_connlabel.c                   |    6 +-
 net/netfilter/xt_connlimit.c                   |    6 +-
 net/netfilter/xt_connmark.c                    |    8 +-
 net/netfilter/xt_conntrack.c                   |    2 
 net/netfilter/xt_helper.c                      |    4 -
 net/netfilter/xt_socket.c                      |   33 +++++++++--
 net/netfilter/xt_state.c                       |    4 -
 40 files changed, 893 insertions(+), 287 deletions(-)
