From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: audit fix, headers,
Date: Tue, 18 Jan 2011 16:16:54 +0100
Message-ID: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40481 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1ARPRH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:17:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit fbabf31e4d482149b5e2704eb0287cf9117bdcf3:

  netfilter: create audit records for x_tables replaces (2011-01-16 18:12:59 +0100)

are available in the git repository at:
  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: add missing aliases for autoloading via iptables
      audit: export symbol for use with xt_AUDIT
      netfilter: xtables: use __uXX guarded types for userspace exports
      netfilter: xtables: add missing header files to export list

Richard Weinberger (1):
      netfilter: xt_connlimit: use hotdrop jump mark

 include/linux/netfilter/Kbuild                 |    2 ++
 include/linux/netfilter_bridge/ebt_802_3.h     |   24 ++++++++++++------------
 include/linux/netfilter_bridge/ebt_among.h     |    2 +-
 include/linux/netfilter_bridge/ebt_arp.h       |    4 ++--
 include/linux/netfilter_bridge/ebt_ip.h        |   12 ++++++------
 include/linux/netfilter_bridge/ebt_ip6.h       |   16 ++++++++--------
 include/linux/netfilter_bridge/ebt_limit.h     |    8 ++++----
 include/linux/netfilter_bridge/ebt_log.h       |    6 +++---
 include/linux/netfilter_bridge/ebt_mark_m.h    |    4 ++--
 include/linux/netfilter_bridge/ebt_nflog.h     |   10 +++++-----
 include/linux/netfilter_bridge/ebt_pkttype.h   |    4 ++--
 include/linux/netfilter_bridge/ebt_stp.h       |   24 ++++++++++++------------
 include/linux/netfilter_bridge/ebt_ulog.h      |    2 +-
 include/linux/netfilter_bridge/ebt_vlan.h      |    8 ++++----
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h   |   14 +++++++-------
 include/linux/netfilter_ipv4/ipt_ECN.h         |    6 +++---
 include/linux/netfilter_ipv4/ipt_SAME.h        |    6 +++---
 include/linux/netfilter_ipv4/ipt_TTL.h         |    4 ++--
 include/linux/netfilter_ipv4/ipt_addrtype.h    |   14 +++++++-------
 include/linux/netfilter_ipv4/ipt_ah.h          |    4 ++--
 include/linux/netfilter_ipv4/ipt_ecn.h         |    8 ++++----
 include/linux/netfilter_ipv4/ipt_ttl.h         |    4 ++--
 include/linux/netfilter_ipv6/ip6t_HL.h         |    4 ++--
 include/linux/netfilter_ipv6/ip6t_REJECT.h     |    2 +-
 include/linux/netfilter_ipv6/ip6t_ah.h         |    8 ++++----
 include/linux/netfilter_ipv6/ip6t_frag.h       |    8 ++++----
 include/linux/netfilter_ipv6/ip6t_hl.h         |    4 ++--
 include/linux/netfilter_ipv6/ip6t_ipv6header.h |    6 +++---
 include/linux/netfilter_ipv6/ip6t_mh.h         |    4 ++--
 include/linux/netfilter_ipv6/ip6t_opts.h       |   10 +++++-----
 include/linux/netfilter_ipv6/ip6t_rt.h         |   12 ++++++------
 kernel/audit.c                                 |    2 ++
 net/netfilter/xt_IDLETIMER.c                   |    2 ++
 net/netfilter/xt_LED.c                         |    2 ++
 net/netfilter/xt_connlimit.c                   |    6 ++----
 net/netfilter/xt_cpu.c                         |    2 ++
 36 files changed, 133 insertions(+), 125 deletions(-)
