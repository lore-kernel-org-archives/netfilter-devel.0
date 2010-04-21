From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: two small ones
Date: Wed, 21 Apr 2010 15:21:08 +0200
Message-ID: <1271856071-32179-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58565 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0DUNVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:21:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit d97a9e47ba148cfc41e354c5cd241f472273207c:
  Jan Engelhardt (1):
        netfilter: x_tables: move sleeping allocation outside BH-disabled region

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (2):
      nefilter: use pr_devel instead of pr_debug
      netfilter: rectify XT_FUNCTION_MAXNAMELEN usage

 include/linux/netfilter/x_tables.h             |   19 ++---
 net/bridge/netfilter/ebt_ulog.c                |    8 +-
 net/bridge/netfilter/ebt_vlan.c                |   14 ++--
 net/bridge/netfilter/ebtables.c                |    6 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   12 ++--
 net/ipv4/netfilter/ipt_LOG.c                   |    4 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    4 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |    4 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |    4 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |   28 +++---
 net/ipv4/netfilter/ipt_ah.c                    |    8 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    8 +-
 net/ipv4/netfilter/nf_nat_core.c               |    6 +-
 net/ipv4/netfilter/nf_nat_ftp.c                |    4 +-
 net/ipv4/netfilter/nf_nat_h323.c               |   18 ++--
 net/ipv4/netfilter/nf_nat_helper.c             |   16 ++--
 net/ipv4/netfilter/nf_nat_irc.c                |    2 +-
 net/ipv4/netfilter/nf_nat_pptp.c               |   18 ++--
 net/ipv4/netfilter/nf_nat_proto_gre.c          |   10 +-
 net/ipv4/netfilter/nf_nat_rule.c               |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c                  |    4 +-
 net/ipv6/netfilter/ip6t_REJECT.c               |   14 ++--
 net/ipv6/netfilter/ip6t_ah.c                   |   18 ++--
 net/ipv6/netfilter/ip6t_frag.c                 |   26 +++---
 net/ipv6/netfilter/ip6t_hbh.c                  |   26 +++---
 net/ipv6/netfilter/ip6t_mh.c                   |    4 +-
 net/ipv6/netfilter/ip6t_rt.c                   |   42 +++++-----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    8 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   44 +++++-----
 net/netfilter/ipvs/ip_vs_proto.c               |    4 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c        |    4 +-
 net/netfilter/nf_conntrack_core.c              |   32 ++++----
 net/netfilter/nf_conntrack_ftp.c               |   48 ++++++------
 net/netfilter/nf_conntrack_h323_main.c         |  106 ++++++++++++------------
 net/netfilter/nf_conntrack_helper.c            |    2 +-
 net/netfilter/nf_conntrack_irc.c               |    8 +-
 net/netfilter/nf_conntrack_pptp.c              |   44 +++++-----
 net/netfilter/nf_conntrack_proto_gre.c         |   18 ++--
 net/netfilter/nf_conntrack_proto_sctp.c        |   44 +++++-----
 net/netfilter/nf_conntrack_proto_tcp.c         |   28 +++---
 net/netfilter/nf_conntrack_sane.c              |   10 +-
 net/netfilter/nf_conntrack_sip.c               |    8 +-
 net/netfilter/nf_conntrack_tftp.c              |    8 +-
 net/netfilter/nf_tproxy_core.c                 |    2 +-
 net/netfilter/x_tables.c                       |    4 +-
 net/netfilter/xt_TPROXY.c                      |    4 +-
 net/netfilter/xt_esp.c                         |    8 +-
 net/netfilter/xt_iprange.c                     |    4 +-
 net/netfilter/xt_multiport.c                   |    6 +-
 net/netfilter/xt_sctp.c                        |   12 ++--
 net/netfilter/xt_socket.c                      |    2 +-
 net/netfilter/xt_tcpudp.c                      |    8 +-
 55 files changed, 405 insertions(+), 408 deletions(-)
