From: pablo@netfilter.org
Subject: [PATCH 0/8] netfilter: netfilter fixes for 2.6.39-rc7
Date: Tue, 10 May 2011 12:05:51 +0200
Message-ID: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48492 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab1EJKGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

following are eight netfilter fixes for 2.6.39-rc7, containing:

- one fix for ebtables compat

- a couple of fixes for netfilter IPv6 targets from Fernando Luis Vazquez

- a couple of fixes for IPVS things that were pushed into 2.6.39-rc1

- revert one patch for the conntrack match

- fix timestamp support in ctnetlink for newly created conntracks

Please pull from:

git://1984.lsi.us.es/net-2.6 pablo/nf-2.6-updates

Thanks!


Eric Dumazet (1):
  netfilter: fix ebtables compat support

Fernando Luis Vazquez Cao (2):
  netfilter: IPv6: initialize TOS field in REJECT target module
  netfilter: IPv6: fix DSCP mangle code

Florian Westphal (1):
  netfilter: ebtables: only call xt_compat_add_offset once per rule

Hans Schillstrom (2):
  IPVS: Change of socket usage to enable name space exit.
  IPVS: init and cleanup restructuring

Pablo Neira Ayuso (2):
  netfilter: ctnetlink: fix timestamp support for new conntracks
  netfilter: revert a2361c8735e07322023aedc36e4938b35af31eb0

 include/net/ip_vs.h                  |   17 +++++
 net/bridge/netfilter/ebtables.c      |   64 +++---------------
 net/ipv6/netfilter/ip6t_REJECT.c     |    4 +-
 net/netfilter/ipvs/ip_vs_app.c       |   15 +----
 net/netfilter/ipvs/ip_vs_conn.c      |   12 +---
 net/netfilter/ipvs/ip_vs_core.c      |  103 ++++++++++++++++++++++++++---
 net/netfilter/ipvs/ip_vs_ctl.c       |  120 ++++++++++++++++++++++++++++-----
 net/netfilter/ipvs/ip_vs_est.c       |   14 +---
 net/netfilter/ipvs/ip_vs_proto.c     |   11 +---
 net/netfilter/ipvs/ip_vs_sync.c      |   65 ++++++++++--------
 net/netfilter/nf_conntrack_netlink.c |    4 +
 net/netfilter/x_tables.c             |    4 +-
 net/netfilter/xt_conntrack.c         |    5 --
 13 files changed, 278 insertions(+), 160 deletions(-)

-- 
1.7.2.3

