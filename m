From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/22] ipset patches for nf-next
Date: Mon, 17 Oct 2016 14:51:17 +0200
Message-ID: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34605 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754912AbcJQNAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 09:00:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next bunch of patches for ipset.
There is new set type in it (hash:ip,mac), elemet counts are reported
to userspace in the set headers data and a couple of small cleanups,
improvements

* rcu_dereference_bh_nfnl() redefined to accept netfilter subsys id.
* Header files cleanup: counter helper functions are grouped together,
  some args are changed to const.
* struct ip_set_skbinfo is introduced instead of open coded fields
  in skbinfo get/init helper funcions.
* In comment extension allocate area with kmalloc() rather than kzalloc().
* Split all extensions into separate files.
* Separate memsize calculation into dedicated functions.
* ip_set_put_extensions() is regrouped and extern is added.
* Add element count to hash headers by Eric B Munson.
* Add element count to all set types header for uniform output.
* Count non-static extension memory into memsize calculation for
  userspace.
* Simplify mtype_expire() for hash types by removing redundant
  parameters which can be get from other ones.
* Make NLEN compile time constant for hash types.
* Make sure element data size is a multiple of u32.
* Optimize hash creation routine, exit as early as possible.
* Make struct htype per ipset family.
* Collapse same condition body into a single one.
* Fix reported memory size for hash:* types.
* hash:ipmac type support added to ipset by Tomasz Chilinski.
* Use setup_timer() and mod_timer() instead of init_timer()
  by Muhammad Falak R Wani, individually for the set type families.
* hash: fix boolreturn.cocci warnings avout bool should use true/false
  by Fengguang Wu.

The following changes since commit 1b830996c1603225a96e233c3b09bf2b12607d78:

  Merge branch 's390-net' (2016-10-12 01:56:10 -0400)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 214ee1d9a5e73f13a126849c69fdb29dfe2bdb3f:

  netfilter: ipset: hash: fix boolreturn.cocci warnings (2016-10-15 14:51:59 +0200)

----------------------------------------------------------------
Eric B Munson (1):
      netfilter: ipset: Add element count to hash headers

Jozsef Kadlecsik (16):
      netfilter: ipset: Correct rcu_dereference_bh_nfnl() usage
      netfilter: ipset: Headers file cleanup
      netfilter: ipset: Improve skbinfo get/init helpers
      netfilter: ipset: Improve comment extension helpers
      netfilter: ipset: Split extensions into separate files
      netfilter: ipset: Separate memsize calculation code into dedicated function
      netfilter: ipset: Regroup ip_set_put_extensions and add extern
      netfilter: ipset: Add element count to all set types header
      netfilter: ipset: Count non-static extension memory for userspace
      netfilter: ipset: Simplify mtype_expire() for hash types
      netfilter: ipset: Make NLEN compile time constant for hash types
      netfilter: ipset: Make sure element data size is a multiple of u32
      netfilter: ipset: Optimize hash creation routine
      netfilter: ipset: Make struct htype per ipset family
      netfilter: ipset: Collapse same condition body to a single one
      netfilter: ipset: Fix reported memory size for hash:* types

Muhammad Falak R Wani (3):
      netfilter: ipset: use setup_timer() and mod_timer().
      netfilter: ipset: use setup_timer() and mod_timer().
      netfilter: ipset: use setup_timer() and mod_timer().

Tomasz Chilinski (1):
      netfilter: ipset: hash:ipmac type support added to ipset

kbuild test robot (1):
      netfilter: ipset: hash: fix boolreturn.cocci warnings

 include/linux/netfilter/ipset/ip_set.h         | 136 ++---------
 include/linux/netfilter/ipset/ip_set_bitmap.h  |   2 +-
 include/linux/netfilter/ipset/ip_set_comment.h |  11 +-
 include/linux/netfilter/ipset/ip_set_counter.h |  75 ++++++
 include/linux/netfilter/ipset/ip_set_skbinfo.h |  46 ++++
 include/linux/netfilter/ipset/ip_set_timeout.h |   4 +-
 net/netfilter/ipset/Kconfig                    |   9 +
 net/netfilter/ipset/Makefile                   |   1 +
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  33 ++-
 net/netfilter/ipset/ip_set_core.c              |  14 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 264 ++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ip.c           |  10 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c        | 315 +++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ipmark.c       |  10 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |   6 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  10 +-
 net/netfilter/ipset/ip_set_hash_net.c          |   8 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     |   8 +-
 net/netfilter/ipset/ip_set_hash_netnet.c       |   8 +-
 net/netfilter/ipset/ip_set_hash_netport.c      |  10 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c   |  10 +-
 net/netfilter/ipset/ip_set_list_set.c          |  37 ++-
 net/netfilter/xt_set.c                         |  12 +-
 24 files changed, 707 insertions(+), 338 deletions(-)
 create mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipmac.c
