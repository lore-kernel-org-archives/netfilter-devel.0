From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/22] ipset patches for nf-next, v3
Date: Thu, 10 Nov 2016 13:57:34 +0100
Message-ID: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:50750 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932467AbcKJM6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows the new batch for nf-next: I addressed all your
concerns about the previous version.

Please review and consider to apply the patchset.
Thanks!
Jozsef

* Cleanup: Remove extra whitespaces in ip_set.h
* Cleanup: Mark some of the helpers arguments as const in ip_set.h
* Cleanup: Group counter helper functions together in ip_set.h
* struct ip_set_skbinfo is introduced instead of open coded fields
  in skbinfo get/init helper funcions
* Use kmalloc() in comment extension helper instead of kzalloc()
  because it is unnecessary to zero out the area just before
  explicit initialization.
* Cleanup: Split extensions into separate files
* Cleanup: Separate memsize calculation code into dedicated function
* Cleanup: group ip_set_put_extensions() and ip_set_get_extensions()
  together
* Add element count to hash headers by Eric B Munson.
* Add element count to all set types header for uniform output
  across all set types.
* Count non-static extension memory into memsize calculation for
  userspace.
* Cleanup: Remove redundant mtype_expire() arguments, because
  they can be get from other parameters
* Cleanup: Simplify mtype_expire() for hash types by removing
  one level of intendation.
* Make NLEN compile time constant for hash types
* Make sure element data size is a multiple of u32 for the hash set
  types.
* Optimize hash creation routine, exit as early as possible
* Make struct htype per ipset family so nets array becomes fixed size
  and thus simplifies the struct htype allocation
* Collapse same condition body into a single one
* Fix reported memory size for hash:* types, base hash bucket structure
  was not taken into account
* hash:ipmac type support added to ipset by Tomasz Chilinski
* Use setup_timer() and mod_timer() instead of init_timer()
  by Muhammad Falak R Wani, individually for the set type families.
* hash: fix boolreturn.cocci warnings avout bool should use true/false

The following changes since commit 56a62e2218f544258bd1796889a42f4516ccd04a:

  netfilter: conntrack: fix NF_REPEAT handling (2016-11-10 00:19:33 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 737d387b75ec79d62b12fd8996c634b4635cc98f:

  netfilter: ipset: hash: fix boolreturn.cocci warnings (2016-11-10 13:28:50 +0100)

----------------------------------------------------------------
Eric B Munson (1):
      netfilter: ipset: Add element count to hash headers

Jozsef Kadlecsik (19):
      netfilter: ipset: Remove extra whitespaces in ip_set.h
      netfilter: ipset: Mark some helper args as const.
      netfilter: ipset: Headers file cleanup
      netfilter: ipset: Improve skbinfo get/init helpers
      netfilter: ipset: Use kmalloc() in comment extension helper
      netfilter: ipset: Split extensions into separate files
      netfilter: ipset: Separate memsize calculation code into dedicated function
      netfilter: ipset: Regroup ip_set_put_extensions and add extern
      netfilter: ipset: Add element count to all set types header
      netfilter: ipset: Count non-static extension memory for userspace
      netfilter: ipset: Remove redundant mtype_expire() arguments
      netfilter: ipset: Simplify mtype_expire() for hash types
      netfilter: ipset: Make NLEN compile time constant for hash types
      netfilter: ipset: Make sure element data size is a multiple of u32
      netfilter: ipset: Optimize hash creation routine
      netfilter: ipset: Make struct htype per ipset family
      netfilter: ipset: Collapse same condition body to a single one
      netfilter: ipset: Fix reported memory size for hash:* types
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
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  31 ++-
 net/netfilter/ipset/ip_set_core.c              |  14 +-
 net/netfilter/ipset/ip_set_hash_gen.h          | 254 +++++++++-----------
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
 24 files changed, 699 insertions(+), 334 deletions(-)
 create mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipmac.c
