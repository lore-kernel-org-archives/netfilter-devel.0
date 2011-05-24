From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/7] ipset patches against net-next-2.6/nf-next-2.6, updated
Date: Tue, 24 May 2011 10:22:26 +0200
Message-ID: <1306225353-1580-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58712 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032Ab1EXIWe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:22:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

And here are the updated patches against net-next-2.6 and nf-next-2.6.
The patches can be applied only if nf-next-2.6 is rebased onto current
net-next-2.6, sorry.

Please consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (7):
  netfilter: ipset: Timeout can be modified for already added elements
  netfilter: ipset: Options and flags support added to the kernel API
  netfilter: ipset: Support listing setnames and headers too
  netfilter: ipset: Fix adding ranges to hash types
  netfilter: ipset: Set type support with multiple revisions added
  netfilter: ipset: Support range for IPv4 at adding/deleting elements
    for hash:*net* types
  netfilter: ipset: Take into account cidr value for the from address
    when creating the set

 include/linux/netfilter/ipset/ip_set.h         |   34 ++++--
 include/linux/netfilter/ipset/ip_set_ahash.h   |   39 +++++--
 include/linux/netfilter/ipset/ip_set_hash.h    |    4 +
 include/linux/netfilter/ipset/ip_set_timeout.h |    3 +
 include/linux/netfilter/ipset/pfxlen.h         |    9 ++
 include/linux/netfilter/xt_set.h               |   15 ++-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   34 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   34 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c       |   30 +++--
 net/netfilter/ipset/ip_set_core.c              |  155 ++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ip.c           |   41 ++++--
 net/netfilter/ipset/ip_set_hash_ipport.c       |   61 ++++++---
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   65 +++++++----
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  129 +++++++++++++-------
 net/netfilter/ipset/ip_set_hash_net.c          |   82 ++++++++++---
 net/netfilter/ipset/ip_set_hash_netport.c      |  111 ++++++++++++-----
 net/netfilter/ipset/ip_set_list_set.c          |  105 +++++++++++------
 net/netfilter/ipset/pfxlen.c                   |   21 +++
 net/netfilter/xt_set.c                         |  151 +++++++++++++++--------
 19 files changed, 751 insertions(+), 372 deletions(-)

