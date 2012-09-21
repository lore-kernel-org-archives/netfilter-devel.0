From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset fixes
Date: Fri, 21 Sep 2012 22:38:21 +0200
Message-ID: <1348259901-16369-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39707 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842Ab2IUUiX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:38:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows two important ipset fixes against your nf tree. (The first
patch is an old one somehow forgotten to send or apply and the other
ones depend on it.)

You can pull these changes from:

git://blackhole.kfki.hu/nf master

Best regards,
Jozsef

Jozsef Kadlecsik (3):
  netfilter: ipset: Fix sparse warnings "incorrect type in assignment"
  netfilter: ipset: Check and reject crazy /0 input parameters
  netfilter: ipset: Fix cidr book keeping for hash:*net* types

 include/linux/netfilter/ipset/ip_set_ahash.h |  104 ++++++++++++++------------
 net/netfilter/ipset/ip_set_bitmap_ip.c       |   10 ++-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |    5 +-
 net/netfilter/ipset/ip_set_hash_ip.c         |    6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |   15 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   15 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   23 +++---
 net/netfilter/ipset/ip_set_hash_net.c        |    4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |    4 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   13 ++--
 10 files changed, 107 insertions(+), 92 deletions(-)

