From: pablo@netfilter.org
Subject: [PATCH 0/3] netfilter fixes for 2.6.37
Date: Wed, 12 Jan 2011 00:26:15 +0100
Message-ID: <1294788378-11475-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab1AKX0j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:26:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

The following patchset contains Netfilter bugfixes for 2.6.37.

You can pull them from:

git://1984.lsi.us.es/net-2.6 master

Please, apply!

Eric Dumazet (1):
  netfilter: x_tables: dont block BH while reading counters

Florian Westphal (1):
  netfilter: ebtables: make broute table work again

Stephen Hemminger (1):
  netfilter: fix race in conntrack between dump_table and destroy

 include/linux/if_bridge.h            |    2 +-
 include/linux/netfilter/x_tables.h   |   10 ++++----
 net/ipv4/netfilter/arp_tables.c      |   45 ++++++++++-----------------------
 net/ipv4/netfilter/ip_tables.c       |   45 ++++++++++-----------------------
 net/ipv6/netfilter/ip6_tables.c      |   45 ++++++++++-----------------------
 net/netfilter/nf_conntrack_netlink.c |   14 ++++-------
 net/netfilter/x_tables.c             |    3 +-
 7 files changed, 55 insertions(+), 109 deletions(-)

