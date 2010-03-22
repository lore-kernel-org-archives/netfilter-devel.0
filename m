From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: cleanups, err reporting (rd.2)
Date: Mon, 22 Mar 2010 20:17:56 +0100
Message-ID: <1269285486-22653-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42159 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0CVTSK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I hope I now got them all.
Please review and merge.

The following changes since commit 2c46cd8163b25bf6f38e612e9f1d162f0357c8f1:
  Zhitong Wang (1):
        netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (9):
      netfilter: xtables: make use of caller family rather than target family
      netfilter: xt extensions: use pr_<level> (2)
      netfilter: xtables: make use of xt_request_find_target
      netfilter: xtables: consolidate code into xt_request_find_match
      netfilter: xt_recent: allow changing ip_list_[ug]id at runtime
      netfilter: xtables: slightly better error reporting (1/2)
      netfilter: xtables: slightly better error reporting (2/2)
      netfilter: xtables: use only error codes for checkentry
      netfilter: xtables: shorten up return clause

 include/linux/netfilter/x_tables.h   |    7 ++-
 net/bridge/netfilter/ebt_802_3.c     |    6 +-
 net/bridge/netfilter/ebt_among.c     |   25 +++++-------
 net/bridge/netfilter/ebt_arp.c       |    8 ++--
 net/bridge/netfilter/ebt_arpreply.c  |    8 ++--
 net/bridge/netfilter/ebt_dnat.c      |   10 ++--
 net/bridge/netfilter/ebt_ip.c        |   16 ++++----
 net/bridge/netfilter/ebt_ip6.c       |   16 ++++----
 net/bridge/netfilter/ebt_limit.c     |    9 ++--
 net/bridge/netfilter/ebt_log.c       |    8 ++--
 net/bridge/netfilter/ebt_mark.c      |   10 ++--
 net/bridge/netfilter/ebt_mark_m.c    |   10 ++--
 net/bridge/netfilter/ebt_nflog.c     |    6 +-
 net/bridge/netfilter/ebt_pkttype.c   |    6 +-
 net/bridge/netfilter/ebt_redirect.c  |   10 ++--
 net/bridge/netfilter/ebt_snat.c      |   10 ++--
 net/bridge/netfilter/ebt_stp.c       |    8 ++--
 net/bridge/netfilter/ebt_ulog.c      |   32 ++++++++-------
 net/bridge/netfilter/ebt_vlan.c      |   52 ++++++++++---------------
 net/bridge/netfilter/ebtables.c      |   23 ++---------
 net/ipv4/netfilter/arp_tables.c      |   20 ++++------
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_tables.c       |   58 ++++++++++++----------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   69 +++++++++++++++++-----------------
 net/ipv4/netfilter/ipt_ECN.c         |   21 ++++------
 net/ipv4/netfilter/ipt_LOG.c         |   15 +++----
 net/ipv4/netfilter/ipt_MASQUERADE.c  |   16 ++++----
 net/ipv4/netfilter/ipt_NETMAP.c      |   14 +++---
 net/ipv4/netfilter/ipt_REDIRECT.c    |   14 +++---
 net/ipv4/netfilter/ipt_REJECT.c      |   14 +++---
 net/ipv4/netfilter/ipt_ULOG.c        |   48 +++++++++++------------
 net/ipv4/netfilter/ipt_addrtype.c    |   24 ++++++------
 net/ipv4/netfilter/ipt_ah.c          |    6 +-
 net/ipv4/netfilter/ipt_ecn.c         |   15 +++----
 net/ipv4/netfilter/nf_nat_rule.c     |    4 +-
 net/ipv6/netfilter/ip6_tables.c      |   49 ++++++++++--------------
 net/ipv6/netfilter/ip6t_LOG.c        |   15 +++----
 net/ipv6/netfilter/ip6t_REJECT.c     |   28 +++++++-------
 net/ipv6/netfilter/ip6t_ah.c         |   12 +++---
 net/ipv6/netfilter/ip6t_frag.c       |   12 +++---
 net/ipv6/netfilter/ip6t_hbh.c        |   14 +++---
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 +-
 net/ipv6/netfilter/ip6t_mh.c         |    4 +-
 net/ipv6/netfilter/ip6t_rt.c         |   14 +++---
 net/netfilter/x_tables.c             |   39 ++++++++++++++++---
 net/netfilter/xt_CONNSECMARK.c       |   14 +++---
 net/netfilter/xt_CT.c                |   17 ++++++--
 net/netfilter/xt_DSCP.c              |    6 +-
 net/netfilter/xt_HL.c                |   16 ++++----
 net/netfilter/xt_LED.c               |   17 +++-----
 net/netfilter/xt_NFLOG.c             |    8 ++--
 net/netfilter/xt_NFQUEUE.c           |   12 +++---
 net/netfilter/xt_RATEEST.c           |   18 +++++----
 net/netfilter/xt_SECMARK.c           |   26 +++++++------
 net/netfilter/xt_TCPMSS.c            |   23 +++++------
 net/netfilter/xt_TPROXY.c            |   10 ++--
 net/netfilter/xt_cluster.c           |    8 ++--
 net/netfilter/xt_connbytes.c         |   15 +++----
 net/netfilter/xt_connlimit.c         |   12 +++--
 net/netfilter/xt_connmark.c          |   22 ++++++-----
 net/netfilter/xt_conntrack.c         |   11 +++--
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    6 +-
 net/netfilter/xt_esp.c               |    8 ++--
 net/netfilter/xt_hashlimit.c         |   57 ++++++++++++++++------------
 net/netfilter/xt_helper.c            |   10 +++--
 net/netfilter/xt_iprange.c           |    1 +
 net/netfilter/xt_limit.c             |    8 ++--
 net/netfilter/xt_multiport.c         |    8 ++--
 net/netfilter/xt_physdev.c           |    8 ++--
 net/netfilter/xt_policy.c            |   12 +++---
 net/netfilter/xt_quota.c             |    8 ++--
 net/netfilter/xt_rateest.c           |    8 ++-
 net/netfilter/xt_recent.c            |   38 ++++++++++---------
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_socket.c            |    5 +-
 net/netfilter/xt_state.c             |   11 +++--
 net/netfilter/xt_statistic.c         |    8 ++--
 net/netfilter/xt_string.c            |   15 +++----
 net/netfilter/xt_tcpudp.c            |    4 +-
 net/netfilter/xt_time.c              |   10 ++--
 net/sched/act_ipt.c                  |    4 +-
 82 files changed, 639 insertions(+), 642 deletions(-)
