From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/08: Netfilter Update
Date: Mon, 21 Jul 2008 18:17:23 +0200 (MEST)
Message-ID: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYGUQRY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following are a few netfilter fixes and some late comer patches
for the merge window, containing:

- a patch to convert conntrack accounting to ct_extend and make it
  run-time selectable by Krzysztof Oledzki

- a patch to send the complete hardware header and all necessary
  information to interpret it to userspace in nfnetlink_log by
  Eric Leblond

- Herbert's fix for SIP NAT SDP parsing

- fixes for some SCTP sparse warnings that were introduced recently

- a fix for xt_time's use of do_div()

- minor cleanups

Please apply, thanks.


 Documentation/feature-removal-schedule.txt         |   10 ++
 Documentation/kernel-parameters.txt                |    7 ++
 include/linux/netfilter/nf_conntrack_common.h      |    8 +--
 include/linux/netfilter/nfnetlink_conntrack.h      |    8 +-
 include/linux/netfilter/nfnetlink_log.h            |    3 +
 include/net/netfilter/nf_conntrack.h               |    6 -
 include/net/netfilter/nf_conntrack_acct.h          |   51 ++++++++++
 include/net/netfilter/nf_conntrack_extend.h        |    2 +
 include/net/netlink.h                              |    3 +
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   18 +---
 net/ipv4/netfilter/nf_nat_core.c                   |    8 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   38 +++++---
 net/netfilter/Kconfig                              |    9 ++
 net/netfilter/Makefile                             |    2 +-
 net/netfilter/nf_conntrack_acct.c                  |  104 ++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c                  |   39 +++++---
 net/netfilter/nf_conntrack_netlink.c               |   44 ++++-----
 net/netfilter/nf_conntrack_proto_sctp.c            |    8 +-
 net/netfilter/nf_conntrack_standalone.c            |   18 +---
 net/netfilter/nfnetlink_log.c                      |    8 ++
 net/netfilter/xt_TCPMSS.c                          |   42 +++------
 net/netfilter/xt_connbytes.c                       |    8 +-
 net/netfilter/xt_time.c                            |    2 +-
 23 files changed, 309 insertions(+), 137 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_acct.h
 create mode 100644 net/netfilter/nf_conntrack_acct.c

Changli Gao (1):
      netfilter: nf_nat_core: eliminate useless find_appropriate_src for IP_NAT_RANGE_PROTO_RANDOM

David Howells (1):
      netfilter: xt_time: fix time's time_mt()'s use of do_div()

Eric Leblond (1):
      netfilter: nfnetlink_log: send complete hardware header

Herbert Xu (1):
      netfilter: nf_nat_sip: c= is optional for session

Jan Engelhardt (1):
      netfilter: xt_TCPMSS: collapse tcpmss_reverse_mtu{4,6} into one function

Krzysztof Piotr Oledzki (2):
      netlink: add NLA_PUT_BE64 macro
      netfilter: accounting rework: ct_extend + 64bit counters (v4)

Patrick McHardy (1):
      netfilter: nf_conntrack_sctp: fix sparse warnings
