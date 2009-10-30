From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables optarg fix
Date: Fri, 30 Oct 2009 09:39:25 +0100
Message-ID: <1256891969-18437-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46755 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbZJ3Ija (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:39:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



The following changes since commit 4f0d7b660e0ae8f678142fd2a1722b27ad472169:
  Jan Engelhardt (1):
        iptables: fix undersized deletion mask creation

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      style: reduce indent in xtables_check_inverse
      xtables: deactivate intrapositional support
      iptables/extensions: make bundled options work again

 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_rt.c         |    8 ++++----
 extensions/libipt_SET.c         |    6 +++---
 extensions/libipt_addrtype.c    |    8 ++++----
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_realm.c       |    4 ++--
 extensions/libipt_set.c         |    6 +++---
 extensions/libxt_comment.c      |    4 ++--
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    4 ++--
 extensions/libxt_conntrack.c    |   18 +++++++++---------
 extensions/libxt_dccp.c         |    8 ++++----
 extensions/libxt_dscp.c         |    4 ++--
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_hashlimit.c    |   16 ++++++++--------
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |    4 ++--
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_multiport.c    |   24 ++++++++++++------------
 extensions/libxt_physdev.c      |    4 ++--
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_rateest.c      |    6 +++---
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_string.c       |    4 ++--
 extensions/libxt_tcp.c          |    8 ++++----
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    4 ++--
 ip6tables.c                     |   12 ++++++------
 iptables.c                      |   15 ++++++---------
 xtables.c                       |   25 +++++++------------------
 40 files changed, 114 insertions(+), 128 deletions(-)
