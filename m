From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables features 20110905
Date: Mon,  5 Sep 2011 20:24:37 +0200
Message-ID: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33387 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab1IESYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:24:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit bf42cf92ea0c53e5470a20d62d00e5e83379f4d5:

  Merge branch 'stable' of git://dev.medozas.de/iptables (2011-09-05 20:16:07 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      libxt_addrtype: rename from libipt_addrtype
      libxt_addrtype: add support for revision 1
      include: refresh include files from kernel 3.1-rc3

 extensions/{libipt_addrtype.c => libxt_addrtype.c} |   56 ++---
 .../{libipt_addrtype.man => libxt_addrtype.man}    |    0
 include/linux/kernel.h                             |   33 ---
 include/linux/netfilter.h                          |   18 ++-
 include/linux/netfilter/ipset/ip_set.h             |  225 ++++++++++++++++++++
 include/linux/netfilter/nf_conntrack_common.h      |   14 ++
 .../linux/netfilter/nf_conntrack_tuple_common.h    |    3 +-
 include/linux/netfilter/x_tables.h                 |    5 +
 include/linux/netfilter/xt_CT.h                    |    2 +
 include/linux/netfilter/xt_TCPOPTSTRIP.h           |    2 +
 include/linux/netfilter/xt_TPROXY.h                |    2 +
 include/linux/netfilter/xt_addrtype.h              |   44 ++++
 include/linux/netfilter/xt_cluster.h               |    2 +
 include/linux/netfilter/xt_connbytes.h             |    4 +-
 include/linux/netfilter/xt_connlimit.h             |    2 +
 include/linux/netfilter/xt_physdev.h               |    3 -
 include/linux/netfilter/xt_policy.h                |   11 -
 include/linux/netfilter/xt_quota.h                 |    4 +-
 include/linux/netfilter/xt_sctp.h                  |    4 +-
 include/linux/netfilter/xt_set.h                   |   81 +------
 include/linux/netfilter/xt_socket.h                |    2 +
 include/linux/netfilter/xt_time.h                  |    2 +
 include/linux/netfilter/xt_u32.h                   |    2 +
 include/linux/netfilter_ipv4/ip_tables.h           |   82 ++++----
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |   16 +-
 include/linux/netfilter_ipv4/ipt_ECN.h             |    8 +-
 include/linux/netfilter_ipv4/ipt_SAME.h            |    8 +-
 include/linux/netfilter_ipv4/ipt_TTL.h             |    6 +-
 include/linux/netfilter_ipv4/ipt_addrtype.h        |   16 +-
 include/linux/netfilter_ipv4/ipt_ah.h              |    6 +-
 include/linux/netfilter_ipv4/ipt_ecn.h             |   10 +-
 include/linux/netfilter_ipv4/ipt_ttl.h             |    6 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |  100 ++++------
 include/linux/netfilter_ipv6/ip6t_HL.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_REJECT.h         |    4 +-
 include/linux/netfilter_ipv6/ip6t_ah.h             |   10 +-
 include/linux/netfilter_ipv6/ip6t_frag.h           |   10 +-
 include/linux/netfilter_ipv6/ip6t_hl.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_ipv6header.h     |    8 +-
 include/linux/netfilter_ipv6/ip6t_mh.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_opts.h           |   12 +-
 include/linux/netfilter_ipv6/ip6t_rt.h             |   13 +-
 include/linux/types.h                              |   13 ++
 43 files changed, 543 insertions(+), 324 deletions(-)
 rename extensions/{libipt_addrtype.c => libxt_addrtype.c} (82%)
 rename extensions/{libipt_addrtype.man => libxt_addrtype.man} (100%)
 create mode 100644 include/linux/netfilter/ipset/ip_set.h
 create mode 100644 include/linux/netfilter/xt_addrtype.h
