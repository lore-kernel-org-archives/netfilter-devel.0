From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: misc fixes
Date: Mon, 31 Jan 2011 03:12:45 +0100
Message-ID: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45261 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaCM4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:12:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 6f03bf79952753fbc0dc8611aa4d6e70a108dbc7:

  Fix listing/saving the new revision of the SET target (2011-01-21 21:55:05 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (8):
      libxt_quota: clarifications on matching
      iptables: improve error reporting with extension loading troubles
      libxt_u32: enclose argument in quotes
      xtables: set custom opts to NULL on free
      iptables: warn when parameter limit is exceeded
      iptables: remove bogus address-of
      iptables: remove more redundant casts
      iptables: do not print trailing whitespaces

 extensions/libip6t_HL.c         |   18 +++---
 extensions/libip6t_LOG.c        |   36 ++++++------
 extensions/libip6t_REJECT.c     |    4 +-
 extensions/libip6t_ah.c         |   26 ++++----
 extensions/libip6t_dst.c        |   19 +++---
 extensions/libip6t_frag.c       |   38 ++++++------
 extensions/libip6t_hbh.c        |   21 +++----
 extensions/libip6t_hl.c         |    4 +-
 extensions/libip6t_icmp6.c      |   23 +++----
 extensions/libip6t_ipv6header.c |   14 ++---
 extensions/libip6t_mh.c         |   12 ++--
 extensions/libip6t_rt.c         |   42 +++++++-------
 extensions/libipt_CLUSTERIP.c   |    6 +-
 extensions/libipt_DNAT.c        |   14 ++---
 extensions/libipt_ECN.c         |   18 +++---
 extensions/libipt_LOG.c         |   36 ++++++------
 extensions/libipt_MASQUERADE.c  |   10 +--
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |   10 +--
 extensions/libipt_REJECT.c      |    4 +-
 extensions/libipt_SAME.c        |   26 ++++-----
 extensions/libipt_SNAT.c        |   14 ++---
 extensions/libipt_TTL.c         |   18 +++---
 extensions/libipt_ULOG.c        |   18 +++---
 extensions/libipt_addrtype.c    |   38 ++++++-------
 extensions/libipt_ah.c          |   13 ++--
 extensions/libipt_ecn.c         |   30 +++++-----
 extensions/libipt_icmp.c        |   25 ++++-----
 extensions/libipt_realm.c       |   14 ++--
 extensions/libipt_ttl.c         |   22 ++++----
 extensions/libxt_AUDIT.c        |    8 +-
 extensions/libxt_CHECKSUM.c     |    6 +-
 extensions/libxt_CLASSIFY.c     |    6 +-
 extensions/libxt_CONNMARK.c     |   51 ++++++++---------
 extensions/libxt_CONNSECMARK.c  |    6 +-
 extensions/libxt_CT.c           |   15 ++---
 extensions/libxt_DSCP.c         |    6 +-
 extensions/libxt_IDLETIMER.c    |    8 +-
 extensions/libxt_LED.c          |   20 +++---
 extensions/libxt_MARK.c         |   30 +++++-----
 extensions/libxt_NFLOG.c        |    8 +-
 extensions/libxt_NFQUEUE.c      |   12 ++--
 extensions/libxt_RATEEST.c      |   12 ++--
 extensions/libxt_SECMARK.c      |    6 +-
 extensions/libxt_SET.c          |    6 +-
 extensions/libxt_TCPMSS.c       |    8 +-
 extensions/libxt_TCPOPTSTRIP.c  |    4 +-
 extensions/libxt_TEE.c          |   20 +++---
 extensions/libxt_TOS.c          |   20 +++---
 extensions/libxt_TPROXY.c       |   24 ++++----
 extensions/libxt_cluster.c      |   14 ++--
 extensions/libxt_comment.c      |    4 +-
 extensions/libxt_connbytes.c    |   32 +++++-----
 extensions/libxt_connlimit.c    |   24 ++++----
 extensions/libxt_connmark.c     |   16 +++---
 extensions/libxt_conntrack.c    |  118 +++++++++++++++++++--------------------
 extensions/libxt_cpu.c          |    4 +-
 extensions/libxt_dccp.c         |   26 ++++----
 extensions/libxt_dscp.c         |    4 +-
 extensions/libxt_esp.c          |   16 +++---
 extensions/libxt_hashlimit.c    |   76 +++++++++++++-------------
 extensions/libxt_helper.c       |    4 +-
 extensions/libxt_iprange.c      |   76 ++++++++++++-------------
 extensions/libxt_ipvs.c         |   44 +++++++-------
 extensions/libxt_length.c       |   12 ++--
 extensions/libxt_limit.c        |   10 ++--
 extensions/libxt_mac.c          |   11 ++--
 extensions/libxt_mark.c         |   20 +++---
 extensions/libxt_multiport.c    |   24 +++-----
 extensions/libxt_osf.c          |    4 +-
 extensions/libxt_owner.c        |   50 ++++++++--------
 extensions/libxt_physdev.c      |   23 ++++----
 extensions/libxt_pkttype.c      |    8 +-
 extensions/libxt_policy.c       |   50 ++++++++--------
 extensions/libxt_quota.c        |    4 +-
 extensions/libxt_quota.man      |    4 +-
 extensions/libxt_rateest.c      |   60 ++++++++++----------
 extensions/libxt_recent.c       |   46 ++++++++--------
 extensions/libxt_sctp.c         |   38 ++++++-------
 extensions/libxt_set.c          |   10 +--
 extensions/libxt_socket.c       |    4 +-
 extensions/libxt_state.c        |    5 +-
 extensions/libxt_statistic.c    |   10 ++--
 extensions/libxt_string.c       |   28 +++++-----
 extensions/libxt_tcp.c          |   34 +++++------
 extensions/libxt_tcpmss.c       |   12 ++--
 extensions/libxt_time.c         |   35 ++++++------
 extensions/libxt_tos.c          |   16 +++---
 extensions/libxt_u32.c          |   11 ++--
 extensions/libxt_udp.c          |   19 +++---
 extensions/tos_values.c         |    2 +-
 ip6tables-restore.c             |   11 ++--
 ip6tables.c                     |   38 ++++++-------
 iptables-restore.c              |   11 ++--
 iptables.c                      |   36 ++++++------
 xtables.c                       |   63 +++++++++++----------
 96 files changed, 985 insertions(+), 1033 deletions(-)
