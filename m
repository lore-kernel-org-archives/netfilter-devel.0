From: Jan Engelhardt <jengelh@medozas.de>
Subject: Misc consistency updates
Date: Fri, 23 Jul 2010 21:36:18 +0200
Message-ID: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56098 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0GWTg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:36:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 5031b4199192c6643b5c550523fc5c09578264e1:

  Merge branch 'master' into iptables-next (2010-07-23 16:16:11 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (5):
      doc: let man(1) autoalign the text in xt_cpu
      doc: remove extra empty line from xt_cpu
      doc: minimal spelling updates to xt_cpu
      all: consistent syntax use in struct option
      doc: consistent use of markup

 extensions/libip6t_HL.c         |    9 +++---
 extensions/libip6t_LOG.c        |   17 ++++++------
 extensions/libip6t_REJECT.c     |    5 ++-
 extensions/libip6t_ah.c         |    9 +++---
 extensions/libip6t_dst.c        |    9 +++---
 extensions/libip6t_frag.c       |   15 ++++++-----
 extensions/libip6t_hbh.c        |    8 +++---
 extensions/libip6t_hl.c         |   12 ++++----
 extensions/libip6t_icmp6.c      |    5 ++-
 extensions/libip6t_ipv6header.c |    7 +++--
 extensions/libip6t_mh.c         |    5 ++-
 extensions/libip6t_rt.c         |   15 ++++++-----
 extensions/libipt_CLUSTERIP.c   |   15 ++++++-----
 extensions/libipt_DNAT.c        |    9 +++---
 extensions/libipt_ECN.c         |   11 ++++---
 extensions/libipt_LOG.c         |   17 ++++++------
 extensions/libipt_MASQUERADE.c  |    7 +++--
 extensions/libipt_NETMAP.c      |    6 ++--
 extensions/libipt_REDIRECT.c    |    7 +++--
 extensions/libipt_REJECT.c      |    5 ++-
 extensions/libipt_SAME.c        |    9 +++---
 extensions/libipt_SNAT.c        |    9 +++---
 extensions/libipt_TTL.c         |    9 +++---
 extensions/libipt_ULOG.c        |   11 ++++---
 extensions/libipt_addrtype.c    |   24 +++++++++---------
 extensions/libipt_ah.c          |    5 ++-
 extensions/libipt_ecn.c         |    9 +++---
 extensions/libipt_icmp.c        |    5 ++-
 extensions/libipt_realm.c       |    5 ++-
 extensions/libipt_ttl.c         |   12 ++++----
 extensions/libxt_CHECKSUM.c     |    5 ++-
 extensions/libxt_CLASSIFY.c     |    5 ++-
 extensions/libxt_CONNMARK.c     |   13 +++++----
 extensions/libxt_CONNMARK.man   |   26 +++++++++---------
 extensions/libxt_CONNSECMARK.c  |    7 +++--
 extensions/libxt_CT.c           |   13 +++++----
 extensions/libxt_DSCP.c         |    7 +++--
 extensions/libxt_IDLETIMER.c    |    8 +++---
 extensions/libxt_LED.c          |    4 +-
 extensions/libxt_MARK.c         |   10 +++---
 extensions/libxt_MARK.man       |   20 +++++++-------
 extensions/libxt_NFLOG.c        |   11 ++++---
 extensions/libxt_NFQUEUE.c      |    7 +++--
 extensions/libxt_RATEEST.c      |    9 +++---
 extensions/libxt_SECMARK.c      |    5 ++-
 extensions/libxt_SET.c          |    7 +++--
 extensions/libxt_TCPMSS.c       |    7 +++--
 extensions/libxt_TCPOPTSTRIP.c  |    4 +-
 extensions/libxt_TOS.c          |    5 ++-
 extensions/libxt_TOS.man        |   18 ++++++------
 extensions/libxt_TPROXY.c       |    8 +++---
 extensions/libxt_TPROXY.man     |    2 +-
 extensions/libxt_cluster.c      |   11 ++++---
 extensions/libxt_comment.c      |    5 ++-
 extensions/libxt_connbytes.c    |    9 +++---
 extensions/libxt_connlimit.c    |    7 +++--
 extensions/libxt_connlimit.man  |    2 +-
 extensions/libxt_connmark.c     |    3 +-
 extensions/libxt_connmark.man   |    2 +-
 extensions/libxt_conntrack.c    |    2 +-
 extensions/libxt_conntrack.man  |   52 +++++++++++++++++++-------------------
 extensions/libxt_cpu.c          |    5 ++-
 extensions/libxt_cpu.man        |    9 +++---
 extensions/libxt_dccp.c         |   15 ++++++-----
 extensions/libxt_dscp.c         |    7 +++--
 extensions/libxt_esp.c          |    5 ++-
 extensions/libxt_hashlimit.c    |   20 +++++++-------
 extensions/libxt_hashlimit.man  |   12 ++++----
 extensions/libxt_helper.c       |    5 ++-
 extensions/libxt_iprange.c      |    3 +-
 extensions/libxt_iprange.man    |    4 +-
 extensions/libxt_ipvs.c         |    3 +-
 extensions/libxt_ipvs.man       |   12 ++++----
 extensions/libxt_length.c       |    5 ++-
 extensions/libxt_limit.c        |    8 +++---
 extensions/libxt_mac.c          |    5 ++-
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |   13 +++++----
 extensions/libxt_osf.c          |   10 +++---
 extensions/libxt_owner.c        |    6 ++--
 extensions/libxt_physdev.c      |   13 +++++----
 extensions/libxt_pkttype.c      |    5 ++-
 extensions/libxt_policy.c       |   21 +++++++++------
 extensions/libxt_quota.c        |    5 ++-
 extensions/libxt_rateest.c      |   31 ++++++++++++-----------
 extensions/libxt_recent.c       |   23 +++++++++--------
 extensions/libxt_recent.man     |   36 +++++++++++++-------------
 extensions/libxt_sctp.c         |   13 +++++----
 extensions/libxt_set.c          |    7 +++--
 extensions/libxt_set.man        |    2 +-
 extensions/libxt_state.c        |    5 ++-
 extensions/libxt_statistic.c    |   11 ++++---
 extensions/libxt_string.c       |   15 ++++++-----
 extensions/libxt_tcp.c          |   17 ++++++------
 extensions/libxt_tcpmss.c       |    5 ++-
 extensions/libxt_time.c         |   18 ++++++------
 extensions/libxt_time.man       |   16 ++++++------
 extensions/libxt_tos.c          |    2 +-
 extensions/libxt_u32.c          |    5 ++-
 extensions/libxt_u32.man        |   36 +++++++++++++-------------
 extensions/libxt_udp.c          |   11 ++++---
 extensions/tos_values.c         |    2 +-
 include/xtables.h.in            |    2 +
 103 files changed, 553 insertions(+), 482 deletions(-)
