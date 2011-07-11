From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset patches against nf-next
Date: Mon, 11 Jul 2011 11:52:52 +0200
Message-ID: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43301 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1GKJw5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:52:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here follows three patches against nf-next: the second one is an important
fix against the new hash:net,iface set type and depends on the first one.
The third is a compiler warning fix for some gcc versions.

Please consider applying them. Thanks!

Best regards,
Jozsef

Chris Friesen (1):
  netfilter: ipset: Fix compiler warnings "'hash_ip4_data_next'
    declared inline after being called"

Jozsef Kadlecsik (2):
  netfilter: ipset: Make possible to hash some part of the data element
    only
  netfilter: ipset: hash:net,iface fixed to handle overlapping nets
    behind different interfaces

 include/linux/netfilter/ipset/ip_set_ahash.h |  108 +++++++++++++++++---------
 net/netfilter/ipset/ip_set_hash_ip.c         |    6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |    6 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   40 ++++++++--
 net/netfilter/ipset/ip_set_hash_netport.c    |    6 +-
 8 files changed, 128 insertions(+), 56 deletions(-)

