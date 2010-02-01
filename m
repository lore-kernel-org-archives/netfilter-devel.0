From: Jan Engelhardt <jengelh@medozas.de>
Subject: Misc doc fixes and two patches
Date: Mon,  1 Feb 2010 01:19:46 +0100
Message-ID: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49641 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0BAAT5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:19:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 88bdf3cd2fbfad5ef24736ff7b14bea01a39c3ff:
  Patrick McHardy (1):
        Bump version to v1.4.6

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (7):
      libipq: build as shared library
      recent: reorder cases in code (cosmetic cleanup)
      doc: fix recent manpage to reflect actual supported syntax
      doc: fix limit manpage to reflect actual supported syntax
      doc: mention requirement of additional packages for ipset
      policy: fix error message showing wrong option
      includes: header updates

 extensions/libipt_SET.man                      |    4 +
 extensions/libipt_set.man                      |    4 +
 extensions/libxt_CONNMARK.c                    |    6 +
 extensions/libxt_MARK.c                        |   17 +++
 extensions/libxt_TOS.c                         |    5 +-
 extensions/libxt_connmark.c                    |    5 +
 extensions/libxt_conntrack.c                   |   33 ++++++
 extensions/libxt_iprange.c                     |   14 +++-
 extensions/libxt_limit.man                     |    2 +-
 extensions/libxt_mark.c                        |    5 +
 extensions/libxt_owner.c                       |   34 ++++++-
 extensions/libxt_policy.c                      |    2 +-
 extensions/libxt_recent.c                      |   16 ++--
 extensions/libxt_recent.man                    |    7 +-
 extensions/libxt_tos.c                         |    6 +-
 extensions/tos_values.c                        |    4 +
 include/linux/netfilter.h                      |    2 +
 include/linux/netfilter/nf_conntrack_common.h  |   72 +-------------
 include/linux/netfilter/x_tables.h             |   51 +++++-----
 include/linux/netfilter/xt_CLASSIFY.h          |    4 +-
 include/linux/netfilter/xt_CONNMARK.h          |   12 +--
 include/linux/netfilter/xt_CONNSECMARK.h       |    4 +-
 include/linux/netfilter/xt_DSCP.h              |    7 +-
 include/linux/netfilter/xt_LED.h               |   15 +++
 include/linux/netfilter/xt_MARK.h              |   19 +---
 include/linux/netfilter/xt_NFLOG.h             |   14 ++-
 include/linux/netfilter/xt_NFQUEUE.h           |    8 +-
 include/linux/netfilter/xt_RATEEST.h           |    6 +-
 include/linux/netfilter/xt_SECMARK.h           |    6 +-
 include/linux/netfilter/xt_TCPMSS.h            |    4 +-
 include/linux/netfilter/xt_connbytes.h         |    9 +-
 include/linux/netfilter/xt_connmark.h          |   11 +--
 include/linux/netfilter/xt_conntrack.h         |   44 +--------
 include/linux/netfilter/xt_dccp.h              |   14 ++-
 include/linux/netfilter/xt_dscp.h              |   12 ++-
 include/linux/netfilter/xt_esp.h               |    9 +-
 include/linux/netfilter/xt_hashlimit.h         |   32 +++---
 include/linux/netfilter/xt_iprange.h           |    4 +-
 include/linux/netfilter/xt_length.h            |    6 +-
 include/linux/netfilter/xt_limit.h             |   17 ++--
 include/linux/netfilter/xt_mark.h              |    9 +-
 include/linux/netfilter/xt_multiport.h         |   27 +++---
 include/linux/netfilter/xt_owner.h             |    8 +-
 include/linux/netfilter/xt_physdev.h           |    6 +-
 include/linux/netfilter/xt_policy.h            |   32 +++----
 include/linux/netfilter/xt_quota.h             |    4 +-
 include/linux/netfilter/xt_rateest.h           |   14 ++-
 include/linux/netfilter/xt_realm.h             |    8 +-
 include/linux/netfilter/xt_recent.h            |   12 ++-
 include/linux/netfilter/xt_sctp.h              |   36 ++++---
 include/linux/netfilter/xt_state.h             |    3 +-
 include/linux/netfilter/xt_statistic.h         |   19 ++--
 include/linux/netfilter/xt_string.h            |   15 ++--
 include/linux/netfilter/xt_tcpmss.h            |    6 +-
 include/linux/netfilter/xt_tcpudp.h            |   26 +++---
 include/linux/netfilter_ipv4.h                 |    1 +
 include/linux/netfilter_ipv4/ip_tables.h       |   15 +--
 include/linux/netfilter_ipv4/ipt_ECN.h         |    4 +-
 include/linux/netfilter_ipv4/ipt_SAME.h        |    3 +-
 include/linux/netfilter_ipv4/ipt_TOS.h         |   12 ---
 include/linux/netfilter_ipv4/ipt_ah.h          |    3 +-
 include/linux/netfilter_ipv4/ipt_ecn.h         |    4 +-
 include/linux/netfilter_ipv4/ipt_iprange.h     |   21 ----
 include/linux/netfilter_ipv4/ipt_owner.h       |   20 ----
 include/linux/netfilter_ipv4/ipt_policy.h      |   23 -----
 include/linux/netfilter_ipv4/ipt_tos.h         |   13 ---
 include/linux/netfilter_ipv6.h                 |   12 +--
 include/linux/netfilter_ipv6/ip6_tables.h      |   24 ++---
 include/linux/netfilter_ipv6/ip6t_ah.h         |    3 +-
 include/linux/netfilter_ipv6/ip6t_frag.h       |    3 +-
 include/linux/netfilter_ipv6/ip6t_ipv6header.h |    3 +-
 include/linux/netfilter_ipv6/ip6t_mh.h         |    3 +-
 include/linux/netfilter_ipv6/ip6t_opts.h       |    3 +-
 include/linux/netfilter_ipv6/ip6t_owner.h      |   18 ----
 include/linux/netfilter_ipv6/ip6t_policy.h     |   23 -----
 include/linux/netfilter_ipv6/ip6t_rt.h         |    3 +-
 include/linux/types.h                          |  127 +-----------------------
 libipq/Makefile.am                             |    4 +-
 78 files changed, 445 insertions(+), 671 deletions(-)
 create mode 100644 include/linux/netfilter/xt_LED.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_TOS.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_iprange.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_owner.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_policy.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_tos.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_owner.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_policy.h
