From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/10] ipset patches for nf-next, v2
Date: Sun, 30 Nov 2014 19:56:51 +0100
Message-ID: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57564 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaK3S4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next series of patches for ipset:

- Fix sparse warning "cast to restricted __be32"
- Fix parallel resizing and listing of the same set: when adding elements
  and listing of the same set were executed parallel, listing could start
  to list the original set (before resizing) and continue with the new one.
- Styles warned by checkpatch.pl fixed
- Introduce RCU locking in the hash types. The patch was
  performance tested by Jesper Dangaard Brouer:

  Generator: sending 12.2Mpps (tx:12264083 pps)
  Drop performance in "raw" with ipset: 8Mpps
  Drop performance in "raw" with ipset with RCU-locking: 11.3Mpps
- Introduce RCU locking in the list type
- Introduce RCU locking in the bitmap types
- Introduce RCU locking instead of rwlock per set in the core
- Remove rbtree from hash:net,iface for RCU locking
- Explicitly add padding elements to hash:net,net and hash:net,port,
  because the elements must be u32 sized for the used hash function.
- Allocate the proper size of memory when /0 networks are supported
- Simplify cidr handling for hash:*net* types (cleaning it up for RCU)
- Indicate explicitly when /0 networks are supported
- Alignment problem between 64bit kernel 32bit userspace fixed by
  introducing a new set match revision, reported by Sven-Haegar Koch
- Support updating element extensions when the set is full (fixes
  netfilter bugzilla id 880)

You can pull the changes from

        git://blackhole.kfki.hu/nf-next master

The iptables part of the new set match functionality
can be found in the iptables git tree, in the ipset
branch.

Thanks,
Jozsef
============================================================================
The following changes since commit beacd3e8ef237e077c8707395440813feef16d3f:

  netfilter: nfnetlink_log: Make use of pr_fmt where applicable (2014-11-20 14:09:01 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 482ebc4fe2be7de3b20cff357d76fde1738e4531:

  netfilter: ipset: Fix sparse warning (2014-11-30 19:49:49 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (14):
      netfilter: ipset: Support updating extensions when the set is full
      netfilter: ipset: Alignment problem between 64bit kernel 32bit userspace
      netfilter: ipset: Indicate when /0 networks are supported
      netfilter: ipset: Simplify cidr handling for hash:*net* types
      netfilter: ipset: Allocate the proper size of memory when /0 networks are supported
      netfilter: ipset: Explicitly add padding elements to hash:net,net and hash:net,port,net
      netfilter: ipset: Remove rbtree from hash:net,iface in order to run under RCU
      netfilter: ipset: Introduce RCU locking instead of rwlock per set in the core
      netfilter: ipset: Introduce RCU locking in the bitmap types
      netfilter: ipset: Introduce RCU locking in the list type
      netfilter: ipset: Introduce RCU locking in the hash types
      netfilter: ipset: styles warned by checkpatch.pl fixed
      netfilter: ipset: Fix parallel resizing and listing of the same set
      netfilter: ipset: Fix sparse warning

 include/linux/netfilter/ipset/ip_set.h         |  25 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |  27 +-
 include/uapi/linux/netfilter/ipset/ip_set.h    |   8 +-
 include/uapi/linux/netfilter/xt_set.h          |  13 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   4 +-
 net/netfilter/ipset/ip_set_core.c              |  72 +--
 net/netfilter/ipset/ip_set_hash_gen.h          | 669 +++++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ipmark.c       |   4 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   2 +
 net/netfilter/ipset/ip_set_hash_net.c          |   4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c     | 159 +-----
 net/netfilter/ipset/ip_set_hash_netnet.c       |   4 +
 net/netfilter/ipset/ip_set_hash_netport.c      |   2 +
 net/netfilter/ipset/ip_set_hash_netportnet.c   |   4 +
 net/netfilter/ipset/ip_set_list_set.c          | 386 +++++++-------
 net/netfilter/xt_set.c                         |  80 ++-
 net/sched/em_ipset.c                           |   5 +-
 17 files changed, 791 insertions(+), 677 deletions(-)
