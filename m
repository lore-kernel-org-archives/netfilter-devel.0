From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: xtables: use __uXX guarded types for userspace exports
Date: Thu, 20 Jan 2011 17:52:21 +0100
Message-ID: <1295542343-20347-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32810 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab1ATQwY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:52:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 41a7cab6d329039d614ca5f0f87aff2dfd90637c:

  netfilter: nf_nat: place conntrack in source hash after SNAT is done (2011-01-20 15:49:52 +0100)

are available in the git repository at:
  git://dev.medozas.de/linux connlimit

Jan Engelhardt (1):
      netfilter: xtables: add missing header inclusions for headers_check

 include/linux/netfilter/xt_CT.h                |    2 ++
 include/linux/netfilter/xt_TCPOPTSTRIP.h       |    2 ++
 include/linux/netfilter/xt_TPROXY.h            |    2 ++
 include/linux/netfilter/xt_cluster.h           |    2 ++
 include/linux/netfilter/xt_connlimit.h         |    2 ++
 include/linux/netfilter/xt_quota.h             |    2 ++
 include/linux/netfilter/xt_socket.h            |    2 ++
 include/linux/netfilter/xt_time.h              |    2 ++
 include/linux/netfilter/xt_u32.h               |    2 ++
 include/linux/netfilter_bridge/ebt_802_3.h     |    2 ++
 include/linux/netfilter_bridge/ebt_among.h     |    2 ++
 include/linux/netfilter_bridge/ebt_arp.h       |    2 ++
 include/linux/netfilter_bridge/ebt_ip.h        |    2 ++
 include/linux/netfilter_bridge/ebt_ip6.h       |    2 ++
 include/linux/netfilter_bridge/ebt_limit.h     |    2 ++
 include/linux/netfilter_bridge/ebt_log.h       |    2 ++
 include/linux/netfilter_bridge/ebt_mark_m.h    |    2 ++
 include/linux/netfilter_bridge/ebt_nflog.h     |    2 ++
 include/linux/netfilter_bridge/ebt_pkttype.h   |    2 ++
 include/linux/netfilter_bridge/ebt_stp.h       |    2 ++
 include/linux/netfilter_bridge/ebt_ulog.h      |    2 ++
 include/linux/netfilter_bridge/ebt_vlan.h      |    2 ++
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h   |    2 ++
 include/linux/netfilter_ipv4/ipt_ECN.h         |    2 ++
 include/linux/netfilter_ipv4/ipt_SAME.h        |    2 ++
 include/linux/netfilter_ipv4/ipt_TTL.h         |    2 ++
 include/linux/netfilter_ipv4/ipt_addrtype.h    |    2 ++
 include/linux/netfilter_ipv4/ipt_ah.h          |    2 ++
 include/linux/netfilter_ipv4/ipt_ecn.h         |    2 ++
 include/linux/netfilter_ipv4/ipt_ttl.h         |    2 ++
 include/linux/netfilter_ipv6/ip6t_HL.h         |    2 ++
 include/linux/netfilter_ipv6/ip6t_REJECT.h     |    2 ++
 include/linux/netfilter_ipv6/ip6t_ah.h         |    2 ++
 include/linux/netfilter_ipv6/ip6t_frag.h       |    2 ++
 include/linux/netfilter_ipv6/ip6t_hl.h         |    2 ++
 include/linux/netfilter_ipv6/ip6t_ipv6header.h |    2 ++
 include/linux/netfilter_ipv6/ip6t_mh.h         |    2 ++
 include/linux/netfilter_ipv6/ip6t_opts.h       |    2 ++
 include/linux/netfilter_ipv6/ip6t_rt.h         |    1 +
 39 files changed, 77 insertions(+), 0 deletions(-)
