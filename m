From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/15] ipset patches for nf-next
Date: Sun, 14 Jun 2015 10:56:17 +0200
Message-ID: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34891 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbbFNI4d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2015 04:56:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next bunch of patches for ipset. First
comes the small changes, then the bugfixes and at the end the RCU
related patches.

* Use MSEC_PER_SEC consistently instead of the number.
* Use SET_WITH_*() helpers to test set extensions from Sergey Popovich.
* Check extensions attributes before getting extensions from Sergey Popovich.
* Permit CIDR equal to the host address CIDR in IPv6 from Sergey Popovich.
* Make sure we always return line number on batch in the case of error
  from Sergey Popovich.
* Check CIDR value only when attribute is given from Sergey Popovich.
* Fix cidr handling for hash:*net* types, reported by Jonathan Johnson.
* Fix parallel resizing and listing of the same set so that the original
  set is kept for the whole dumping.
* Make sure listing doesn't grab a set which is just being destroyed.
* Remove rbtree from ip_set_hash_netiface.c in order to introduce RCU.
* Replace rwlock_t with spinlock_t in "struct ip_set", change the locking
  in the core and simplifications in the timeout routines.
* Introduce RCU locking in bitmap:* types with a slight modification in the
  logic on how an element is added.
* Introduce RCU locking in hash:* types. This is the most complex part of
  the changes.
* Introduce RCU locking in list type where standard rculist is used.
* Fix coding styles reported by checkpatch.pl.

Best regards,
Jozsef

The following changes since commit 482cfc318559e2527dfd8513582d2fdb276e47c2:

  netfilter: xtables: avoid percpu ruleset duplication (2015-06-12 14:27:10 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to ca0f6a5cd99e0c6ba4bb78dc402817f636370f26:

  netfilter: ipset: Fix coding styles reported by checkpatch.pl (2015-06-14 10:40:18 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (10):
      netfilter: ipset: Use MSEC_PER_SEC consistently
      netfilter: ipset: Fix cidr handling for hash:*net* types
      netfilter: ipset: Fix parallel resizing and listing of the same set
      netfilter: ipset: Make sure listing doesn't grab a set which is just being destroyed.
      netfilter:ipset Remove rbtree from hash:net,iface
      netfilter: ipset: Prepare the ipset core to use RCU at set level
      netfilter: ipset: Introduce RCU locking in bitmap:* types
      netfilter: ipset: Introduce RCU locking in hash:* types
      netfilter: ipset: Introduce RCU locking in list type
      netfilter: ipset: Fix coding styles reported by checkpatch.pl

Sergey Popovich (5):
      netfilter: ipset: Use SET_WITH_*() helpers to test set extensions
      netfilter: ipset: Check extensions attributes before getting extensions.
      netfilter: ipset: Permit CIDR equal to the host address CIDR in IPv6
      netfilter: ipset: Make sure we always return line number on batch
      netfilter: ipset: Check CIDR value only when attribute is given

 include/linux/netfilter/ipset/ip_set.h         |  29 +-
 include/linux/netfilter/ipset/ip_set_comment.h |  38 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |  27 +-
 include/uapi/linux/netfilter/ipset/ip_set.h    |   6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  44 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  27 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  46 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |  24 +-
 net/netfilter/ipset/ip_set_core.c              | 344 ++++++------
 net/netfilter/ipset/ip_set_getport.c           |  13 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 714 +++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ip.c           |  39 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c       |  46 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |  51 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  53 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  58 +-
 net/netfilter/ipset/ip_set_hash_mac.c          |  19 +-
 net/netfilter/ipset/ip_set_hash_net.c          |  49 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     | 225 ++------
 net/netfilter/ipset/ip_set_hash_netnet.c       | 120 ++---
 net/netfilter/ipset/ip_set_hash_netport.c      |  52 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c   | 128 ++---
 net/netfilter/ipset/ip_set_list_set.c          | 419 +++++++--------
 net/netfilter/ipset/pfxlen.c                   |  16 +-
 net/netfilter/xt_set.c                         |  44 +-
 25 files changed, 1319 insertions(+), 1312 deletions(-)
