From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 14:50:32 +0200
Message-ID: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52080 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3D0Mur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 08:50:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next patches against your nf-next tree.

The patches introduce the new extensions infrastructure in ipset and
add packet/byte counters as a new extension besides timeouts. The set
match is extended by the functionality to match the counters too.

Best regards,
Jozsef

The following changes since commit 37fe0660981d7a1577409226f77554c2c5123e27:
  Vlad Yasevich (1):
        net: fix address check in rtnl_fdb_del

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

Jozsef Kadlecsik (13):
      netfilter: ipset: Make possible to test elements marked with nomatch
      netfilter: ipset: Move often used IPv6 address masking function to header file
      netfilter: ipset: Introduce extensions to elements in the core
      netfilter: ipset: Unified bitmap type generation
      netfilter: ipset: Bitmap types using the unified code base
      netfilter: ipset: Unified hash type generation
      netfilter: ipset: Hash types using the unified code base
      netfilter: ipset: list:set type using the extension interface
      netfilter: ipset: Introduce the counter extension in the core
      netfilter: ipset: The bitmap types with counter support
      netfilter: ipset: The hash types with counter support
      netfilter: ipset: The list:set type with counter support
      netfilter: ipset: set match: add support to match the counters

 include/linux/netfilter/ipset/ip_set.h         |  126 +++-
 include/linux/netfilter/ipset/ip_set_ahash.h   | 1241 ------------------------
 include/linux/netfilter/ipset/ip_set_bitmap.h  |    6 +
 include/linux/netfilter/ipset/ip_set_timeout.h |  102 +--
 include/linux/netfilter/ipset/pfxlen.h         |    9 +
 include/uapi/linux/netfilter/ipset/ip_set.h    |   36 +-
 include/uapi/linux/netfilter/xt_set.h          |    9 +
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  277 ++++++
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  411 +++------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  624 +++++--------
 net/netfilter/ipset/ip_set_bitmap_port.c       |  414 +++------
 net/netfilter/ipset/ip_set_core.c              |   36 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 1100 +++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ip.c           |  344 ++-----
 net/netfilter/ipset/ip_set_hash_ipport.c       |  362 +++-----
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  368 +++-----
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  469 +++------
 net/netfilter/ipset/ip_set_hash_net.c          |  402 +++------
 net/netfilter/ipset/ip_set_hash_netiface.c     |  478 ++++------
 net/netfilter/ipset/ip_set_hash_netport.c      |  456 +++------
 net/netfilter/ipset/ip_set_list_set.c          |  622 +++++++-----
 net/netfilter/xt_set.c                         |   94 ++-
 22 files changed, 3478 insertions(+), 4508 deletions(-)
 delete mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_gen.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_gen.h
