From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: error codes
Date: Thu, 25 Mar 2010 17:04:12 +0100
Message-ID: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41674 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0CYQEd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:04:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


(JFYI, the next pull group will be hashlimit v0 removal.)


The following changes since commit 5dc7a6d5749d3ddbf9fbea9512cb45762428512c:
  Jan Engelhardt (1):
        netfilter: xt_recent: allow changing ip_list_[ug]id at runtime

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (12):
      netfilter: bridge: use NFPROTO values for NF_HOOK invocation
      netfilter: ipv4: use NFPROTO values for NF_HOOK invocation
      netfilter: ipv6: use NFPROTO values for NF_HOOK invocation
      netfilter: decnet: use NFPROTO values for NF_HOOK invocation
      netfilter: ipvs: use NFPROTO values for NF_HOOK invocation
      netfilter: xtables: untangle spaghetti if clauses in checkentry
      netfilter: xtables: change xt_match.checkentry return type
      netfilter: xtables: change xt_target.checkentry return type
      netfilter: xtables: change matches to return error code
      netfilter: xtables: change targets to return error code
      netfilter: xtables: slightly better error reporting
      netfilter: xtables: shorten up return clause

 include/linux/netfilter/x_tables.h      |    6 ++--
 net/bridge/br_forward.c                 |   10 +++---
 net/bridge/br_input.c                   |    6 ++--
 net/bridge/br_multicast.c               |    2 +-
 net/bridge/br_netfilter.c               |   15 ++++----
 net/bridge/br_stp_bpdu.c                |    2 +-
 net/bridge/netfilter/ebt_802_3.c        |    6 ++--
 net/bridge/netfilter/ebt_among.c        |   10 +++---
 net/bridge/netfilter/ebt_arp.c          |    8 ++--
 net/bridge/netfilter/ebt_arpreply.c     |    8 ++--
 net/bridge/netfilter/ebt_dnat.c         |   10 +++---
 net/bridge/netfilter/ebt_ip.c           |   16 ++++----
 net/bridge/netfilter/ebt_ip6.c          |   16 ++++----
 net/bridge/netfilter/ebt_limit.c        |    6 ++--
 net/bridge/netfilter/ebt_log.c          |    8 ++--
 net/bridge/netfilter/ebt_mark.c         |   10 +++---
 net/bridge/netfilter/ebt_mark_m.c       |   10 +++---
 net/bridge/netfilter/ebt_nflog.c        |    6 ++--
 net/bridge/netfilter/ebt_pkttype.c      |    6 ++--
 net/bridge/netfilter/ebt_redirect.c     |   10 +++---
 net/bridge/netfilter/ebt_snat.c         |   10 +++---
 net/bridge/netfilter/ebt_stp.c          |    8 ++--
 net/bridge/netfilter/ebt_ulog.c         |    6 ++--
 net/bridge/netfilter/ebt_vlan.c         |   16 ++++----
 net/decnet/dn_neigh.c                   |    9 +++--
 net/decnet/dn_nsp_in.c                  |    3 +-
 net/decnet/dn_route.c                   |   28 +++++++++++----
 net/ipv4/ip_forward.c                   |    4 +-
 net/ipv4/ip_input.c                     |    4 +-
 net/ipv4/ip_output.c                    |   18 +++++-----
 net/ipv4/ipmr.c                         |    2 +-
 net/ipv4/netfilter/arpt_mangle.c        |    2 +-
 net/ipv4/netfilter/ip_tables.c          |    4 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c      |   24 ++++++-------
 net/ipv4/netfilter/ipt_ECN.c            |   10 +++---
 net/ipv4/netfilter/ipt_LOG.c            |    8 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c     |    8 ++--
 net/ipv4/netfilter/ipt_NETMAP.c         |    8 ++--
 net/ipv4/netfilter/ipt_REDIRECT.c       |    8 ++--
 net/ipv4/netfilter/ipt_REJECT.c         |    8 ++--
 net/ipv4/netfilter/ipt_ULOG.c           |    8 ++--
 net/ipv4/netfilter/ipt_addrtype.c       |   10 +++---
 net/ipv4/netfilter/ipt_ah.c             |    6 ++--
 net/ipv4/netfilter/ipt_ecn.c            |   10 +++---
 net/ipv4/netfilter/nf_nat_rule.c        |   12 +++---
 net/ipv4/raw.c                          |    4 +-
 net/ipv4/xfrm4_input.c                  |    2 +-
 net/ipv4/xfrm4_output.c                 |    2 +-
 net/ipv6/ip6_input.c                    |    4 +-
 net/ipv6/ip6_output.c                   |   16 ++++----
 net/ipv6/ip6mr.c                        |    2 +-
 net/ipv6/mcast.c                        |    4 +-
 net/ipv6/ndisc.c                        |    4 +-
 net/ipv6/netfilter/ip6_tables.c         |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c           |    8 ++--
 net/ipv6/netfilter/ip6t_REJECT.c        |    8 ++--
 net/ipv6/netfilter/ip6t_ah.c            |    6 ++--
 net/ipv6/netfilter/ip6t_frag.c          |    6 ++--
 net/ipv6/netfilter/ip6t_hbh.c           |    8 ++--
 net/ipv6/netfilter/ip6t_ipv6header.c    |    6 ++--
 net/ipv6/netfilter/ip6t_mh.c            |    4 +-
 net/ipv6/netfilter/ip6t_rt.c            |    8 ++--
 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 +-
 net/ipv6/raw.c                          |    4 +-
 net/ipv6/xfrm6_input.c                  |    2 +-
 net/ipv6/xfrm6_output.c                 |    4 +-
 net/netfilter/ipvs/ip_vs_xmit.c         |   16 ++++----
 net/netfilter/x_tables.c                |   24 +++++++++++--
 net/netfilter/xt_CONNSECMARK.c          |   14 ++++----
 net/netfilter/xt_CT.c                   |   17 ++++++---
 net/netfilter/xt_DSCP.c                 |    6 ++--
 net/netfilter/xt_HL.c                   |   16 ++++----
 net/netfilter/xt_LED.c                  |   12 +++----
 net/netfilter/xt_NFLOG.c                |    8 ++--
 net/netfilter/xt_NFQUEUE.c              |    8 ++--
 net/netfilter/xt_RATEEST.c              |   18 +++++----
 net/netfilter/xt_SECMARK.c              |   26 +++++++------
 net/netfilter/xt_TCPMSS.c               |   16 ++++----
 net/netfilter/xt_TPROXY.c               |    6 ++--
 net/netfilter/xt_cluster.c              |    8 ++--
 net/netfilter/xt_connbytes.c            |   15 ++++----
 net/netfilter/xt_connlimit.c            |   12 ++++---
 net/netfilter/xt_connmark.c             |   22 ++++++-----
 net/netfilter/xt_conntrack.c            |   11 +++---
 net/netfilter/xt_dccp.c                 |   12 ++++--
 net/netfilter/xt_dscp.c                 |    6 ++--
 net/netfilter/xt_esp.c                  |    6 ++--
 net/netfilter/xt_hashlimit.c            |   57 +++++++++++++++++-------------
 net/netfilter/xt_helper.c               |   10 +++--
 net/netfilter/xt_limit.c                |    8 ++--
 net/netfilter/xt_multiport.c            |    8 ++--
 net/netfilter/xt_physdev.c              |    8 ++--
 net/netfilter/xt_policy.c               |   12 +++---
 net/netfilter/xt_quota.c                |    8 ++--
 net/netfilter/xt_rateest.c              |    8 +++--
 net/netfilter/xt_recent.c               |   25 +++++++------
 net/netfilter/xt_sctp.c                 |   22 +++++++-----
 net/netfilter/xt_state.c                |   11 +++---
 net/netfilter/xt_statistic.c            |    8 ++--
 net/netfilter/xt_string.c               |   15 ++++----
 net/netfilter/xt_tcpudp.c               |    8 ++--
 net/netfilter/xt_time.c                 |    6 ++--
 102 files changed, 536 insertions(+), 470 deletions(-)
