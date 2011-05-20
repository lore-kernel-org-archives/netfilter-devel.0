From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/6] ipset patches against net-next-2.6/nf-next-2.6
Date: Fri, 20 May 2011 20:59:34 +0200
Message-ID: <1305917980-14567-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:54230 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab1ETS7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 14:59:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave and Patrick,

And here are the patches against net-next-2.6 and nf-next-2.6. Patrick,
the patches can be applied only if nf-next-2.6 is rebased onto current
net-next-2.6, sorry.

Please consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (6):
  netfilter: ipset: Timeout can be modified for already added elements
  netfilter: ipset: Options and flags support added to the kernel API
  netfilter: ipset: Support listing setnames and headers too
  netfilter: ipset: Fix adding ranges to hash types
  netfilter: ipset: Set type support with multiple revisions added
  netfilter: ipset: Support range for IPv4 at adding/deleting elements
    for hash:*net* types

 include/linux/netfilter/ipset/ip_set.h         |   34 ++++--
 include/linux/netfilter/ipset/ip_set_ahash.h   |   39 +++++--
 include/linux/netfilter/ipset/ip_set_hash.h    |    4 +
 include/linux/netfilter/ipset/ip_set_timeout.h |    3 +
 include/linux/netfilter/ipset/pfxlen.h         |    3 +
 include/linux/netfilter/xt_set.h               |   15 ++-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   29 +++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   32 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c       |   30 +++--
 net/netfilter/ipset/ip_set_core.c              |  155 ++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ip.c           |   38 ++++--
 net/netfilter/ipset/ip_set_hash_ipport.c       |   58 ++++++---
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   62 +++++++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  127 +++++++++++++------
 net/netfilter/ipset/ip_set_hash_net.c          |   82 ++++++++++---
 net/netfilter/ipset/ip_set_hash_netport.c      |  112 ++++++++++++-----
 net/netfilter/ipset/ip_set_list_set.c          |  105 +++++++++++------
 net/netfilter/ipset/pfxlen.c                   |   21 +++
 net/netfilter/xt_set.c                         |  151 +++++++++++++++--------
 19 files changed, 740 insertions(+), 360 deletions(-)

