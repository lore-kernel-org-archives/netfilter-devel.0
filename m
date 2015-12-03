From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 0/12] netfilter: don't copy init ns hooks to new namespaces
Date: Thu,  3 Dec 2015 10:49:33 +0100
Message-ID: <1449136185-4165-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52597 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932871AbbLCJt4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Dec 2015 04:49:56 -0500
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

My problem with this patch set is the ridiculous amount of code that needs
to be added to cover all the 'register the hooks for conntrack' cases.

We now have an ingress hook point for nftables, so it would make sense
to also allow hooking conntrack at ingress point.

IOW, it might be a much better idea to respin this patch series so
that it does NOT contain any of the conntrack changes (only 'don't register
xtables hooks + don't register bridge hooks), and then add
net.netfilter.nf_conntrack_disable (or whatever), plus -j CT --track.

That would also solve this issue, albeit not by default and it leaves
the question of how we should deal with defragmentation
(-s 10.2.3.0/24 -p tcp --dport 80 would not work reliably).

Perhaps we could attempt to propogate a *conntrack rule active* bit into
the xtables core and call defrag from there.  Another, simpler alternative
would be to stick an unconditional 'defrag' call into the raw table.

Comments, ideas?

Other Caveats:
- conntrack is no longer active just by loading nf_conntrack module -- at
least one (x)tables rule that requires conntrack has to be added, e.g.
conntrack match or S/DNAT target.
Loading the nat table is *not* sufficient.

Changes since v2:
Pablo pointed out problems with setups that only use ctnetlink
(but have no rules that make use of conntrack), I added a few
patches to the series (at the end) to address these, but they're quite
ugly :-/

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

 include/linux/netfilter.h                      |   31 ++----
 include/linux/netfilter/nfnetlink.h            |    1 
 include/linux/netfilter/x_tables.h             |    6 -
 include/linux/netfilter_arp/arp_tables.h       |    9 +
 include/linux/netfilter_ipv4/ip_tables.h       |    9 +
 include/linux/netfilter_ipv6/ip6_tables.h      |    9 +
 include/net/netfilter/ipv4/nf_defrag_ipv4.h    |    3 
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    3 
 include/net/netfilter/nf_conntrack.h           |    4 
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 
 net/bridge/br_netfilter_hooks.c                |   68 +++++++++++++
 net/ipv4/netfilter/arp_tables.c                |   66 ++++++++-----
 net/ipv4/netfilter/arptable_filter.c           |   40 ++++----
 net/ipv4/netfilter/ip_tables.c                 |   63 +++++++-----
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    4 
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    8 +
 net/ipv4/netfilter/ipt_SYNPROXY.c              |    4 
 net/ipv4/netfilter/iptable_filter.c            |   55 +++++++----
 net/ipv4/netfilter/iptable_mangle.c            |   41 +++++---
 net/ipv4/netfilter/iptable_nat.c               |   41 ++++----
 net/ipv4/netfilter/iptable_raw.c               |   42 +++++---
 net/ipv4/netfilter/iptable_security.c          |   44 +++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   77 +++++++++++++--
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   49 +++++++++-
 net/ipv4/netfilter/nft_masq_ipv4.c             |    7 +
 net/ipv4/netfilter/nft_redir_ipv4.c            |    7 +
 net/ipv6/netfilter/ip6_tables.c                |   65 ++++++++-----
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |    4 
 net/ipv6/netfilter/ip6table_filter.c           |   47 +++++----
 net/ipv6/netfilter/ip6table_mangle.c           |   45 +++++----
 net/ipv6/netfilter/ip6table_nat.c              |   41 ++++----
 net/ipv6/netfilter/ip6table_raw.c              |   46 +++++----
 net/ipv6/netfilter/ip6table_security.c         |   44 +++++----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   76 ++++++++++++---
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   50 +++++++++-
 net/ipv6/netfilter/nft_masq_ipv6.c             |    7 +
 net/ipv6/netfilter/nft_redir_ipv6.c            |    7 +
 net/netfilter/nf_conntrack_netlink.c           |  122 +++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto.c             |   54 +++++++++++
 net/netfilter/nfnetlink.c                      |   48 ++++++---
 net/netfilter/nfnetlink_log.c                  |   28 +++--
 net/netfilter/nfnetlink_queue.c                |    8 +
 net/netfilter/nft_ct.c                         |   24 ++--
 net/netfilter/nft_masq.c                       |    5 -
 net/netfilter/nft_nat.c                        |   11 ++
 net/netfilter/nft_redir.c                      |    2 
 net/netfilter/x_tables.c                       |   65 ++++++++-----
 net/netfilter/xt_CONNSECMARK.c                 |    4 
 net/netfilter/xt_CT.c                          |    6 -
 net/netfilter/xt_NETMAP.c                      |   11 +-
 net/netfilter/xt_REDIRECT.c                    |   12 ++
 net/netfilter/xt_TPROXY.c                      |   15 ++-
 net/netfilter/xt_connbytes.c                   |    4 
 net/netfilter/xt_connlabel.c                   |    6 -
 net/netfilter/xt_connlimit.c                   |    6 -
 net/netfilter/xt_connmark.c                    |    8 -
 net/netfilter/xt_conntrack.c                   |    4 
 net/netfilter/xt_helper.c                      |    4 
 net/netfilter/xt_nat.c                         |   18 +++
 net/netfilter/xt_socket.c                      |   33 +++++-
 net/netfilter/xt_state.c                       |    4 
 61 files changed, 1186 insertions(+), 443 deletions(-)
