From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: accumulated bugfixes and annotations
Date: Sat,  8 Jan 2011 16:20:01 +0100
Message-ID: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32868 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1AHPUQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hey Pablo,


could you please pull this while Patrick is away, so that users get a
chance to benefit of these accumulated bugfixes.

==
The following changes since commit 3a84b3d5de492e40aff7bae5038b06dd6b6041c4:

  Merge branch 'master' of git://dev.medozas.de/iptables (2010-12-15 23:36:19 +0100)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (11):
      src: const annotations
      xt_comment: remove redundant cast
      src: use C99/POSIX types
      iptables: abort on empty interface specification
      xtables: reorder num_old substraction for clarity
      ip[6]tables: only call match's parse function when option char is in range
      ip[6]tables: only call target's parse function when option char is in range
      extensions: remove no longer necessary default: cases
      libxt_sctp: fix a typo
      libipt_CLUSTERIP: const annotations
      libxtables: do some option structure checking

Rob Leslie (1):
      iptables-restore: resolve confusing policy error message

Stephen Beahm (1):
      libipt_REDIRECT: avoid dereference of uninitialized pointer

 extensions/libip6t_HL.c              |    4 --
 extensions/libip6t_LOG.c             |    5 +--
 extensions/libip6t_REJECT.c          |    3 --
 extensions/libip6t_ah.c              |   10 ++----
 extensions/libip6t_dst.c             |   12 +++----
 extensions/libip6t_frag.c            |    8 ++---
 extensions/libip6t_hbh.c             |   12 +++----
 extensions/libip6t_hl.c              |    4 +--
 extensions/libip6t_icmp6.c           |   13 +++-----
 extensions/libip6t_ipv6header.c      |   14 ++++-----
 extensions/libip6t_mh.c              |   13 +++-----
 extensions/libip6t_rt.c              |    8 ++---
 extensions/libipt_CLUSTERIP.c        |    8 ++---
 extensions/libipt_DNAT.c             |    4 +--
 extensions/libipt_ECN.c              |    2 -
 extensions/libipt_LOG.c              |    4 +--
 extensions/libipt_MASQUERADE.c       |    4 +--
 extensions/libipt_NETMAP.c           |   14 ++++-----
 extensions/libipt_REDIRECT.c         |    6 +--
 extensions/libipt_REJECT.c           |    2 -
 extensions/libipt_SAME.c             |    3 --
 extensions/libipt_SNAT.c             |    4 +--
 extensions/libipt_TTL.c              |    4 --
 extensions/libipt_ULOG.c             |    2 -
 extensions/libipt_addrtype.c         |   10 ++----
 extensions/libipt_ah.c               |    8 ++---
 extensions/libipt_ecn.c              |    2 -
 extensions/libipt_icmp.c             |   13 +++-----
 extensions/libipt_realm.c            |    3 --
 extensions/libipt_ttl.c              |    3 --
 extensions/libxt_CHECKSUM.c          |    2 -
 extensions/libxt_CLASSIFY.c          |    3 --
 extensions/libxt_CONNMARK.c          |    6 +--
 extensions/libxt_CONNSECMARK.c       |    3 --
 extensions/libxt_CT.c                |    2 -
 extensions/libxt_DSCP.c              |    5 +--
 extensions/libxt_IDLETIMER.c         |    3 --
 extensions/libxt_MARK.c              |   11 +-----
 extensions/libxt_NFLOG.c             |    2 -
 extensions/libxt_NFQUEUE.c           |    4 --
 extensions/libxt_RATEEST.c           |    3 --
 extensions/libxt_SECMARK.c           |    2 -
 extensions/libxt_SET.c               |    6 ----
 extensions/libxt_TCPMSS.c            |    3 --
 extensions/libxt_TOS.c               |    7 +---
 extensions/libxt_cluster.c           |    2 -
 extensions/libxt_comment.c           |    5 +--
 extensions/libxt_connbytes.c         |    2 -
 extensions/libxt_connlimit.c         |   10 ++----
 extensions/libxt_connmark.c          |    5 +--
 extensions/libxt_conntrack.c         |   10 +-----
 extensions/libxt_cpu.c               |    3 --
 extensions/libxt_dccp.c              |   18 +++++------
 extensions/libxt_dscp.c              |    3 --
 extensions/libxt_esp.c               |    8 ++---
 extensions/libxt_hashlimit.c         |   12 +++----
 extensions/libxt_helper.c            |    3 --
 extensions/libxt_iprange.c           |    7 +---
 extensions/libxt_ipvs.c              |    7 +----
 extensions/libxt_length.c            |    5 +--
 extensions/libxt_limit.c             |   13 +++-----
 extensions/libxt_mac.c               |    3 --
 extensions/libxt_mark.c              |    5 +--
 extensions/libxt_multiport.c         |   34 +++++++++------------
 extensions/libxt_osf.c               |    2 -
 extensions/libxt_owner.c             |   10 +++---
 extensions/libxt_physdev.c           |    3 --
 extensions/libxt_pkttype.c           |    3 --
 extensions/libxt_policy.c            |    6 +--
 extensions/libxt_quota.c             |    5 +--
 extensions/libxt_rateest.c           |    7 +---
 extensions/libxt_recent.c            |    3 --
 extensions/libxt_sctp.c              |   19 +++++-------
 extensions/libxt_set.c               |    6 ----
 extensions/libxt_state.c             |    3 --
 extensions/libxt_statistic.c         |    2 -
 extensions/libxt_string.c            |    3 --
 extensions/libxt_tcp.c               |   17 ++++------
 extensions/libxt_tcpmss.c            |    6 +--
 extensions/libxt_tos.c               |    4 +-
 extensions/libxt_u32.c               |    4 +-
 extensions/libxt_udp.c               |    9 ++----
 extensions/tos_values.c              |    2 +-
 include/linux/netfilter/xt_comment.h |    2 +-
 ip6tables-restore.c                  |    2 +-
 ip6tables.c                          |   54 +++++++++++++++++++++------------
 iptables-restore.c                   |    2 +-
 iptables.c                           |   50 ++++++++++++++++++++-----------
 libipq/libipq.c                      |    4 +-
 libiptc/libip4tc.c                   |    4 +-
 xshared.h                            |    4 ++
 xtables.c                            |   42 +++++++++++++++++++-------
 92 files changed, 262 insertions(+), 435 deletions(-)
