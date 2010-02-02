From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/06: CT target
Date: Tue,  2 Feb 2010 17:52:54 +0100 (MET)
Message-ID: <20100202165253.25160.18314.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33887 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0BBQw5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:52:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This first part of my conntrack zones patchset contains the CT target,
which is used for specifying initial conntrack parameters and will be
used by the zones series for zone classification. I've seperated the
two patchsets since they're mostly unrelated for easier review.

If there are no further comments or requests, I'll begin by merging
this patchset into the nf-next-2.6.git tree and will post the zones
patchset next.


 include/linux/netfilter/Kbuild                |    1 +
 include/linux/netfilter/nf_conntrack_common.h |   22 ++++
 include/linux/netfilter/x_tables.h            |    2 +
 include/linux/netfilter/xt_CT.h               |   16 +++
 include/net/netfilter/nf_conntrack_ecache.h   |   58 +++++-----
 include/net/netfilter/nf_conntrack_helper.h   |    8 +-
 net/bridge/netfilter/ebtables.c               |   10 +-
 net/ipv4/netfilter/ip_tables.c                |    8 +-
 net/ipv6/netfilter/ip6_tables.c               |    8 +-
 net/netfilter/Kconfig                         |   12 ++
 net/netfilter/Makefile                        |    1 +
 net/netfilter/nf_conntrack_core.c             |   52 ++++++---
 net/netfilter/nf_conntrack_helper.c           |   44 ++++++-
 net/netfilter/nf_conntrack_netlink.c          |   33 +++---
 net/netfilter/nf_conntrack_proto_gre.c        |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c       |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_udp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_udplite.c    |    2 +-
 net/netfilter/xt_CT.c                         |  151 +++++++++++++++++++++++++
 20 files changed, 349 insertions(+), 87 deletions(-)
 create mode 100644 include/linux/netfilter/xt_CT.h
 create mode 100644 net/netfilter/xt_CT.c

Patrick McHardy (6):
      netfilter: add struct net * to target parameters
      netfilter: nf_conntrack: split up IPCT_STATUS event
      netfilter: ctnetlink: support selective event delivery
      netfilter: ctnetlink: only assign helpers for matching protocols
      netfilter: nf_conntrack: support conntrack templates
      netfilter: xtables: add CT target
