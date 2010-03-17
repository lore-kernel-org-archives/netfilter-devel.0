From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: checks and three modules
Date: Wed, 17 Mar 2010 14:18:55 +0100
Message-ID: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59336 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0CQNTQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 0e706b5d2042a0e0451f8d1c9707cf42d353709f:
  Tim Gardner (1):
        netfilter: xt_recent: add an entry reaper

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (9):
      netfilter: xtables: do without explicit XT_ALIGN
      netfilter: xtables: slightly more detailed checkentry return values
      netfilter: xtables: restrict TCPMSS to mangle table as intended
      netfilter: xtables: clean up xt_mac match routine
      netfilter: xtables: limit xt_mac to ethernet devices
      netfilter: xtables: resort osf kconfig text
      netfilter: xtables: inclusion of xt_SYSRQ
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables: inclusion of xt_condition

Please review :)


 include/linux/netfilter/Kbuild         |    2 +
 include/linux/netfilter/x_tables.h     |    6 +-
 include/linux/netfilter/xt_TEE.h       |    8 +
 include/linux/netfilter/xt_condition.h |   12 +
 net/bridge/netfilter/ebt_802_3.c       |    2 +-
 net/bridge/netfilter/ebt_among.c       |    2 +-
 net/bridge/netfilter/ebt_arp.c         |    2 +-
 net/bridge/netfilter/ebt_arpreply.c    |    2 +-
 net/bridge/netfilter/ebt_dnat.c        |    2 +-
 net/bridge/netfilter/ebt_ip.c          |    2 +-
 net/bridge/netfilter/ebt_ip6.c         |    2 +-
 net/bridge/netfilter/ebt_limit.c       |    2 +-
 net/bridge/netfilter/ebt_log.c         |    2 +-
 net/bridge/netfilter/ebt_mark.c        |    2 +-
 net/bridge/netfilter/ebt_mark_m.c      |    2 +-
 net/bridge/netfilter/ebt_nflog.c       |    2 +-
 net/bridge/netfilter/ebt_pkttype.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c    |    2 +-
 net/bridge/netfilter/ebt_snat.c        |    2 +-
 net/bridge/netfilter/ebt_stp.c         |    2 +-
 net/bridge/netfilter/ebt_ulog.c        |    2 +-
 net/bridge/netfilter/ebt_vlan.c        |    2 +-
 net/ipv4/netfilter/arpt_mangle.c       |    2 +-
 net/ipv4/netfilter/ip_tables.c         |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c     |   13 +-
 net/ipv4/netfilter/ipt_ECN.c           |    2 +-
 net/ipv4/netfilter/ipt_LOG.c           |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c    |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c        |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c      |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c        |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c          |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c      |    2 +-
 net/ipv4/netfilter/ipt_ah.c            |    2 +-
 net/ipv4/netfilter/ipt_ecn.c           |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c       |    4 +-
 net/ipv6/netfilter/ip6_tables.c        |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c          |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c       |    2 +-
 net/ipv6/netfilter/ip6t_ah.c           |    2 +-
 net/ipv6/netfilter/ip6t_frag.c         |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c          |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c   |    2 +-
 net/ipv6/netfilter/ip6t_mh.c           |    2 +-
 net/ipv6/netfilter/ip6t_rt.c           |    2 +-
 net/netfilter/Kconfig                  |   53 ++++--
 net/netfilter/Makefile                 |    3 +
 net/netfilter/x_tables.c               |   22 ++-
 net/netfilter/xt_CONNSECMARK.c         |    8 +-
 net/netfilter/xt_CT.c                  |   15 +-
 net/netfilter/xt_DSCP.c                |    2 +-
 net/netfilter/xt_HL.c                  |    4 +-
 net/netfilter/xt_LED.c                 |   15 +-
 net/netfilter/xt_NFLOG.c               |    2 +-
 net/netfilter/xt_NFQUEUE.c             |    2 +-
 net/netfilter/xt_RATEEST.c             |   11 +-
 net/netfilter/xt_SECMARK.c             |   14 +-
 net/netfilter/xt_SYSRQ.c               |  372 ++++++++++++++++++++++++++++++++
 net/netfilter/xt_TCPMSS.c              |    6 +-
 net/netfilter/xt_TEE.c                 |  304 ++++++++++++++++++++++++++
 net/netfilter/xt_TPROXY.c              |    2 +-
 net/netfilter/xt_cluster.c             |    2 +-
 net/netfilter/xt_condition.c           |  243 +++++++++++++++++++++
 net/netfilter/xt_connbytes.c           |    8 +-
 net/netfilter/xt_connlimit.c           |   10 +-
 net/netfilter/xt_connmark.c            |   18 +-
 net/netfilter/xt_conntrack.c           |    9 +-
 net/netfilter/xt_dccp.c                |    2 +-
 net/netfilter/xt_dscp.c                |    2 +-
 net/netfilter/xt_esp.c                 |    2 +-
 net/netfilter/xt_hashlimit.c           |   33 ++--
 net/netfilter/xt_helper.c              |    2 +-
 net/netfilter/xt_limit.c               |    4 +-
 net/netfilter/xt_mac.c                 |   21 ++-
 net/netfilter/xt_multiport.c           |    8 +-
 net/netfilter/xt_physdev.c             |    2 +-
 net/netfilter/xt_policy.c              |    2 +-
 net/netfilter/xt_quota.c               |    4 +-
 net/netfilter/xt_rateest.c             |    4 +-
 net/netfilter/xt_recent.c              |    9 +-
 net/netfilter/xt_sctp.c                |    2 +-
 net/netfilter/xt_state.c               |    9 +-
 net/netfilter/xt_statistic.c           |    4 +-
 net/netfilter/xt_string.c              |    4 +-
 net/netfilter/xt_tcpudp.c              |    4 +-
 net/netfilter/xt_time.c                |    2 +-
 86 files changed, 1199 insertions(+), 169 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_SYSRQ.c
 create mode 100644 net/netfilter/xt_TEE.c
 create mode 100644 net/netfilter/xt_condition.c
