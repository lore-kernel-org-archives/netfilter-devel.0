From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/34] ipset patches for nf-next
Date: Sat,  2 May 2015 19:27:49 +0200
Message-ID: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:36944 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next bunch of patches for ipset. The patchset
contains the RCU introduction in ipset, splitted into six parts for easier
review. There are also some bugfixes and a lot of small corrections as well.

* Remove rbtree from ip_set_hash_netiface.c in order to introduce RCU.
* Replace rwlock_t with spinlock_t in "struct ip_set", change the locking
  in the core and simplifications in the timeout routines.
* Introduce RCU locking in bitmap:* types with a slight modification in the
  logic on how an element is added.
* Introduce RCU locking in hash:* types. This is the most complex part of
  the changes.
* Introduce RCU locking in list type where standard rculist is used.
* Fix parallel resizing and listing of the same set so that the original
  set is kept for the whole dumping.
* Fix the sparse warning: cast to restricted __be32
* Use MSEC_PER_SEC consistently instead of the number
* Give a better name to a macro in ip_set_core.c
* Missing rcu protection in mtype_list() fixed.
* Make sure listing doesn't grab a set which is just being destroyed.
* Make ip_set_get_ip*_port to use skb_network_offset from Alexander Drozdov.
* Fix cidr handling for hash:*net* types, reported by Jonathan Johnson.
* Properly calculate extensions offsets and total length so that memory
  is not wasted, from Sergey Popovich.
* Make sure bit operations are not reordered in ip_set_hash_gen.h.
* Remove unnecessary nomatch bitfield from Sergey Popovich.
* Preprocessor directives cleanup from Sergey Popovich.
* Return ipset error instead of bool in uadt functions from Sergey Popovich.
* Use SET_WITH_*() helpers to test set extensions from Sergey Popovich.
* Check extensions attributes before getting extensions from Sergey Popovich.
* Check IPSET_ATTR_PORT only once from Sergey Popovich.
* Use HOST_MASK literal to represent host address CIDR len from Sergey Popovich.
* Permit CIDR equal to the host address CIDR in IPv6 from Sergey Popovich.
* Make sure we always return line number on batch in the case of error
  from Sergey Popovich.
* Check CIDR value only when attribute is given from Sergey Popovich.
* Return bool values instead of int in bool functions from Sergey Popovich.
* Check for comment netlink attribute length from Sergey Popovich.
* Fix ext_*() macros so pointers returned by these macros could be referenced
  directly from Sergey Popovich.
* Fix hashing for ipv6 sets because HKEY_DATALEN was not undefied,
  from Sergey Popovich.
* Improve preprocessor macros checks for mandatory ones from Sergey Popovich.
* Make sure dumping can't grab set being just destroyed.
* RCU safe comment extension handling added
* Fix coding styles reported by checkpatch.pl
* Use better include files in xt_set.c.

Best regards,
Jozsef

The following changes since commit 97bb43c3e06e9bfdc9e3140a312004df462685b9:

  netfilter: nf_tables: get rid of the expression example code (2015-04-13 20:20:09 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 5ea3388f3524ccbab897a0580cc6de21a3cf7b4e:

  netfilter: ipset: Use better include files in xt_set.c (2015-05-02 18:30:42 +0200)

----------------------------------------------------------------
Alexander Drozdov (1):
      netfilter: ipset: make ip_set_get_ip*_port to use skb_network_offset

Jozsef Kadlecsik (17):
      netfilter: ipset: Remove rbtree from hash:net,iface
      netfilter: ipset: Prepare the ipset core to use RCU at set level
      netfilter: ipset: Introduce RCU locking in bitmap:* types
      netfilter: ipset: Introduce RCU locking in hash:* types
      netfilter: ipset: Introduce RCU locking in list type
      netfilter: ipset: Fix parallel resizing and listing of the same set
      netfilter: ipset: Fix sparse warning
      netfilter: ipset: Use MSEC_PER_SEC consistently
      netfilter: ipset: Give a better name to a macro in ip_set_core.c
      netfilter: ipset: Missing rcu protection in mtype_list() fixed
      netfilter: ipset: Make sure listing doesn't grab a set which is just being destroyed.
      netfilter: ipset: Fix cidr handling for hash:*net* types
      netfilter: ipset: Make sure bit operations are not reordered
      netfilter: ipset: Make sure dumping can't grab set being just destroyed
      netfilter: ipset: RCU safe comment extension handling
      netfilter: ipset: Fix coding styles reported by checkpatch.pl
      netfilter: ipset: Use better include files in xt_set.c

Sergey Popovich (16):
      netfilter: ipset: Properly calculate extensions offsets and total length
      netfilter: ipset: No need to make nomatch bitfield
      netfilter: ipset: Preprocessor directices cleanup
      netfilter: ipset: Return ipset error instead of bool
      netfilter: ipset: Use SET_WITH_*() helpers to test set extensions
      netfilter: ipset: Check extensions attributes before getting extensions.
      netfilter: ipset: Check IPSET_ATTR_PORT only once
      netfilter: ipset: Use HOST_MASK literal to represent host address CIDR len
      netfilter: ipset: Permit CIDR equal to the host address CIDR in IPv6
      netfilter: ipset: Make sure we always return line number on batch
      netfilter: ipset: Check CIDR value only when attribute is given
      netfilter: ipset: Return bool values instead of int
      netfilter: ipset: Check for comment netlink attribute length
      netfilter: ipset: Fix ext_*() macros
      netfilter: ipset: Fix hashing for ipv6 sets
      netfilter: ipset: Improve preprocessor macros checks

 include/linux/netfilter/ipset/ip_set.h         |  38 +-
 include/linux/netfilter/ipset/ip_set_comment.h |  38 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |  27 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  44 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  44 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  61 ++-
 net/netfilter/ipset/ip_set_bitmap_port.c       |  27 +-
 net/netfilter/ipset/ip_set_core.c              | 362 ++++++------
 net/netfilter/ipset/ip_set_getport.c           |  19 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 731 +++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ip.c           |  72 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c       |  87 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c       |  98 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  91 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  96 ++--
 net/netfilter/ipset/ip_set_hash_mac.c          |  30 +-
 net/netfilter/ipset/ip_set_hash_net.c          |  73 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c     | 246 +++------
 net/netfilter/ipset/ip_set_hash_netnet.c       | 146 +++--
 net/netfilter/ipset/ip_set_hash_netport.c      |  86 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c   | 176 +++---
 net/netfilter/ipset/ip_set_list_set.c          | 422 +++++++-------
 net/netfilter/ipset/pfxlen.c                   |  16 +-
 net/netfilter/xt_set.c                         |  40 +-
 24 files changed, 1561 insertions(+), 1509 deletions(-)
