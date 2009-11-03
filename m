From: Jan Engelhardt <jengelh@medozas.de>
Subject: Bug 611, plan B
Date: Tue,  3 Nov 2009 21:58:17 +0100
Message-ID: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50731 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbZKCU6S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:58:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Of course there is a plan B that is, given the recent input, is
undoubtly less intrusive. Intra-! support is retained while option
bundling is now supported.

-----
The following changes since commit 4f0d7b660e0ae8f678142fd2a1722b27ad472169:
  Jan Engelhardt (1):
        iptables: fix undersized deletion mask creation

are available in the git repository at:

  git://dev.medozas.de/iptables bug611

Jan Engelhardt (3):
      style: reduce indent in xtables_check_inverse
      libxtables: hand argv to xtables_check_inverse
      iptables/extensions: make bundled options work again

 configure.ac                    |    4 ++--
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    4 ++--
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    8 ++++----
 extensions/libip6t_dst.c        |    8 ++++----
 extensions/libip6t_frag.c       |    8 ++++----
 extensions/libip6t_hbh.c        |    8 ++++----
 extensions/libip6t_hl.c         |    4 ++--
 extensions/libip6t_icmp6.c      |    4 ++--
 extensions/libip6t_ipv6header.c |    4 ++--
 extensions/libip6t_mh.c         |    4 ++--
 extensions/libip6t_rt.c         |   16 ++++++++--------
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_LOG.c         |    4 ++--
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    2 +-
 extensions/libipt_SET.c         |    8 ++++----
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    4 ++--
 extensions/libipt_addrtype.c    |   16 ++++++++--------
 extensions/libipt_ah.c          |    4 ++--
 extensions/libipt_ecn.c         |    6 +++---
 extensions/libipt_icmp.c        |    4 ++--
 extensions/libipt_realm.c       |    4 ++--
 extensions/libipt_set.c         |    8 ++++----
 extensions/libipt_ttl.c         |    2 +-
 extensions/libxt_NFLOG.c        |    4 ++--
 extensions/libxt_cluster.c      |    4 ++--
 extensions/libxt_comment.c      |    4 ++--
 extensions/libxt_connbytes.c    |    4 ++--
 extensions/libxt_connlimit.c    |    6 +++---
 extensions/libxt_connmark.c     |    2 +-
 extensions/libxt_conntrack.c    |   34 +++++++++++++++++-----------------
 extensions/libxt_dccp.c         |   16 ++++++++--------
 extensions/libxt_dscp.c         |    8 ++++----
 extensions/libxt_esp.c          |    4 ++--
 extensions/libxt_hashlimit.c    |   16 ++++++++--------
 extensions/libxt_helper.c       |    2 +-
 extensions/libxt_iprange.c      |    4 ++--
 extensions/libxt_length.c       |    4 ++--
 extensions/libxt_limit.c        |    4 ++--
 extensions/libxt_mac.c          |    4 ++--
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |   24 ++++++++++++------------
 extensions/libxt_physdev.c      |   14 +++++++-------
 extensions/libxt_pkttype.c      |    4 ++--
 extensions/libxt_policy.c       |    8 ++++----
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |   20 ++++++++++----------
 extensions/libxt_recent.c       |    8 ++++----
 extensions/libxt_sctp.c         |   12 ++++++------
 extensions/libxt_state.c        |    4 ++--
 extensions/libxt_string.c       |    8 ++++----
 extensions/libxt_tcp.c          |   16 ++++++++--------
 extensions/libxt_tcpmss.c       |    4 ++--
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    8 ++++----
 include/xtables.h.in            |    2 +-
 ip6tables.c                     |   22 +++++++++++-----------
 iptables.c                      |   22 +++++++++++-----------
 xtables.c                       |   35 ++++++++++++++++++-----------------
 66 files changed, 245 insertions(+), 244 deletions(-)
