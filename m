From: pablo@netfilter.org
Subject: [PATCH 0/3] netfilter updates for 3.2-rc
Date: Mon, 28 Nov 2011 04:30:57 +0100
Message-ID: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57655 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1K1DbS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:31:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

The following patches are three bugfixes for 3.2-rc. One that fixes
the stopping one lxc container while having conntracks in the table
and nf_netlink_conntrack enabled. Some minor compilation warning in
ipset and unaligned access in ip_route_me_harder.

You can pull these changes from (my nf branch):

git://1984.lsi.us.es/net nf

Thanks!

Jozsef Kadlecsik (1):
  netfilter: ipset: suppress compile-time warnings in ip_set_hash_ipport*.c

Pablo Neira Ayuso (1):
  netfilter: nf_conntrack: make event callback registration per-netns

Paul Guo (1):
  netfilter: possible unaligned packet header in ip_route_me_harder

 include/net/netfilter/nf_conntrack_ecache.h |   19 ++++---
 include/net/netns/conntrack.h               |    2 +
 net/ipv4/netfilter.c                        |    3 +-
 net/netfilter/ipset/ip_set_hash_ipport.c    |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    2 +-
 net/netfilter/nf_conntrack_ecache.c         |   37 +++++++-------
 net/netfilter/nf_conntrack_netlink.c        |   73 +++++++++++++++++++--------
 8 files changed, 87 insertions(+), 53 deletions(-)

-- 
1.7.2.5

