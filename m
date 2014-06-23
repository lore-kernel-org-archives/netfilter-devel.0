From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter packet logging updates
Date: Mon, 23 Jun 2014 16:41:04 +0200
Message-ID: <1403534473-5178-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, fw@strlen.de,
	eric.dumazet@gmail.com, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbaFWOle (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:41:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

The following patch series contain updates for the Netfilter packet
logging infrastructure that aim to finish the nft_log support by
providing isolated modules that implement the family packet logger
for IPv4, IPv6, ARP and bridged packets.

The result is somewhat similar to what we already have in the
conntrack and NAT subsystems, ie. per-family modularized code. The
output format aims to be consistent for all families, so nf_tables
will solve the inconsistencies between the ebtables and ip{6}tables
plain text logging formats. The bridge logger also doesn't replicate
the IPv4, IPv6 and ARP code to log packets anymore.

These are the patches:

1) Kill the ulog targets, both ebt_ulog and ipt_ULOG. It's been a long
   time since we're providing the nfnetlink_log infrastructure.

2) Use an array of loggers, one per type. Basically, we can have the
   plain text packet logger and the netlink packet logging infrastructure.
   Now that the old ulog targets are gone, we don't need to keep the list
   of overlapping loggers anymore. This change prepares the follow up
   patch to consolidate nf_log_packet() interface.

3) Move Eric Dumazet's log buffering used by xt_LOG to the nf_log core
   so it can be used from other packet loggers, such as the new ARP
   packet logger.

4) Move the family specific code from xt_LOG to nf_log_ipv4.c,
   nf_log_ipv6.c and nf_log_common.c. This allows us to register one
   logger per family which can be used both from nft_log and xt_LOG.

5) Use the struct nf_loginfo parameter as the explict logger to be used
   through nf_log_packet(). Thus, the nf_log_packet() routes the packet
   to the corresponding family and type logger. If not specified, it still
   uses the default logger.

6) Add the ARP packet logger, which is indirectly used by nft_log through
   nf_log_packet().

7) Add the bridged packet logger. The ebt_log output has been left in
   place not to break backward compatibility. The ebt_log is not the
   default logger anymore, we should also reject new patches that use
   nf_log_packet() from the ebtables code.

8) Add the inet packet logger for the special inet chain.

9) Complete the nft_log support by allowing to specify the type of logging
   through the NFTA_LOG_SYSLOG and NFTA_LOG_GROUP attributes, which allows
   you to select plain kernel logging through the ringbuffer and the
   nfnetlink_log infrastructure.

Please, let me know if you have any comment. Thanks.

Pablo Neira Ayuso (9):
  netfilter: kill ulog targets
  netfilter: nf_log: use an array of loggers instead of list
  netfilter: nf_log: move log buffering to core logging
  netfilter: log: split family specific code to nf_log_{ip,ip6,common}.c files
  netfilter: log: nf_log_packet() as real unified interface
  netfilter: add generic ARP packet logger
  netfilter: bridge: add generic packet logger
  netfilter: add generic inet packet logger
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
 net/netfilter/Kconfig                          |   10 +
 net/netfilter/Makefile                         |    4 +
 net/netfilter/nf_log.c                         |  144 +++-
 net/netfilter/nf_log_common.c                  |  187 +++++
 net/netfilter/nf_log_inet.c                    |   78 +++
 net/netfilter/nfnetlink_log.c                  |    4 +
 net/netfilter/nft_log.c                        |   81 ++-
 net/netfilter/xt_LOG.c                         |  884 +-----------------------
 28 files changed, 1597 insertions(+), 2026 deletions(-)
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
 create mode 100644 net/netfilter/nf_log_inet.c

-- 
1.7.10.4

