From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/7] ipset patches for nf-next, v2
Date: Sat, 22 Sep 2012 22:51:42 +0200
Message-ID: <1348347102-19029-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37268 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2IVUvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:51:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows the ipset patches against your nf-next tree. I have included
the three patches sent previously against nf and rewrote the description
of the third one.

You can pull the changes from

git://blackhole.kfki.hu/nf-next master

Best regards,
Jozsef


Jozsef Kadlecsik (7):
  netfilter: ipset: Fix sparse warnings "incorrect type in assignment"
  netfilter: ipset: Check and reject crazy /0 input parameters
  netfilter: ipset: Rewrite cidr book keeping to handle /0
  netfilter: ipset: Add /0 network support to hash:net,iface type
  netfilter: ipset: Include supported revisions in module description
  netfilter: ipset: Coding style fixes
  netfilter: ipset: Support to match elements marked with "nomatch"

 include/linux/netfilter/ipset/ip_set.h       |   15 +++-
 include/linux/netfilter/ipset/ip_set_ahash.h |  106 ++++++++++++++------------
 net/netfilter/ipset/ip_set_bitmap_ip.c       |   19 +++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |   18 +++--
 net/netfilter/ipset/ip_set_bitmap_port.c     |    9 ++-
 net/netfilter/ipset/ip_set_core.c            |   15 +++-
 net/netfilter/ipset/ip_set_hash_ip.c         |   15 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c     |   24 ++++---
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   24 ++++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   47 +++++++-----
 net/netfilter/ipset/ip_set_hash_net.c        |   25 ++++---
 net/netfilter/ipset/ip_set_hash_netiface.c   |   66 ++++++++--------
 net/netfilter/ipset/ip_set_hash_netport.c    |   36 +++++----
 net/netfilter/ipset/ip_set_list_set.c        |    9 ++-
 net/netfilter/xt_set.c                       |   22 ++++++
 15 files changed, 270 insertions(+), 180 deletions(-)

