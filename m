From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/26] ipset patches for nf-next
Date: Mon, 30 Sep 2013 21:50:11 +0200
Message-ID: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:36514 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab3I3Tuj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows a huge batch of ipset patches for nf-next. Besides a lot of small
fixes and corrections, it contains two new set types, a reworked extensions
support with a new extension (per element comments) and netns support.
Please consider applying them.

Best regards,
Jozsef

The following changes since commit 7722e0d1c076d9610f00d79bde8af977157aa23b:
  Gao feng (1):
        netfilter: xt_TCPMSS: lookup route from proper net namespace

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

Anders K. Pedersen (1):
      netfilter: ipset: Support package fragments for IPv4 protos without ports

Jozsef Kadlecsik (18):
      netfilter: ipset: Don't call ip_nest_end needlessly in the error path
      netfilter: ipset: Sparse warning about shadowed variable fixed
      netfilter: ipset: Fix sparse warnings due to missing rcu annotations
      netfilter: ipset: Rename simple macro names to avoid namespace issues.
      netfilter: ipset: Fix "may be used uninitialized" warnings
      netfilter: ipset: Use fix sized type for timeout in the extension part
      netfilter: ipset: order matches and targets separatedly in xt_set.c
      netfilter: ipset: Introduce new operation to get both setname and family
      netfilter: ipset: Prepare ipset to support multiple networks for hash types
      netfilter: ipset: Rename extension offset ids to extension ids
      netfilter: ipset: Move extension data to set structure
      netfilter: ipset: Generalize extensions support
      netfilter: ipset: Support extensions which need a per data destroy function
      netfilter: ipset: list:set: make sure all elements are checked by the gc
      netfilter: ipset: Kconfig: ipset needs NETFILTER_NETLINK
      netfilter: ipset: Fix hash resizing with comments
      netfilter: ipset: For set:list types, replaced elements must be zeroed out
      netfilter: ipset: Use a common function at listing the extensions

Oliver Smith (6):
      netfilter: ipset: Add hash:net,net module to kernel.
      netfilter: ipset: Support comments for ipset entries in the core.
      netfilter: ipset: Support comments in bitmap-type ipsets.
      netfilter: ipset: Support comments in the list-type ipset.
      netfilter: ipset: Support comments in hash-type ipsets.
      netfilter: ipset: Add hash:net,port,net module to kernel.

Vitaly Lavrov (1):
      netfiler: ipset: Add net namespace for ipset

 include/linux/netfilter/ipset/ip_set.h         |  151 +++++-
 include/linux/netfilter/ipset/ip_set_comment.h |   57 +++
 include/linux/netfilter/ipset/ip_set_timeout.h |    4 +-
 include/uapi/linux/netfilter/ipset/ip_set.h    |   16 +-
 net/netfilter/ipset/Kconfig                    |   20 +-
 net/netfilter/ipset/Makefile                   |    2 +
 net/netfilter/ipset/ip_set_bitmap_gen.h        |  163 ++++---
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  125 ++----
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  156 ++-----
 net/netfilter/ipset/ip_set_bitmap_port.c       |  112 ++----
 net/netfilter/ipset/ip_set_core.c              |  361 +++++++++++----
 net/netfilter/ipset/ip_set_getport.c           |   18 +-
 net/netfilter/ipset/ip_set_hash_gen.h          |  526 +++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ip.c           |   58 +--
 net/netfilter/ipset/ip_set_hash_ipport.c       |   80 +---
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   86 +---
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  108 +----
 net/netfilter/ipset/ip_set_hash_net.c          |   85 +---
 net/netfilter/ipset/ip_set_hash_netiface.c     |   98 +----
 net/netfilter/ipset/ip_set_hash_netnet.c       |  483 +++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |   92 +---
 net/netfilter/ipset/ip_set_hash_netportnet.c   |  588 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_list_set.c          |  263 ++++-------
 net/netfilter/xt_set.c                         |  222 +++++-----
 net/sched/em_ipset.c                           |    7 +-
 25 files changed, 2364 insertions(+), 1517 deletions(-)
 create mode 100644 include/linux/netfilter/ipset/ip_set_comment.h
 create mode 100644 net/netfilter/ipset/ip_set_hash_netnet.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_netportnet.c
