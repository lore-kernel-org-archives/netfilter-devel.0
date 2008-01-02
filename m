From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 0/27] Netfilter update
Date: Wed, 2 Jan 2008 21:18:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49272 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbYABUSS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:18:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,


Please cherrypick (or fetch&merge) from

	git://computergmbh.de/linux netfilter

	commits b6e9a26f05e83d8058f1dc56a45e5f5d533ad373 to
	ff4d6f3afa5c8edb602a50abafb0ae7a2bb6132d (inclusive)

to receive the strawberries listed below (will also be posted as
replies to this mail for easy review from mailclient).
I planned for these to also go in for 2.6.25 already.

Jan Engelhardt (27):
      [NETFILTER]: remove ipt_TOS.c
      [NETFILTER]: Change semantic of mask value in xt_TOS
      [NETFILTER]: Properly set the TOS field in xt_TOS
      [NETFILTER]: Annotate start of kernel fields in NF headers
      [NETFILTER]: Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
      [NETFILTER]: xt_CONNMARK target, revision 1
      [NETFILTER]: xt_MARK target, revision 2
      [NETFILTER]: xt_connmark match, revision 1
      [NETFILTER]: Extend nf_inet_addr with in{,6}_addr
      [NETFILTER}: xt_conntrack match, revision 1
      [NETFILTER]: xt_hashlimit: use the new union nf_inet_addr
      [NETFILTER]: xt_hashlimit match, revision 1
      [NETFILTER]: xt_helper: Do not bypass RCU
      [NETFILTER]: xt_helper match, revision 1
      [NETFILTER]: xt_length match, revision 1
      [NETFILTER]: xt_mark match, revision 1
      [NETFILTER]: xt_pkttype: Add explicit check for IPv4
      [NETFILTER]: xt_pkttype IPv6 multicast address recognition
      [NETFILTER]: xt_policy: use the new unoin nf_inet_addr
      [NETFILTER]: Update modules' descriptions
      [NETFILTER]: Convert unfixated types to fixated ones.
      [NETFILTER]: Rename ipt_iprange to xt_iprange
      [NETFILTER]: xt_iprange match, revision 1
      [NETFILTER]: Merge ipt_REJECT and ip6t_REJECT into xt_REJECT
      [NETFILTER]: Merge ipt_ah and ip6t_ah into xt_ah
      [NETFILTER]: Unknot xt_ah IPv6 logic
      [NETFILTER]: Update feature-removal-schedule.txt

 Documentation/feature-removal-schedule.txt   |   44 ++
 include/linux/netfilter.h                    |    4 +
 include/linux/netfilter/xt_CONNMARK.h        |    5 +
 include/linux/netfilter/xt_MARK.h            |    4 +
 include/linux/netfilter/xt_RATEEST.h         |    2 +
 include/linux/netfilter/xt_connlimit.h       |    4 +-
 include/linux/netfilter/xt_connmark.h        |    5 +
 include/linux/netfilter/xt_conntrack.h       |   16 +-
 include/linux/netfilter/xt_hashlimit.h       |   39 ++-
 include/linux/netfilter/xt_helper.h          |    6 +
 include/linux/netfilter/xt_iprange.h         |   17 +
 include/linux/netfilter/xt_length.h          |   18 +
 include/linux/netfilter/xt_mac.h             |    4 +-
 include/linux/netfilter/xt_mark.h            |    5 +
 include/linux/netfilter/xt_pkttype.h         |    4 +-
 include/linux/netfilter/xt_policy.h          |   23 +-
 include/linux/netfilter/xt_quota.h           |    2 +
 include/linux/netfilter/xt_rateest.h         |    2 +
 include/linux/netfilter/xt_sctp.h            |    2 +-
 include/linux/netfilter/xt_state.h           |    2 +-
 include/linux/netfilter/xt_statistic.h       |    1 +
 include/linux/netfilter/xt_string.h          |    2 +
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |    1 +
 include/linux/netfilter_ipv4/ipt_LOG.h       |    4 +-
 include/linux/netfilter_ipv4/ipt_SAME.h      |    2 +-
 include/linux/netfilter_ipv4/ipt_iprange.h   |    6 +-
 include/linux/netfilter_ipv4/ipt_sctp.h      |    2 +-
 include/linux/netfilter_ipv6/ip6t_LOG.h      |    4 +-
 net/ipv4/netfilter/Kconfig                   |   31 --
 net/ipv4/netfilter/Makefile                  |    3 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c           |    2 +-
 net/ipv4/netfilter/ipt_ECN.c                 |    2 +-
 net/ipv4/netfilter/ipt_LOG.c                 |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c          |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c              |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c            |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c              |  251 ---------
 net/ipv4/netfilter/ipt_TOS.c                 |   82 ---
 net/ipv4/netfilter/ipt_TTL.c                 |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c            |    2 +-
 net/ipv4/netfilter/ipt_ah.c                  |  105 ----
 net/ipv4/netfilter/ipt_ecn.c                 |    2 +-
 net/ipv4/netfilter/ipt_iprange.c             |   77 ---
 net/ipv4/netfilter/ipt_recent.c              |    2 +-
 net/ipv4/netfilter/ipt_ttl.c                 |    2 +-
 net/ipv6/netfilter/Kconfig                   |   20 -
 net/ipv6/netfilter/Makefile                  |    2 -
 net/ipv6/netfilter/ip6t_HL.c                 |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c                |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c             |  260 ----------
 net/ipv6/netfilter/ip6t_ah.c                 |  131 -----
 net/ipv6/netfilter/ip6t_eui64.c              |    2 +-
 net/ipv6/netfilter/ip6t_frag.c               |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c                |    2 +-
 net/ipv6/netfilter/ip6t_hl.c                 |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c         |    2 +-
 net/ipv6/netfilter/ip6t_mh.c                 |    2 +-
 net/ipv6/netfilter/ip6t_rt.c                 |    2 +-
 net/netfilter/Kconfig                        |   29 +
 net/netfilter/Makefile                       |    3 +
 net/netfilter/xt_CLASSIFY.c                  |    2 +-
 net/netfilter/xt_CONNMARK.c                  |  119 ++++-
 net/netfilter/xt_CONNSECMARK.c               |    2 +-
 net/netfilter/xt_DSCP.c                      |    8 +-
 net/netfilter/xt_MARK.c                      |   76 ++-
 net/netfilter/xt_NFLOG.c                     |    2 +-
 net/netfilter/xt_NFQUEUE.c                   |    2 +-
 net/netfilter/xt_NOTRACK.c                   |    1 +
 net/netfilter/xt_RATEEST.c                   |    2 +-
 net/netfilter/xt_REJECT.c                    |  484 ++++++++++++++++++
 net/netfilter/xt_SECMARK.c                   |    2 +-
 net/netfilter/xt_TCPMSS.c                    |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c               |    2 +-
 net/netfilter/xt_TRACE.c                     |    1 +
 net/netfilter/xt_ah.c                        |  194 +++++++
 net/netfilter/xt_comment.c                   |    2 +-
 net/netfilter/xt_connbytes.c                 |    2 +-
 net/netfilter/xt_connlimit.c                 |    2 +-
 net/netfilter/xt_connmark.c                  |   86 +++-
 net/netfilter/xt_conntrack.c                 |  209 +++++++-
 net/netfilter/xt_dccp.c                      |    2 +-
 net/netfilter/xt_dscp.c                      |    2 +-
 net/netfilter/xt_esp.c                       |    2 +-
 net/netfilter/xt_hashlimit.c                 |  361 +++++++++++---
 net/netfilter/xt_helper.c                    |  101 ++++-
 net/netfilter/xt_iprange.c                   |  181 +++++++
 net/netfilter/xt_length.c                    |  198 +++++++-
 net/netfilter/xt_limit.c                     |   56 +--
 net/netfilter/xt_mac.c                       |    2 +-
 net/netfilter/xt_mark.c                      |   66 ++-
 net/netfilter/xt_multiport.c                 |    2 +-
 net/netfilter/xt_owner.c                     |    2 +-
 net/netfilter/xt_physdev.c                   |    2 +-
 net/netfilter/xt_pkttype.c                   |   19 +-
 net/netfilter/xt_policy.c                    |   17 +-
 net/netfilter/xt_quota.c                     |    1 +
 net/netfilter/xt_realm.c                     |    2 +-
 net/netfilter/xt_sctp.c                      |    2 +-
 net/netfilter/xt_state.c                     |    2 +
 net/netfilter/xt_statistic.c                 |    2 +-
 net/netfilter/xt_string.c                    |    2 +-
 net/netfilter/xt_tcpmss.c                    |    2 +-
 net/netfilter/xt_tcpudp.c                    |    2 +-
 net/netfilter/xt_time.c                      |    2 +-
 net/netfilter/xt_u32.c                       |    2 +-
 106 files changed, 2177 insertions(+), 1321 deletions(-)
 create mode 100644 include/linux/netfilter/xt_iprange.h
 delete mode 100644 net/ipv4/netfilter/ipt_REJECT.c
 delete mode 100644 net/ipv4/netfilter/ipt_TOS.c
 delete mode 100644 net/ipv4/netfilter/ipt_ah.c
 delete mode 100644 net/ipv4/netfilter/ipt_iprange.c
 delete mode 100644 net/ipv6/netfilter/ip6t_REJECT.c
 delete mode 100644 net/ipv6/netfilter/ip6t_ah.c
 create mode 100644 net/netfilter/xt_REJECT.c
 create mode 100644 net/netfilter/xt_ah.c
 create mode 100644 net/netfilter/xt_iprange.c
