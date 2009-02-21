From: Jan Engelhardt <jengelh@medozas.de>
Subject: [pull] request for 20090220
Date: Sat, 21 Feb 2009 04:17:58 +0100
Message-ID: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37802 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZBUDSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Please pull some more patches from the usual location,
	git://dev.medozas.de/iptables master

Jamal, I had to truncate the OPTION_OFFSET macro of yours (it was not 
prefixed, and the only user was xtables.c), I hope this is ok with your 
proceedings with iproute2. If not, please send an update on top.

Jan Engelhardt (6):
      doc: resynchronize manpage with in-code help
      libxtables: inline and remove unused OPTION_OFFSET macro
      libxtables: prefix exit_error to xtables_error
      extensions: remove unwanted/add needed includes for IPv6 exts
      extensions: remove unwanted/add needed includes for IPv4 exts
      libxt_policy: use bounded strtoui

 extensions/dscp_helper.c        |    4 +-
 extensions/expr                 |  179 +++++++++++++++++++++++++++++++++++++++
 extensions/libip6t_HL.c         |   17 ++--
 extensions/libip6t_LOG.c        |   27 +++---
 extensions/libip6t_REJECT.c     |    5 +-
 extensions/libip6t_ah.c         |   12 ++--
 extensions/libip6t_dst.c        |   24 +++---
 extensions/libip6t_frag.c       |   18 ++--
 extensions/libip6t_hbh.c        |   24 +++---
 extensions/libip6t_hl.c         |   11 +--
 extensions/libip6t_icmp6.c      |   10 +-
 extensions/libip6t_ipv6header.c |   13 ++--
 extensions/libip6t_mh.c         |    7 +-
 extensions/libip6t_policy.c     |   65 ++++++++-------
 extensions/libip6t_rt.c         |   32 ++++----
 extensions/libipt_CLUSTERIP.c   |   39 ++++-----
 extensions/libipt_DNAT.c        |   24 +++---
 extensions/libipt_ECN.c         |   17 ++--
 extensions/libipt_LOG.c         |   27 +++---
 extensions/libipt_MASQUERADE.c  |   10 +-
 extensions/libipt_MIRROR.c      |    1 -
 extensions/libipt_NETMAP.c      |   15 ++--
 extensions/libipt_REDIRECT.c    |   12 ++--
 extensions/libipt_REJECT.c      |    5 +-
 extensions/libipt_SAME.c        |   15 ++--
 extensions/libipt_SET.c         |   11 +--
 extensions/libipt_SNAT.c        |   22 +++---
 extensions/libipt_TTL.c         |   15 ++--
 extensions/libipt_ULOG.c        |   27 +++---
 extensions/libipt_addrtype.c    |   23 +++---
 extensions/libipt_ah.c          |    8 +-
 extensions/libipt_ecn.c         |   11 +--
 extensions/libipt_icmp.c        |    8 +-
 extensions/libipt_policy.c      |   63 +++++++-------
 extensions/libipt_realm.c       |    6 +-
 extensions/libipt_set.c         |    8 +-
 extensions/libipt_set.h         |   18 ++--
 extensions/libipt_ttl.c         |   15 ++--
 extensions/libxt_CLASSIFY.c     |    6 +-
 extensions/libxt_CONNMARK.c     |   20 ++--
 extensions/libxt_CONNSECMARK.c  |   10 +-
 extensions/libxt_DSCP.c         |   10 +-
 extensions/libxt_MARK.c         |   16 ++--
 extensions/libxt_NFLOG.c        |   24 +++---
 extensions/libxt_NFQUEUE.c      |    4 +-
 extensions/libxt_RATEEST.c      |   20 ++--
 extensions/libxt_SECMARK.c      |    8 +-
 extensions/libxt_TCPMSS.c       |    8 +-
 extensions/libxt_TCPOPTSTRIP.c  |   10 +-
 extensions/libxt_TOS.c          |    4 +-
 extensions/libxt_TPROXY.c       |    2 +-
 extensions/libxt_comment.c      |    6 +-
 extensions/libxt_connbytes.c    |   10 +-
 extensions/libxt_connlimit.c    |   10 +-
 extensions/libxt_connmark.c     |    4 +-
 extensions/libxt_conntrack.c    |   54 ++++++------
 extensions/libxt_dccp.c         |   14 ++--
 extensions/libxt_dscp.c         |   10 +-
 extensions/libxt_esp.c          |   10 +-
 extensions/libxt_hashlimit.c    |   32 ++++----
 extensions/libxt_helper.c       |    4 +-
 extensions/libxt_iprange.c      |   10 +-
 extensions/libxt_length.c       |    8 +-
 extensions/libxt_limit.c        |   10 +-
 extensions/libxt_mac.c          |    6 +-
 extensions/libxt_mark.c         |    4 +-
 extensions/libxt_multiport.c    |   28 +++---
 extensions/libxt_owner.c        |    4 +-
 extensions/libxt_physdev.c      |    4 +-
 extensions/libxt_pkttype.c      |    4 +-
 extensions/libxt_quota.c        |    6 +-
 extensions/libxt_rateest.c      |   44 +++++-----
 extensions/libxt_recent.c       |   12 ++--
 extensions/libxt_sctp.c         |   18 ++--
 extensions/libxt_state.c        |    8 +-
 extensions/libxt_statistic.c    |   32 ++++----
 extensions/libxt_string.c       |   38 ++++----
 extensions/libxt_tcp.c          |   18 ++--
 extensions/libxt_tcpmss.c       |    6 +-
 extensions/libxt_time.c         |   36 ++++----
 extensions/libxt_tos.c          |    4 +-
 extensions/libxt_u32.c          |   30 +++---
 extensions/libxt_udp.c          |    6 +-
 extensions/tos_values.c         |    6 +-
 include/xtables.h.in            |    3 +-
 ip6tables-restore.c             |   26 +++---
 ip6tables-save.c                |    8 +-
 ip6tables.8.in                  |    6 +-
 ip6tables.c                     |   77 +++++++++--------
 iptables-restore.c              |   26 +++---
 iptables-save.c                 |    8 +-
 iptables-xml.c                  |   16 ++--
 iptables.8.in                   |    6 +-
 iptables.c                      |   81 +++++++++---------
 xtables.c                       |    2 +-
 95 files changed, 957 insertions(+), 788 deletions(-)
