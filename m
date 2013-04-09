From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/15] ipset patches for nf-next
Date: Tue,  9 Apr 2013 21:09:43 +0200
Message-ID: <1365534598-23877-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:59777 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935618Ab3DITKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:10:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next patches against your nf-next tree.

The patches introduce the new extensions infrastructure in ipset and
add packet/byte counters as a new extension besides timeouts. The set
match is extended by the functionality to match the counters too.

The patches can be pulled from

git://blackhole.kfki.hu/nf-next master

and include the two bugfixes sent previously for your stable tree.

Best regards,
Jozsef

Jozsef Kadlecsik (15):
  netfilter: ipset: list:set: fix reference counter update
  netfilter: ipset: hash:*net*: nomatch flag not excluded on set resize
  netfilter: ipset: Make possible to test elements marked with nomatch
  netfilter: ipset: Move often used IPv6 address masking function to
    header file
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
 include/linux/netfilter/ipset/ip_set_ahash.h   | 1225 ------------------------
 include/linux/netfilter/ipset/ip_set_bitmap.h  |    6 +
 include/linux/netfilter/ipset/ip_set_timeout.h |  102 +--
 include/linux/netfilter/ipset/pfxlen.h         |    9 +
 include/uapi/linux/netfilter/ipset/ip_set.h    |   36 +-
 include/uapi/linux/netfilter/xt_set.h          |    9 +
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  277 ++++++
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  411 +++------
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  620 +++++--------
 net/netfilter/ipset/ip_set_bitmap_port.c       |  414 +++------
 net/netfilter/ipset/ip_set_core.c              |   36 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 1100 +++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ip.c           |  344 ++-----
 net/netfilter/ipset/ip_set_hash_ipport.c       |  362 +++-----
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  368 +++-----
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  451 ++++------
 net/netfilter/ipset/ip_set_hash_net.c          |  384 +++-----
 net/netfilter/ipset/ip_set_hash_netiface.c     |  460 ++++------
 net/netfilter/ipset/ip_set_hash_netport.c      |  438 +++------
 net/netfilter/ipset/ip_set_list_set.c          |  622 +++++++-----
 net/netfilter/xt_set.c                         |   94 ++-
 22 files changed, 3480 insertions(+), 4414 deletions(-)
 delete mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_gen.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_gen.h

