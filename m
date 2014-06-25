From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter packet logging updates (v2)
Date: Wed, 25 Jun 2014 14:32:34 +0200
Message-ID: <1403699563-3604-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbaFYMcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:32:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

This is a second round of patches to update the Netfilter packet
logging infrastructure [1] to finish the nft_log support for all the
supported families: inet, ip, ip6, arp and bridge.

The main changes with regards to v1 are:

1) The patch [8/9] ("netfilter: add generic inet packet logger") has
   been replaced by ("netfilter: nft_log: request explicit logger
   when loading rules"). Basically, the inet logger is not really
   required since we don't see packets of NFPROTO_INET family type,
   but the real NFPROTO_IPV4 and NFPROTO_IPV6 types. The new patch
   just grabs the IPV4 and IPv6 loggers when you add a rule to the
   inet table that uses the log statement.

2) Fix missing RCU assignment/dereferencing in the original patch
   [2/9] ("netfilter: nf_log: use an array of loggers instead of
   list").

I'll let the patches remain on the table this week, if no concerns
arise I'll push them to the nf-next tree.

Thanks.

[1] http://marc.info/?l=netfilter-devel&m=140353449907890&w=2

Pablo Neira Ayuso (9):
  netfilter: kill ulog targets
  netfilter: nf_log: use an array of loggers instead of list
  netfilter: nf_log: move log buffering to core logging
  netfilter: log: split family specific code to nf_log_{ip,ip6,common}.c files
  netfilter: log: nf_log_packet() as real unified interface
  netfilter: add generic ARP packet logger
  netfilter: bridge: add generic packet logger
  netfilter: nft_log: request explicit logger when loading rules
  netfilter: nft_log: complete logging support

 include/net/netfilter/nf_log.h                 |   42 +-
 include/net/netfilter/xt_log.h                 |   54 --
 include/uapi/linux/netfilter/nf_tables.h       |    4 +
 include/uapi/linux/netfilter_bridge/Kbuild     |    1 -
 include/uapi/linux/netfilter_bridge/ebt_ulog.h |   38 -
 include/uapi/linux/netfilter_ipv4/Kbuild       |    1 -
 include/uapi/linux/netfilter_ipv4/ipt_ULOG.h   |   49 --
 net/bridge/netfilter/Kconfig                   |   19 +-
 net/bridge/netfilter/Makefile                  |    3 +
 net/bridge/netfilter/ebt_log.c                 |   47 +-
 net/bridge/netfilter/ebt_ulog.c                |  393 -----------
 net/bridge/netfilter/nf_log_bridge.c           |   96 +++
 net/ipv4/netfilter/Kconfig                     |   23 +-
 net/ipv4/netfilter/Makefile                    |    4 +
 net/ipv4/netfilter/ipt_ULOG.c                  |  498 -------------
 net/ipv4/netfilter/nf_log_arp.c                |  149 ++++
 net/ipv4/netfilter/nf_log_ipv4.c               |  385 +++++++++++
 net/ipv6/netfilter/Kconfig                     |    5 +
 net/ipv6/netfilter/Makefile                    |    3 +
 net/ipv6/netfilter/nf_log_ipv6.c               |  417 +++++++++++
 net/netfilter/Kconfig                          |    6 +
 net/netfilter/Makefile                         |    3 +
 net/netfilter/nf_log.c                         |  149 +++-
 net/netfilter/nf_log_common.c                  |  187 +++++
 net/netfilter/nfnetlink_log.c                  |    4 +
 net/netfilter/nft_log.c                        |   98 ++-
 net/netfilter/xt_LOG.c                         |  884 +-----------------------
 27 files changed, 1537 insertions(+), 2025 deletions(-)
 delete mode 100644 include/net/netfilter/xt_log.h
 delete mode 100644 include/uapi/linux/netfilter_bridge/ebt_ulog.h
 delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ULOG.h
 delete mode 100644 net/bridge/netfilter/ebt_ulog.c
 create mode 100644 net/bridge/netfilter/nf_log_bridge.c
 delete mode 100644 net/ipv4/netfilter/ipt_ULOG.c
 create mode 100644 net/ipv4/netfilter/nf_log_arp.c
 create mode 100644 net/ipv4/netfilter/nf_log_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_log_ipv6.c
 create mode 100644 net/netfilter/nf_log_common.c

-- 
1.7.10.4

