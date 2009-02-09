From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxtables rework
Date: Mon,  9 Feb 2009 18:34:44 +0100
Message-ID: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51460 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbZBIRfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Patrick McHardy wrote on  2009-02-09 15:39:16:

>So I prefer a resubmission in any case.

Jan Engelhardt (16):
      src: remove redundant returns at end of void-returning functions
      src: remove redundant casts
      libxt_owner: use correct UID/GID boundaries
      extensions: use UINT_MAX constants over open-coded bits (1/2)
      extensions: use UINT_MAX constants over open-coded numbers (2/2)
      libxtables: prefix/order - libdir
      libxtables: prefix/order - strtoui
      libxtables: prefix/order - program_name
      libxtables: prefix/order - param_act
      libxtables: prefix/order - ipaddr/ipmask to ascii output
      libxtables: prefix/order - ascii to ipaddr/ipmask input
      libxtables: prefix - misc functions
      libxtables: prefix - parse and escaped output func
      libxtables: prefix/order - move check_inverse to xtables.c
      libxtables: prefix/order - move parse_protocol to xtables.c
      libxtables: move afinfo around

 .gitignore                      |    1 +
 Makefile.am                     |    2 +-
 configure.ac                    |   26 +--
 extensions/libip6t_HL.c         |    4 +-
 extensions/libip6t_LOG.c        |    8 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    6 +-
 extensions/libip6t_dst.c        |   11 +-
 extensions/libip6t_frag.c       |    6 +-
 extensions/libip6t_hbh.c        |   11 +-
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    6 +-
 extensions/libip6t_ipv6header.c |    8 +-
 extensions/libip6t_mh.c         |    4 +-
 extensions/libip6t_policy.c     |    8 +-
 extensions/libip6t_rt.c         |   10 +-
 extensions/libipt_CLUSTERIP.c   |   10 +-
 extensions/libipt_DNAT.c        |   10 +-
 extensions/libipt_ECN.c         |    6 +-
 extensions/libipt_LOG.c         |   10 +-
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_NETMAP.c      |   12 +-
 extensions/libipt_REDIRECT.c    |    4 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |   14 +-
 extensions/libipt_SET.c         |    2 +-
 extensions/libipt_SNAT.c        |   10 +-
 extensions/libipt_TTL.c         |    4 +-
 extensions/libipt_ULOG.c        |    6 +-
 extensions/libipt_addrtype.c    |    8 +-
 extensions/libipt_ah.c          |    4 +-
 extensions/libipt_ecn.c         |    8 +-
 extensions/libipt_icmp.c        |    6 +-
 extensions/libipt_policy.c      |   16 +-
 extensions/libipt_realm.c       |    4 +-
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    8 +-
 extensions/libxt_CONNMARK.c     |   56 +++---
 extensions/libxt_DSCP.c         |    7 +-
 extensions/libxt_MARK.c         |   50 +++---
 extensions/libxt_NFLOG.c        |    6 +-
 extensions/libxt_NFQUEUE.c      |    3 +-
 extensions/libxt_TCPMSS.c       |    3 +-
 extensions/libxt_TCPOPTSTRIP.c  |    3 +-
 extensions/libxt_TOS.c          |   36 ++--
 extensions/libxt_TPROXY.c       |   36 ++--
 extensions/libxt_comment.c      |    2 +-
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    2 +-
 extensions/libxt_connmark.c     |   16 +-
 extensions/libxt_conntrack.c    |   91 +++++-----
 extensions/libxt_dccp.c         |   18 +-
 extensions/libxt_dscp.c         |   11 +-
 extensions/libxt_esp.c          |    4 +-
 extensions/libxt_hashlimit.c    |   98 +++++-----
 extensions/libxt_helper.c       |    4 +-
 extensions/libxt_iprange.c      |   80 ++++----
 extensions/libxt_length.c       |    6 +-
 extensions/libxt_limit.c        |    6 +-
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_mark.c         |   16 +-
 extensions/libxt_multiport.c    |   18 +-
 extensions/libxt_owner.c        |   73 ++++----
 extensions/libxt_physdev.c      |   14 +-
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_quota.c        |    4 +-
 extensions/libxt_rateest.c      |   27 ++--
 extensions/libxt_recent.c       |    8 +-
 extensions/libxt_sctp.c         |   12 +-
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_statistic.c    |    9 +-
 extensions/libxt_string.c       |    6 +-
 extensions/libxt_tcp.c          |   18 +-
 extensions/libxt_tcpmss.c       |    6 +-
 extensions/libxt_time.c         |    1 -
 extensions/libxt_tos.c          |    8 +-
 extensions/libxt_u32.c          |    2 -
 extensions/libxt_udp.c          |   10 +-
 extensions/tos_values.c         |    8 +-
 include/xtables.h.in            |  115 +++++++------
 include/xtables/internal.h      |   36 ----
 include/xtables/internal.h.in   |   17 ++
 ip6tables-restore.c             |   17 +--
 ip6tables-save.c                |   17 +--
 ip6tables-standalone.c          |   15 +-
 ip6tables.c                     |  149 +++------------
 iptables-restore.c              |   17 +--
 iptables-save.c                 |   17 +--
 iptables-standalone.c           |   15 +-
 iptables-xml.c                  |    8 +-
 iptables.c                      |  140 +++-----------
 xtables.c                       |  387 +++++++++++++++++++++++++++------------
 92 files changed, 963 insertions(+), 1036 deletions(-)
