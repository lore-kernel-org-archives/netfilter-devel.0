From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: a mixed bag, try#2
Date: Tue, 11 May 2010 18:47:23 +0200
Message-ID: <1273596452-27011-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37419 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0EKQr5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 May 2010 12:47:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


>My suggestions would be for me to merge patches 01-08 and you
>include the remaining ones in a series that actually need that
>change. If you manage to submit that series in time for 2.6.35,
>even better. How does that sound?


How do these eight look? :)


The following changes since commit e772c349a11de448f194d0c9f2e7eb23800e1a13:
  Patrick McHardy (1):
        netfilter: nf_ct_h323: switch "incomplete TPKT" message to pr_debug()

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (8):
      netfilter: ip_tables: fix compilation when debug is enabled
      netfilter: xtables: fix incorrect return code
      netfilter: xtables: dissolve do_match function
      netfilter: xtables: combine struct xt_match_param and xt_target_param
      netfilter: xtables: substitute temporary defines by final name
      netfilter: xtables: deconstify struct xt_action_param for matches
      netfilter: xtables: change hotdrop pointer to direct modification
      netfilter: xtables: combine built-in extension structs

 include/linux/netfilter/x_tables.h   |   45 +++++-------
 net/bridge/netfilter/ebt_802_3.c     |    2 +-
 net/bridge/netfilter/ebt_among.c     |    2 +-
 net/bridge/netfilter/ebt_arp.c       |    2 +-
 net/bridge/netfilter/ebt_arpreply.c  |    2 +-
 net/bridge/netfilter/ebt_dnat.c      |    2 +-
 net/bridge/netfilter/ebt_ip.c        |    2 +-
 net/bridge/netfilter/ebt_ip6.c       |    2 +-
 net/bridge/netfilter/ebt_limit.c     |    2 +-
 net/bridge/netfilter/ebt_log.c       |    2 +-
 net/bridge/netfilter/ebt_mark.c      |    2 +-
 net/bridge/netfilter/ebt_mark_m.c    |    2 +-
 net/bridge/netfilter/ebt_nflog.c     |    2 +-
 net/bridge/netfilter/ebt_pkttype.c   |    2 +-
 net/bridge/netfilter/ebt_redirect.c  |    2 +-
 net/bridge/netfilter/ebt_snat.c      |    2 +-
 net/bridge/netfilter/ebt_stp.c       |    2 +-
 net/bridge/netfilter/ebt_ulog.c      |    2 +-
 net/bridge/netfilter/ebt_vlan.c      |    2 +-
 net/bridge/netfilter/ebtables.c      |   33 ++++-----
 net/ipv4/netfilter/arp_tables.c      |   65 ++++++++---------
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_tables.c       |  128 ++++++++++++++-------------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c      |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    4 +-
 net/ipv4/netfilter/ipt_ah.c          |    4 +-
 net/ipv4/netfilter/ipt_ecn.c         |    4 +-
 net/ipv4/netfilter/nf_nat_rule.c     |    4 +-
 net/ipv6/netfilter/ip6_tables.c      |  118 +++++++++++++------------------
 net/ipv6/netfilter/ip6t_LOG.c        |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    6 +-
 net/ipv6/netfilter/ip6t_eui64.c      |    4 +-
 net/ipv6/netfilter/ip6t_frag.c       |    6 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    6 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    6 +-
 net/ipv6/netfilter/ip6t_rt.c         |    6 +-
 net/netfilter/xt_CLASSIFY.c          |    2 +-
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_CT.c                |    2 +-
 net/netfilter/xt_DSCP.c              |    8 +-
 net/netfilter/xt_HL.c                |    4 +-
 net/netfilter/xt_LED.c               |    2 +-
 net/netfilter/xt_NFLOG.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    4 +-
 net/netfilter/xt_NOTRACK.c           |    2 +-
 net/netfilter/xt_RATEEST.c           |    2 +-
 net/netfilter/xt_SECMARK.c           |    2 +-
 net/netfilter/xt_TCPMSS.c            |    4 +-
 net/netfilter/xt_TCPOPTSTRIP.c       |    4 +-
 net/netfilter/xt_TEE.c               |    4 +-
 net/netfilter/xt_TPROXY.c            |    2 +-
 net/netfilter/xt_TRACE.c             |    2 +-
 net/netfilter/xt_cluster.c           |    2 +-
 net/netfilter/xt_comment.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connlimit.c         |    6 +-
 net/netfilter/xt_connmark.c          |    4 +-
 net/netfilter/xt_conntrack.c         |    6 +-
 net/netfilter/xt_dccp.c              |    6 +-
 net/netfilter/xt_dscp.c              |    6 +-
 net/netfilter/xt_esp.c               |    4 +-
 net/netfilter/xt_hashlimit.c         |    4 +-
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_hl.c                |    4 +-
 net/netfilter/xt_iprange.c           |    4 +-
 net/netfilter/xt_length.c            |    4 +-
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_mac.c               |    2 +-
 net/netfilter/xt_mark.c              |    4 +-
 net/netfilter/xt_multiport.c         |    8 +-
 net/netfilter/xt_osf.c               |    4 +-
 net/netfilter/xt_owner.c             |    2 +-
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_pkttype.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_rateest.c           |    2 +-
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_recent.c            |    4 +-
 net/netfilter/xt_sctp.c              |    6 +-
 net/netfilter/xt_socket.c            |    6 +-
 net/netfilter/xt_state.c             |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpmss.c            |    4 +-
 net/netfilter/xt_tcpudp.c            |   14 ++--
 net/netfilter/xt_time.c              |    2 +-
 net/netfilter/xt_u32.c               |    2 +-
 net/sched/act_ipt.c                  |    2 +-
 98 files changed, 316 insertions(+), 367 deletions(-)
