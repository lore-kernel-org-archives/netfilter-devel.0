From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 00/15] Netfilter pernet hook support
Date: Mon, 15 Jun 2015 17:46:42 +0200
Message-ID: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: ebiederm@xmission.com, aschultz@warp10.net, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36817 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbbFOPln (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 11:41:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is a first version RFC patchset to add pernet hook support to Netfilter,
with basically almost no testing here so far.

The initial three patches try to address a problem in the existing netfilter
netns header files. Basically, it's not a good idea to include
linux/netfilter.h from net/netns/netfilter.h. This is pulling quite a lot of
definitions from everything that includes net/net_namespace.h that are not
required.

It follows the initial patch to introduce of the pernet support for
nf_register_hook(). Initially, all callers are converted to use init_net.
Unlike Eric Bierderman's approach, there is no new parameter struct net from
any of the NF_HOOK(), NF_HOOK_COND() and nf_hook() but I prefer his approach
since we can avoid the dev_net(indev) ? ... branch.

Then, you get the bunch converted to use the pernet hooks by introducing the
boiler plate code to duplicate the existing nf_hooks_ops struct and register
it.

Pablo Neira Ayuso (15):
  net: include missing headers in net/net_namespace.h
  netfilter: use forward declaration instead of including linux/proc_fs.h
  netfilter: don't pull include/linux/netfilter.h from netns headers
  netfilter: add pernet hook support
  netfilter: ipt_CLUSTERIP: adapt it to support pernet hooks
  netfilter: x_tables: adapt xt_hook_link() to support pernet hooks
  netfilter: x_tables: adapt tables to pernet hooks
  netfilter: nf_conntrack: adapt IPv4 and IPv6 trackers to pernet hooks
  netfilter: synproxy: adapt IPv4 and IPv6 targets to pernet hooks
  netfilter: defrag: add pernet hook support
  ipvs: adapt it to pernet hooks
  netfilter: ebtables: adapt the filter and nat table to pernet hooks
  netfilter: nf_tables: adapt it to pernet hooks
  security: adapt it to pernet hooks
  netfilter: bridge: adapt it to pernet hooks

 include/linux/netfilter.h                      |   33 +++--
 include/linux/netfilter/x_tables.h             |    5 +-
 include/linux/netfilter_arp/arp_tables.h       |    3 +-
 include/linux/netfilter_defs.h                 |    9 ++
 include/linux/netfilter_ingress.h              |    6 +-
 include/linux/netfilter_ipv4/ip_tables.h       |    8 +-
 include/linux/netfilter_ipv6/ip6_tables.h      |    8 +-
 include/net/ip_vs.h                            |    3 +
 include/net/net_namespace.h                    |    2 +
 include/net/netfilter/br_netfilter.h           |   52 +++++++
 include/net/netns/conntrack.h                  |    4 +
 include/net/netns/netfilter.h                  |   27 +++-
 include/net/netns/x_tables.h                   |    4 +-
 include/uapi/linux/netfilter.h                 |    3 +-
 net/bridge/br_netfilter.c                      |  171 ++++++++++++++----------
 net/bridge/netfilter/ebtable_filter.c          |   41 ++++--
 net/bridge/netfilter/ebtable_nat.c             |   41 ++++--
 net/core/dev.c                                 |    6 +-
 net/decnet/netfilter/dn_rtmsg.c                |    2 +-
 net/ipv4/netfilter/arp_tables.c                |   15 ++-
 net/ipv4/netfilter/arptable_filter.c           |   25 +---
 net/ipv4/netfilter/ip_tables.c                 |   46 ++++++-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   31 +++--
 net/ipv4/netfilter/ipt_SYNPROXY.c              |   51 ++++++-
 net/ipv4/netfilter/iptable_filter.c            |   21 +--
 net/ipv4/netfilter/iptable_mangle.c            |   21 +--
 net/ipv4/netfilter/iptable_nat.c               |   54 +++++---
 net/ipv4/netfilter/iptable_raw.c               |   20 +--
 net/ipv4/netfilter/iptable_security.c          |   24 +---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   36 +++--
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   37 ++++-
 net/ipv6/netfilter/ip6_tables.c                |   42 +++++-
 net/ipv6/netfilter/ip6t_SYNPROXY.c             |   52 ++++++-
 net/ipv6/netfilter/ip6table_filter.c           |   25 +---
 net/ipv6/netfilter/ip6table_mangle.c           |   24 +---
 net/ipv6/netfilter/ip6table_nat.c              |   54 +++++---
 net/ipv6/netfilter/ip6table_raw.c              |   24 +---
 net/ipv6/netfilter/ip6table_security.c         |   24 +---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   45 ++++---
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   40 +++++-
 net/ipv6/output_core.c                         |    1 +
 net/netfilter/core.c                           |   26 ++--
 net/netfilter/ipvs/ip_vs_core.c                |   42 ++++--
 net/netfilter/nf_queue.c                       |    2 +-
 net/netfilter/nf_synproxy_core.c               |    1 +
 net/netfilter/nf_tables_api.c                  |   12 +-
 net/netfilter/x_tables.c                       |    5 +-
 security/selinux/hooks.c                       |   41 +++++-
 security/smack/smack_netfilter.c               |    3 +-
 49 files changed, 845 insertions(+), 427 deletions(-)
 create mode 100644 include/linux/netfilter_defs.h

-- 
1.7.10.4

