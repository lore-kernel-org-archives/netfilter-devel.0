From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: cleanups (rd.3)
Date: Thu, 25 Mar 2010 13:56:43 +0100
Message-ID: <1269521809-29393-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59858 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab0CYM4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:56:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a repost of the 5-set you requested.


The following changes since commit 2c46cd8163b25bf6f38e612e9f1d162f0357c8f1:
  Zhitong Wang (1):
        netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (5):
      netfilter: xtables: make use of caller family rather than target family
      netfilter: xt extensions: use pr_<level> (2)
      netfilter: xtables: make use of xt_request_find_target
      netfilter: xtables: consolidate code into xt_request_find_match
      netfilter: xt_recent: allow changing ip_list_[ug]id at runtime

 include/linux/netfilter/x_tables.h  |    1 +
 net/bridge/netfilter/ebt_among.c    |   15 ++++-----
 net/bridge/netfilter/ebt_limit.c    |    3 +-
 net/bridge/netfilter/ebt_ulog.c     |   26 +++++++++-------
 net/bridge/netfilter/ebt_vlan.c     |   36 ++++++++--------------
 net/bridge/netfilter/ebtables.c     |   23 +++-----------
 net/ipv4/netfilter/arp_tables.c     |   20 +++++-------
 net/ipv4/netfilter/ip_tables.c      |   56 +++++++++++++++--------------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   47 +++++++++++++++--------------
 net/ipv4/netfilter/ipt_ECN.c        |   11 ++----
 net/ipv4/netfilter/ipt_LOG.c        |    7 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c |    8 ++--
 net/ipv4/netfilter/ipt_NETMAP.c     |    6 ++--
 net/ipv4/netfilter/ipt_REDIRECT.c   |    6 ++--
 net/ipv4/netfilter/ipt_REJECT.c     |    6 ++--
 net/ipv4/netfilter/ipt_ULOG.c       |   40 ++++++++++++-------------
 net/ipv4/netfilter/ipt_addrtype.c   |   14 ++++----
 net/ipv4/netfilter/ipt_ecn.c        |    5 +--
 net/ipv6/netfilter/ip6_tables.c     |   47 ++++++++++++-----------------
 net/ipv6/netfilter/ip6t_LOG.c       |    7 ++--
 net/ipv6/netfilter/ip6t_REJECT.c    |   20 ++++++------
 net/ipv6/netfilter/ip6t_ah.c        |    6 ++--
 net/ipv6/netfilter/ip6t_frag.c      |    6 ++--
 net/ipv6/netfilter/ip6t_hbh.c       |    6 ++--
 net/ipv6/netfilter/ip6t_rt.c        |    6 ++--
 net/netfilter/x_tables.c            |   15 +++++++--
 net/netfilter/xt_NFQUEUE.c          |    4 +-
 net/netfilter/xt_TCPMSS.c           |    7 ++--
 net/netfilter/xt_TPROXY.c           |    4 +-
 net/netfilter/xt_esp.c              |    2 +-
 net/netfilter/xt_iprange.c          |    1 +
 net/netfilter/xt_recent.c           |   14 ++++----
 net/netfilter/xt_socket.c           |    5 +--
 net/netfilter/xt_time.c             |    4 +-
 net/sched/act_ipt.c                 |    4 +-
 35 files changed, 224 insertions(+), 264 deletions(-)
