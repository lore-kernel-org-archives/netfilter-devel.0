From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/9] netfilter: don't copy initns hooks to new namespaces
Date: Fri, 23 Oct 2015 12:43:17 +0200
Message-ID: <1445597006-11264-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44998 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbbJWKnb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2015 06:43:31 -0400
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

To keep behaviour somewhat compatible, xtable hooks are registered once a
iptables set/getsockopt call is made within a net namespace.
This also means that e.g. conntrack behaviour is not yet optimal, we
still create all the data structures and only skip hook registration
at this time.

Caveats:
- conntrack is no longer active just by loading nf_conntrack module -- at
least one (x)tables rule that requires conntrack has to be added, e.g.
conntrack match or S/DNAT target.
Loading the nat table is *not* sufficient.

Changes since v1:
- Don't add a dependency on conntrack in the nat table.
It causes hard to resolve dependency problems on initcall ordering, f.e.
ip6tables nat will fail if link order caues nat table initcall before
conntrack_ipv6 initcall, and so on (also makes the patch set pretty much
useless with MODULES=n builds).
- change all targets and matches that need conntrack, including MASQUERADE,
  REDIRECT, SNAT/DNAT to register w. conntrack.
- get rid of a couple of refcount bugs.
- reduce amount of copy&pastry in iptable_foo modules.  For this to work
all the XXX_register_table() functions had to be extended with the location of
the table pointer storage, problem is that this must be setup by the time the
hook is registered since we can see packets right away.

Ads section:
conntrack+filter + nat table used in init namespace, single TCP_STREAM lo netperf:
87380  16384  16384    30.00    14348.66
with patch set, netperf running in net namespace without rules:
87380  16384  16384    30.00    15683.97

routing from ns3 -> ns2, filter + nat table & conntrack in all namespaces:
87380  16384  16384    30.00    5664.46
without conntrack+any tables in those namespaces:
87380  16384  16384    30.00    7336.54

Comments welcome.

 include/linux/netfilter.h                      |   29 ++++------
 include/linux/netfilter/x_tables.h             |    6 +-
 include/linux/netfilter_arp/arp_tables.h       |    9 +--
 include/linux/netfilter_ingress.h              |    9 ++-
 include/linux/netfilter_ipv4/ip_tables.h       |    9 +--
 include/linux/netfilter_ipv6/ip6_tables.h      |    9 +--
 include/net/netfilter/ipv4/nf_defrag_ipv4.h    |    3 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    3 -
 include/net/netfilter/nf_conntrack.h           |    4 +
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 +
 net/bridge/br_netfilter_hooks.c                |   68 +++++++++++++++++++++++--
 net/ipv4/netfilter/arp_tables.c                |   66 +++++++++++++++---------
 net/ipv4/netfilter/arptable_filter.c           |   39 ++++++++------
 net/ipv4/netfilter/ip_tables.c                 |   63 +++++++++++++----------
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    4 -
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    8 ++
 net/ipv4/netfilter/ipt_SYNPROXY.c              |    4 -
 net/ipv4/netfilter/iptable_filter.c            |   55 ++++++++++++--------
 net/ipv4/netfilter/iptable_mangle.c            |   41 ++++++++++-----
 net/ipv4/netfilter/iptable_nat.c               |   41 ++++++++-------
 net/ipv4/netfilter/iptable_raw.c               |   42 ++++++++++-----
 net/ipv4/netfilter/iptable_security.c          |   44 ++++++++++------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   62 ++++++++++++++++++----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   49 ++++++++++++++++--
 net/ipv4/netfilter/nft_masq_ipv4.c             |    7 ++
 net/ipv4/netfilter/nft_redir_ipv4.c            |    7 ++
 net/ipv6/netfilter/ip6_tables.c                |   65 ++++++++++++++---------
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |    4 -
 net/ipv6/netfilter/ip6table_filter.c           |   47 ++++++++++-------
 net/ipv6/netfilter/ip6table_mangle.c           |   45 +++++++++-------
 net/ipv6/netfilter/ip6table_nat.c              |   41 ++++++++-------
 net/ipv6/netfilter/ip6table_raw.c              |   46 ++++++++++------
 net/ipv6/netfilter/ip6table_security.c         |   44 +++++++++-------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   61 +++++++++++++++++-----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   50 ++++++++++++++++--
 net/ipv6/netfilter/nft_masq_ipv6.c             |    7 ++
 net/ipv6/netfilter/nft_redir_ipv6.c            |    7 ++
 net/netfilter/nf_conntrack_proto.c             |   48 +++++++++++++++++
 net/netfilter/nft_ct.c                         |   24 ++++----
 net/netfilter/nft_masq.c                       |    5 +
 net/netfilter/nft_nat.c                        |   11 +++-
 net/netfilter/nft_redir.c                      |    2 
 net/netfilter/x_tables.c                       |   65 ++++++++++++++---------
 net/netfilter/xt_CONNSECMARK.c                 |    4 -
 net/netfilter/xt_CT.c                          |    6 +-
 net/netfilter/xt_NETMAP.c                      |   11 +++-
 net/netfilter/xt_REDIRECT.c                    |   12 +++-
 net/netfilter/xt_TPROXY.c                      |   15 +++--
 net/netfilter/xt_connbytes.c                   |    4 -
 net/netfilter/xt_connlabel.c                   |    6 +-
 net/netfilter/xt_connlimit.c                   |    6 +-
 net/netfilter/xt_connmark.c                    |    8 +-
 net/netfilter/xt_conntrack.c                   |    4 -
 net/netfilter/xt_helper.c                      |    4 -
 net/netfilter/xt_nat.c                         |   18 ++++++
 net/netfilter/xt_socket.c                      |   33 ++++++++++--
 net/netfilter/xt_state.c                       |    4 -
 57 files changed, 970 insertions(+), 422 deletions(-)

